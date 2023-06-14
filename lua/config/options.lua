-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.conceallevel = 0
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldenable = true

-- highlight options for search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8

vim.opt.statuscolumn = "%l %r"

if vim.loop.os_uname().sysname == "Windows_NT" then
  local powershell_options = {
    shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }
  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
  vim.g.python3_host_prog = os.getenv("USERPROFILE") .. "\\.pyenv\\pyenv-win\\shims\\python.bat"
end

if vim.loop.os_uname().sysname == "Darwin" then
  vim.g.python3_host_prog = "/Users/alex/.pyenv/shims/python"
end
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
