;;; init-languages.el --- Language support  -*- lexical-binding: t; -*-

;;; Lisp (Clojure and Emacs Lisp)

(use-package paredit
  :hook ((emacs-lisp-mode lisp-data-mode clojure-mode cider-repl-mode) . paredit-mode)
  :bind (:map paredit-mode-map
              ("C-w" . paredit-kill-region-or-backward-word)
              ("M-(" . paredit-wrap-round)
              ("M-s-8" . paredit-wrap-square)
              ("M-s-(" . paredit-wrap-curly))
  :config
  ;; Move paredit bindings that clash with common keys over to Super
  (dolist (binding '(("M-s"         "s-s"         paredit-splice-sexp)
                     ("M-<up>"      "s-<up>"      paredit-splice-sexp-killing-backward)
                     ("M-<down>"    "s-<down>"    paredit-splice-sexp-killing-forward)
                     ("C-<right>"   "s-<right>"   paredit-forward-slurp-sexp)
                     ("C-<left>"    "s-<left>"    paredit-forward-barf-sexp)
                     ("C-M-<left>"  "s-S-<left>"  paredit-backward-slurp-sexp)
                     ("C-M-<right>" "s-S-<right>" paredit-backward-barf-sexp)))
    (pcase-let ((`(,original ,replacement ,command) binding))
      (define-key paredit-mode-map (kbd original) nil)
      (define-key paredit-mode-map (kbd replacement) command)))

  ;; Make paredit play nice with delete-selection-mode
  (put 'paredit-forward-delete 'delete-selection 'supersede)
  (put 'paredit-backward-delete 'delete-selection 'supersede)
  (put 'paredit-newline 'delete-selection t))

(defun paredit-kill-region-or-backward-word ()
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (paredit-backward-kill-word)))

(use-package clojure-mode
  :hook (clojure-mode . eglot-ensure)
  :custom (clojure-toplevel-inside-comment-form t))

(use-package cider
  :defer t
  :custom
  (cider-save-file-on-load t)
  (cider-repl-pop-to-buffer-on-connect nil)
  (cider-reuse-dead-repls 'auto)
  (cider-repl-display-output-before-window-boundaries t)
  (sesman-use-friendly-sessions nil))

;;; JavaScript / TypeScript / web

(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :hook ((typescript-ts-mode tsx-ts-mode js-ts-mode) . eglot-ensure))

;;; Python

(add-hook 'python-ts-mode-hook #'eglot-ensure)

;;; Haskell and Tidal

(use-package haskell-mode
  :hook (haskell-mode . interactive-haskell-mode))

;; Live coding with TidalCycles. C-c C-s starts, C-c C-c sends the block.
(use-package tidal
  :defer t)

;;; Markdown and config

;; Used a lot: CLAUDE.md, plans, READMEs
(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("CLAUDE\\.md\\'" . gfm-mode))
  ;; markdown-mode uses M-n/M-p for links. We want paragraphs, like everywhere else.
  :bind (:map markdown-mode-map
              ("M-n" . markdown-forward-paragraph)
              ("M-p" . markdown-backward-paragraph)
              ("M-N" . markdown-next-link)
              ("M-P" . markdown-previous-link))
  :custom (markdown-fontify-code-blocks-natively t))

(use-package yaml-ts-mode
  :ensure nil
  :if (treesit-language-available-p 'yaml)
  :mode "\\.ya?ml\\'")

(provide 'init-languages)
