;;; init-macos.el --- Norsk Mac-tastatur og skallmiljø  -*- lexical-binding: t; -*-

;; Hent PATH m.m. fra skallet, så `claude', `clojure-lsp', `rg' osv. finnes
(use-package exec-path-from-shell
  :if (or (memq window-system '(mac ns)) (daemonp))
  :config (exec-path-from-shell-initialize))

(when (eq system-type 'darwin)
  ;; Cmd er Meta, venstre Option er Super, Fn er Hyper.
  ;; Høyre Option er urørt, så den gir vanlige norske tegn.
  (setq mac-command-modifier 'meta
        mac-option-modifier 'super
        mac-right-option-modifier nil
        ns-function-modifier 'hyper)

  ;; Klammeparenteser og venner med venstre Option, som på norsk tastatur
  (dolist (pair '(("s-8" . "[") ("s-9" . "]")
                  ("s-(" . "{") ("s-)" . "}")
                  ("s-7" . "|") ("M-s-7" . "M-|")
                  ("s-/" . "\\")))
    (define-key key-translation-map (kbd (car pair)) (kbd (cdr pair))))

  ;; Backslash, uten spørsmål
  (global-set-key (kbd "H-7") (lambda () (interactive) (insert "\\")))

  ;; Slettede filer havner i papirkurven
  (setq trash-directory "~/.Trash/emacs")

  ;; brew install aspell coreutils
  (when-let* ((aspell (executable-find "aspell")))
    (setq ispell-program-name aspell))
  (when (executable-find "gls")
    (setq insert-directory-program "gls")))

(provide 'init-macos)
