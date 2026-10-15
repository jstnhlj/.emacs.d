;;; init-workspaces.el --- Perspektiver og prosjekter  -*- lexical-binding: t; -*-

;; Ett perspektiv per prosjekt, med egne buffere og vindusoppsett. Gir god
;; flyt med AI også: hvert prosjekt har sin egen Claude-sesjon.
(use-package perspective
  :bind (("C-x C-b" . persp-ibuffer)
         ("C-x k" . persp-kill-buffer*))
  :custom
  (persp-mode-prefix-key (kbd "C-x x"))
  (persp-suppress-no-prefix-key-warning t)
  :init (persp-mode 1))

;; Vis bare bufferne til gjeldende perspektiv i C-x b
(use-package consult
  :after perspective
  :bind ("C-x b" . consult-buffer)
  :config
  (consult-customize consult-source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source))

;; project.el (innebygd) erstatter projectile. Prefiks: C-x p eller s-p.
(use-package project
  :ensure nil
  :bind-keymap ("s-p" . project-prefix-map)
  :bind (:map project-prefix-map
              ("p" . my/project-switch-with-perspective)
              ("s-p" . my/project-switch-with-perspective)
              ("e" . my/switch-to-emacs-config))
  :custom
  ;; Bytte prosjekt går rett til find-file
  (project-switch-commands #'project-find-file))

(defun my/project-switch-with-perspective (dir)
  "Bytt til prosjektet i DIR i et eget perspektiv oppkalt etter prosjektet."
  (interactive (list (funcall project-prompter)))
  (let* ((name (file-name-nondirectory (directory-file-name dir)))
         (new? (not (gethash name (perspectives-hash)))))
    (persp-switch name)
    (when new?
      (project-switch-project dir))))

(defun my/switch-to-emacs-config ()
  (interactive)
  (my/project-switch-with-perspective user-emacs-directory))

(provide 'init-workspaces)
