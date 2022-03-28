--
-- A simple lua config for nvim
--

-- map leader key
vim.g.mapleader = ","

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- PackerComile on init.lua changes
vim.cmd([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]])

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'
  -- fuzzy finder
  use { 'nvim-telescope/telescope.nvim',
    -- requires = { {'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'} }
    requires = { 'nvim-lua/plenary.nvim' }
  }
  -- fzf algorithm for telescope
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- color scheme
  use 'mjlbach/onedark.nvim'
  -- statusline
  use {'vim-airline/vim-airline', requires = { 'vim-airline/vim-airline-themes'}, }
  -- highlighting, indentation, or folding
  use { 'nvim-treesitter/nvim-treesitter' }
  -- file explorer
  use { 'preservim/nerdtree' }
  -- git decorations
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end
  }
  -- popup with possible key bindings
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        plugins = {
          spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 30, -- how many suggestions should be shown in the list?
          },
        },
      }
    end
  }

  -- LSP and Autocompletion
  -- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-path' -- nvim-cmp source for path
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'quangnguyen30192/cmp-nvim-tags' -- tags completion source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp

end)

-- ========Global Settings========
-- ref: https://github.com/nanotee/nvim-lua-guide#using-meta-accessors

-- decrease update time
vim.opt.updatetime = 300

-- increase cmd history
vim.opt.history = 1000

-- enable mouse support
vim.o.mouse = 'nv'

-- use relative line number
vim.opt.relativenumber = true

-- enable system clipboard
vim.opt.clipboard = 'unnamedplus'

-- wild ignore
vim.opt.wildignore = { '*.o', '*.a', '*.obj' }

-- replace TAB with spaces
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Set colorscheme
vim.opt.termguicolors = true
vim.cmd([[colorscheme onedark]])

-- popup menu
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- listchars
vim.opt.listchars = {eol = '↵'}
vim.opt.list = true

-- ========key mapping========
-- ref: https://github.com/nanotee/nvim-lua-guide#defining-mappings

-- -- telescope key map
-- vim.api.nvim_set_keymap('n', '<leader>tb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>tf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
--
-- -- buffer operations
-- vim.api.nvim_set_keymap('', 'bn', ':bn<CR>', { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('', 'bp', ':bp<CR>', { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('', 'bd', ':bd<CR>', { noremap = true, silent = true})

local wk = require("which-key")
wk.register({
  -- file
  ["<leader>t"] = { name = "Telescope" },
  ["<leader>tf"] = { "<cmd>Telescope find_files previewer=false<CR>", "Find File" },
  ["<leader>tb"] = { "<cmd>Telescope buffers<CR>", "Find Buffer" },
  ["<leader>td"] = { "<cmd>Telescope lsp_definitions<CR>", "Goto Definitions" },
  ["<leader>tr"] = { "<cmd>Telescope lsp_references<CR>", "Goto References" },
  ["<leader>ti"] = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementations" },
  ["<leader>tt"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Goto Type Definitions" },
  -- diagnostics
  ["<leader>d"] = { name = "Diagnostics" },
  -- ["<leader>de"] = { "<cmd>lua vim.diagnostic.enable()<CR>", "Enable Diagnostic" },
  ["<leader>de"] = { "<cmd>LspStart<CR>", "Enable Diagnostic" },
  -- ["<leader>dd"] = { "<cmd>lua vim.diagnostic.disable()<CR>", "Disable Diagnostic" },
  ["<leader>dd"] = { "<cmd>LspStop<CR>", "Disable Diagnostic" },
  ["<leader>dn"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
  ["<leader>dp"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev Diagnostic" },
  ["<leader>dl"] = { "<cmd>Telescope diagnostics<CR>", "List Diagnostic" },
  -- buffer
  ["<leader>b"] = { name = "buffer" },
  ["<leader>bn"] = { "<cmd>bn<CR>", "Next Buffer" },
  ["<leader>bp"] = { "<cmd>bp<CR>", "Previous Buffer" },
  ["<leader>bh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Display Info" },
  ["<leader>brn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
  ["<leader>bc"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
  -- git
  ["<leader>g"] = { name = "git signs" },
  ["<leader>gt"] = { "<cmd>Gitsigns toggle_signs<CR>", "Toggle Signs" },
  ["<leader>gn"] = { "<cmd>Gitsigns next_hunk<CR>", "Next Hunk" },
  ["<leader>gp"] = { ":Gitsigns prev_hunk<CR>", "Prev Hunk" },
  ["<leader>gd"] = { ":Gitsigns preview_hunk<CR>", "Hunk Diff" },
})

-- ========plugin config========

-- vim-airline
vim.g.airline_theme = 'onedark'

-- telescope
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {"bash", "c", "cmake", "cpp", "css", "devicetree", "dockerfile", "go", "gomod", "gowork", "html", "javascript", "json", "make", "ninja", "python", "rust", "toml", "typescript", "vim", "yaml", "zig"},

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- ==============================================
-- ========LSP and Autocompletion Support========
-- ==============================================

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
-- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
local servers = { 'clangd' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- with tab
-- local cmp = require'cmp'
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       require('luasnip').lsp_expand(args.body)
--     end,
--   },
--   mapping = {
--     ['<C-p>'] = cmp.mapping.select_prev_item(),
--     ['<C-n>'] = cmp.mapping.select_next_item(),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end,
--     ['<S-Tab>'] = function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end,
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'buffer' },
--     { name = 'luasnip' },
--     { name = 'tags' },
--   },
-- }

