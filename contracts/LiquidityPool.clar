;; Liquidity Pool Contract
;; Allows users to deposit and withdraw tokens with a simple fee mechanism

(define-data-var total-liquidity uint u0)
(define-data-var fee-percentage uint u30) ;; 0.3% fee (represented as 30 basis points)

(define-map liquidity-providers principal uint)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-INSUFFICIENT-LIQUIDITY (err u402))
(define-constant ERR-ZERO-AMOUNT (err u403))

;; Read-only functions
(define-read-only (get-total-liquidity)
  (var-get total-liquidity)
)

(define-read-only (get-fee-percentage)
  (var-get fee-percentage)
)

(define-read-only (get-provider-liquidity (provider principal))
  (default-to u0 (map-get? liquidity-providers provider))
)

;; Public functions
(define-public (add-liquidity (amount uint))
  (begin
    (asserts! (> amount u0) ERR-ZERO-AMOUNT)
    
    ;; Update provider's liquidity
    (map-set liquidity-providers tx-sender 
      (+ (get-provider-liquidity tx-sender) amount)
    )
    
    ;; Update total liquidity
    (var-set total-liquidity (+ (var-get total-liquidity) amount))
    
    (ok amount)
  )
)

(define-public (remove-liquidity (amount uint))
  (let (
    (provider-liquidity (get-provider-liquidity tx-sender))
  )
    (asserts! (> amount u0) ERR-ZERO-AMOUNT)
    (asserts! (>= provider-liquidity amount) ERR-INSUFFICIENT-LIQUIDITY)
    
    ;; Update provider's liquidity
    (map-set liquidity-providers tx-sender 
      (- provider-liquidity amount)
    )
    
    ;; Update total liquidity
    (var-set total-liquidity (- (var-get total-liquidity) amount))
    
    (ok amount)
  )
)

(define-public (update-fee-percentage (new-fee-percentage uint))
  (begin
    (asserts! (is-eq tx-sender (contract-owner)) ERR-NOT-AUTHORIZED)
    (asserts! (<= new-fee-percentage u1000) (err u404)) ;; Max 10% (1000 basis points)
    
    (var-set fee-percentage new-fee-percentage)
    (ok new-fee-percentage)
  )
)

(define-read-only (calculate-fee (amount uint))
  (/ (* amount (var-get fee-percentage)) u10000)
)

(define-read-only (contract-owner)
  (at 'owner (contract-call? 'SP000000000000000000002Q6VF78.contract-ownership get-ownership))
)