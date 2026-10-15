;;; init-git.el --- Git: magit, diff-hl, ediff  -*- lexical-binding: t; -*-

(use-package magit
  :bind (("C-x m" . magit-status)
         ("C-x v t" . magit-log-buffer-file))
  :custom
  ;; Magit-status i hele rammen, q gjenoppretter vinduene
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

;; Vis endringer i margen. Rask oversikt over hva agenten har rørt.
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

;; ediff i samme ramme, side ved side. claude-code-ide bruker ediff til å vise
;; foreslåtte endringer.
(use-package ediff
  :ensure nil
  :custom
  (ediff-window-setup-function #'ediff-setup-windows-plain)
  (ediff-split-window-function #'split-window-horizontally))

(provide 'init-git)
