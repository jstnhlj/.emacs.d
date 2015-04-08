(defmacro project-specifics (name &rest body)
  (declare (indent 1))
  `(progn
     (add-hook 'find-file-hook
               (lambda ()
                 (when (string-match-p ,name (buffer-file-name))
                   ,@body)))
     (add-hook 'dired-after-readin-hook
               (lambda ()
                 (when (string-match-p ,name (dired-current-directory))
                   ,@body)))))

;; Emacs
(defun custom-persp/emacs ()
  (interactive)
  (custom-persp "emacs"
                (find-file "~/.emacs.d/init.el")))

(define-key persp-mode-map (kbd "C-x p e") 'custom-persp/emacs)

;; Org
(defun custom-persp/org ()
  (interactive)
  (custom-persp "org"
                (find-file "~/Dropbox/org/")))

(define-key persp-mode-map (kbd "C-<f6>") 'custom-persp/org)

;; Småjobber
;; (defun custom-persp/smajobber ()
;;   (interactive)
;;   (custom-persp "smajobber"
;;                 (find-file "~/finn/smajobber/")))

;; (define-key persp-mode-map (kbd "C-x p s") 'custom-persp/smajobber)

;; (require 'smajobber-mode)

;; (project-specifics "smajobber"
;;   (ffip-local-patterns "*.js" "*.jsp" "*.css" "*.org" "*.vm" "*.xml" "*.properties")
;;   (smajobber-mode))

;; FINN Oppdrag
;; (defun custom-persp/oppdrag ()
;;   (interactive)
;;   (custom-persp "oppdrag"
;;                 (find-file "~/finn/oppdrag-services/app-main/web/src/")))

;; (define-key persp-mode-map (kbd "C-x p o") 'custom-persp/oppdrag)

;; (require 'oppdrag-mode)

;; (project-specifics "oppdrag-services"
;;   (set (make-local-variable 'slime-js-target-url) "http://local.finn.no:8080/")
;;   (set (make-local-variable 'slime-js-connect-url) "http://local.finn.no:8009")
;;   (set (make-local-variable 'slime-js-starting-url) "/oppdrag/")
;;   (ffip-local-patterns "*.js" "*.jsp" "*.css" "*.org" "*.vm" "*jsTestDriver.conf" "*jawr.properties")
;;   (oppdrag-mode))

;; Spond
(defun custom-persp/spond ()
  (interactive)
  (custom-persp "spond"
                (find-file "~/projects/spond-frontend/spond-web-client-new/")))

(define-key persp-mode-map (kbd "C-x p s") 'custom-persp/spond)

(project-specifics "spond-frontend"
  (set (make-local-variable 'sgml-basic-offset) 4)
  (set (make-local-variable 'js2-basic-offset) 4)
  (set (make-local-variable 'js-indent-level) 4))



