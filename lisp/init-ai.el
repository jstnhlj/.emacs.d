;;; init-ai.el --- Claude Code i Emacs  -*- lexical-binding: t; -*-

;; Terminal i ren elisp. Claude Code-CLIen kjører i en eat-buffer.
(use-package eat
  :custom (eat-kill-buffer-on-exit t))

;; claude-code-ide kjører `claude' i prosjektet og kobler den til Emacs over
;; MCP. Claude ser da åpne buffere, markert region og flymake-diagnostikk, og
;; viser forslag til endringer i ediff.
(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind (("C-c a" . claude-code-ide-menu)
         ("C-c A" . claude-code-ide-toggle))
  :custom
  (claude-code-ide-terminal-backend 'eat)
  (claude-code-ide-window-side 'right)
  (claude-code-ide-window-width 100)
  :config
  ;; Gi Claude tilgang til xref, imenu, tree-sitter og project.el
  (claude-code-ide-emacs-tools-setup))

(defun my/project-claude-md ()
  "Åpne CLAUDE.md i roten av gjeldende prosjekt."
  (interactive)
  (find-file (expand-file-name "CLAUDE.md" (project-root (project-current t)))))

(keymap-set project-prefix-map "C" #'my/project-claude-md)

(provide 'init-ai)
