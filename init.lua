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
  use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'} } }
  -- color scheme
  use 'mjlbach/onedark.nvim'
  -- Fancier statusline
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  -- highlighting, indentation, or folding
  use 'nvim-treesitter/nvim-treesitter'

  -- Additional textobjects for treesitter
  -- use 'nvim-treesitter/nvim-treesitter-textobjects'
  -- use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  -- use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  -- use 'hrsh7th/cmp-nvim-lsp'
  -- use 'saadparwaiz1/cmp_luasnip'
  -- use 'L3MON4D3/LuaSnip' -- Snippets plugin
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


-- ========key mapping========
-- ref: https://github.com/nanotee/nvim-lua-guide#defining-mappings

-- telescope key map
-- buffers
vim.api.nvim_set_keymap('n', '<leader>tb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
-- find files
vim.api.nvim_set_keymap('n', '<leader>tf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })

-- buffer operations
vim.api.nvim_set_keymap('', 'bn', ':bn<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('', 'bp', ':bp<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('', 'bd', ':bd<CR>', { noremap = true, silent = true})

-- ========plugin config========

-- icons, not working
require'nvim-web-devicons'.setup {
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

-- statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}

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

