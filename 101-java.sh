printf "\n#### BEGIN CONFIG : Java\n\n"

read -t 5 -p "?? Version of Java to install 8, 11, 17, 21 [$DEFAULT_JAVA_VERSION] " respJavaVersion

if [[ -z $respJavaVersion ]]; then
    respJavaVersion=$DEFAULT_JAVA_VERSION
fi

case $respJavaVersion in
"8")  downloadVersion="java-1.8.0-openjdk-devel" ;;
"11") downloadVersion="java-11-openjdk-devel" ;;
"17") downloadVersion="java-17-openjdk-devel" ;;
"21") downloadVersion="java-21-openjdk-devel" ;;
"l")  downloadVersion="java-latest-openjdk-devel" ;;
*) printf "ERR: bad version\n" && exit ;;
esac

dnf -y -q install $downloadVersion

JAVA_HOME=$(realpath $(which java) | sed -r 's#/(jre|bin)/.*##')
export JAVA_HOME

printf "export JAVA_HOME=%s\n" $JAVA_HOME > /etc/profile.d/java.sh

touch /tmp/doreboot

printf "\n#### FINISHED CONFIG : Java\n\n"
