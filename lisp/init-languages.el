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

;; Jump between src/foo/bar.clj and test/foo/bar_test.clj (also .cljs/.cljc).
;; Paths are absolute, since relative expansions resolve from where MATCH starts.
(setq find-sibling-rules
      '(("\\`\\(.*/\\)src/\\(.+\\)\\.clj[cs]?\\'"
         "\\1test/\\2_test\\.clj[cs]?\\'")
        ("\\`\\(.*/\\)test/\\(.+\\)_test\\.clj[cs]?\\'"
         "\\1src/\\2\\.clj[cs]?\\'")))

(defun my/clojure-path->ns (path)
  "Turn a relative PATH like \"foo/bar_baz\" into the namespace foo.bar-baz."
  (string-replace "_" "-" (string-replace "/" "." path)))

(defun my/clojure-sibling-target (file)
  "Return (PATH . CONTENTS) for the src/test file FILE should have, or nil."
  (cond
   ((string-match "\\`\\(.*/\\)src/\\(.+\\)\\.\\(clj[cs]?\\)\\'" file)
    (let ((ns (my/clojure-path->ns (match-string 2 file))))
      (cons (concat (match-string 1 file) "test/" (match-string 2 file)
                    "_test." (match-string 3 file))
            (format "(ns %s-test\n  (:require [clojure.test :refer [deftest is testing]]\n            [%s :as sut]))\n"
                    ns ns))))
   ((string-match "\\`\\(.*/\\)test/\\(.+\\)_test\\.\\(clj[cs]?\\)\\'" file)
    (cons (concat (match-string 1 file) "src/" (match-string 2 file)
                  "." (match-string 3 file))
          (format "(ns %s)\n" (my/clojure-path->ns (match-string 2 file)))))))

(defun my/find-sibling-or-create (file)
  "Visit the sibling of FILE. If there is none, offer to create the src/test file.
The file is written with its ns form before it is visited, so clojure-lsp
doesn't add a second one."
  (interactive (list (or buffer-file-name (user-error "Not visiting a file"))))
  (if (find-sibling-file-search file)
      (find-sibling-file file)
    (pcase-let* ((`(,target . ,contents)
                  (or (my/clojure-sibling-target file)
                      (user-error "Couldn't find any sibling files")))
                 (root (if-let* ((project (project-current)))
                           (project-root project)
                         default-directory)))
      (when (y-or-n-p (format "Create %s? " (file-relative-name target root)))
        (make-directory (file-name-directory target) t)
        (write-region contents nil target nil 'silent nil 'excl)
        (find-file target)))))

(defun my/find-sibling-or-create-other-window ()
  "Like `my/find-sibling-or-create', but open the sibling in another window."
  (interactive)
  (let* ((origin (current-buffer))
         (buffer (save-window-excursion
                   (call-interactively #'my/find-sibling-or-create)
                   (current-buffer))))
    (unless (eq buffer origin)
      (switch-to-buffer-other-window buffer))))

(global-set-key (kbd "s-j") #'my/find-sibling-or-create)
(global-set-key (kbd "s-J") #'my/find-sibling-or-create-other-window)

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
              ("M-P" . markdown-previous-link)
              ("C-c v" . my/markdown-read-mode))
  :hook (markdown-mode . visual-line-mode)
  :custom
  (markdown-fontify-code-blocks-natively t)
  (markdown-header-scaling t)
  (markdown-header-scaling-values '(1.6 1.4 1.2 1.1 1.0 1.0))
  (markdown-hide-urls t)
  (markdown-italic-underscore t))

;; Reading view: proportional font for prose, hidden markup, centered column.
;; Code blocks and tables stay monospaced so they still line up.
(use-package mixed-pitch
  :defer t)

(use-package visual-fill-column
  :defer t
  :custom
  (visual-fill-column-width 90)
  (visual-fill-column-center-text t))

(define-minor-mode my/markdown-read-mode
  "Show the current markdown buffer as rendered prose."
  :lighter " Read"
  (let ((arg (if my/markdown-read-mode 1 -1)))
    (markdown-toggle-markup-hiding arg)
    (mixed-pitch-mode arg)
    (visual-fill-column-mode arg)))

(use-package yaml-ts-mode
  :ensure nil
  :if (treesit-language-available-p 'yaml)
  :mode "\\.ya?ml\\'")

(provide 'init-languages)
