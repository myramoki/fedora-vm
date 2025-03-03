printf "\n#### BEGIN CONFIG : Java\n\n"

dnf install -y -q java-1.8.0-openjdk-headless

mkdir -p /etc/environment.d

printf "JAVA_HOME=%s\n" $(realpath $(which java) | sed 's#/jre/.*##') > /etc/environment.d/101-java.conf

touch /tmp/doreboot

printf "\n#### FINISHED CONFIG : Java\n\n"
