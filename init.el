;;; init.el --- A simple config, tuned for AI-assisted development  -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Keep Custom settings out of init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(require 'init-packages)    ; package.el + use-package
(require 'init-macos)       ; Norwegian Mac keyboard, PATH from the shell
(require 'init-defaults)    ; sane defaults
(require 'init-ui)          ; theme, font, appearance
(require 'init-editing)     ; editing and keybindings
(require 'init-completion)  ; vertico, orderless, consult, corfu
(require 'init-workspaces)  ; perspective + project.el
(require 'init-git)         ; magit, diff-hl, ediff
(require 'init-prog)        ; eglot, tree-sitter, search
(require 'init-languages)   ; Clojure, JS/TS, Python, Haskell/Tidal, Markdown
(require 'init-ai)          ; Claude Code in Emacs

;; Local, machine-specific settings that aren't checked in
(load (expand-file-name "local.el" user-emacs-directory) 'noerror 'nomessage)
