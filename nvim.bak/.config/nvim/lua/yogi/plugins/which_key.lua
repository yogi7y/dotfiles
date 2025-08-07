return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (whch key)",
		},
	},
	config = function()
		local which_key = require("which-key")

		which_key.setup({
			delay = 1500,
		})
	end,
}
