# install Neovim on Ubuntu

Ref: [Install Neovim Ubuntu](https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu)

```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
```

## install tree-sitter

```
wget https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
gzip -d tree-sitter-linux-x64.gz
mv tree-sitter-linux-x64 tree-sitter
chmod a+x tree-sitter
```

## install rust-analyzer

```
wget https://github.com/rust-lang/rust-analyzer/releases/download/2022-11-07/rust-analyzer-x86_64-unknown-linux-gnu.gz
gunzip rust-analyzer-x86_64-unknown-linux-gnu.gz
mv rust-analyzer-x86_64-unknown-linux-gnu rust-analyzer
chmod a+x rust-analyzer
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

```shell
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

Install requirements

```bash
./install-deps.sh
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

