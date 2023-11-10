#/bin/bash

echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing requriment"
brew install zplug
brew install exa
brew install pygments
brew install git

echo "Installing optional"
brew install gh
brew install tree

echo "Installing apps"
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask google-chrome
brew install --cask alfred
brew install --cask notion
brew install --cask docker
brew install --cask paw
brew install --cask tower

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "Installing node 18"
nvm install 18

echo "Install yarn / pnpm"
npm install -g yarn
npm install -g pnpm

echo "Move files"
ln -s -f "$(pwd)/.zshrc" ~/.zshrc
touch ~/.zshrc.local
ln -s -f "$(pwd)/.vimrc" ~/.vimrc
ln -s -f "$(pwd)/.gitconfig" ~/.gitconfig
ln -s -f "$(pwd)/.gitignore" ~/.gitignore

echo "Init zsh"
source ~/.zshrc
