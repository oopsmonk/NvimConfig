--
-- A simple lua config for nvim
-- Neovim 0.7.0+
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
  -- display tags in a windown
  use 'preservim/tagbar'
  -- A (Neo)vim plugin for formatting code
  use 'sbdchd/neoformat'
  -- Delete/change/add parentheses/quotes/XML-tags/much more with ease
  use 'tpope/vim-surround'
  -- Smart and powerful comment plugin for neovim
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  -- statusline
  use {'vim-airline/vim-airline', requires = { 'vim-airline/vim-airline-themes'}, }
  -- highlighting, indentation, or folding
  use { 'nvim-treesitter/nvim-treesitter' }
  -- file explorer
  use { 'preservim/nerdtree' }
  -- A Git wrapper so awesome, it should be illegal
  use 'tpope/vim-fugitive'
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
        marks = false, -- disable marks on ' and `, disable for surround plugin
        registers = false, -- disable show registers on ", disable for surrond plugin
        -- or leave it empty to use the default settings
        plugins = {
          spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 30, -- how many suggestions should be shown in the list?
          },
          -- the presets plugin, adds help for a bunch of default keybindings in neovim
          -- No actual key bindings are created
          presets = {
            g = false, -- bindings for prefixed with g, disable for surround plugin
          },
        },
      }
    end
  }

  -- doxygen
  use 'vim-scripts/DoxygenToolkit.vim'
  -- zig language
  use 'ziglang/zig.vim'
  -- Markdown support
  use 'preservim/vim-markdown'
  use 'iamcco/markdown-preview.nvim'
  -- Go language
  use {'fatih/vim-go', run = ':GoInstallBinaries'}
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

  -- hop lines and words in the buffer
  use 'phaazon/hop.nvim'
  -- buffer as tabs
  use {'akinsho/bufferline.nvim', tag = "v3.*"}
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
vim.opt.number = true
vim.opt.relativenumber = true

-- enable system clipboard
vim.opt.clipboard = 'unnamedplus'

-- wild ignore
vim.opt.wildignore = { '*.o', '*.a', '*.obj' }

-- enable cursor line highlight
vim.opt.cursorline = true

-- replace TAB with spaces
vim.api.nvim_create_autocmd("FileType",
  {pattern = { "c", "cpp", "markdown" }, command = [[setlocal expandtab shiftwidth=2 softtabstop=2]]})
vim.api.nvim_create_autocmd("FileType",
  {pattern = "sh", command = [[setlocal expandtab shiftwidth=2 softtabstop=2]]})

-- go to last location
vim.api.nvim_create_autocmd("BufReadPost",
  { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] })

-- Set colorscheme
vim.opt.termguicolors = true
vim.cmd([[colorscheme onedark]])

-- popup menu
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- listchars
vim.opt.listchars = {eol = '↵'}
vim.opt.list = true

-- folding
vim.opt.foldlevel = 20
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

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
  ["<leader>nt"] = { "<cmd>NERDTreeFind<CR>", "Find the file in NERDTree" },
  -- file
  ["<leader>t"] = { name = "Telescope" },
  ["<leader>tf"] = { "<cmd>Telescope find_files previewer=false<CR>", "Find File" },
  ["<leader>tb"] = { "<cmd>Telescope buffers<CR>", "Find Buffer" },
  ["<leader>td"] = { "<cmd>Telescope lsp_definitions<CR>", "Goto Definitions" },
  ["<leader>tr"] = { "<cmd>Telescope lsp_references<CR>", "Goto References" },
  ["<leader>ti"] = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementations" },
  ["<leader>tt"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Goto Type Definitions" },
  ["<leader>tl"] = { "<cmd>Telescope live_grep<CR>", "Live grep" },
  ["<leader>tm"] = { "<cmd>Telescope marks<CR>", "Show marks" },
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
  ["<leader>bd"] = { "<cmd>bdel<CR>", "Delete Buffer" },
  ["<leader>bh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Display Info" },
  ["<leader>brn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
  ["<leader>bc"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
  -- git
  ["<leader>g"] = { name = "git signs" },
  ["<leader>gt"] = { "<cmd>Gitsigns toggle_signs<CR>", "Toggle Signs" },
  ["<leader>gn"] = { "<cmd>Gitsigns next_hunk<CR>", "Next Hunk" },
  ["<leader>gp"] = { "<cmd>Gitsigns prev_hunk<CR>", "Prev Hunk" },
  ["<leader>gd"] = { "<cmd>Gitsigns preview_hunk<CR>", "Hunk Diff" },
  ["<leader>gr"] = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
  -- hop
  ["<leader>h"] = { name = "hop" },
  ["<leader>hl"] = { "<cmd>HopLineStart<CR>", "Hop between lines" },
  ["<leader>hw"] = { "<cmd>HopWord<CR>", "Hop between Words" },
  ["<leader>hc"] = { "<cmd>HopWordCurrentLine<CR>", "Hop between Words at current line" },
})

-- ========plugin config========
-- bufferline.nvim
vim.opt.termguicolors = true
require("bufferline").setup{
  options = {
    indicator = {
      icon = '|',
      style = 'icon',
    },
    buffer_close_icon = 'x',
    modified_icon = '●',
    close_icon = 'x',
    left_trunc_marker = '>',
    right_trunc_marker = '<',
  }
}

-- hop.nvim
require'hop'.setup()

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
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
-- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
local servers = { 'clangd', 'zls', 'cmake', 'pyright', 'gopls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
-- ref: https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
local ls = require 'luasnip'
ls.config.set_config({
  history = true,
  -- Update more often, :h events for more info.
  update_events = "TextChanged,TextChangedI",
  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
})

-- <c-j> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })
-- <c-k> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- nvim-cmp setup
local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
    -- vim.fn["vsnip#anonymous"](args.body) -- For 'vsnip` users
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- ==============================================
-- ========           Snippets           ========
-- ==============================================

ls.add_snippets(
  -- "all", {
  --   ls.snippet("ternary", { ls.insert_node(1, "cond"), ls.text_node(" ? "), ls.insert_node(2, "then"), ls.text_node(" : "), ls.insert_node(3, "else")})
  -- },
  "c", {
    ls.snippet("pf", { ls.text_node('printf("[%s:%d] '), ls.insert_node(1,'text'), ls.text_node('", __func__, __LINE__);')})
  }
)

