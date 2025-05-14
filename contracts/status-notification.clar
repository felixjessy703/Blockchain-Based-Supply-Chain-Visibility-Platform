;; Status Notification Contract
;; Alerts stakeholders of changes

(define-map notifications
  { notification-id: (string-ascii 36) }
  {
    product-id: (string-ascii 36),
    entity-id: (string-ascii 36),
    status-type: uint,
    message: (string-utf8 500),
    timestamp: uint,
    acknowledged: bool,
    created-at: uint
  }
)

;; Status types: 1=Info, 2=Warning, 3=Critical, 4=Recall
(define-read-only (get-notification (notification-id (string-ascii 36)))
  (map-get? notifications { notification-id: notification-id })
)

(define-public (create-notification
    (notification-id (string-ascii 36))
    (product-id (string-ascii 36))
    (entity-id (string-ascii 36))
    (status-type uint)
    (message (string-utf8 500))
    (timestamp uint))
  (let ((caller tx-sender))
    ;; Verify entity exists and is verified (would need to call entity-verification contract)
    ;; Verify product exists (would need to call product-registration contract)
    ;; For simplicity, we're not implementing cross-contract calls here

    (asserts! (and (>= status-type u1) (<= status-type u4)) (err u1)) ;; Valid status type
    (asserts! (is-none (get-notification notification-id)) (err u2)) ;; Notification ID not already used

    (ok (map-set notifications
      { notification-id: notification-id }
      {
        product-id: product-id,
        entity-id: entity-id,
        status-type: status-type,
        message: message,
        timestamp: timestamp,
        acknowledged: false,
        created-at: block-height
      }
    ))
  )
)

(define-public (acknowledge-notification (notification-id (string-ascii 36)))
  (let ((caller tx-sender))
    ;; In a real implementation, we would check if caller is authorized
    ;; For simplicity, we're not implementing that check here

    (match (get-notification notification-id)
      notification (ok (map-set notifications
                        { notification-id: notification-id }
                        (merge notification { acknowledged: true })
                      ))
      (err u3) ;; Notification not found
    )
  )
)

(define-read-only (get-entity-notifications (entity-id (string-ascii 36)))
  ;; In a real implementation, we would need to implement a more complex
  ;; indexing mechanism since Clarity doesn't support filtering directly
  ;; This is a placeholder for the concept
  (ok true)
)
