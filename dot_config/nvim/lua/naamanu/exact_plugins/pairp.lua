return {
	"naamanu/pairp",
	branch = "feat/chat-window",
	cmd = "Pairp",
	keys = {
		{ "<leader>cc", desc = "Pairp: toggle Claude Code" },
	},
	config = function()
		require("pairp").setup()
	end,
}
