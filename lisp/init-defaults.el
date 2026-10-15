;;; init-defaults.el --- Sane defaults  -*- lexical-binding: t; -*-

;; Revert buffers when files change on disk. Important when an agent edits
;; your files: buffers keep up without you doing anything.
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil
      auto-revert-check-vc-info t)   ; the git branch in the mode line follows too
(global-auto-revert-mode 1)

;; UTF-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(setq locale-coding-system 'utf-8)

;; Small things that make life better
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
(winner-mode 1)          ; C-c <left>/<right> undoes window changes
(savehist-mode 1)        ; minibuffer history across restarts
(save-place-mode 1)      ; remember position in files

(use-package recentf
  :ensure nil
  :custom (recentf-max-saved-items 200)
  :config (recentf-mode 1))

;; Backups in their own directory, autosaves in tmp, no lock files
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      vc-make-backup-files t
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      create-lockfiles nil
      vc-handled-backends '(Git))

;; Offer to create missing directories when visiting a new file
(defun my/create-non-existent-directory ()
  (let ((parent (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent))
               (y-or-n-p (format "Directory `%s' does not exist. Create it?" parent)))
      (make-directory parent t))))
(add-to-list 'find-file-not-found-functions #'my/create-non-existent-directory)

;; Emacs server for emacsclient (handy as $EDITOR, also for Claude Code)
(use-package server
  :ensure nil
  :defer 2
  :config (unless (server-running-p) (server-start)))

(provide 'init-defaults)
