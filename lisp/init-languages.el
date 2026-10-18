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
    (visual-fill-column-mode arg))
  (if my/markdown-read-mode
      (progn
        (add-hook 'after-change-functions #'my/markdown-tables-schedule nil t)
        (add-hook 'window-size-change-functions #'my/markdown-tables-schedule nil t)
        (my/markdown-tables-schedule))
    (remove-hook 'after-change-functions #'my/markdown-tables-schedule t)
    (remove-hook 'window-size-change-functions #'my/markdown-tables-schedule t)
    (remove-overlays nil nil 'my/markdown-table t)))

;; Tables in the reading view are drawn as overlays: aligned on the visible
;; text (hidden markup would otherwise skew the columns), with box borders,
;; and with cells wrapped inside their column when the table is too wide.

(defvar-local my/markdown-tables-timer nil)

(defun my/markdown-tables-schedule (&rest _)
  "Redraw the tables in the current buffer once Emacs is idle."
  (when (timerp my/markdown-tables-timer)
    (cancel-timer my/markdown-tables-timer))
  (setq my/markdown-tables-timer
        (run-with-idle-timer 0.2 nil #'my/markdown-tables-render (current-buffer))))

(defun my/markdown-table-split-row (line)
  "Split the table row LINE into cell strings.
Pipes inside code spans or escaped with a backslash don't split."
  (let ((line (string-trim line))
        (cells nil) (cell "") (in-code nil) (i 0))
    (when (string-prefix-p "|" line)
      (setq line (substring line 1)))
    (while (< i (length line))
      (let ((c (aref line i)))
        (cond ((and (eq c ?\\) (< (1+ i) (length line)) (eq (aref line (1+ i)) ?|))
               (setq cell (concat cell "|") i (1+ i)))
              ((eq c ?`) (setq in-code (not in-code) cell (concat cell "`")))
              ((and (eq c ?|) (not in-code)) (push cell cells) (setq cell ""))
              (t (setq cell (concat cell (string c))))))
      (setq i (1+ i)))
    (unless (string-blank-p cell) (push cell cells))
    (mapcar #'string-trim (nreverse cells))))

(defun my/markdown-table-inline (text)
  "Return TEXT with code, bold, italic and link markup rendered as faces."
  (let ((re (concat "`\\([^`]+\\)`\\|\\*\\*\\(.+?\\)\\*\\*"
                    "\\|\\[\\([^]]+\\)\\]([^)]*)\\|\\*\\([^*]+\\)\\*"))
        (pos 0) (out ""))
    (while (string-match re text pos)
      (setq out (concat out (substring text pos (match-beginning 0))
                        (cond ((match-beginning 1)
                               (propertize (match-string 1 text) 'face 'markdown-inline-code-face))
                              ((match-beginning 2)
                               (propertize (match-string 2 text) 'face 'bold))
                              ((match-beginning 3)
                               (propertize (match-string 3 text) 'face 'markdown-link-face))
                              (t (propertize (match-string 4 text) 'face 'italic))))
            pos (match-end 0)))
    (concat out (substring text pos))))

(defun my/markdown-table-widths (natural minimum avail)
  "Fit the column widths NATURAL into AVAIL characters.
Each column gets its MINIMUM (its longest word) and the rest is shared in
proportion to how much more it needs. If even the minimums don't fit,
narrow columns keep their width and the others share what is left equally."
  (let ((min-total (apply #'+ minimum)))
    (cond
     ((<= (apply #'+ natural) avail) natural)
     ((<= min-total avail)
      (let* ((wants (cl-mapcar #'- natural minimum))
             (extra (- avail min-total))
             (total (max 1 (apply #'+ wants))))
        (cl-mapcar (lambda (min want) (+ min (/ (* extra want) total)))
                   minimum wants)))
     (t
      (let ((widths (make-vector (length natural) nil))
            (left avail)
            (open (number-sequence 0 (1- (length natural))))
            (changed t))
        (while (and open changed)
          (setq changed nil)
          (let ((share (/ left (length open))))
            (dolist (i (copy-sequence open))
              (when (<= (nth i natural) share)
                (aset widths i (nth i natural))
                (setq left (- left (nth i natural))
                      open (delq i open)
                      changed t)))))
        (let ((share (max 4 (/ left (max 1 (length open))))))
          (dolist (i open) (aset widths i share)))
        (append widths nil))))))

(defun my/markdown-table-wrap (text width)
  "Word-wrap TEXT into a list of lines no wider than WIDTH."
  (let ((lines nil) (current ""))
    (dolist (word (split-string text " " t))
      (while (> (string-width word) width)
        (unless (string-empty-p current) (push current lines) (setq current ""))
        (push (truncate-string-to-width word width) lines)
        (setq word (substring word (length (car lines)))))
      (cond ((string-empty-p current) (setq current word))
            ((<= (+ (string-width current) 1 (string-width word)) width)
             (setq current (concat current " " word)))
            (t (push current lines) (setq current word))))
    (push current lines)
    (nreverse lines)))

(defun my/markdown-table-pad (text width align)
  "Pad TEXT to WIDTH according to ALIGN (l, c or r)."
  (let* ((gap (max 0 (- width (string-width text))))
         (before (pcase align ('r gap) ('c (/ gap 2)) (_ 0))))
    (concat (make-string before ?\s) text (make-string (- gap before) ?\s))))

(defun my/markdown-table-columns ()
  "Number of fixed-pitch characters that fit in the window showing this buffer."
  (if-let* ((window (get-buffer-window nil t)))
      (let ((char (/ (string-pixel-width (propertize (make-string 10 ?x) 'face 'fixed-pitch))
                     10.0)))
        (1- (floor (window-body-width window t) char)))
    80))

(defun my/markdown-table-draw (rows aligns avail)
  "Draw ROWS (header first) as a box table at most AVAIL wide.
Return one list of screen lines per source line: the header, the delimiter
row and then each body row."
  (let* ((ncols (apply #'max (mapcar #'length rows)))
         (rows (mapcar (lambda (row)
                         (mapcar #'my/markdown-table-inline
                                 (append row (make-list (- ncols (length row)) ""))))
                       rows))
         (natural (cl-loop for i below ncols
                           collect (max 1 (apply #'max (mapcar (lambda (row) (string-width (nth i row)))
                                                               rows)))))
         (minimum (cl-loop for i below ncols
                           collect (apply #'max 1 (mapcan (lambda (row)
                                                            (mapcar #'string-width
                                                                    (split-string (nth i row) " " t)))
                                                          rows))))
         (widths (my/markdown-table-widths natural minimum (- avail (1+ (* 3 ncols)))))
         (wrapped (mapcar (lambda (row) (cl-mapcar #'my/markdown-table-wrap row widths)) rows))
         (separate (cl-some (lambda (row) (cl-some #'cdr row)) wrapped))
         (rule (lambda (left mid right)
                 (propertize (concat left (mapconcat (lambda (w) (make-string (+ w 2) ?─))
                                                     widths mid)
                                     right)
                             'face 'shadow)))
         (bar (propertize "│" 'face 'shadow))
         (line (lambda (row n header)
                 (concat bar
                         (cl-loop for cell in row
                                  for w in widths
                                  for i from 0
                                  concat (let ((text (or (nth n cell) "")))
                                           (when header
                                             (setq text (propertize text 'face 'bold)))
                                           (concat " " (my/markdown-table-pad text w (nth i aligns))
                                                   " " bar))))))
         (lines-of (lambda (row header)
                     (cl-loop for n below (apply #'max (mapcar #'length row))
                              collect (funcall line row n header))))
         (groups (list (list (funcall rule "├" "┼" "┤"))
                       (cons (funcall rule "┌" "┬" "┐")
                             (funcall lines-of (car wrapped) t)))))
    (cl-loop for (row . more) on (cdr wrapped)
             do (push (append (funcall lines-of row nil)
                              (cond ((null more) (list (funcall rule "└" "┴" "┘")))
                                    (separate (list (funcall rule "├" "┼" "┤")))))
                      groups))
    (when (null (cdr wrapped))
      (setcar groups (append (car groups) (list (funcall rule "└" "┴" "┘")))))
    (mapcar (lambda (group)
              (mapcar (lambda (l) (add-face-text-property 0 (length l) 'fixed-pitch t l) l)
                      group))
            (nreverse groups))))

(defun my/markdown-table-place (lines beg end)
  "Show LINES in place of the text between BEG and END.
Each line gets its own overlay on a character of the source line, so the
window can start at any of them and scroll the table line by line."
  (let ((pos beg))
    (while lines
      (let* ((last (or (null (cdr lines)) (>= (1+ pos) end)))
             (ov (make-overlay pos (if last end (1+ pos)))))
        (overlay-put ov 'my/markdown-table t)
        (overlay-put ov 'evaporate t)
        (overlay-put ov 'display (if last
                                     (string-join lines "\n")
                                   (concat (car lines) "\n")))
        (setq pos (1+ pos)
              lines (if last nil (cdr lines)))))))

(defun my/markdown-tables-render (&optional buffer)
  "Draw every GFM table in BUFFER (default current) with overlays."
  (with-current-buffer (or buffer (current-buffer))
    (when my/markdown-read-mode
      (remove-overlays nil nil 'my/markdown-table t)
      (let ((avail (my/markdown-table-columns)))
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward markdown-table-line-regexp nil t)
            (if (not (markdown-table-at-point-p))
                (forward-line 1)
              (let* ((beg (markdown-table-begin))
                     (end (markdown-table-end))
                     (lines (split-string (buffer-substring-no-properties beg end) "\n" t))
                     (delimiter (cadr lines)))
                (when (and delimiter (string-match-p "\\`[ \t|:-]+\\'" delimiter))
                  (let* ((aligns (mapcar (lambda (spec)
                                           (cond ((string-match-p "\\`:.*:\\'" spec) 'c)
                                                 ((string-match-p ":\\'" spec) 'r)
                                                 (t 'l)))
                                         (my/markdown-table-split-row delimiter)))
                         (rows (mapcar #'my/markdown-table-split-row
                                       (cons (car lines) (cddr lines))))
                         (groups (my/markdown-table-draw rows aligns avail)))
                    (goto-char beg)
                    (dolist (group groups)
                      (my/markdown-table-place group (point) (line-end-position))
                      (forward-line 1))))
                (goto-char end)))))))))

(use-package yaml-ts-mode
  :ensure nil
  :if (treesit-language-available-p 'yaml)
  :mode "\\.ya?ml\\'")

(provide 'init-languages)
