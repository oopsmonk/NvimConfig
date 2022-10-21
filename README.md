# NVIM Config in Lua language

## install Neovim

Ref: [Install Neovim Ubuntu](https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu)

```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
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

Install plugins

```bash
nvim +PackerInstall
```

Check plugin

```bash
nvim +checkhealth
```

