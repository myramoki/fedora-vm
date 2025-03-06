printf "\n#### BEGIN CONFIG : Github SSH Keys\n\n"

echo "[core]
    autocrlf = false
" > ~bn/.gitconfig
chown bn: ~bn/.gitconfig

printf "#- fetch ssh keys\n"

sshkeystempfile=$(mktemp tmp.dl.sshkeys.XXXXXXXXXX)
curl -sL -o $sshkeystempfile https://raw.githubusercontent.com/myramoki/fedora-vm/main/biznuvo-server-keys.tar.xz.gpg
gpg -d $sshkeystempfile | tar -J -tvf - -C ~bn/.ssh/

printf "#- configure ssh config\n"

mkdir -p ~bn/.ssh

printf "
Host github.com-server-v2
    Hostname ssh.github.com
    Port 443
    IdentityFile=~/.ssh/biznuvo-server-v2-id_ed25519
" >> ~bn/.ssh/config

chown -R bn: ~bn/.ssh

printf "\n#### FINISHED CONFIG : Github SSH Keys\n\n"
