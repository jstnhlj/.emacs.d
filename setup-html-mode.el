(defun skip-to-next-blank-line ()
  (interactive)
  (let ((inhibit-changing-match-data t))
    (skip-syntax-forward " >")
    (unless (search-forward-regexp "^\\s *$" nil t)
      (goto-char (point-max)))))

(defun skip-to-previous-blank-line ()
  (interactive)
  (let ((inhibit-changing-match-data t))
    (skip-syntax-backward " >")
    (unless (search-backward-regexp "^\\s *$" nil t)
      (goto-char (point-min)))))

(defun html-wrap-in-tag (beg end)
  (interactive "r")
  (let ((oneline? (= (line-number-at-pos beg) (line-number-at-pos end))))
    (deactivate-mark)
    (goto-char end)
    (unless oneline? (newline-and-indent))
    (insert "</div>")
    (goto-char beg)
    (insert "<div>")
    (unless oneline? (newline-and-indent))
    (indent-region beg (+ end 11))
    (goto-char (+ beg 4))))

(eval-after-load "sgml-mode"
  '(progn
     (define-key html-mode-map [remap forward-paragraph] 'skip-to-next-blank-line)
     (define-key html-mode-map [remap backward-paragraph] 'skip-to-previous-blank-line)
     (define-key html-mode-map (kbd "C-c C-w") 'html-wrap-in-tag)
     (define-key html-mode-map (kbd "/") nil) ;; no buggy matching of slashes

     (require 'tagedit)

     ;; paredit lookalikes
     (define-key html-mode-map (kbd "s-<right>") 'tagedit-forward-slurp-tag)
     (define-key html-mode-map (kbd "C-)") 'tagedit-forward-slurp-tag)
     (define-key html-mode-map (kbd "s-<left>") 'tagedit-forward-barf-tag)
     (define-key html-mode-map (kbd "C-}") 'tagedit-forward-barf-tag)
     (define-key html-mode-map (kbd "M-r") 'tagedit-raise-tag)

     (tagedit-add-experimental-features)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))

     ;; no paredit equivalents
     (define-key html-mode-map (kbd "s-k") 'tagedit-kill-attribute)
     (define-key html-mode-map (kbd "s-<return>") 'tagedit-toggle-multiline-tag)))

(autoload 'zencoding-mode "zencoding-mode")
(autoload 'zencoding-expand-line "zencoding-mode")

(defun zencoding-expand-or-indent-for-tab ()
  (interactive)
  (unless (and (memq last-command yas/expand-only-for-last-commands)
               (zencoding-expand-yas))
    (indent-for-tab-command)))

(defun --setup-zencoding-mode ()
  (zencoding-mode)
  (add-to-list 'zencoding-self-closing-tags "hr")
  (set (make-local-variable 'yas/fallback-behavior)
       '(apply zencoding-expand-or-indent-for-tab)))

(add-hook 'sgml-mode-hook '--setup-zencoding-mode)

(eval-after-load 'zencoding-mode
  '(progn
     (define-key zencoding-mode-keymap (kbd "C-j") nil)
     (define-key zencoding-mode-keymap (kbd "<C-return>") nil)
     (define-key zencoding-mode-keymap (kbd "C-c C-j") 'zencoding-expand-line)

     (defun zencoding-transform-yas (ast)
       (let ((zencoding-leaf-function (lambda () "$0")))
         (zencoding-transform ast)))

     (defun zencoding-indent (text)
       "Indent the text"
       (if text
           (replace-regexp-in-string "\n" "\n  " (concat "\n" text))
         nil))

     (diminish 'zencoding-mode)

     ))

(provide 'setup-html-mode)
