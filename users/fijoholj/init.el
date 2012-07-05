;; stuff goes here yo

(setq-default js2-basic-offset 2)

;; Set up slime-js
;; To install, see https://github.com/swank-js/swank-js/wiki/Installation

(eval-after-load "js2-mode"
  '(progn
     (require 'slime)
     (require 'slime-js)
     (require 'setup-slime-js)
     (setq slime-js-browser-command "open -a \"Google Chrome\"")
     (diminish 'slime-js-minor-mode)))
