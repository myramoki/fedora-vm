printf "\n#### BEGIN CONFIG : Software\n\n"

dnf -y -q upgrade
dnf -y -q copr enable lihaohong/yazi
dnf -y -q install vim stow git at yazi

# https://discussion.fedoraproject.org/t/vim-default-editor-in-coreos/71356/4
dnf -y swap nano-default-editor vim-default-editor --allowerasing

touch /tmp/doreboot

printf "\n#### FINISHED CONFIG : Software\n\n"
