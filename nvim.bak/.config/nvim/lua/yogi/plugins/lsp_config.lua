return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")
			local dart_utils = require("yogi.utils.dart")

			-- Lua LSP
			lspconfig.lua_ls.setup({
				on_attach = function(client, bufnr)
					local filepath = vim.api.nvim_buf_get_name(bufnr)
					if filepath:match("%.nvim%.lua$") then
						vim.schedule(function()
							vim.lsp.buf_detach_client(bufnr, client.id)
							vim.notify("Lua LSP disabled for .nvim.lua file", vim.log.levels.INFO)
						end)
					else
					end
				end,
				root_dir = function(fname)
					if fname:match("%.nvim%.lua$") then
						return nil
					end
					return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
				end,
			})

			-- Dart LSP
			lspconfig.dartls.setup({
				cmd = { "dart", "language-server", "--protocol=lsp" },
				root_dir = function(fname)
					local root = util.root_pattern("pubspec.yaml", ".git")(fname)
					if root and dart_utils.is_flutter_project(root) then
						return nil
					end
					return root
				end,
				filetypes = { "dart" },
				init_options = {
					closingLabels = true,
					onlyAnalyzeProjectsWithOpenFiles = true,
					outline = true,
				},
				settings = {
					dart = {
						completeFunctionCalls = true,
						showTodos = true,
					},
				},
			})

			-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
			-- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			-- vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
			-- vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
			-- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
			-- vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
			-- vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
			-- vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
			-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

			local fzf = require("fzf-lua")

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "<leader>gi", fzf.lsp_implementations, { desc = "Go to implementation" })
			vim.keymap.set("n", "<leader>gr", fzf.lsp_references, { desc = "Find references" })
			vim.keymap.set("n", "<leader>ds", fzf.lsp_document_symbols, { desc = "Document symbols" })
			vim.keymap.set("n", "<leader>ws", fzf.lsp_workspace_symbols, { desc = "Workspace symbols" })
			vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
			vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
		end,
	},
}
