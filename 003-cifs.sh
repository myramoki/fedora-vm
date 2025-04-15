# https://phoenixnap.com/kb/linux-mount-cifs

printf "\n#### BEGIN CONFIG : CIFS\n\n"

read -p "?? Add Windows share path [return for nothing] " respDest

if [[ -n $respDest ]]; then
    read -p "?? Enter username: " respUsername
    read -p "?? Enter password: " respPassword

    # already installed so this doesn't do anything, just here to ensure it is
    dnf -y -q install cifs-utils

    mkdir -p /mnt/shared

    printf ".. setup creds\n"

    mkdir -p /etc/cifs-creds
    chmod 700 /etc/cifs-creds

    printf "username=%s\npassword=%s\n" $respUsername $respPassword >> /etc/cifs-creds/shared

    chmod 600 /etc/cifs-creds/shared

    printf ".. setup fstab\n"

    printf "%s /mnt/shared cifs credentials=/etc/cifs-creds/shared,uid=%s,gid=%s 0 0\n" $respDest "$(id -u $SUDO_USER)" "$(id -g $SUDO_USER)" >> /etc/fstab

    systemctl daemon-reload

    touch /tmp/doreboot
fi

printf "\n#### FINISHED CONFIG : CIFS\n\n"
