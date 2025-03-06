printf "\n#### BEGIN CONFIG : Github SSH Keys\n\n"

echo "[core]
    autocrlf = false
" > ~$SUDO_USER/.gitconfig
chown $SUDO_USER: ~$SUDO_USER/.gitconfig

printf "#- fetch ssh keys\n"

mkdir -p ~$SUDO_USER/.ssh

sshkeystempfile=$(mktemp /tmp/tmp.dl.sshkeys.XXXXXXXXXX)
curl -sL -o $sshkeystempfile https://raw.githubusercontent.com/myramoki/fedora-vm/main/biznuvo-server-keys.tar.xz.gpg
gpg -d $sshkeystempfile | tar -J -tvf - -C ~$SUDO_USER/.ssh

printf "#- configure ssh config\n"

printf "
Host github.com-server-v2
    Hostname ssh.github.com
    Port 443
    IdentityFile=~/.ssh/biznuvo-server-v2-id_ed25519
" >> ~$SUDO_USER/.ssh/config

chown -R $SUDO_USER: ~$SUDO_USER/.ssh

printf "\n#### FINISHED CONFIG : Github SSH Keys\n\n"
