vim.g.mapleader = " " -- easy to reach leader key

-- Before nvim tree, used this to get to explorer
-- vim.keymap.set("n", "-", vim.cmd.Ex) -- need nvim 0.8+

vim.keymap.set('n', '<C-h>', '<C-w><Left>', {})
vim.keymap.set('n', '<C-l>', '<C-w><Right>', {})
vim.keymap.set('n', '<C-j>', '<C-w><Down>', {})
vim.keymap.set('n', '<C-k>', '<C-w><Up>', {})
vim.keymap.set('n', '<leader>%', ':vsplit<cr>', {})
vim.keymap.set('n', '<leader>"', ':split<cr>', {})
