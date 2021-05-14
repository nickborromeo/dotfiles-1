#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OS="$(uname)"

if [ "$OS" = "Darwin"]; then
  if ! command -v brew &> /dev/null; then
    echo '🍺 Installing Homebrew.'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  echo '📦 Checking if we need to install packages…'
  if ! brew bundle check; then
    echo '📦 Running `brew bundle install` to install desired packages.'
    brew bundle install
  fi
fi

# Link all linkable files
for linkable in $DIR/**/*.symlink; do
  target=$HOME"/."$(basename $linkable | sed 's/.symlink//')
  if [ ! -L $target ]; then
    echo "🔗 Linking $target → $linkable."
    ln -Ff -s $linkable $target
  fi
done

for executable in $DIR/**/install.sh; do
  echo "👟 Running $executable."
  sh $executable
done

