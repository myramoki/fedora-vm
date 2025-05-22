dnf install -y -q msmtp

cd $SUDO_USER_HOME
curl $GITDIR/scripts/build-automation/.msmtprc | sed 's#aliases #aliases '${SUDO_USER_HOME}'/' > .msmtprc

printf "buildnotification: DEST1,DEST2\n" > .msmtprc_aliases
chown -R $SUDO_USER: .msmtprc .msmtprc_aliases
chmod 600 .msmtprc .msmtprc_aliases

mkdir $SUDO_USER_HOME/automation
cd $SUDO_USER_HOME/automation

curl -O "$GITDIR/scripts/build-automation/{build-if-changed.sh,build.sh,cron-build.sh}"
chown -R $SUDO_USER: $SUDO_USER_HOME/automation
chmod u+x $SUDO_USER_HOME/automation/*.sh

mkdir $SUDO_USER_HOME/.locks $SUDO_USER_HOME/repos
chown $SUDO_USER: $SUDO_USER_HOME/.locks $SUDO_USER_HOME/repos
