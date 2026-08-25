# Emacs and Neovim capability contract

The editors share external binaries and workflows while keeping native interaction styles. Emacs uses built-in projects, Eglot, Apheleia, Dape, Magit, Denote and Citar. Neovim uses native LSP, Conform, nvim-dap, Gitsigns/Diffview, Snacks and Overseer.

## Tool ownership

Tools resolve in this order: project environment (`direnv`, `.venv`, `node_modules/.bin`, opam switch), `~/.local/bin`, then the system PATH. Neovim does not install language tools privately. Run `dev-doctor --all` from a terminal, `C-c e h` in Emacs, or `:checkhealth` in Neovim.

`setup.sh` installs tools; `setup.sh --check` is read-only. Editor plugins remain pinned by their package metadata or `lazy-lock.json`. Projects own compiler and dependency versions.

## Language matrix

| Language | LSP | Formatter | Build/test |
| :--- | :--- | :--- | :--- |
| TypeScript/JavaScript/React | vtsls + ESLint | Prettier | package-manager scripts |
| Python | basedpyright + Ruff | Ruff | uv/pytest |
| Rust | rust-analyzer | rustfmt | Cargo/Clippy |
| Go | gopls | goimports/gofmt | go test |
| C/C++ | clangd | clang-format | Make/CMake/Meson |
| OCaml | ocamllsp | ocamlformat | dune/utop |
| Haskell | HLS | ormolu | Cabal/Stack |
| Lua | lua-language-server | Stylua | project command |
| shell | bash-language-server + ShellCheck | shfmt | shellcheck |
| JSON/YAML/Docker | vscode/yaml/docker servers | Prettier | project command |
| SQL | none | sql-formatter | interactive client |

Missing optional binaries leave editing usable and are reported by the doctor.

## Shared workflows

| Capability | Emacs | Neovim |
| :--- | :--- | :--- |
| Project search | `C-c s s` | `<leader>fg` |
| Build/test | `C-c p m` / `C-c p t` | `<leader>ob` / `<leader>on` |
| LSP action/rename | `C-c l a` / `C-c l r` | `<leader>la` / `<leader>lr` |
| Format | `C-c l f` or save | `<leader>cf` or save |
| Debug | `C-c d` prefix | `<leader>d` prefix |
| HTTP request | Restclient `.http` buffer | Kulala `.http` buffer |
| Terminal agent | `C-c g g` | `<leader>aa` |
| Agent context | `C-c g c` | `<leader>ac` |

Set `DEV_AGENT` to a command name to override agent selection. Otherwise both editors choose `codex`, then `claude`. Context commands copy an explicit `@file:start-end` reference and open a project-root terminal; paste intentionally rather than sending data silently.

## Portable research data

Durable notes are Markdown files under `${NOTES_DIR:-~/notes}` with Denote-compatible timestamp identifiers and YAML front matter. The bibliography defaults to `${BIBLIOGRAPHY:-~/notes/references.bib}` and citations use Pandoc syntax (`[@key]`). PDF locations belong in BibTeX `file` fields.

| Action | Emacs | Neovim |
| :--- | :--- | :--- |
| New/find/search note | `C-c n n/f/s` | `<leader>nn/nf/ns` |
| Link/backlinks | `C-c n l/b` | `<leader>nl/nb` |
| Browse citations | `C-c n c` | — |
| Insert Pandoc citation | `C-c n C` | `<leader>nc` |

Org capture and agenda remain an Emacs-only task-management enhancement. They are not the durable note format.
