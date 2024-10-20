require('core.mappings')
require('core.options')
require('core.plugins')

----------- NVIM-TREE -----------
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  view = {
      width = 58,
      relativenumber = true,
  },
})

-------------------- LSP --------------------
local lsp_zero = require('lsp-zero')
local lsp = require('lspconfig')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
  ensure_installed = { 'html', 'ts_ls', 'cssls', 'dockerls' },
  handlers = {
      function(server_name)
          lsp[server_name].setup({})
      end,

      -- custom handler for gopls
      gopls = function()
          lsp.gopls.setup({
              root_dir = lsp.util.root_pattern("go.work", "go.mod", "WORKSPACE"),
              settings = {
                  gopls = {
                      env = {
                          GOPACKAGESDRIVER = "~/repos/satcode/payload/tools/gopackagesdriver.sh",
                          GOPACKAGESDRIVER_BAZEL_BUILD_FLAGS = "--strategy=GoStdlibList=local --linkopt=-Wl,--strip-all --config=armv7l",
                          BAZEL_NOTIFY_THRESH = "999999999",
                      },
                      directoryFilters = {
                          "-bazel-bin",
                          "-bazel-out",
                          "-bazel-testlogs",
                          "-bazel-payload",
                      },
                      analyses = {
                          unusedparams = false,
                          simplifycompositelit = false,
                          simplifyrange = false,
                          infertypeargs = false,
                      },
                      staticcheck = true,
                      gofumpt = true,
                  },
              },
      })
    end,
  },
})


local lsp = require('lsp-zero').preset({})
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

lsp.setup()

-------------------- Auto close --------------------
require("autoclose").setup()

-------------------- Colorscheme -------------------
vim.cmd[[colorscheme cyberdream]]
