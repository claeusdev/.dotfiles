return {
  "miikanissi/modus-themes.nvim",
  priority = 1000,
  lazy = false,
  -- Which variant loads is decided by naamanu.theme from the shared mode file,
  -- so a Neovim started while the desktop is light comes up light. All the
  -- theme options live there too, next to the light/dark decision.
  config = function()
    local theme = require("naamanu.theme")
    theme.apply(theme.mode())
  end,
}
