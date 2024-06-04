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
  pip install pynvim balck isort
  if [ $? -ne 0 ]; then
    echo "install pynvim error!"
    exit 1
  fi
}

# call install dependences
install_deps
