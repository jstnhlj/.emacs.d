;;; init-prog.el --- Shared programming tools  -*- lexical-binding: t; -*-

;;; Tree-sitter

;; Pinned versions that work with Emacs 30. Install with M-x my/treesit-install-grammars.
(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.23.1" "src")
        (json       "https://github.com/tree-sitter/tree-sitter-json" "v0.24.8")
        (css        "https://github.com/tree-sitter/tree-sitter-css" "v0.23.2")
        (python     "https://github.com/tree-sitter/tree-sitter-python" "v0.23.6")
        (yaml       "https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0")))

(defun my/treesit-install-grammars ()
  "Install all missing tree-sitter grammars."
  (interactive)
  (dolist (lang (mapcar #'car treesit-language-source-alist))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

;; Use *-ts-mode when the grammar is available
(dolist (remap '((js-mode . js-ts-mode)
                 (javascript-mode . js-ts-mode)
                 (js-json-mode . json-ts-mode)
                 (css-mode . css-ts-mode)
                 (python-mode . python-ts-mode)))
  (when (treesit-language-available-p
         (intern (string-remove-suffix "-ts-mode" (symbol-name (cdr remap)))))
    (add-to-list 'major-mode-remap-alist remap)))

;;; LSP

;; Eglot is built in and uses flymake for diagnostics
(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format))
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-config '(:size 0 :format full)))

(use-package flymake
  :ensure nil
  :bind (:map flymake-mode-map
              ("M-g n" . flymake-goto-next-error)
              ("M-g p" . flymake-goto-prev-error)))

;;; Search

(use-package deadgrep
  :bind (("M-s s" . deadgrep)
         :map deadgrep-mode-map
         ("e" . deadgrep-edit-mode)))

;; Edit search hits directly in grep buffers (C-c C-p), saved automatically
(use-package wgrep
  :custom (wgrep-auto-save-buffer t))

;;; Misc

;; Colors in compilation buffers (test runs etc.)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)
(setq compilation-scroll-output 'first-error)

(use-package dired
  :ensure nil
  :hook (dired-mode . dired-hide-details-mode)
  :custom (dired-dwim-target t)
  :bind (:map dired-mode-map
              ("M-<up>" . dired-up-directory)
              ("M-<down>" . dired-find-file)
              ("k" . dired-do-delete)))

(provide 'init-prog)
