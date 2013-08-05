;; Default js indentation levels
(setq-default js2-basic-offset 4)
(setq js-indent-level 4)

;; Disallow scrolling with mouse wheel
(when window-system
  (mouse-wheel-mode -1))

;; Font size
(define-key global-map (kbd "M-s +") 'zoom-in)
(define-key global-map (kbd "M-s -") 'zoom-out)
