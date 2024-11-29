;; QuestVerse Core Smart Contract
;; Implements AR location-based gaming with NFTs, achievements, and player management

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-invalid-location (err u102))
(define-constant err-already-claimed (err u103))
(define-constant err-insufficient-funds (err u104))

;; Data Variables
(define-data-var min-distance-meters uint u10)
(define-data-var reward-amount uint u100)

;; NFT Definitions
(define-non-fungible-token game-item uint)
(define-non-fungible-token achievement uint)

;; Maps for Data Storage
(define-map players principal 
    {
        score: uint,
        items: (list 100 uint),
        achievements: (list 50 uint),
        last-location: {latitude: int, longitude: int}
    }
)

(define-map locations uint 
    {
        latitude: int,
        longitude: int,
        reward-type: (string-utf8 20),
        active: bool,
        claimed-by: (optional principal)
    }
)

(define-map items uint 
    {
        name: (string-utf8 50),
        rarity: uint,
        power: uint
    }
)

(define-map achievements uint 
    {
        name: (string-utf8 50),
        description: (string-utf8 100),
        points: uint
    }
)

(define-map leaderboard uint principal)

;; Counter Variables
(define-data-var next-item-id uint u1)
(define-data-var next-achievement-id uint u1)
(define-data-var next-location-id uint u1)

;; Administrative Functions

(define-public (add-location (latitude int) (longitude int) (reward-type (string-utf8 20)))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (map-set locations (var-get next-location-id)
            {
                latitude: latitude,
                longitude: longitude,
                reward-type: reward-type,
                active: true,
                claimed-by: none
            }
        )
        (var-set next-location-id (+ (var-get next-location-id) u1))
        (ok true)
    )
)

;; Player Management Functions

(define-public (register-player)
    (begin
        (map-set players tx-sender
            {
                score: u0,
                items: (list),
                achievements: (list),
                last-location: {latitude: 0, longitude: 0}
            }
        )
        (ok true)
    )
)

(define-public (update-player-location (latitude int) (longitude int))
    (begin
        (map-set players tx-sender
            (merge (default-to
                {
                    score: u0,
                    items: (list),
                    achievements: (list),
                    last-location: {latitude: 0, longitude: 0}
                }
                (map-get? players tx-sender)
            )
            {
                last-location: {latitude: latitude, longitude: longitude}
            })
        )
        (ok true)
    )
)

;; Game Mechanics

(define-private (calculate-distance (lat1 int) (lon1 int) (lat2 int) (lon2 int))
    ;; Simple distance calculation for demonstration
    ;; In practice, you'd want a more accurate haversine formula
    (let (
        (lat-diff (if (> lat1 lat2) 
                     (- lat1 lat2) 
                     (- lat2 lat1)))
        (lon-diff (if (> lon1 lon2) 
                     (- lon1 lon2) 
                     (- lon2 lon1)))
    )
    (+ lat-diff lon-diff))
)

(define-public (check-location (location-id uint))
    (let (
        (location (unwrap! (map-get? locations location-id) err-not-found))
        (player-data (unwrap! (map-get? players tx-sender) err-not-found))
        (player-location (get last-location player-data))
        (distance (calculate-distance 
            (get latitude player-location)
            (get longitude player-location)
            (get latitude location)
            (get longitude location)
        ))
    )
    (asserts! (<= (to-uint distance) (var-get min-distance-meters)) err-invalid-location)
    (asserts! (get active location) err-not-found)
    (asserts! (is-none (get claimed-by location)) err-already-claimed)
    
    ;; Reward player
    (let (
        (new-score (+ (get score player-data) (var-get reward-amount)))
        (new-item-id (var-get next-item-id))
    )
        ;; Mint NFT reward
        (try! (nft-mint? game-item new-item-id tx-sender))
        
        ;; Update player data
        (map-set players tx-sender
            (merge player-data {
                score: new-score,
                items: (unwrap! (as-max-len? (append (get items player-data) new-item-id) u100) err-invalid-location)
            })
        )
        
        ;; Mark location as claimed
        (map-set locations location-id
            (merge location {
                active: false,
                claimed-by: (some tx-sender)
            })
        )
        
        ;; Update item counter
        (var-set next-item-id (+ new-item-id u1))
        
        (ok new-item-id)
    )
))

;; Achievement System

(define-public (award-achievement (achievement-id uint))
    (let (
        (player-data (unwrap! (map-get? players tx-sender) err-not-found))
        (achievement-data (unwrap! (map-get? achievements achievement-id) err-not-found))
    )
    (begin
        ;; Mint achievement NFT
        (try! (nft-mint? achievement achievement-id tx-sender))
        
        ;; Update player achievements
        (map-set players tx-sender
            (merge player-data {
                score: (+ (get score player-data) (get points achievement-data)),
                achievements: (unwrap! (as-max-len? (append (get achievements player-data) achievement-id) u50) err-invalid-location)
            })
        )
        (ok true)
    ))
)

;; Trading System

(define-public (transfer-item (item-id uint) (recipient principal))
    (begin
        (try! (nft-transfer? game-item item-id tx-sender recipient))
        ;; Update player inventories would go here
        (ok true)
    )
)

;; Leaderboard Management

(define-private (update-leaderboard)
    (let (
        (current-player tx-sender)
        (player-score (get score (unwrap! (map-get? players current-player) err-not-found)))
    )
    ;; Simple leaderboard update - in practice, you'd want more sophisticated logic
    (begin
        (map-set leaderboard player-score current-player)
        (ok true)
    ))
)

;; Getter Functions

(define-read-only (get-player-info (player principal))
    (map-get? players player)
)

(define-read-only (get-location-info (location-id uint))
    (map-get? locations location-id)
)

(define-read-only (get-item-info (item-id uint))
    (map-get? items item-id)
)

(define-read-only (get-achievement-info (achievement-id uint))
    (map-get? achievements achievement-id)
)