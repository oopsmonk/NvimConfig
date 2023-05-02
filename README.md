# NVIM Config in Lua language

## install Neovim

Ref: [Install Neovim Ubuntu](https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu)

```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
```

## install tree-sitter

```
wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.20.7/tree-sitter-linux-x64.gz
unzip tree-sitter-linux-x64.gz
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

Install requirments

```bash
./install-deps.sh
```

Check plugin

```bash
nvim +checkhealth
```

