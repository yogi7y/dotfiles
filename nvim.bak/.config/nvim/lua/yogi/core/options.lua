local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = true
opt.linebreak = true
opt.showbreak = "↪"
opt.textwidth = 0
opt.wrapmargin = 0

vim.opt.swapfile = false

-- Search
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"

-- Fold
-- opt.foldmethod = "indent"
-- opt.foldenable = false

opt.foldcolumn = "0" -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value
opt.foldlevelstart = 99
opt.foldenable = true

opt.clipboard:append("unnamedplus") -- Use system clipboard

opt.laststatus = 3
opt.splitkeep = "screen"

opt.spell = true

opt.formatoptions:append("r") -- Continue comments when pressing Enter
opt.formatoptions:append("o") -- Continue comments when pressing o or O

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "__FLUTTER_DEV_LOG__",
	callback = function()
		vim.opt_local.spell = false
	end,
})
