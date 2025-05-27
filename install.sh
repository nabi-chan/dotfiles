#/bin/bash

sudo -v

echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Installing shell programs with brew"
brew install zplug
brew install bat
brew install doggo
brew install eza
brew install pygments
brew install git
brew install pyenv
brew install gnupg
brew install gh
brew install tree
brew install wget
brew install mas
brew install jesseduffield/lazygit/lazygit
brew install cloudflared
brew install awscli
brew install mise
brew install 1password-cli
brew install k9s
brew install pulumi
brew install terraform
brew install watchman
brew install gum
brew install just
brew install yq

echo "Installing programs with brew --cask"
brew install --cask 1password
brew install --cask zed
brew install --cask google-chrome
brew install --cask google-drive
brew install --cask discord
brew install --cask datagrip
brew install --cask intellij-idea
brew install --cask orbstack
brew install --cask pritunl
brew install --cask warp
brew install --cask raycast
brew install --cask figma
brew install --cask tunnelbear
brew install --cask notion
brew install --cask notion-calendar
brew install --cask utm
brew install --cask postman
brew install --cask linear
brew install --cask hancom-word
brew install --cask slack
brew install --cask logi-options+

echo "Install Font"
brew install --cask font-jetbrains-mono
brew install --cask font-hack-nerd-font
brew install --cask font-pretendard

echo "Installing Mac App Store apps"
mas install 441258766 # Magnet
mas install 869223134 # KakaoTalk
mas install 497799835 # Xcode
mas install 1265704574 # Bandizip
mas install 1276493162 # reMarkable
mas install 1102655071 # Channel Talk
mas install 409201541 # Pages
mas install 409203825 # Numbers
mas install 409183694 # Keynote
mas install 6714467650 # Perplexity
mas install 1519867270 # Refined Github
mas install 1231935892 # Unicorn Ad Blocker
mas install 1569813296 # 1Password for safari
mas install 6738274497 # Raycast Companion
mas install 1023251042 # 알라딘 eBook

echo "Installing KakaoTalk For Work"
sudo ./scripts/kakaotalk-for-work.sh

# node
echo "Installing node 22"
mise install node@22
mise use -g node@22

# python
echo "Installing python 2.7.18"
mise install python@2.7.18
mise use -g python@2.7.18

# java
mise install java@zulu-8
mise install java@zulu-23
mise use -g java@zulu-23

# corepack
echo "Enable corepack for yarn"
corepack enable
yarn -v
pnpm -v

echo "Install bun"
curl -fsSL https://bun.sh/install | bash

echo "Move files"
touch ~/.zshrc.local
ln -s -f "$(pwd)/.zshrc" ~/.zshrc
ln -s -f "$(pwd)/.vimrc" ~/.vimrc
ln -s -f "$(pwd)/.gitconfig" ~/.gitconfig
ln -s -f "$(pwd)/.gitignore" ~/.gitignore
touch ~/.ssh/config.local
ln -s -f "$(pwd)/.ssh-config" ~/.ssh/config
ln -s -f "$(pwd)/app-configs/lazygit.yml" ~/Library/Application\ Support/lazygit/config.yml
ln -s -f "$(pwd)/app-configs/zed.json" ~/.config/zed/settings.json
ln -s -f "$(pwd)/app-configs/justfile" ~/.config/just/justfile

echo "Init zsh"
source ~/.zshrc
