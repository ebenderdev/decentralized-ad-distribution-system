;; ad-distribution-system.clar
;; Decentralized advertising ecosystem for content publishers and advertisers


;; ========================================
;; Storage & Persistent State
;; ========================================

;; System administration
(define-data-var admin-address principal tx-sender)
(define-data-var system-fee-basis-points uint u200)  ;; 2% expressed in basis points
(define-data-var ad-sequence-number uint u0)
(define-data-var accumulated-platform-revenue uint u0)
(define-data-var base-ad-deposit uint u100000)  ;; in micro-STX

;; ========================================
;; Error Definitions
;; ========================================

(define-constant ACCESS-DENIED (err u401))
(define-constant INVALID-INPUT (err u400))
(define-constant RESOURCE-NOT-AVAILABLE (err u404))
(define-constant AD-TIMEFRAME-ENDED (err u410))
(define-constant PAYMENT-REQUIRED (err u402))
(define-constant INVALID-OPERATION (err u403))
(define-constant AD-SUSPENDED (err u405))
(define-constant IMPRESSION-CAP-REACHED (err u406))
(define-constant CONTENT-PROVIDER-UNVERIFIED (err u407))

;; ========================================
;; Data Structures
;; ========================================

;; Ad category definitions
(define-map AdCategories
    { category-code: uint }
    {
        label: (string-ascii 20),
        minimum-runtime: uint,
        maximum-runtime: uint,
        minimum-funding: uint
    }
)

;; Ad campaign storage
(define-map AdCampaigns
    { ad-id: uint }
    {
        owner: principal,
        category-code: uint,
        total-funding: uint,
        available-funding: uint,
        impression-price: uint,
        activation-block: uint,
        expiration-block: uint,
        operational-status: (string-ascii 20),
        impression-goal: uint,
        recorded-impressions: uint,
        daily-impression-max: uint,
        segment-criteria: (optional (string-utf8 500)),
        allows-refund: bool,
        platform-commission: uint,
        creation-timestamp: uint,
        modification-timestamp: uint
    }
)
