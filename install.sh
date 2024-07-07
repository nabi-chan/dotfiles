#/bin/bash

echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing requriment"
brew install zplug
brew install eza
brew install pygments
brew install git
brew install pyenv

echo "Installing optional"
brew install gh
brew install tree
brew install wget
brew install mas
brew install jesseduffield/lazygit/lazygit

echo "Installing apps"
brew install --cask visual-studio-code
brew install --cask google-chrome
brew install --cask docker
brew install --cask warp
brew install --cask raycast
brew install --cask figma
brew install --cask ngrok
brew install --cask tunnelbear
brew install --cask notion
brew install --cask notion-calendar
brew install --cask 1password

echo "Installing Mac App Store apps"
mas install 441258766
mas install 869223134
mas install 497799835
mas install 1265704574

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "Installing node 18"
nvm install 22

echo "Installing python 2.7"
pyenv install 2.7.18

echo "Install yarn / pnpm"
npm install -g yarn
npm install -g pnpm

echo "Install bun"
curl -fsSL https://bun.sh/install | zsh

echo "Move files"
touch ~/.zshrc.local
ln -s -f "$(pwd)/.zshrc" ~/.zshrc
ln -s -f "$(pwd)/.vimrc" ~/.vimrc
ln -s -f "$(pwd)/.gitconfig" ~/.gitconfig
ln -s -f "$(pwd)/.gitignore" ~/.gitignore

echo "Init zsh"
source ~/.zshrc
