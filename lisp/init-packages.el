;;; init-packages.el --- Package management  -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Happens automatically on normal startup, but not in --batch
(unless package--initialized
  (package-initialize))

;; Install missing packages automatically
(require 'use-package)
(setq use-package-always-ensure t)

(provide 'init-packages)
