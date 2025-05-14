;; Entity Verification Contract
;; Validates supply chain participants

(define-data-var admin principal tx-sender)

;; Entity types: 1=Manufacturer, 2=Distributor, 3=Retailer, 4=Logistics
(define-map entities
  { entity-id: (string-ascii 36) }
  {
    owner: principal,
    name: (string-utf8 100),
    entity-type: uint,
    verified: bool,
    created-at: uint
  }
)

(define-read-only (get-entity (entity-id (string-ascii 36)))
  (map-get? entities { entity-id: entity-id })
)

(define-public (register-entity
    (entity-id (string-ascii 36))
    (name (string-utf8 100))
    (entity-type uint))
  (let ((caller tx-sender))
    (asserts! (and (>= entity-type u1) (<= entity-type u4)) (err u1)) ;; Valid entity type
    (asserts! (is-none (get-entity entity-id)) (err u2)) ;; Entity ID not already used

    (ok (map-set entities
      { entity-id: entity-id }
      {
        owner: caller,
        name: name,
        entity-type: entity-type,
        verified: false,
        created-at: block-height
      }
    ))
  )
)

(define-public (verify-entity (entity-id (string-ascii 36)))
  (let ((caller tx-sender))
    (asserts! (is-eq caller (var-get admin)) (err u3)) ;; Only admin can verify

    (match (get-entity entity-id)
      entity (ok (map-set entities
                  { entity-id: entity-id }
                  (merge entity { verified: true })
                ))
      (err u4) ;; Entity not found
    )
  )
)

(define-public (transfer-admin (new-admin principal))
  (let ((caller tx-sender))
    (asserts! (is-eq caller (var-get admin)) (err u3)) ;; Only admin can transfer
    (ok (var-set admin new-admin))
  )
)
