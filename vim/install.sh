#!/bin/sh

DIR="$(pwd -P $0)"

echo "📝 Ensuring vim is setup."

if [ ! -d ~/.vim ]; then
  if [ $(uname) = "Darwin" ]; then
    ln -s ~/.dotfiles/vim/ ~/.vim

    if command -v mvim &> /dev/null; then
      mvim +PlugInstall +qall
    fi
  else
    ln -sd ~/.dotfiles/vim/ ~/.vim

    if command -v vim &> /dev/null; then
      vim +PlugInstall +qall
    fi
  fi
fi
