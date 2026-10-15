;;; init.el --- Et enkelt oppsett, tunet for AI-utvikling  -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Hold Custom-innstillinger unna init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(require 'init-packages)    ; package.el + use-package
(require 'init-macos)       ; norsk Mac-tastatur, PATH fra skallet
(require 'init-defaults)    ; fornuftige standardverdier
(require 'init-ui)          ; tema, font, utseende
(require 'init-editing)     ; redigering og tastebindinger
(require 'init-completion)  ; vertico, orderless, consult, corfu
(require 'init-workspaces)  ; perspective + project.el
(require 'init-git)         ; magit, diff-hl, ediff
(require 'init-prog)        ; eglot, tree-sitter, søk
(require 'init-languages)   ; Clojure, JS/TS, Python, Haskell/Tidal, Markdown
(require 'init-ai)          ; Claude Code i Emacs

;; Lokale, maskinspesifikke ting som ikke skal sjekkes inn
(load (expand-file-name "local.el" user-emacs-directory) 'noerror 'nomessage)
