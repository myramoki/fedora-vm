printf "\n#### BEGIN CONFIG : Github SSH Keys\n\n"

printf "#- fetch ssh keys\n"

mkdir -p $SUDO_USER_HOME/.ssh

sshkeystempfile=$(mktemp /tmp/tmp.dl.sshkeys.XXXXXXXXXX)
curl -sL -o $sshkeystempfile $GITDIR/ssh-config.tar.xz.gpg
gpg -d $sshkeystempfile | tar -J -xvf - -C $SUDO_USER_HOME/.ssh

chown -R $SUDO_USER: $SUDO_USER_HOME/.ssh

printf "\n#### FINISHED CONFIG : Github SSH Keys\n\n"
