local builtin = require('telescope.builtin')

-- Before nvim tree, used this to get to explorer
-- vim.keymap.set("n", "-", vim.cmd.Ex) -- need nvim 0.8+

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ft', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})
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

-- CMP
local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
})

vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<cr>', {})

local colorschemes = { 'eldritch', 'fluoromachine', 'material', 'catppuccin' }
local colorscheme_index = 1 -- Start with the first color scheme
function _G.toggle_colorscheme()
    colorscheme_index = (colorscheme_index % #colorschemes) + 1
    vim.cmd('colorscheme ' .. colorschemes[colorscheme_index])
end

vim.keymap.set('n', '<leader>cc', ':lua toggle_colorscheme()<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>fo', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

-- Harpoon
vim.keymap.set('n', '<leader>m', require('harpoon.mark').add_file,  { noremap = true, silent = true })
vim.keymap.set('n', '<leader>hh', require('harpoon.ui').toggle_quick_menu,  { noremap = true, silent = true })
