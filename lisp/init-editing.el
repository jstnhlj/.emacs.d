;;; init-editing.el --- Redigering og tastebindinger  -*- lexical-binding: t; -*-

;;; Tastebindinger

;; C-h er backspace som i skallet, hjelp ligger på F1
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f1>") #'help-command)
(global-set-key (kbd "<f1> a") #'apropos)

;; Ikke avslutt Emacs ved et uhell. Mnemonic: C-x REALLY QUIT
(global-set-key (kbd "C-x r q") #'save-buffers-kill-terminal)
(global-set-key (kbd "C-x C-c") #'delete-frame)
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "s-u") #'universal-argument)

;; Slett og kopier
(global-set-key (kbd "C-w") #'kill-region-or-backward-word)
(global-set-key (kbd "M-h") #'kill-region-or-backward-word)
(global-set-key (kbd "M-w") #'copy-region-or-rest-of-line)
(global-set-key (kbd "C-c d") #'duplicate-dwim)
(global-set-key (kbd "C-c n") #'cleanup-buffer)
(global-set-key (kbd "M-j") (lambda () (interactive) (join-line -1)))
(global-set-key (kbd "M-&") #'query-replace-regexp)
(global-set-key (kbd "M-s l") #'sort-lines)
(global-set-key (kbd "M-<escape>") (lambda () (interactive) (revert-buffer t t)))

;; Smarte nye linjer
(global-set-key (kbd "C-o") #'open-line-and-indent)
(global-set-key (kbd "<C-return>") #'open-line-below)
(global-set-key (kbd "<C-S-return>") #'open-line-above)
(global-set-key (kbd "<M-return>") #'new-line-dwim)

;; Navigasjon
(global-set-key (kbd "C-s") #'isearch-forward-use-region)
(global-set-key (kbd "C-r") #'isearch-backward-use-region)
(global-set-key (kbd "M-i") #'back-to-indentation)
(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)
(global-set-key (kbd "C-S-n") (lambda () (interactive) (ignore-errors (forward-line 5))))
(global-set-key (kbd "C-S-p") (lambda () (interactive) (ignore-errors (forward-line -5))))

;; Vinduer: Shift+piler for å flytte, og hold dem balanserte
(windmove-default-keybindings)
(global-set-key (kbd "C-x 0") #'my/delete-window)
(global-set-key (kbd "C-x 2") #'my/split-window-down)
(global-set-key (kbd "C-x 3") #'my/split-window-right)

;;; Pakker

(use-package move-text
  :bind (("<C-S-down>" . move-text-down)
         ("<C-S-up>" . move-text-up)))

(use-package expand-region
  :bind (("C-'" . er/expand-region)
         ("C-@" . er/expand-region)))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C-S-c C-a" . mc/edit-beginnings-of-lines)
         ("C-S-c C-e" . mc/edit-ends-of-lines)
         ("C-æ" . mc/mark-next-like-this)
         ("C-å" . mc/mark-previous-like-this)
         ("M-æ" . mc/mark-all-dwim)
         ("C-Æ" . mc/mark-more-like-this-extended)
         ("M-å" . mc/mark-all-in-region)
         ("H-0" . mc/insert-numbers)))

(use-package undo-fu
  :custom
  (undo-limit 400000)
  (undo-strong-limit 3000000)
  (undo-outer-limit 48000000)
  :bind (("C-_" . undo-fu-only-undo)
         ("M-_" . undo-fu-only-redo)))

(use-package vundo
  :bind ("C-x u" . vundo)
  :custom (vundo-glyph-alist vundo-unicode-symbols))

;; Rydd whitespace ved lagring, men bare i filer som var rene fra før
(use-package whitespace-cleanup-mode
  :config (global-whitespace-cleanup-mode 1))

;;; Implementasjoner

(defun kill-region-or-backward-word ()
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))

(defun copy-region-or-rest-of-line ()
  (interactive)
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (kill-ring-save (point) (line-end-position))
    (message "Kopierte til slutten av linja")))

(defun cleanup-buffer ()
  "Fjern tabber og trailing whitespace, og indenter hele bufferen."
  (interactive)
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max)))

(defun open-line-and-indent ()
  (interactive)
  (newline-and-indent)
  (end-of-line 0)
  (indent-for-tab-command))

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(defun new-line-dwim ()
  "Ny linje. Står vi mellom et par som {}, åpnes paret over tre linjer."
  (interactive)
  (let ((break-open-pair (or (and (looking-back "{" 1) (looking-at "}"))
                             (and (looking-back ">" 1) (looking-at "<"))
                             (and (looking-back "(" 1) (looking-at ")"))
                             (and (looking-back "\\[" 1) (looking-at "\\]")))))
    (newline)
    (when break-open-pair
      (save-excursion
        (newline)
        (indent-for-tab-command)))
    (indent-for-tab-command)))

(defun my/isearch-with-region (fn)
  (when (region-active-p)
    (add-to-history 'search-ring (buffer-substring (region-beginning) (region-end)))
    (deactivate-mark))
  (call-interactively fn))

(defun isearch-forward-use-region ()
  "Som `isearch-forward', men legger regionen (om noen) i søkehistorikken."
  (interactive)
  (my/isearch-with-region #'isearch-forward))

(defun isearch-backward-use-region ()
  "Som `isearch-backward', men legger regionen (om noen) i søkehistorikken."
  (interactive)
  (my/isearch-with-region #'isearch-backward))

(defun my/delete-window ()
  (interactive)
  (delete-window)
  (balance-windows))

(defun my/split-window-down ()
  (interactive)
  (select-window (split-window-below))
  (balance-windows))

(defun my/split-window-right ()
  (interactive)
  (select-window (split-window-right))
  (balance-windows))

(provide 'init-editing)
