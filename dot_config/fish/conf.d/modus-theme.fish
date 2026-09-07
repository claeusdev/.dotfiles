# Modus Vivendi Tinted for fish -- the palette Neovim, Emacs, Ghostty and tmux
# already share.
#
# None of these hexes are guessed. Each is the colour Neovim actually renders
# for the corresponding highlight group under modus_vivendi (tinted), read out
# of nvim_get_hl, so fish and the editors drift together or not at all:
#
#   Normal      #ffffff    Comment   #ff9f80 italic   String   #2fafff
#   Function    #dfaf7a    Keyword   #79a8ff italic   Statement #b6a0ff
#   Identifier  #4ae2f0    Special   #feacd0          SpecialChar #9ac8e0
#   NonText     #989898    Visual bg #7030af          Search bg #2f822f
#   DiagnosticError #ff7f9f
#
# This file replaces conf.d/fish_frozen_theme.fish, which pinned fish's stock
# ANSI theme. fish's own note in that file says to delete it and configure the
# theme yourself, which is what this is. It sorts after "fish_..." so it still
# wins if a future fish upgrade drops that file back in.

# --- syntax highlighting ---
set -g fish_color_normal         ffffff             # Normal
set -g fish_color_command        dfaf7a             # Function: the command word
set -g fish_color_keyword        79a8ff --italics   # Keyword, italic as in Neovim
set -g fish_color_quote          2fafff             # String
set -g fish_color_param          4ae2f0             # Identifier: arguments
set -g fish_color_option         feacd0             # Special: flags
set -g fish_color_redirection    ffffff             # Operator
set -g fish_color_end            b6a0ff             # Statement: ; and &
set -g fish_color_escape         9ac8e0             # SpecialChar
set -g fish_color_comment        ff9f80 --italics   # Comment, italic as in Neovim
set -g fish_color_error          ff7f9f             # DiagnosticError
set -g fish_color_operator       ffffff             # Operator
set -g fish_color_valid_path     --underline

# Autosuggestions are ghost text, not comments. Neovim renders that as NonText,
# and the upstream modus fish extra maps it to the comment salmon -- which makes
# a suggestion louder than the command it trails. Dim it instead.
set -g fish_color_autosuggestion 989898             # NonText

set -g fish_color_selection      ffffff --background=7030af   # Visual
set -g fish_color_search_match   --background=2f822f          # Search
set -g fish_color_history_current --bold
set -g fish_color_cancel         -r

# --- bits of fish's built-in prompt (starship draws the real one) ---
set -g fish_color_cwd            2fafff
set -g fish_color_cwd_root       ff5f59
set -g fish_color_user           6ae4b9
set -g fish_color_host           ffffff
set -g fish_color_host_remote    fec43f
set -g fish_color_status         ff5f59

# --- completion pager ---
set -g fish_pager_color_progress            989898
set -g fish_pager_color_prefix              79a8ff --bold
set -g fish_pager_color_completion          ffffff
set -g fish_pager_color_description         989898
set -g fish_pager_color_selected_background --background=7030af
