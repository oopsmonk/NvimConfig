# Simple NVIM Configuration in Lua

## install Neovim

Ref: [Install Neovim macOS](https://github.com/neovim/neovim/blob/master/INSTALL.md#macos--os-x)

```bash
brew install neovim
```

## Install other tools

```bash
brew install ripgrep fd ack tree-sitter node fzf
pip3 install pynvim pyright
# need to be checked
# brew install universal-ctags rust-analyzer
```

## Neovim configuration

Clone the project

```bash
git clone https://github.com/oopsmonk/NvimConfig.git
```

Replace local nvim config

```bash
# mv ~/.config/nvim ~/.config/nvim-backup
ln -s ${PWD}/NvimConfig ${HOME}/.config/nvim
```

Clean up cache, useful for switching between different plugin manager as well.

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

Health check

```bash
nvim +checkhealth
```

## Troubleshooting

**treesitter/highlighter: Error executing lua: /usr/share/nvim/runtime/lua/vim/treesitter/query.lua...**
**treesitter/highlighter: Error executing lua: /usr/share/nvim/runtime/lua/vim/treesitter/query.lua...**
**treesitter/highlighter: Error executing lua: /usr/share/nvim/runtime/lua/vim/treesitter/query.lua...**

```
:TSInstall lua
```

