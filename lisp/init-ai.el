;;; init-ai.el --- Claude Code in Emacs  -*- lexical-binding: t; -*-

;; The Claude Code CLI runs in a vterm buffer. vterm is built on libvterm (a C
;; module), so it renders Claude's TUI faster and more faithfully than eat.
;; Building the module needs cmake (brew install cmake libvterm).
(use-package vterm
  :custom
  (vterm-always-compile-module t)
  (vterm-kill-buffer-on-exit t)
  (vterm-max-scrollback 10000))

(defun my/claude-sideload-flags-disabled-p ()
  "Non-nil if Claude Code's org settings forbid flags like --mcp-config."
  (let ((file (expand-file-name "~/.claude/remote-settings.json")))
    (and (file-readable-p file)
         (eq t (ignore-errors
                 (gethash "disableSideloadFlags"
                          (with-temp-buffer
                            (insert-file-contents file)
                            (json-parse-buffer :false-object nil))))))))

;; claude-code-ide runs `claude' in the project and connects it to Emacs over
;; MCP. Claude can then see open buffers, the active region and flymake
;; diagnostics, and proposed changes are shown in ediff.
(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind (("C-c a" . claude-code-ide-menu)
         ("C-c A" . claude-code-ide-toggle))
  :custom
  (claude-code-ide-terminal-backend 'vterm)
  (claude-code-ide-window-side 'right)
  (claude-code-ide-window-width 100)
  :config
  ;; Give Claude access to xref, imenu, tree-sitter and project.el. This
  ;; passes --mcp-config, which some organizations forbid through
  ;; disableSideloadFlags, making claude exit immediately. Skip it there;
  ;; the core IDE integration works without it.
  (unless (my/claude-sideload-flags-disabled-p)
    (claude-code-ide-emacs-tools-setup)))

(defun my/project-claude-md ()
  "Open CLAUDE.md at the root of the current project."
  (interactive)
  (find-file (expand-file-name "CLAUDE.md" (project-root (project-current t)))))

(keymap-set project-prefix-map "C" #'my/project-claude-md)

(provide 'init-ai)
