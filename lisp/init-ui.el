;;; init-ui.el --- Utseende  -*- lexical-binding: t; -*-

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(load-theme 'default-black t)

(defun my/reset-font ()
  "Sett fonten. Kjør på nytt for hånd hvis Emacs startet som daemon."
  (interactive)
  (when (member "Monaco" (font-family-list))
    (set-face-attribute 'default nil :family "Monaco" :height 150)))
(my/reset-font)

(setq frame-title-format '(buffer-file-name "%f" ("%b"))
      font-lock-maximum-decoration t)

(global-hl-line-mode 1)
(blink-cursor-mode -1)
(tooltip-mode -1)
(pixel-scroll-precision-mode 1)

;; Ikke pip, bare blink modeline
(setq ring-bell-function
      (lambda ()
        (invert-face 'mode-line)
        (run-with-timer 0.05 nil #'invert-face 'mode-line)))

;; Ikke zoom med pinch eller C-scroll
(global-set-key (kbd "<pinch>") #'ignore)
(global-set-key (kbd "C-<wheel-up>") #'ignore)
(global-set-key (kbd "C-<wheel-down>") #'ignore)

;; Vis tilgjengelige taster etter et prefiks (innebygd i Emacs 30)
(use-package which-key
  :ensure nil
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.05)
  :config (which-key-mode 1))

(provide 'init-ui)
