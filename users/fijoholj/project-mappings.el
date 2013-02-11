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
(defun custom-persp/smajobber ()
  (interactive)
  (custom-persp "smajobber"
                (find-file "~/finn/code/smajobber/")))

(define-key persp-mode-map (kbd "C-x p s") 'custom-persp/smajobber)

(require 'smajobber-mode)
(project-specifics "smajobber"
                   (smajobber-mode))

;; FINN Oppdrag
(defun custom-persp/oppdrag ()
  (interactive)
  (custom-persp "oppdrag"
                (find-file "~/finn/code/oppdrag-services/app-main/web/src/")))

(define-key persp-mode-map (kbd "C-x p o") 'custom-persp/oppdrag)

(require 'oppdrag-mode)

(project-specifics "oppdrag-services"
                   (set (make-local-variable 'slime-js-target-url) "http://local.finn.no:8080/")
                   (set (make-local-variable 'slime-js-connect-url) "http://local.finn.no:8009")
                   (set (make-local-variable 'slime-js-starting-url) "/oppdrag/")
                   (ffip-local-patterns "*.js" "*.jsp" "*.css" "*.org" "*.vm" "*jsTestDriver.conf" "*jawr.properties")
                   (oppdrag-mode))

;; HDO
(defun custom-persp/hdo ()
  (interactive)
  (custom-persp "hdo"
                (find-file "~/projects/hdo-site/")))

(project-specifics "hdo-site"
                   (setq js2r-path-to-tests "/spec/javascript/")
                   (setq js2r-path-to-sources "/app/assets/javascripts/"))

(define-key persp-mode-map (kbd "C-x p h") 'custom-persp/hdo)
