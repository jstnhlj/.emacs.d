(setq my-ctrl-option-mapping
      '(("q" . "<C-268632081>")
        ("w" . "<C-268632087>")
        ("e" . "<C-268632069>")
        ("r" . "<C-268632082>")
        ("t" . "<C-268632084>")
        ("y" . "<C-268632089>")
        ("u" . "<C-268632085>")
        ("i" . "<C-268632073>")
        ("o" . "<C-268632079>")
        ("p" . "<C-268632080>")
        ("a" . "<C-268632065>")
        ("s" . "<C-268632083>")
        ("d" . "<C-268632068>")
        ("f" . "<C-268632070>")
        ("g" . "<C-268632071>")
        ("h" . "<C-268632072>")
        ("j" . "<C-268632074>")
        ("k" . "<C-268632075>")
        ("l" . "<C-268632076>")
        ("z" . "<C-268632090>")
        ("x" . "<C-268632088>")
        ("c" . "<C-268632067>")
        ("v" . "<C-268632086>")
        ("b" . "<C-268632066>")
        ("n" . "<C-268632078>")
        ("3" . "M-£")
        ("m" . "<C-268632077>")))

(defun my-js2-keys (keys)
  (->> (string-to-list keys)
    (--map (aget my-ctrl-option-mapping (char-to-string it)))
    (s-join " ")
    (read-kbd-macro)))

(eval-after-load "js2-refactor"
  '(progn
     (define-key js2-mode-map (my-js2-keys "eo") 'js2r-expand-object)
     (define-key js2-mode-map (my-js2-keys "co") 'js2r-contract-object)
     (define-key js2-mode-map (my-js2-keys "wi") 'js2r-wrap-buffer-in-iife)
     (define-key js2-mode-map (my-js2-keys "ig") 'js2r-inject-global-in-iife)
     (define-key js2-mode-map (my-js2-keys "ev") 'js2r-extract-var)
     (define-key js2-mode-map (my-js2-keys "iv") 'js2r-inline-var)
     (define-key js2-mode-map (my-js2-keys "rv") 'js2r-rename-var)
     (define-key js2-mode-map (my-js2-keys "vt") 'js2r-var-to-this)
     (define-key js2-mode-map (my-js2-keys "ag") 'js2r-add-to-globals-annotation)
     (define-key js2-mode-map (my-js2-keys "sv") 'js2r-split-var-declaration)
     (define-key js2-mode-map (my-js2-keys "ef") 'js2r-extract-function)
     (define-key js2-mode-map (my-js2-keys "em") 'js2r-extract-method)
     (define-key js2-mode-map (my-js2-keys "ip") 'js2r-introduce-parameter)
     (define-key js2-mode-map (my-js2-keys "tf") 'js2r-toggle-function-expression-and-declaration)
     (define-key js2-mode-map (my-js2-keys "ao") 'js2r-arguments-to-object)
     (define-key js2-mode-map (my-js2-keys "uw") 'js2r-unwrap)
     (define-key js2-mode-map (my-js2-keys "wl") 'js2r-wrap-in-for-loop)
     (define-key js2-mode-map (my-js2-keys "3i") 'js2r-ternary-to-if)
     ))

;; (f6
;;  (let* ((c (read-char "Char: "))
;;         (k (help-key-description (read-key-sequence "Describe key (or click or menu item): ") nil)))
;;    (insert "(\"" c "\" . \"" k "\")")
;;    (newline-and-indent)))
