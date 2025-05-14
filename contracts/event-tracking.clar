;; Event Tracking Contract
;; Monitors supply chain milestones

(define-map events
  { event-id: (string-ascii 36) }
  {
    product-id: (string-ascii 36),
    entity-id: (string-ascii 36),
    event-type: uint,
    timestamp: uint,
    notes: (string-utf8 500),
    recorded-at: uint
  }
)

;; Event types: 1=Production, 2=Packaging, 3=Shipping, 4=Receiving, 5=Quality Check
(define-read-only (get-event (event-id (string-ascii 36)))
  (map-get? events { event-id: event-id })
)

(define-public (record-event
    (event-id (string-ascii 36))
    (product-id (string-ascii 36))
    (entity-id (string-ascii 36))
    (event-type uint)
    (timestamp uint)
    (notes (string-utf8 500)))
  (let ((caller tx-sender))
    ;; Verify entity exists and is verified (would need to call entity-verification contract)
    ;; Verify product exists (would need to call product-registration contract)
    ;; For simplicity, we're not implementing cross-contract calls here

    (asserts! (and (>= event-type u1) (<= event-type u5)) (err u1)) ;; Valid event type
    (asserts! (is-none (get-event event-id)) (err u2)) ;; Event ID not already used

    (ok (map-set events
      { event-id: event-id }
      {
        product-id: product-id,
        entity-id: entity-id,
        event-type: event-type,
        timestamp: timestamp,
        notes: notes,
        recorded-at: block-height
      }
    ))
  )
)

(define-read-only (get-product-history (product-id (string-ascii 36)))
  ;; In a real implementation, we would need to implement a more complex
  ;; indexing mechanism since Clarity doesn't support filtering directly
  ;; This is a placeholder for the concept
  (ok true)
)
