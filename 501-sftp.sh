printf "\n#### BEGIN CONFIG : SFTP\n\n"

printf "Adding biznuvo sftp user\n"

useradd -m -U -s /sbin/nologin biznuvo


printf "Adding biznuvo group to ${SUDO_USER}\n"

usermod -a -G biznuvo $SUDO_USER


printf "Creating downloads directory\n"

mkdir -p /var/sftp/biznuvo/downloads
chmod -R 755 /var/sftp
chown biznuvo: /var/sftp/biznuvo/downloads
chmod g+w /var/sftp/biznuvo/downloads


printf "Updating sshd with more restrictions for build server\n"

sed -i '/#PasswordAuthentication yes/a PasswordAuthentication no' /etc/ssh/sshd_config

echo "
Match User biznuvo
    ForceCommand internal-sftp -R
    ChrootDirectory /var/sftp/%u
    PermitTunnel no
    AllowAgentForwarding no
    AllowTcpForwarding no
    X11Forwarding no
" >> /etc/ssh/sshd_config

systemctl restart sshd

printf "\n#### END CONFIG : SFTP\n\n"
