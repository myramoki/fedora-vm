printf "\n#### BEGIN CONFIG : Java\n\n"

dnf install -y -q java-21-openjdk-devel

printf "export JAVA_HOME=%s\n" $(realpath $(which java) | sed 's#/bin/.*##') > /etc/profile.d/java.sh

touch /tmp/doreboot

printf "\n#### FINISHED CONFIG : Java\n\n"
