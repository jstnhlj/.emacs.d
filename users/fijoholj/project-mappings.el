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

;; Potion
(defun custom-persp/potion ()
  (interactive)
  (custom-persp "Potion"
                (find-file "~/projects/potion/")))

(define-key persp-mode-map (kbd "C-x p p") 'custom-persp/potion)

;; Nyhetstavla
(defun custom-persp/nyhetstavla ()
  (interactive)
  (custom-persp "Nyhetstavla"
                (find-file "~/projects/nyhetstavla/")))

(define-key persp-mode-map (kbd "C-x p n") 'custom-persp/nyhetstavla)

;; Bidra web
(defun custom-persp/bidra-web ()
  (interactive)
  (custom-persp "bidra-web"
                (find-file "~/projects/bidra-web/")))

(define-key persp-mode-map (kbd "C-x p b") 'custom-persp/bidra-web)

;; Leest
(defun custom-persp/leest ()
  (interactive)
  (custom-persp "leest"
                (find-file "~/projects/leest/")))

(define-key persp-mode-map (kbd "C-x p l") 'custom-persp/leest)

;; ussr
(defun custom-persp/ussr ()
  (interactive)
  (custom-persp "ussr"
                (find-file "~/projects/ussr/")))

(define-key persp-mode-map (kbd "C-x p u") 'custom-persp/ussr)


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
