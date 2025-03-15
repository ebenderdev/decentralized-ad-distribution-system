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

;; Content provider registry
(define-map AuthorizedContentProviders
    { content-provider: principal }
    {
        authorization-status: bool,
        quality-score: uint,
        lifetime-revenue: uint,
        registration-block: uint,
        recent-activity-block: uint
    }
)

;; Advertiser performance tracking
(define-map AdvertiserPerformance
    { advertiser: principal }
    {
        campaign-count: uint,
        live-campaign-count: uint,
        lifetime-spend: uint,
        lifetime-impressions: uint,
        engagement-rate: uint,
        trust-score: uint,
        most-recent-campaign: uint,
        registration-block: uint
    }
)

;; Impression tracking by time period
(define-map ImpressionsByDay
    { ad-id: uint, block-day: uint }
    { impression-count: uint }
)

;; ========================================
;; Utility Functions
;; ========================================

(define-private (compute-commission-amount (payment-amount uint))
    (/ (* payment-amount (var-get system-fee-basis-points)) u10000)
)

(define-private (verify-admin-privileges)
    (is-eq tx-sender (var-get admin-address))
)

(define-private (check-provider-eligibility (content-provider principal))
    (match (map-get? AuthorizedContentProviders { content-provider: content-provider })
        provider-record (get authorization-status provider-record)
        false
    )
)

(define-private (log-daily-impression (ad-id uint))
    (let
        (
            (current-period (/ block-height u144))  ;; Approximately daily blocks
            (period-data (default-to { impression-count: u0 }
                (map-get? ImpressionsByDay { ad-id: ad-id, block-day: current-period })))
        )
        (map-set ImpressionsByDay
            { ad-id: ad-id, block-day: current-period }
            { impression-count: (+ u1 (get impression-count period-data)) }
        )
        true  ;; Return success flag
    )
)

(define-private (verify-impression-availability (ad-id uint))
    (let
        (
            (ad-data (unwrap-panic (map-get? AdCampaigns { ad-id: ad-id })))
            (current-period (/ block-height u144))
            (period-impressions (default-to { impression-count: u0 }
                (map-get? ImpressionsByDay { ad-id: ad-id, block-day: current-period })))
        )
        (<= (get impression-count period-impressions) (get daily-impression-max ad-data))
    )
)

