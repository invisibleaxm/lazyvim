-- VSCode-specific configuration
if not vim.g.vscode then
  return {}
end

-- Keymaps that work well in VSCode
local keymap = vim.keymap.set

-- Better navigation
keymap("n", "<C-j>", ":call VSCodeNotify('workbench.action.navigateDown')<CR>")
keymap("n", "<C-k>", ":call VSCodeNotify('workbench.action.navigateUp')<CR>")
keymap("n", "<C-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>")
keymap("n", "<C-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>")

-- File navigation
keymap("n", "<leader>ff", ":call VSCodeNotify('workbench.action.quickOpen')<CR>")
keymap("n", "<leader>fg", ":call VSCodeNotify('workbench.action.findInFiles')<CR>")
keymap("n", "<leader>fb", ":call VSCodeNotify('workbench.action.showAllEditors')<CR>")

-- Editor actions
keymap("n", "<leader>ca", ":call VSCodeNotify('editor.action.quickFix')<CR>")
keymap("n", "gr", ":call VSCodeNotify('editor.action.goToReferences')<CR>")
keymap("n", "gd", ":call VSCodeNotify('editor.action.revealDefinition')<CR>")
keymap("n", "gi", ":call VSCodeNotify('editor.action.goToImplementation')<CR>")
keymap("n", "K", ":call VSCodeNotify('editor.action.showHover')<CR>")

-- Comment toggling
keymap("n", "gcc", ":call VSCodeNotify('editor.action.commentLine')<CR>")
keymap("x", "gc", ":call VSCodeNotify('editor.action.commentLine')<CR>")

-- Center cursor on scroll
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Better paste
keymap("x", "<leader>p", '"_dP')

-- Copy to system clipboard
keymap({ "n", "v" }, "<leader>y", '"+y')
keymap("n", "<leader>Y", '"+Y')

return {}
