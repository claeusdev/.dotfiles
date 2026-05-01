return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  ft = "json",
  keys = {
    { "<leader>Ps", function() require("package-info").show() end, desc = "Show package versions" },
    { "<leader>Ph", function() require("package-info").hide() end, desc = "Hide package versions" },
    { "<leader>Pt", function() require("package-info").toggle() end, desc = "Toggle package versions" },
    { "<leader>Pu", function() require("package-info").update() end, desc = "Update package" },
    { "<leader>Pd", function() require("package-info").delete() end, desc = "Delete package" },
    { "<leader>Pi", function() require("package-info").install() end, desc = "Install new package" },
    { "<leader>Pc", function() require("package-info").change_version() end, desc = "Change package version" },
  },
  opts = {
    autostart = true,
    hide_up_to_date = false,
    hide_unstable_versions = false,
  },
}
