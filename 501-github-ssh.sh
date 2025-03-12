printf "\n#### BEGIN CONFIG : Github SSH Keys\n\n"

dnf install -y -q git

sudouserhome=$(getent passwd $SUDO_USER | cut -d: -f6)

printf "[core]
    autocrlf = false
" > $sudouserhome/.gitconfig

chown $SUDO_USER: $sudouserhome/.gitconfig

printf "#- fetch ssh keys\n"

mkdir -p $sudouserhome/.ssh

sshkeystempfile=$(mktemp /tmp/tmp.dl.sshkeys.XXXXXXXXXX)
curl -sL -o $sshkeystempfile https://raw.githubusercontent.com/myramoki/fedora-vm/main/biznuvo-server-keys.tar.xz.gpg
gpg -d $sshkeystempfile | tar -J -xvf - -C $sudouserhome/.ssh

printf "#- configure ssh config\n"

printf "
Host github.com-server-v2
    Hostname ssh.github.com
    Port 443
    IdentityFile=~/.ssh/biznuvo-server-v2-id_ed25519
" >> $sudouserhome/.ssh/config

chown -R $SUDO_USER: $sudouserhome/.ssh

printf "\n#### FINISHED CONFIG : Github SSH Keys\n\n"
