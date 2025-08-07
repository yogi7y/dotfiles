return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			local copilot = require("copilot")

			copilot.setup({
				suggestion = {
					enabled = false,
					keymap = {
						accept = "<Tab>",
					},
				},
				panel = { enabled = true },
				filetypes = {
					markdown = true,
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		config = function()
			local copilot_chat = require("CopilotChat")

			copilot_chat.setup({})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			local copilot_cmp = require("copilot_cmp")

			copilot_cmp.setup({})
		end,
	},
}
