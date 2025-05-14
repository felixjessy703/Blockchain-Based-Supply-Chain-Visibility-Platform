;; Product Registration Contract
;; Records item details

(define-map products
  { product-id: (string-ascii 36) }
  {
    entity-id: (string-ascii 36),
    name: (string-utf8 100),
    description: (string-utf8 500),
    manufacturer-date: uint,
    batch-number: (string-ascii 50),
    registered-at: uint
  }
)

(define-read-only (get-product (product-id (string-ascii 36)))
  (map-get? products { product-id: product-id })
)

(define-public (register-product
    (product-id (string-ascii 36))
    (entity-id (string-ascii 36))
    (name (string-utf8 100))
    (description (string-utf8 500))
    (manufacturer-date uint)
    (batch-number (string-ascii 50)))
  (let ((caller tx-sender))
    ;; Verify entity exists and is verified (would need to call entity-verification contract)
    ;; For simplicity, we're not implementing cross-contract calls here

    (asserts! (is-none (get-product product-id)) (err u1)) ;; Product ID not already used

    (ok (map-set products
      { product-id: product-id }
      {
        entity-id: entity-id,
        name: name,
        description: description,
        manufacturer-date: manufacturer-date,
        batch-number: batch-number,
        registered-at: block-height
      }
    ))
  )
)

(define-read-only (get-products-by-entity (entity-id (string-ascii 36)))
  ;; In a real implementation, we would need to implement a more complex
  ;; indexing mechanism since Clarity doesn't support filtering directly
  ;; This is a placeholder for the concept
  (ok true)
)
