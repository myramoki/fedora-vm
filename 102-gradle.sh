printf "\n#### BEGIN CONFIG : Gradle\n\n"

read -t 5 -p "?? Version of Gradle to install [$DEFAULT_GRADLE_VERSION] " respGradleVersion

if [[ -z $respGradleVersion ]]; then
	respGradleVersion=$DEFAULT_GRADLE_VERSION
fi

printf ".. fetch gradle\n"

gradletempzip=$(mktemp /tmp/tmp.dl.gradle.XXXXXXXXXX)
curl -sL -o $gradletempzip https://services.gradle.org/distributions/gradle-$respGradleVersion-bin.zip
unzip $gradletempzip -d /opt

cd /opt

ln -s gradle-$respGradleVersion gradle

printf ".. setup environment\n"

printf 'GRADLE_HOME=/opt/gradle\nPATH=$PATH:/opt/gradle/bin\n' > /etc/profile.d/gradle.sh

sed -i 's#/snap/bin#/snap/bin:/opt/gradle/bin#' /etc/sudoers

touch /tmp/doreboot

printf "\n#### FINISHED CONFIG : Gradle\n\n"
