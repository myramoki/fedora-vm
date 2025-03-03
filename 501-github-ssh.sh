printf "\n#### BEGIN CONFIG : Github SSH Keys\n\n"

echo "[core]
    autocrlf = false
" > ~bn/.gitconfig
chown bn: ~bn/.gitconfig

printf "#- fetch ssh keys\n"

curl -sL -o /tmp/ssh-keys https://raw.githubusercontent.com/myramoki/ubuntu-vm/main/biznuvo-server-keys.tar.xz.gpg
gpg -d /tmp/ssh-keys | tar -J -tvf - -C ~bn/.ssh/

printf "#- configure ssh config\n"

echo "
Host github.com-server-v2
    Hostname ssh.github.com
    Port 443
    IdentityFile=~/.ssh/biznuvo-server-v2-id_ed25519
" > ~bn/.ssh/config

chown bn: ~bn/.ssh/*

printf "\n#### FINISHED CONFIG : Github SSH Keys\n\n"
