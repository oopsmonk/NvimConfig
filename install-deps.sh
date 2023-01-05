#!/bin/bash

function install_deps(){
  echo "Installing dependences..."
  sudo apt update
  sudo apt install ripgrep fd-find python3-pip ack exuberant-ctags -y
  if [ $? -ne 0 ]; then
    echo "install deps error!"
    exit 1
  fi
  pip install cmake-language-server
  if [ $? -ne 0 ]; then
    echo "install cmake lsp error!"
    exit 1
  fi
  pip install pyright
  if [ $? -ne 0 ]; then
    echo "install python lsp error!"
    exit 1
  fi
  # install packer for nvim plugin management
  packer_file="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
  if [ ! -d ${packer_file} ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ${paker_file}
    if [ $? -ne 0 ]; then
      echo "install packer!"
      exit 1
    fi
  fi
}

# call install dependences
install_deps
