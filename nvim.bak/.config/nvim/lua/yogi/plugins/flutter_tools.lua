return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local flutter_tools = require("flutter-tools")
		local dart_utils = require("yogi.utils.dart")

		flutter_tools.setup({
			decoration = {
				statusline = {
					app_version = true,
					device = true,
					project_config = true,
				},
			},
			debugger = {
				enabled = true,
				exception_breakpoints = {},
				evaluate_to_string_in_debug_views = true,
			},
			fvm = true,
			outline = { auto_open = false },
			widget_guides = { enabled = true },
			dev_log = {
				enabled = true,
				open_cmd = "botright split",
				filter = function(line)
					if line:match("^D/EGL") then
						return false
					end
					return true
				end,
			},
			lsp = {
				color = {
					enabled = true,
					background = false,
					virtual_text = true,
				},
				settings = {
					showtodos = true,
					renameFilesWithClasses = "prompt",
					onlyAnalyzeProjectsWithOpenFiles = true,
					analysisExcludedFolders = {
						"build",
						".dart_tool",
						".idea",
						".pub",
						".vscode",
						vim.fn.expand("$HOME/.pub-cache"),
					},
					lineLength = (function()
						local user = vim.fn.expand("$USER")
						return user:find("yogi") and 100 or 80
					end)(),
				},
				on_attach = function(client, _)
					local root = client.config.root_dir
					if not dart_utils.is_flutter_project(root) then
						return false
					end
				end,
			},
		})

		local keymap = vim.keymap

		require("telescope").load_extension("flutter")
		keymap.set("n", "<leader>fr", "<Cmd>FlutterRun<CR>", { desc = "Run Flutter" })
	end,
}
