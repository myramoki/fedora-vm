printf "\n#### BEGIN CONFIG : Gradle\n\n"

DEFAULT_GRADLE_VERSION=8.8

read -p "?? Version of Gradle to install [$DEFAULT_GRADLE_VERSION] " respGradleVersion

if [[ -z $respGradleVersion ]]; then
	respGradleVersion=$DEFAULT_GRADLE_VERSION
fi

printf ".. fetch gradle\n"

curl -sL -o /tmp/gradle.zip https://services.gradle.org/distributions/gradle-$respGradleVersion-bin.zip
unzip /tmp/gradle.zip -d /opt

cd /opt

ln -s gradle-$respGradleVersion gradle

printf ".. setup environment\n"

mkdir -p /etc/environment.d

printf 'GRADLE_HOME=/opt/gradle\nPATH=$PATH:/opt/gradle/bin' > /etc/environment.d/102-gradle.conf

sed -i 's#/snap/bin#/snap/bin:/opt/gradle/bin#' /etc/sudoers

touch /tmp/doreboot

printf "\n#### FINISHED CONFIG : Gradle\n\n"
