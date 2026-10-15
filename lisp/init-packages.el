;;; init-packages.el --- Pakkehåndtering  -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Skjer automatisk ved vanlig oppstart, men ikke i --batch
(unless package--initialized
  (package-initialize))

;; Installer manglende pakker automatisk
(require 'use-package)
(setq use-package-always-ensure t)

(provide 'init-packages)
