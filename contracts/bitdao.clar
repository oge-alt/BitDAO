;; Title: BitDAO - Bitcoin-Native Decentralized Autonomous Organization
;; 
;; Summary:
;; A Bitcoin-compliant DAO governance system built on Stacks Layer 2,
;; enabling secure, scalable, and decentralized organization management
;; with direct Bitcoin integration.
;;
;; Description:
;; This contract implements a comprehensive DAO governance framework that leverages
;; Stacks Layer 2 capabilities while maintaining Bitcoin's security guarantees.
;; Key features include:
;; - Secure membership management with reputation tracking
;; - Bitcoin-native treasury management
;; - Proposal creation and weighted voting system
;; - Cross-DAO collaboration capabilities
;; - Automated reputation decay for inactive members
;;

;; Constants

;; Access Control
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))

;; Membership Errors
(define-constant ERR-ALREADY-MEMBER (err u101))
(define-constant ERR-NOT-MEMBER (err u102))

;; Proposal Errors
(define-constant ERR-INVALID-PROPOSAL (err u103))
(define-constant ERR-PROPOSAL-EXPIRED (err u104))
(define-constant ERR-ALREADY-VOTED (err u105))

;; Financial Errors
(define-constant ERR-INSUFFICIENT-FUNDS (err u106))
(define-constant ERR-INVALID-AMOUNT (err u107))

;; Data Variables

;; Core DAO metrics
(define-data-var total-members uint u0)
(define-data-var total-proposals uint u0)
(define-data-var treasury-balance uint u0)

;; Data Maps

;; Member Data Structure
(define-map members principal 
  {
    reputation: uint,
    stake: uint,
    last-interaction: uint
  }
)

;; Proposal Data Structure
(define-map proposals uint 
  {
    creator: principal,
    title: (string-ascii 50),
    description: (string-utf8 500),
    amount: uint,
    yes-votes: uint,
    no-votes: uint,
    status: (string-ascii 10),
    created-at: uint,
    expires-at: uint
  }
)

;; Voting Records
;; Tracks member votes to prevent double voting
(define-map votes {proposal-id: uint, voter: principal} bool)