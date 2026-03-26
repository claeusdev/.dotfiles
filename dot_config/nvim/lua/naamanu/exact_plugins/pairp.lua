return {
	"naamanu/pairp",
	branch = "main",
	cmd = "Pairp",
	keys = {
		{ "<leader>cc", desc = "Pairp: toggle Claude Code" },
	},
	config = function()
		require("pairp").setup()
	end,
}
