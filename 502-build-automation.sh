dnf -y -q msmtp

cd $SUDO_USER_HOME
curl -O $GITDIR/scripts/build-automation/.msmtprc
printf "buildnotification: \n" > .msmtprc_aliases
chown -R bn: .msmtprc .msmtprc_aliases

mkdir $SUDO_USER_HOME/automation
cd $SUDO_USER_HOME/automation

curl -O $GITDIR/scripts/build-automation/build-if-changed.sh -O $GITDIR/scripts/build-automation/build.sh -O $GITDIR/scripts/build-automation/cron-build.sh
chown -R bn: $SUDO_USER_HOME/automation
chmod u+x $SUDO_USER_HOME/automation/*.sh
