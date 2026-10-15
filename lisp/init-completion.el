;;; init-completion.el --- Minibuffer- og in-buffer-komplettering  -*- lexical-binding: t; -*-

;; Vertikal kompletteringsliste i minibufferen
(use-package vertico
  :bind (:map vertico-map
              ("M-<return>" . vertico-exit-input))
  :init (vertico-mode 1))

;; Følger med vertico. Bedre navigering i filstier.
(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; Søk med mellomromsseparerte biter i vilkårlig rekkefølge
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (orderless-matching-styles '(orderless-literal orderless-prefixes
                               orderless-initialism orderless-regexp)))

;; Ekstra info i kompletteringslister
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

;; Kompletteringspopup i buffere. TAB indenterer først, så kompletterer den.
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto nil)
  (tab-always-indent 'complete)
  :bind ("C-," . completion-at-point)
  :init (global-corfu-mode 1))

(provide 'init-completion)
