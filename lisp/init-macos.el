;;; init-macos.el --- Norwegian Mac keyboard and shell environment  -*- lexical-binding: t; -*-

;; Get PATH etc. from the shell, so `claude', `clojure-lsp', `rg' and friends are found
(use-package exec-path-from-shell
  :if (or (memq window-system '(mac ns)) (daemonp))
  :config (exec-path-from-shell-initialize))

(when (eq system-type 'darwin)
  ;; Cmd is Meta, left Option is Super, Fn is Hyper.
  ;; Right Option is left alone, so it types regular Norwegian characters.
  (setq mac-command-modifier 'meta
        mac-option-modifier 'super
        mac-right-option-modifier nil
        ns-function-modifier 'hyper)

  ;; Brackets and friends with left Option, as on a Norwegian keyboard
  (dolist (pair '(("s-8" . "[") ("s-9" . "]")
                  ("s-(" . "{") ("s-)" . "}")
                  ("s-7" . "|") ("M-s-7" . "M-|")
                  ("s-/" . "\\")))
    (define-key key-translation-map (kbd (car pair)) (kbd (cdr pair))))

  ;; Backslash, no questions asked
  (global-set-key (kbd "H-7") (lambda () (interactive) (insert "\\")))

  ;; Deleted files go to the trash
  (setq trash-directory "~/.Trash/emacs")

  ;; brew install aspell coreutils
  (when-let* ((aspell (executable-find "aspell")))
    (setq ispell-program-name aspell))
  (when (executable-find "gls")
    (setq insert-directory-program "gls")))

(provide 'init-macos)
