;;; init-git.el --- Git: magit, diff-hl, ediff  -*- lexical-binding: t; -*-

(use-package magit
  :bind (("C-x m" . magit-status)
         ("C-x v t" . magit-log-buffer-file))
  :custom
  ;; Magit status fills the frame, q restores the windows
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  (magit-bury-buffer-function #'magit-restore-window-configuration)
  (magit-diff-refine-hunk t)
  (magit-no-confirm '(stage-all-changes unstage-all-changes))
  (magit-section-initial-visibility-alist '((untracked . show)
                                            (unstaged . show)
                                            (unpushed . show)
                                            (unpulled . show)
                                            (stashes . show)))
  :config
  (remove-hook 'magit-status-sections-hook #'magit-insert-tags-header))

;; Show changes in the fringe. A quick overview of what the agent has touched.
(use-package diff-hl
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)
         (dired-mode . diff-hl-dired-mode))
  :bind (("C-x v n" . diff-hl-next-hunk)
         ("C-x v p" . diff-hl-previous-hunk)
         ("C-x v s" . diff-hl-show-hunk))
  :init (global-diff-hl-mode 1))

(use-package browse-at-remote
  :bind ("C-x v w" . browse-at-remote-kill))

;; ediff in the same frame, side by side. claude-code-ide uses ediff to show
;; proposed changes.
(use-package ediff
  :ensure nil
  :custom
  (ediff-window-setup-function #'ediff-setup-windows-plain)
  (ediff-split-window-function #'split-window-horizontally))

(provide 'init-git)
