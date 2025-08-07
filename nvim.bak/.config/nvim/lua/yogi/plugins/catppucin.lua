return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.o.termguicolors = true
			vim.cmd.colorscheme("catppuccin-mocha")

			local catppuccin = require("catppuccin")

			catppuccin.setup({
				integrations = {
					cmp = true,
					gitsigns = true,
					treesitter = true,
					harpoon = true,
					mason = true,
					noice = true,
					dap = true,
					dap_ui = true,
					lsp_trouble = true,
					which_key = true,
					neotree = true,
					telescope = {
						enabled = true,
					},
				},
			})
		end,
	},
}
