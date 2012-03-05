;; Project peculiarities: FINN Oppdrag
(require 'oppdrag-mode)
(add-hook 'find-file-hook
          (lambda ()
            (when (string-match-p "oppdrag-services" (buffer-file-name))
              (oppdrag-mode))))

;; Perspectives

(defun custom-persp/oppdrag ()
  (interactive)
  (custom-persp "oppdrag"
                (find-file "~/finn/code/oppdrag-services/app-main/web/src/")))

(defun custom-persp/emacs ()
  (interactive)
  (custom-persp "emacs"
                (find-file "~/.emacs.d/init.el")))

(defun custom-persp/org ()
  (interactive)
  (custom-persp "org"
                (find-file "~/Dropbox/org/")))
(defun custom-persp/tirilaarvig ()
  (interactive)
  (custom-persp "tirilaarvig"
                (find-file "~/projects/tirilaarvig/app/")))

(define-key persp-mode-map (kbd "C-x p o") 'custom-persp/oppdrag)
(define-key persp-mode-map (kbd "C-x p e") 'custom-persp/emacs)
(define-key persp-mode-map (kbd "C-x p t") 'custom-persp/tirilaarvig)
(define-key persp-mode-map (kbd "C-<f6>") 'custom-persp/org)
