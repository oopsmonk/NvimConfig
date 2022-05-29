#!/bin/bash

function install_deps(){
  echo "Installing dependences..."
  sudo apt update 
  sudo apt install ripgrep fd-find -y
  if [ $? -ne 0 ]
  then
    echo "install deps error!"
    exit 1
  fi
  pip install cmake-language-server
  if [ $? -ne 0 ]
  then
    echo "install cmake lsp error!"
    exit 1
  fi
  pip install pyright
  if [ $? -ne 0 ]
  then
    echo "install python lsp error!"
    exit 1
  fi
}

function install_nerd_font(){
  # reqiered by kyazdani42/nvim-web-devicons
  # install Nerd Font from https://github.com/ryanoasis/nerd-fonts
  declare -a fonts=(
      BitstreamVeraSansMono
      Hack
      Noto
      Overpass
      SourceCodePro
      Ubuntu
      UbuntuMono
  )

  # nerd font release version
  version='2.1.0'

  fonts_dir="${HOME}/.local/share/fonts"

  if [[ ! -d "$fonts_dir" ]]; then
      mkdir -p "$fonts_dir"
  fi

  for font in "${fonts[@]}"; do
      zip_file="${font}.zip"
      download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
      echo "Downloading $download_url"
      wget "$download_url"
      if [ $? -ne 0 ]
      then
        echo "download ${font} failed!"
        exit 1
      fi
      unzip "$zip_file" -d "$fonts_dir"
      rm "$zip_file"
  done

  # remove unused fonts
  find "$fonts_dir" -name '*Windows Compatible*' -delete

  # update font cache
  fc-cache -fv
}

# call install dependences
install_deps
# call install nerd font
# install_nerd_font

