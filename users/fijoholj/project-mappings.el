(defmacro project-specifics (name &rest body)
  `(progn
     (add-hook 'find-file-hook
             (lambda ()
               (when (string-match-p ,name (buffer-file-name))
                 ,@body)))
     (add-hook 'dired-after-readin-hook
             (lambda ()
               (when (string-match-p ,name (dired-current-directory))
                 ,@body)))))

;; Project peculiarities: FINN Oppdrag
(require 'oppdrag-mode)
(add-hook 'find-file-hook
          (lambda ()
            (when (string-match-p "oppdrag-services" (buffer-file-name))
              (oppdrag-mode))))

(project-specifics "oppdrag-services"
                   (set (make-local-variable 'slime-js-target-url) "http://local.finn.no:8080/oppdrag/")
                   (ffip-local-patterns "*.js" "*.jsp" "*.css" "*.org" "*.vm" "*jsTestDriver.conf" "*jawr.properties")
                   (oppdrag-mode))

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
