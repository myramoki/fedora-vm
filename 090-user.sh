cd $SUDO_USER_HOME
sudo -u bn git clone https://github.com/myramoki/dotfiles-fedora.git .dotfiles
sudo -u bn stow --adopt .dotfiles
sudo -u bn git reset --hard
