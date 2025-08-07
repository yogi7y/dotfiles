return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		local format = function(bufnr)
			vim.lsp.buf.format({
				filter = function(client)
					return client.name == "null-ls"
				end,
				bufnr = bufnr,
			})
		end

		local on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						format(bufnr)
					end,
				})
			end
		end

		null_ls.setup({
			on_attach = on_attach,
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.dart_format.with({
					extra_args = function()
						local user = vim.fn.expand("$USER")
						local line_length = user:find("yogi") and 100 or 80
						return { "--line-length", tostring(line_length) }
					end,
				}),
			},
		})

		vim.keymap.set("n", "<leader>gf", function()
			local bufnr = vim.api.nvim_get_current_buf()
			format(bufnr)
		end, { desc = "Format file" })
	end,
}
