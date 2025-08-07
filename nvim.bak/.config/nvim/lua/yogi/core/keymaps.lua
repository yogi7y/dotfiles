vim.g.mapleader = " "

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Resize windows
keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Split windows
keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

-- Focus in and out of windows
keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Focus only on current window (close others)" })
keymap.set("n", "<leader>ww", "<C-w>w", { desc = "Cycle through windows" })
keymap.set("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows" })

-- Navigate vim panes
keymap.set("n", "<c-k>", ":wincmd k<CR>", { desc = "Move to the pane above" })
keymap.set("n", "<c-j>", ":wincmd j<CR>", { desc = "Move to the pane below" })
keymap.set("n", "<c-h>", ":wincmd h<CR>", { desc = "Move to the left pane" })
keymap.set("n", "<c-l>", ":wincmd l<CR>", { desc = "Move to the right pane" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>bb", require("yogi.utils.toogle_boolean").toogle, { desc = "Toogle boolean" })

-- Add these to your keymaps.lua
keymap.set("n", "<M-j>", "3<C-e>", { desc = "Scroll down (screen)" }) -- Alt-j to scroll down
keymap.set("n", "<M-k>", "3<C-y>", { desc = "Scroll up (screen)" }) -- Alt-k to scroll up
