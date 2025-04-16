printf "\n#### BEGIN CONFIG : Github SSH Keys\n\n"

printf "#- fetch ssh keys\n"

mkdir -p $SUDO_USER_HOME/.ssh

sshkeystempfile=$(mktemp /tmp/tmp.dl.sshkeys.XXXXXXXXXX)
curl -sL -o $sshkeystempfile $GITDIR/biznuvo-server-keys.tar.xz.gpg
gpg -d $sshkeystempfile | tar -J -xvf - -C $SUDO_USER_HOME/.ssh

printf "#- configure ssh config\n"

printf "
Host github.com
    Hostname ssh.github.com
    Port 443
    IdentityFile=~/.ssh/biznuvo-server-v2-id_ed25519
" >> $SUDO_USER_HOME/.ssh/config

chown -R $SUDO_USER: $SUDO_USER_HOME/.ssh

printf "\n#### FINISHED CONFIG : Github SSH Keys\n\n"
