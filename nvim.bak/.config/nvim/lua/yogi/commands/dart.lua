local M = {}

function M.setup()
  -- Dart version command
  vim.api.nvim_create_user_command("DartVersion", function()
    local version = vim.fn.system("dart --version")
    vim.notify(version, vim.log.levels.INFO)
  end, {})
end

return M
