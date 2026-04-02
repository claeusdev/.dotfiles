return {
	"naamanu/pairp",
	branch = "main",
	cmd = {
		"PairpToggle",
		"PairpSend",
		"PairpContext",
		"PairpSendFile",
		"PairpList",
		"PairpClose",
		"PairpSwitch",
	},
	keys = {
		{ "<leader>cc", desc = "Pairp: toggle Claude Code" },
	},
	config = function()
		require("pairp").setup()
	end,
}
