printf "\n#### BEGIN CONFIG : Software\n\n"

fwupdmgr -y --no-reboot-check upgrade

dnf upgrade -y
dnf install -y vim stow

# https://discussion.fedoraproject.org/t/vim-default-editor-in-coreos/71356/4
dnf swap -y nano-default-editor vim-default-editor --allowerasing

touch /tmp/doreboot

printf "\n#### FINISHED CONFIG : Software\n\n"
