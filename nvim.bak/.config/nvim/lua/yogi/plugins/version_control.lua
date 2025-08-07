return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "       <author>, <author_time:%R> • <summary>",
		})

		vim.keymap.set("n", "<leader>vhp", gitsigns.preview_hunk, { desc = "Preview git hunk" })
		vim.keymap.set("n", "<leader>vhr", gitsigns.reset_hunk, { desc = "Reset git hunk" })
		vim.keymap.set("n", "<leader>vt", gitsigns.toggle_current_line_blame, { desc = "Toggle git blame" })
	end,
}
