useradd -m -U -s /sbin/nologin biznuvo

usermod -a -G biznuvo bn

mkdir -p /var/sftp/biznuvo/downloads
chmod -R 755 /var/sftp
chown biznuvo: /var/sftp/biznuvo/downloads
chmod g+w /var/sftp/biznuvo/downloads

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
