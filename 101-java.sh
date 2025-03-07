printf "\n#### BEGIN CONFIG : Java\n\n"

dnf install -y -q java-1.8.0-openjdk-headless

printf "export JAVA_HOME=%s\n" $(realpath $(which java) | sed 's#/jre/.*##') > /etc/profile.d/java.sh

touch /tmp/doreboot

printf "\n#### FINISHED CONFIG : Java\n\n"
