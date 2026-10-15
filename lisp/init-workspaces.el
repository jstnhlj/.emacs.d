;;; init-workspaces.el --- Perspectives and projects  -*- lexical-binding: t; -*-

;; One perspective per project, with its own buffers and window layout. Works
;; well with AI too: each project keeps its own Claude session.
(use-package perspective
  :bind (("C-x C-b" . persp-ibuffer)
         ("C-x k" . persp-kill-buffer*))
  :custom
  (persp-mode-prefix-key (kbd "C-x x"))
  (persp-suppress-no-prefix-key-warning t)
  :init (persp-mode 1))

;; Only show buffers from the current perspective in C-x b
(use-package consult
  :after perspective
  :bind ("C-x b" . consult-buffer)
  :config
  (consult-customize consult-source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source))

;; project.el (built in) replaces projectile. Prefix: C-x p or s-p.
(use-package project
  :ensure nil
  :bind-keymap ("s-p" . project-prefix-map)
  :bind (:map project-prefix-map
              ("p" . my/project-switch-with-perspective)
              ("s-p" . my/project-switch-with-perspective)
              ("e" . my/switch-to-emacs-config))
  :custom
  ;; Switching project goes straight to find-file
  (project-switch-commands #'project-find-file))

(defun my/project-switch-with-perspective (dir)
  "Switch to the project in DIR in its own perspective named after the project."
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
