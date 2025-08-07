local M = {}
function M.toogle()
  local col = vim.fn.col(".")
  local word = vim.fn.expand("<cword>")

  if word == "true" then
    vim.cmd("normal ciwfalse")
  elseif word == "false" then
    vim.cmd("normal ciwtrue")
  end

  vim.fn.cursor(vim.fn.line("."), col)
end

return M
