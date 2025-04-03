cd $SUDO_USER_HOME
sudo -u bn git clone https://github.com/myramoki/dotfiles-fedora.git .dotfiles

cd $SUDO_USER_HOME/.dotfiles
sudo -u bn stow --adopt .
sudo -u bn git reset --hard
