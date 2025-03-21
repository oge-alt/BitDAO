# BitDAO - Bitcoin-Native Decentralized Autonomous Organization

A Bitcoin-compliant DAO governance system built on Stacks Layer 2, enabling secure, scalable, and decentralized organization management with direct Bitcoin integration.

## Table of Contents

- [Overview](#overview)
- [Technical Details](#technical-details)
- [Core Features](#core-features)
- [Error Codes](#error-codes)
- [Security Considerations](#security-considerations)
- [Examples](#examples)
- [License](#license)

## Overview

BitDAO is a sophisticated governance system combining Bitcoin's security with Stacks Layer 2 scalability. The contract enables:

- Secure membership management with reputation tracking
- Bitcoin-native treasury management
- Weighted voting system based on reputation and stake
- Cross-DAO collaboration framework
- Automated reputation decay mechanism

## Technical Details

### Prerequisites

- Stacks Layer 2 environment
- STX tokens for transactions
- Principal addresses for member management

### Contract Structure

```bash
├── Data Variables
├── Data Maps
├── Membership Management
├── Proposal System
├── Voting Mechanism
├── Treasury Management
├── Reputation System
└── Cross-DAO Collaboration
```

## Core Features

### 1. Membership Management

#### Join DAO

```clarity
(join-dao)
```

- Requires: Non-member status
- Effects: Initializes member with 1 reputation point

#### Leave DAO

```clarity
(leave-dao)
```

- Requires: Existing membership
- Effects: Removes member records and stake

### 2. Staking System

#### Stake Tokens

```clarity
(stake-tokens uint)
```

- Minimum: 1 STX
- Effects: Increases member stake and treasury balance

#### Unstake Tokens

```clarity
(unstake-tokens uint)
```

- Requires: Sufficient staked balance
- Effects: Reduces stake and transfers STX back

### 3. Proposal Lifecycle

#### Create Proposal

```clarity
(create-proposal (string-ascii 50) (string-utf8 500) uint)
```

- Requirements:
  - Minimum title/description length
  - Treasury balance >= requested amount
- Expiration: 1440 blocks (~24 hours)

#### Voting Mechanism

```clarity
(vote-on-proposal uint bool)
```

- Weight Calculation:
  ```
  Voting Power = (Reputation * 10) + Stake
  ```
- Prevents double voting

#### Proposal Execution

```clarity
(execute-proposal uint)
```

- Conditions:
  - Voting period ended
  - Majority approval
- Successful execution transfers funds to creator

### 4. Treasury Management

#### Donations

```clarity
(donate-to-treasury uint)
```

- Accepts: Any amount >0 STX
- Reward: +2 reputation for members

#### Balance Check

```clarity
(get-treasury-balance)
```

- Returns current treasury balance

### 5. Reputation System

#### Reputation Factors

- +1 for proposal creation
- +1 for voting
- +5 for successful proposal execution
- +2 for donations

#### Decay Mechanism

```clarity
(decay-inactive-members)
```

- Automatic 50% reduction after 4320 blocks (~3 days) inactivity

### 6. Cross-DAO Collaboration

#### Initiate Collaboration

```clarity
(propose-collaboration principal uint)
```

- Links proposals between DAOs

#### Accept Collaboration

```clarity
(accept-collaboration uint)
```

- Requires: Partner DAO authorization

## Error Codes

| Code | Constant               | Description                        |
| ---- | ---------------------- | ---------------------------------- |
| 100  | ERR-NOT-AUTHORIZED     | Unauthorized access attempt        |
| 101  | ERR-ALREADY-MEMBER     | Duplicate membership attempt       |
| 102  | ERR-NOT-MEMBER         | Action requires membership         |
| 103  | ERR-INVALID-PROPOSAL   | Malformed proposal data            |
| 104  | ERR-PROPOSAL-EXPIRED   | Action on expired proposal         |
| 105  | ERR-ALREADY-VOTED      | Duplicate voting attempt           |
| 106  | ERR-INSUFFICIENT-FUNDS | Insufficient treasury balance      |
| 107  | ERR-INVALID-AMOUNT     | Invalid financial operation amount |

## Security Considerations

1. **Access Controls**

   - Critical functions restricted to contract owner
   - Member-only operations validation

2. **Financial Safeguards**

   - Reentrancy protection through STX transfers
   - Proposal amount validation against treasury

3. **Reputation Protection**

   - Time-locked decay mechanism
   - Weighted voting prevents Sybil attacks

4. **Collaboration Security**
   - Mutual DAO verification
   - Proposal status tracking

## Examples

### Join DAO and Create Proposal

```clarity
(contract-call? .bitdao join-dao)
(contract-call? .bitdao create-proposal "New Feature" "Implement X feature" u500)
```

### Vote and Execute Proposal

```clarity
(contract-call? .bitdao vote-on-proposal u1 true)
(contract-call? .bitdao execute-proposal u1)
```

### Cross-DAO Collaboration

```clarity
;; DAO A
(contract-call? .bitdao propose-collaboration 'SP123456 u1)

;; DAO B
(contract-call? .bitdao accept-collaboration u1)
```
