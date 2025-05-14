;; Location Verification Contract
;; Validates geographic positions

(define-map locations
  { location-id: (string-ascii 36) }
  {
    product-id: (string-ascii 36),
    entity-id: (string-ascii 36),
    latitude: int,
    longitude: int,
    timestamp: uint,
    verified: bool,
    recorded-at: uint
  }
)

(define-read-only (get-location (location-id (string-ascii 36)))
  (map-get? locations { location-id: location-id })
)

(define-public (record-location
    (location-id (string-ascii 36))
    (product-id (string-ascii 36))
    (entity-id (string-ascii 36))
    (latitude int)
    (longitude int)
    (timestamp uint))
  (let ((caller tx-sender))
    ;; Verify entity exists and is verified (would need to call entity-verification contract)
    ;; Verify product exists (would need to call product-registration contract)
    ;; For simplicity, we're not implementing cross-contract calls here

    (asserts! (is-none (get-location location-id)) (err u1)) ;; Location ID not already used

    (ok (map-set locations
      { location-id: location-id }
      {
        product-id: product-id,
        entity-id: entity-id,
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp,
        verified: false,
        recorded-at: block-height
      }
    ))
  )
)

(define-public (verify-location (location-id (string-ascii 36)))
  (let ((caller tx-sender))
    ;; In a real implementation, we would check if caller is authorized
    ;; For simplicity, we're not implementing that check here

    (match (get-location location-id)
      location (ok (map-set locations
                    { location-id: location-id }
                    (merge location { verified: true })
                  ))
      (err u2) ;; Location not found
    )
  )
)

(define-read-only (get-product-locations (product-id (string-ascii 36)))
  ;; In a real implementation, we would need to implement a more complex
  ;; indexing mechanism since Clarity doesn't support filtering directly
  ;; This is a placeholder for the concept
  (ok true)
)
