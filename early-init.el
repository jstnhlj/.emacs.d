;;; early-init.el --- Runs before packages and the GUI load  -*- lexical-binding: t; -*-

;; Keep GC out of the way during startup, then set a sensible threshold
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024))
            (message "Emacs ready in %.2f seconds with %d garbage collections."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

;; Turn off UI clutter before the first frame is drawn
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(fullscreen . maximized) initial-frame-alist)

(setq inhibit-startup-screen t
      frame-inhibit-implied-resize t)

;; Don't nag about native-comp warnings from packages
(setq native-comp-async-report-warnings-errors 'silent)
