;;; init-ui.el --- Appearance  -*- lexical-binding: t; -*-

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(load-theme 'default-black t)

(defun my/reset-font ()
  "Set the font. Run it by hand if Emacs was started as a daemon."
  (interactive)
  (when (member "Monaco" (font-family-list))
    (set-face-attribute 'default nil :family "Monaco" :height 150))
  (when (member "Helvetica Neue" (font-family-list))
    (set-face-attribute 'variable-pitch nil :family "Helvetica Neue" :height 1.1)))
(my/reset-font)

(setq frame-title-format '(buffer-file-name "%f" ("%b"))
      font-lock-maximum-decoration t)

(global-hl-line-mode 1)
(blink-cursor-mode -1)
(tooltip-mode -1)
(pixel-scroll-precision-mode 1)

;; Don't beep, just flash the mode line
(setq ring-bell-function
      (lambda ()
        (invert-face 'mode-line)
        (run-with-timer 0.05 nil #'invert-face 'mode-line)))

;; No zooming with pinch or C-scroll
(global-set-key (kbd "<pinch>") #'ignore)
(global-set-key (kbd "C-<wheel-up>") #'ignore)
(global-set-key (kbd "C-<wheel-down>") #'ignore)

;; Show available keys after a prefix (built into Emacs 30)
(use-package which-key
  :ensure nil
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.05)
  :config (which-key-mode 1))

(provide 'init-ui)
