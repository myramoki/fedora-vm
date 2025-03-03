printf "\n#### BEGIN CONFIG : Software\n\n"

dnf upgrade -y
dnf install -y vim

# https://discussion.fedoraproject.org/t/vim-default-editor-in-coreos/71356/4
dnf swap -y nano-default-editor vim-default-editor --allowerasing

printf "\n#### FINISHED CONFIG : Software\n\n"
