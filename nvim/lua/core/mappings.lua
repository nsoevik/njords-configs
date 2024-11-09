local builtin = require('telescope.builtin')

-- Before nvim tree, used this to get to explorer
-- vim.keymap.set("n", "-", vim.cmd.Ex) -- need nvim 0.8+

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- vim.keymap.set('n', '<C-g>', builtin.cycle_history_next, {})
-- vim.keymap.set('n', '<C-f>', builtin.cycle_history_prev, {})
vim.keymap.set('n', '<C-h>', '<C-w><Left>', {})
vim.keymap.set('n', '<C-l>', '<C-w><Right>', {})
vim.keymap.set('n', '<C-j>', '<C-w><Down>', {})
vim.keymap.set('n', '<C-k>', '<C-w><Up>', {})
vim.keymap.set('n', '<leader>|', ':vsplit<cr>', {})
vim.keymap.set('n', '<leader>_', ':split<cr>', {})

vim.keymap.set('n', '<Right>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<Down>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<Up>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<Left>', ':vertical resize +2<CR>', { silent = true })

vim.api.nvim_create_user_command('Reload', function()
      vim.cmd('source $MYVIMRC')
end, {})

-- Barbar
vim.keymap.set('n', '<F12>', ':BufferNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-F12>', ':BufferPrevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>x', ':BufferClose<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b1', ':BufferGoto 1<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b2', ':BufferGoto 2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b3', ':BufferGoto 3<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b4', ':BufferGoto 4<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b5', ':BufferGoto 5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b6', ':BufferGoto 6<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b7', ':BufferGoto 7<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b8', ':BufferGoto 8<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b9', ':BufferGoto 9<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

-- CMP
local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' }, 
        { name = 'luasnip' },
    },
})

vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<cr>', {})

local colorschemes = {'eldritch', 'fluoromachine', 'material', 'catppuccin'}
local colorscheme_index = 1  -- Start with the first color scheme
function _G.toggle_colorscheme()
  colorscheme_index = (colorscheme_index % #colorschemes) + 1
  vim.cmd('colorscheme ' .. colorschemes[colorscheme_index])
end
vim.keymap.set('n', '<leader>mm', ':lua toggle_colorscheme()<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>fo', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
