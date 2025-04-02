vim.g.mapleader = " "

local builtin = require('telescope.builtin')

vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files hidden=true<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ft', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})

-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fg', function()
  print("Calling live_grep_args...")
  require('telescope').extensions.live_grep_args.live_grep_args()
end, {})
-- vim.keymap.set('n', '<leader>t', actions.cycle_history_next, {})
-- vim.keymap.set('n', '<leader>y', actions.cycle_history_prev, {})
vim.keymap.set('n', '<leader>h', '<C-w><Left>', {})
vim.keymap.set('n', '<leader>l', '<C-w><Right>', {})
vim.keymap.set('n', '<leader>j', '<C-w><Down>', {})
vim.keymap.set('n', '<leader>k', '<C-w><Up>', {})
vim.keymap.set('n', '<leader>|', ':vsplit<cr>', {})
vim.keymap.set('n', '<leader>_', ':split<cr>', {})
vim.keymap.set('n', '<leader>fh', ':Telescope search_history<CR>', { noremap = true, silent = true })


vim.keymap.set('n', '<Right>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<Down>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<Up>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<Left>', ':vertical resize +2<CR>', { silent = true })

vim.api.nvim_create_user_command('R', function()
    vim.cmd('source $MYVIMRC')
end, {})

vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<cr>', {})

vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true })
vim.keymap.set("n", "gt", vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fo', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':NvimTreeFocus<cr>', {})

vim.keymap.set("n", "<Leader>q", ":tabclose<CR>", { silent = true }) -- Close current tab
vim.keymap.set("n", "<Leader>a", ":tabonly<CR>", { silent = true })
vim.keymap.set("n", "<C-p>", ":tabprevious<CR>", { silent = true }) -- Previous tab
vim.keymap.set("n", "<C-n>", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>z", ":tab split<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>pw', function()
  local file_path = vim.fn.expand('%:p')
  vim.api.nvim_out_write(file_path .. "\n")
  vim.fn.setreg('+', file_path)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>d", function()
    require('harpoon.ui').toggle_quick_menu()
    vim.cmd("resize 25")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>m", require('harpoon.mark').add_file, { noremap = true, silent = true })

for i = 1, 6 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  vim.keymap.set("n", lhs, rhs, { desc = "Move to window " .. i })
end
