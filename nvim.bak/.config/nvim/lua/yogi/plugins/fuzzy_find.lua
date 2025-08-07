return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
					file_ignore_patterns = { ".git", "node_modules", "vendor" },
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			require("telescope").load_extension("ui-select")
			telescope.load_extension("fzf")
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")

			vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "Search Files" })
			vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Search Files" })
			vim.keymap.set("n", "<leader>sg", fzf.live_grep_native, { desc = "Live Grep" })

			fzf.setup({
				files = {
					fzf_opts = {
						["--keep-right"] = "",
					},
				},
				grep = {
					fzf_opts = {
						["--delimiter"] = ":",
						["--with-nth"] = "1",
					},
					rg_opts = "--hidden --column --line-number --color=always --smart-case",
				},
				winopts = {
					preview = {
						layout = "horizontal",
						horizontal = "down:70%",
					},
				},
			})
		end,
	},
}
