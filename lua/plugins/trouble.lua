-- VSCODE HYBRID MODE: Disable Trouble in VSCode
-- Use VSCode's Problems panel instead
if vim.g.vscode then
  return {}
end

return {
  "folke/trouble.nvim",
  -- opts will be merged with the parent spec
  opts = { auto_preview = false, auto_open = false },
}
