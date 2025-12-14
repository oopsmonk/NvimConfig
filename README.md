# NVIM Configuration

## Key Bindings

Code format, `:Neoformat`, neoformat
Jump to the newer/older cursor position in the jumplist, `Ctrl i` / `Ctrl o` / `:jumps`, build-in, 
Snippet jump to the next/prev parameter, `Ctrl j` / `Ctrl k`, luasnip
Comment the current line, `gcc`, Comment.nvim


### Git

Git open a vertical diff split, `:Gvdiffsplit`, vim-fugitive
Jump to the next/prev hunk, `]c` / `[c`, vim-fugitive

`:Git` status buffer, vim-fugitive
- stage/unstage file, `-`
- open diff, `dv`
- inline diff, `=`


### Window

Layoyt to horizontal, `Ctrl+w H`, build-in
Split to horizontal, `Ctrl+w v`, build-in
Rotate, `Ctrl+w r`, build-in
Rotate, `Ctrl+w r`, build-in
Close all other windows, `Ctrl+w o`, build-in


## Plugins

1. [lazy.nvim](https://github.com/folke/lazy.nvim): plugin manager
1. [vim-fugitive](https://github.com/tpope/vim-fugitive): Git wrapper
1. [sleuth.vim](https://github.com/tpope/vim-sleuth): automatically adjusts `shiftwidth` and `expandtab` heuristically based on the current file
1. [mason.nvim](https://github.com/mason-org/mason.nvim): easily manage external editor tooling such as LSP servers, DAP servers, linters, and formatters through a single interface.
1. [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): a collection of LSP server configurations for the [Nvim LSP client](https://neovim.io/doc/user/lsp.html).
1. [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim): mason-lspconfig bridges `mason.nvim` with the `lspconfig` plugin
1. [lazydev.nvim](https://github.com/folke/lazydev.nvim): Faster LuaLS setup for Neovim
1. [nvim-cmp](https://github.com/hrsh7th/nvim-cmp): A completion plugin for neovim coded in Lua.
1. [which-key.nvim](https://github.com/folke/which-key.nvim): showing available keybindings in a popup as you type.
1. [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim): Git integration for buffers
1. [onedark.nvim](https://github.com/navarasu/onedark.nvim): One dark and light colorscheme
1. [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim): A blazing fast and easy to configure neovim statusline plugin.
1. [Comment.nvim](https://github.com/numToStr/Comment.nvim): Smart and powerful comment
1. [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim): the power of the moon.
1. [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim): a c port of [fzf](https://github.com/junegunn/fzf).
1. [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter): Nvim Treesitter configurations and abstraction layer.
1. [flash.nvim](https://github.com/folke/flash.nvim): lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.
1. [nvim-autopairs](https://github.com/windwp/nvim-autopairs): autopairs
1. [bufferline.nvim](https://github.com/akinsho/bufferline.nvim): A snazzy bufferline
1. [nerdtree](https://github.com/preservim/nerdtree): a file system explorer
1. [tagbar](https://github.com/preservim/tagbar): display tags in a window, ordered by scope.
1. [zig.vim](https://codeberg.org/ziglang/zig.vim): File detection and syntax highlighting for the zig programming language.
1. [neoformat](https://github.com/sbdchd/neoformat): code formatter.
1. [nvim-colorizer](https://github.com/catgoose/nvim-colorizer.lua): A high-performance color highlighter.
1. [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim): improve viewing Markdown files.
