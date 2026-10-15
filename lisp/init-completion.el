;;; init-completion.el --- Minibuffer and in-buffer completion  -*- lexical-binding: t; -*-

;; Vertical completion list in the minibuffer
(use-package vertico
  :bind (:map vertico-map
              ("M-<return>" . vertico-exit-input))
  :init (vertico-mode 1))

;; Ships with vertico. Nicer navigation of file paths.
(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; Match space-separated components in any order
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (orderless-matching-styles '(orderless-literal orderless-prefixes
                               orderless-initialism orderless-regexp)))

;; Extra annotations in completion lists
(use-package marginalia
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :init (marginalia-mode 1))

(use-package consult
  :bind (("C-x f" . consult-recent-file)
         ("C-x C-i" . consult-imenu)
         ("C-x M-i" . consult-imenu-multi)
         ("C-v" . consult-line)
         ("M-v" . consult-line-multi)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g f" . consult-flymake)
         ("M-s r" . consult-ripgrep)
         ("M-s k" . consult-keep-lines)))

;; Completion popup in buffers. TAB indents first, then completes.
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto nil)
  (tab-always-indent 'complete)
  :bind ("C-," . completion-at-point)
  :init (global-corfu-mode 1))

(provide 'init-completion)
