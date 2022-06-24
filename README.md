# NVIM Config in Lua language

Clone the project

```bash
git clone https://github.com/oopsmonk/NvimConfig.git
```

Replace local nvim config

```bash
mv ~/.config/nvim ~/.config/nvim-backup
ln -s NvimConfig ${HOME}/.config/nvim
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

