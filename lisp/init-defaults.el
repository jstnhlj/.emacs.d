;;; init-defaults.el --- Fornuftige standardverdier  -*- lexical-binding: t; -*-

;; Oppdater buffere når filer endres på disk. Viktig når en agent redigerer
;; filene dine: bufferne følger med uten at du må gjøre noe.
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil
      auto-revert-check-vc-info t)   ; git-branch i modeline følger med også
(global-auto-revert-mode 1)

;; UTF-8 overalt
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(setq locale-coding-system 'utf-8)

;; Små ting som gjør hverdagen bedre
(setq use-short-answers t
      echo-keystrokes 0.1
      delete-by-moving-to-trash t
      shift-select-mode nil
      sentence-end-double-space nil
      require-final-newline t
      kill-do-not-save-duplicates t
      save-interprogram-paste-before-kill t
      eval-expression-print-level 100
      uniquify-buffer-name-style 'forward)

(setq-default indent-tabs-mode nil
              fill-column 80
              truncate-lines t
              indicate-empty-lines t)

(column-number-mode 1)
(delete-selection-mode 1)
(global-subword-mode 1)
(winner-mode 1)          ; C-c <left>/<right> angrer vindusendringer
(savehist-mode 1)        ; minibuffer-historikk over omstarter
(save-place-mode 1)      ; husk posisjon i filer

(use-package recentf
  :ensure nil
  :custom (recentf-max-saved-items 200)
  :config (recentf-mode 1))

;; Backups i egen mappe, autosave i tmp, ingen låsefiler
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      vc-make-backup-files t
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      create-lockfiles nil
      vc-handled-backends '(Git))

;; Tilby å lage manglende mapper når en ny fil åpnes
(defun my/create-non-existent-directory ()
  (let ((parent (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent))
               (y-or-n-p (format "Mappen `%s' finnes ikke. Opprette den?" parent)))
      (make-directory parent t))))
(add-to-list 'find-file-not-found-functions #'my/create-non-existent-directory)

;; Emacs-server for emacsclient (fint som $EDITOR, også for Claude Code)
(use-package server
  :ensure nil
  :defer 2
  :config (unless (server-running-p) (server-start)))

(provide 'init-defaults)
