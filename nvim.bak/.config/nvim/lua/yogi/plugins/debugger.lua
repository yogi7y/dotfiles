return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		local virtual_text = require("nvim-dap-virtual-text")

		-- Setup
		dapui.setup({
			layouts = {
				{
					elements = {
						"stacks",
						"scopes",
						"watches",
					},
					size = 40,
					position = "right",
				},
				{
					elements = {
						"repl",
					},
					size = 10,
					position = "bottom",
				},
			},
		})

		virtual_text.setup({
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			only_first_definition = true,
			all_references = false,
			clear_on_continue = false,
			virt_text_pos = "eol",
			all_frames = false,
			virt_lines = false,
			virt_text_win_col = nil,
		})

		local function open_repl_only()
			dapui.open({ layout = 2 })
		end

		local function toggle_sidebar()
			dapui.toggle({ layout = 1 })
		end

		local function toggle_repl()
			dapui.toggle({ layout = 2 })
		end
		-- Listeners
		dap.listeners.before.attach.dapui_config = function()
			open_repl_only()
		end

		dap.listeners.before.launch.dapui_config = function()
			open_repl_only()
		end

		-- Theming
		local sign_color = "#f9e2af"
		local line_color = "#45475a"

		-- Define signs without line highlighting except for DapStopped
		vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapBreakpoint" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DapBreakpoint" })
		vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DapLogPoint" })
		vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DapBreakpointRejected" })

		-- Set highlight groups with bold text
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = sign_color, bold = true })
		vim.api.nvim_set_hl(0, "DapLogPoint", { fg = sign_color, bold = true })
		vim.api.nvim_set_hl(0, "DapStopped", { fg = sign_color, bold = true })
		vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = sign_color, bold = true })

		-- Set DapStoppedLine with a distinct background color
		vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = line_color })

		-- Configuration
		dap.adapters.dart = {
			type = "executable",
			command = "dart",
			args = { "debug_adapter" },
		}

		dap.configurations.dart = {
			{
				type = "dart",
				request = "launch",
				name = "Launch Dart Program",
				program = "${file}",
				cwd = "${workspaceFolder}",
				args = {},
			},
		}

		-- Keymaps
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Condition:"))
		end, { desc = "Conditional breakpoint" })

		vim.keymap.set("n", "<leader>dl", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log:"))
		end, { desc = "Log point" })

		vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to cursor" })

		vim.keymap.set("n", "<leader>dd", function()
			dap.continue()
			vim.cmd("sleep 100m")
			vim.cmd("redraw")
		end, { desc = "Continue debugging" })

		-- vim.keymap.set("n", "6", dap.step_into, { desc = "Step into" })
		-- vim.keymap.set("n", "7", dap.step_over, { desc = "Step over" })
		-- vim.keymap.set("n", "8", dap.step_out, { desc = "Step out" })
		-- vim.keymap.set("n", "9", dap.restart, { desc = "Restart" })

		vim.keymap.set("n", "<leader>du", dapui.open, { desc = "Open DAP UI" })
		vim.keymap.set("n", "<leader>ds", toggle_sidebar, { desc = "Toggle sidebar" })
		vim.keymap.set("n", "<leader>dr", toggle_repl, { desc = "Toggle repl" })
		vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate DAP" })

		-- Eval value under cursor
		vim.keymap.set("n", "<leader><leader>", function()
			dapui.eval(nil, { enter = true })
		end)
	end,
}
