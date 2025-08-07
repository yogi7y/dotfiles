return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "sidlatau/neotest-dart",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-dart")({
          command = "fvm flutter test --reporter=expanded",
        }),
      },
    })

    vim.keymap.set("n", "<leader>tt", function()
      neotest.run.run()
    end, { desc = "Run nearest test" })

    vim.keymap.set("n", "<leader>tf", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Run all tests in file" })

    vim.keymap.set("n", "<leader>ts", function()
      neotest.summary.toggle()
    end, { desc = "Toggle test summary" })

    vim.keymap.set("n", "<leader>to", function()
      neotest.output.open({ enter = true })
    end, { desc = "Open test output" })

    vim.keymap.set("n", "<leader>tO", function()
      neotest.output_panel.toggle()
    end, { desc = "Toggle output panel" })

    vim.keymap.set("n", "<leader>tS", function()
      neotest.run.stop()
    end, { desc = "Stop nearest test" })

    vim.keymap.set("n", "[t", function()
      neotest.jump.prev({ status = "failed" })
    end, { desc = "Jump to previous failed test" })

    vim.keymap.set("n", "]t", function()
      neotest.jump.next({ status = "failed" })
    end, { desc = "Jump to next failed test" })

    vim.keymap.set("n", "<leader>tl", function()
      neotest.run.run_last()
    end, { desc = "Run last test" })

    vim.keymap.set("n", "<leader>td", function()
      neotest.run.run({ strategy = "dap" })
    end, { desc = "Debug nearest test" })
  end,
}
