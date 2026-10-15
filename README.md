# .emacs.d-reboot

Et enkelt Emacs 30-oppsett for norsk Mac-tastatur, tunet for AI-utvikling med
Claude Code. Inspirert av [magnars/emacsd-reboot](https://github.com/magnars/emacsd-reboot),
men skrevet fra scratch og med mest mulig innebygd.

## Prøv uten å røre ~/.emacs.d

```sh
/Applications/Emacs.app/Contents/MacOS/Emacs --init-directory ~/.emacs.d-reboot
```

Første oppstart installerer pakkene. Når du er fornøyd:

```sh
mv ~/.emacs.d ~/.emacs.d-old && mv ~/.emacs.d-reboot ~/.emacs.d
```

## Avhengigheter utenfor Emacs

```sh
brew install ripgrep aspell coreutils clojure-lsp/brew/clojure-lsp-native
npm i -g typescript-language-server typescript   # JS/TS
pip install basedpyright                          # Python (eller pyright)
```

Claude Code-CLIen (`claude`) må ligge på PATH. Tree-sitter-grammatikker:
`M-x my/treesit-install-grammars`.

## Struktur

| Fil                        | Innhold                                            |
|----------------------------|----------------------------------------------------|
| `early-init.el`            | Raskere oppstart, ingen verktøylinjer              |
| `lisp/init-macos.el`       | Cmd = Meta, Option = Super, `[]{}\|` med Option    |
| `lisp/init-defaults.el`    | Auto-revert, backups, historikk, server            |
| `lisp/init-ui.el`          | Tema, font, which-key                              |
| `lisp/init-editing.el`     | Tastebindinger, multiple-cursors, undo-fu          |
| `lisp/init-completion.el`  | vertico, orderless, marginalia, consult, corfu     |
| `lisp/init-workspaces.el`  | perspective + project.el                           |
| `lisp/init-git.el`         | magit, diff-hl, ediff                              |
| `lisp/init-prog.el`        | eglot, flymake, tree-sitter, deadgrep, dired       |
| `lisp/init-languages.el`   | Clojure/CIDER, JS/TS, Python, Haskell/Tidal, Markdown |
| `lisp/init-ai.el`          | Claude Code (claude-code-ide + eat)                |
| `local.el`                 | Maskinspesifikt, sjekkes ikke inn                  |

## Viktige taster

**AI**

| Tast      | Kommando                                   |
|-----------|--------------------------------------------|
| `C-c a`   | Claude Code-menyen (start, send, stopp …)  |
| `C-c A`   | Vis/skjul Claude-vinduet for prosjektet    |
| `C-x p C` | Åpne prosjektets `CLAUDE.md`               |

Claude kjører i en eat-terminal til høyre og er koblet til Emacs over MCP.
Den ser markert region, åpne filer og diagnostikk, og foreslåtte endringer
vises i ediff. Buffere oppdateres automatisk når Claude skriver til disk, og
diff-hl viser endringene i margen (`C-x v n`/`C-x v p` hopper mellom dem).

**Prosjekter og perspektiver**

| Tast            | Kommando                                     |
|-----------------|----------------------------------------------|
| `C-x p p`/`s-p p` | Bytt prosjekt (i eget perspektiv)          |
| `C-x p f`       | Finn fil i prosjektet                        |
| `C-x p e`       | Åpne denne konfigurasjonen                   |
| `C-x x s`       | Bytt perspektiv                              |
| `C-x b`         | Buffere i gjeldende perspektiv               |

**Git**: `C-x m` magit-status (`q` gjenoppretter vinduene), `C-x v t` logg for
filen, `C-x v w` kopier GitHub-lenke.

**Søk**: `C-v` søk i buffer, `M-s s` deadgrep, `M-s r` consult-ripgrep,
`C-x f` nylige filer, `C-x C-i` imenu.

**Redigering**: `C-w`/`C-h` slett ord/tegn bakover, `M-w` kopier region eller
resten av linja, `C-c d` dupliser, `C-S-opp/ned` flytt linje, `C-'` expand-region,
`C-æ`/`C-å`/`M-æ` multiple-cursors, `C-x u` vundo, hjelp på `F1`.

## Bevisst utelatt fra det gamle oppsettet

projectile (erstattet av project.el), lsp-mode og flycheck (erstattet av eglot
og flymake), yasnippet, prodigy, restclient, smartparens, clj-refactor, kaocha,
straight.el, `users/`-mappene og alt som er spesifikt for Matnyttig og Mattilsynet.
