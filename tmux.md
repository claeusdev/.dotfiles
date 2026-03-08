# tmux Setup

**Prefix**: `C-a`
**Plugin manager**: TPM
**Theme**: tmux-gruvbox (dark)
**Config**: `~/.tmux.conf`

---

## Plugins

| Plugin | Purpose |
| :--- | :--- |
| tmux-plugins/tpm | Plugin manager |
| tmux-plugins/tmux-sensible | Sensible defaults |
| tmux-plugins/tmux-yank | System clipboard integration in copy mode |
| tmux-plugins/tmux-resurrect | Save and restore sessions |
| tmux-plugins/tmux-continuum | Automatic session saving |
| egel/tmux-gruvbox | Gruvbox colour theme |

---

## Options

| Option | Value |
| :--- | :--- |
| History limit | 100,000 lines |
| Display time | 2000ms |
| Escape time | 0ms |
| Mouse | on |
| Window/pane base index | 1 |
| Renumber windows | on |
| Activity alerts | on (silent) |
| Copy mode | vi keys |
| Resurrect pane contents | on |
| Resurrect nvim strategy | session |
| Continuum auto-restore | off |

**Terminal overrides**: true color (xterm-256color, alacritty, ghostty), undercurl (LSP diagnostics), strikethrough.

---

## Keybindings

All bindings use prefix `C-a` unless noted as no-prefix (`-n`).

### Session & Config

| Key | Action |
| :--- | :--- |
| `prefix + R` | Reload `~/.tmux.conf` |
| `prefix + T` | Open sesh session picker (fzf popup) |

### Windows

| Key | Action |
| :--- | :--- |
| `prefix + c` | New window |
| `prefix + p` | Previous window |
| `prefix + n` | Next window |
| `prefix + ,` | Rename window |
| `prefix + &` | Kill window |

### Panes

| Key | Action |
| :--- | :--- |
| `prefix + \|` | Split horizontal (current path) |
| `prefix + -` | Split vertical (current path) |
| `prefix + h/j/k/l` | Select pane left/down/up/right |
| `prefix + H/J/K/L` | Resize pane left/down/up/right (×5, repeatable) |
| `prefix + m` | Maximize/zoom pane (toggle) |
| `prefix + x` | Kill pane |

### Neovim-aware navigation (no prefix)

`C-h/j/k/l` and `M-h/j/k/l` are intercepted: if the active pane is running Neovim they are forwarded to Neovim, otherwise they navigate/resize tmux panes.

| Key | In tmux | In Neovim |
| :--- | :--- | :--- |
| `C-h/j/k/l` | Select pane | Move window |
| `M-h/j/k/l` | Resize pane (×3) | Resize window |

### Copy mode (vi keys)

Enter with `prefix + [`.

| Key | Action |
| :--- | :--- |
| `v` | Begin selection |
| `C-v` | Rectangle selection toggle |
| `y` | Copy selection and exit |
| `q` | Exit copy mode |

### Session manager — sesh (`prefix + T`)

Opens an fzf popup. Inside the picker:

| Key | Filter |
| :--- | :--- |
| `C-a` | All sessions |
| `C-t` | tmux sessions only |
| `C-g` | Config sessions |
| `C-x` | Zoxide directories |
| `C-f` | Find directories (fd) |
| `C-d` | Kill selected session |
| `Tab` / `S-Tab` | Down / up |

### Plugin management

| Key | Action |
| :--- | :--- |
| `prefix + I` | Install plugins (TPM) |
| `prefix + U` | Update plugins (TPM) |
| `prefix + alt+u` | Remove unused plugins (TPM) |

### Session persistence (tmux-resurrect)

| Key | Action |
| :--- | :--- |
| `prefix + C-s` | Save session |
| `prefix + C-r` | Restore session |
