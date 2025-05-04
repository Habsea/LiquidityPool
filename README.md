# Liquidity Pool Smart Contract

A Clarity smart contract for the Stacks blockchain that implements a basic liquidity pool with deposit and withdrawal functionality.

## Overview

This contract allows users to:
- Add liquidity to the pool
- Remove their liquidity from the pool
- Calculate fees based on configurable percentage

The contract maintains a record of each provider's contribution and the total liquidity in the pool.

## Contract Functions

### Read-Only Functions

- `get-total-liquidity`: Returns the total liquidity in the pool
- `get-fee-percentage`: Returns the current fee percentage (in basis points)
- `get-provider-liquidity`: Returns the liquidity provided by a specific address
- `calculate-fee`: Calculates the fee for a given amount based on the current fee percentage
- `contract-owner`: Returns the contract owner's address

### Public Functions

- `add-liquidity`: Allows users to add liquidity to the pool
- `remove-liquidity`: Allows users to withdraw their liquidity from the pool
- `update-fee-percentage`: Allows the contract owner to update the fee percentage

## Error Codes

- `401`: Not authorized (only contract owner can perform this action)
- `402`: Insufficient liquidity (trying to withdraw more than deposited)
- `403`: Zero amount (amount must be greater than zero)
- `404`: Invalid fee percentage (must be less than or equal to 1000 basis points)

## Usage Examples

### Adding Liquidity

```clarity
(contract-call? .liquidity-pool add-liquidity u1000)