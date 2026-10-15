# AGENTS.md — .emacs.d

Personal Emacs 30 config for macOS with a Norwegian keyboard, geared towards
AI-assisted development. See `README.md` for the module overview and keybindings.

## Verifying changes

Load the whole config in batch mode and look for errors:

```sh
/Applications/Emacs.app/Contents/MacOS/Emacs --batch --init-directory="$HOME/.emacs.d" \
  -l early-init.el -l init.el --eval '(message "LOADED-OK")' 2>&1 | grep -E 'LOADED-OK|rror'
```

Add `--eval` forms to check keybindings (`(key-binding (kbd "..."))`) or call
functions. Test file-related commands against a throwaway directory, never the
user's real projects.

The user usually has Emacs running with a server, so you can inspect and update
the live session:

```sh
EC=/Applications/Emacs.app/Contents/MacOS/bin-arm64-11/emacsclient
$EC --eval '(with-current-buffer "*Messages*" (buffer-substring (max 1 (- (point-max) 3000)) (point-max)))'
```

Vertico and other packages write stack traces to `*Messages*`. After changing a
file, load the changed forms into the session so the user can try them without
restarting.

## Conventions

- One module per area in `lisp/init-*.el`, required explicitly from `init.el`.
  New settings go in the module that fits; add a new module only for a new area.
- Configure packages with `use-package` (`use-package-always-ensure` is on).
  Built-in packages need `:ensure nil`. Packages not on (M)ELPA use `:vc`.
- Prefer what's built into Emacs 30 (eglot, project.el, flymake, treesit,
  which-key) over third-party packages.
- Helper functions are prefixed `my/`.
- Comments, docstrings, messages and commit messages are in English; the repo
  is public.
- When adding or changing a keybinding, update the tables in `README.md`.

## Keyboard gotchas

- Cmd is Meta, left Option is Super (`s-`), Fn is Hyper (`H-`). Right Option is
  untouched for Norwegian characters.
- `s-8`, `s-9`, `s-(`, `s-)`, `s-7` and `s-/` are translated to `[]{}|\` in
  `init-macos.el`. Don't bind them.
- `C-h` is translated to backspace; help is on `F1`.
- `C-c C-<letter>` is reserved for major modes (CIDER, markdown …). Use
  `C-c <letter>` for global bindings.

## Known pitfalls

- If a package errors with `wrong-number-of-arguments` on a built-in function,
  it was probably byte-compiled against Emacs' bundled `compat` instead of the
  installed one. Fix with `(package-recompile-all)` in a fresh Emacs.
- When creating Clojure files programmatically, write the file with its `ns`
  form *before* visiting it. Otherwise clojure-lsp adds a second `ns` to the
  empty buffer.
- `find-sibling-rules` expansions resolve relative to where the match starts,
  so the rules use absolute paths (`\\1src/...`).

## Not checked in

`elpa/`, `eln-cache/`, `tree-sitter/`, `backups/`, history files, `custom.el` and
`local.el` (machine-specific settings) are in `.gitignore`.
