;;; early-init.el --- Kjøres før pakker og GUI lastes  -*- lexical-binding: t; -*-

;; La GC hvile under oppstart, og sett en fornuftig terskel etterpå
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024))
            (message "Emacs klar på %.2f sekunder med %d GC-er."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

;; Slå av UI-skrammel før første vindu tegnes
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(fullscreen . maximized) initial-frame-alist)

(setq inhibit-startup-screen t
      frame-inhibit-implied-resize t)

;; Ikke mas om native-comp-advarsler fra pakker
(setq native-comp-async-report-warnings-errors 'silent)
