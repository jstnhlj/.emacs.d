# .emacs.d

My personal Emacs configuration. It's inspired by
[magnars/emacsd-reboot](https://github.com/magnars/emacsd-reboot) but rewritten
from scratch, kept small, and geared towards AI-assisted development with
[Claude Code](https://claude.com/claude-code). It targets Emacs 30 on macOS
with a Norwegian keyboard and leans on built-in packages where possible.

## Installation

```sh
git clone https://github.com/jstnhlj/.emacs.d.git ~/.emacs.d
```

Packages are installed automatically on first startup. To try the config
without replacing your current one:

```sh
/Applications/Emacs.app/Contents/MacOS/Emacs --init-directory /path/to/this/repo
```

### External dependencies

```sh
brew install ripgrep aspell coreutils clojure-lsp/brew/clojure-lsp-native
npm i -g typescript-language-server typescript   # JS/TS
pip install basedpyright                          # Python (or pyright)
```

The Claude Code CLI (`claude`) must be on your `PATH`. Install the tree-sitter
grammars with `M-x my/treesit-install-grammars`.

## Structure

| File                      | Contents                                                    |
|---------------------------|-------------------------------------------------------------|
| `early-init.el`           | Faster startup, no toolbars                                 |
| `init.el`                 | Loads the modules below                                     |
| `lisp/init-packages.el`   | package.el + use-package                                    |
| `lisp/init-macos.el`      | Cmd = Meta, Option = Super, `[]{}\|` via Option, shell PATH |
| `lisp/init-defaults.el`   | Auto-revert, backups, history, Emacs server                 |
| `lisp/init-ui.el`         | Theme, font, which-key                                      |
| `lisp/init-editing.el`    | Keybindings, multiple-cursors, expand-region, undo-fu       |
| `lisp/init-completion.el` | vertico, orderless, marginalia, consult, corfu              |
| `lisp/init-workspaces.el` | perspective + project.el                                    |
| `lisp/init-git.el`        | magit, diff-hl, ediff                                       |
| `lisp/init-prog.el`       | eglot, flymake, tree-sitter, deadgrep, dired                |
| `lisp/init-languages.el`  | Clojure/CIDER, JS/TS, Python, Haskell/Tidal, Markdown       |
| `lisp/init-ai.el`         | Claude Code (claude-code-ide + eat)                         |
| `themes/`                 | The `default-black` theme                                   |
| `local.el`                | Machine-specific settings, not checked in                   |

## Packages

| Area          | Packages                                                                            |
|---------------|-------------------------------------------------------------------------------------|
| AI            | [claude-code-ide](https://github.com/manzaltu/claude-code-ide.el), eat              |
| Completion    | vertico, orderless, marginalia, consult, corfu                                      |
| Workspaces    | perspective, project.el (built-in)                                                  |
| Git           | magit, diff-hl, browse-at-remote, ediff (built-in)                                  |
| LSP & linting | eglot, flymake, tree-sitter (all built-in)                                          |
| Search        | deadgrep, wgrep, consult-ripgrep                                                    |
| Editing       | multiple-cursors, expand-region, move-text, undo-fu, vundo, whitespace-cleanup-mode |
| Languages     | clojure-mode, cider, paredit, haskell-mode, tidal, markdown-mode                    |
| macOS         | exec-path-from-shell                                                                |

## How the AI setup works

Claude Code runs in an `eat` terminal on the right side of the frame and is
connected to Emacs over MCP via claude-code-ide. Claude can see the active
region, open buffers and flymake diagnostics, and can use xref, imenu,
tree-sitter and project.el. Proposed changes are shown in ediff.

Buffers revert automatically when Claude writes to disk (the git branch in the
mode line follows along too), and diff-hl marks changed lines in the fringe, so
it's easy to see what the agent has touched. Each project gets its own
perspective, which keeps its Claude session together with its buffers.

## Keybindings

Modifiers on macOS: **Cmd** is Meta (`M-`), **left Option** is Super (`s-`)
and **Fn** is Hyper (`H-`). Right Option is left alone for typing Norwegian
characters. `C-h` is backspace, so help lives on `F1`.

### AI

| Key       | Command                                       |
|-----------|-----------------------------------------------|
| `C-c a`   | Claude Code menu (start, send prompt, stop …) |
| `C-c A`   | Show/hide the Claude window for this project  |
| `C-x p C` | Open the project's `CLAUDE.md`                |

### Projects and perspectives

| Key                 | Command                                   |
|---------------------|-------------------------------------------|
| `C-x p p` / `s-p p` | Switch project (in its own perspective)   |
| `C-x p f`           | Find file in project                      |
| `C-x p e`           | Open this Emacs config                    |
| `C-x x s`           | Switch perspective                        |
| `C-x b`             | Switch buffer (current perspective only)  |
| `C-x C-b`           | ibuffer for the current perspective       |
| `C-x k`             | Kill buffer (and remove from perspective) |

### Files, search and navigation

| Key               | Command                                   |
|-------------------|-------------------------------------------|
| `C-x f`           | Recent files                              |
| `C-v` / `M-v`     | Search lines in buffer / in all buffers   |
| `M-s s`           | deadgrep (ripgrep; `e` to edit results)   |
| `M-s r`           | consult-ripgrep                           |
| `C-x C-i`         | Jump to symbol (imenu)                    |
| `M-g g`           | Go to line                                |
| `C-s` / `C-r`     | isearch, seeded with the region if active |
| `M-n` / `M-p`     | Next / previous paragraph                 |
| `M-i`             | Back to indentation                       |
| `S-<arrows>`      | Move between windows                      |
| `C-x 2` / `C-x 3` | Split window (and rebalance)              |
| `C-c <left>`      | Undo window layout change (winner-mode)   |

### Editing

| Key                           | Command                                 |
|-------------------------------|-----------------------------------------|
| `C-w` / `M-h`                 | Kill region, or the previous word       |
| `M-w`                         | Copy region, or the rest of the line    |
| `C-c d`                       | Duplicate line or region                |
| `C-S-<up>` / `C-S-<down>`     | Move line up / down                     |
| `C-'`                         | Expand region                           |
| `C-æ` / `C-å`                 | Add cursor at next / previous match     |
| `M-æ`                         | Add cursors at all matches              |
| `C-S-c C-S-c`                 | Add a cursor to each line in the region |
| `C-o`                         | Open line and indent                    |
| `C-<return>` / `C-S-<return>` | Open line below / above                 |
| `M-j`                         | Join with the next line                 |
| `C-_` / `M-_`                 | Undo / redo                             |
| `C-x u`                       | Visual undo tree (vundo)                |
| `C-c n`                       | Clean up whitespace and reindent buffer |
| `TAB` / `C-,`                 | Complete at point                       |

### Code

| Key                      | Command                       |
|--------------------------|-------------------------------|
| `M-.` / `M-,`            | Go to definition / back       |
| `C-c l r`                | Rename symbol (eglot)         |
| `C-c l a`                | Code actions (eglot)          |
| `C-c l f`                | Format buffer (eglot)         |
| `M-g n` / `M-g p`        | Next / previous error         |
| `M-g f`                  | List errors (consult-flymake) |
| `s-<right>` / `s-<left>` | Paredit slurp / barf          |
| `s-s`                    | Paredit splice                |

### Git

| Key                   | Command                                         |
|-----------------------|-------------------------------------------------|
| `C-x m`               | magit status (fullscreen, `q` restores windows) |
| `C-x v t`             | Log for the current file                        |
| `C-x v n` / `C-x v p` | Next / previous changed hunk                    |
| `C-x v s`             | Show hunk at point                              |
| `C-x v w`             | Copy GitHub link to the current line            |

### Markdown

| Key                   | Command                       |
|-----------------------|-------------------------------|
| `C-c C-n` / `C-c C-p` | Next / previous heading       |
| `C-c C-u`             | Up to parent heading          |
| `M-N` / `M-P`         | Next / previous link          |
| `C-c C-x C-m`         | Toggle hiding of markup       |

### Misc

| Key       | Command                                      |
|-----------|----------------------------------------------|
| `F1`      | Help prefix (`F1 e` shows `*Messages*`)      |
| `C-x r q` | Quit Emacs (`C-x C-c` only closes the frame) |
| `H-7`     | Insert a backslash                           |
