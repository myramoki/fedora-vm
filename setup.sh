GITDIR="https://raw.githubusercontent.com/myramoki/fedora-vm/java24"
export GITDIR

SUDO_USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
export SUDO_USER_HOME

DEFAULT_JAVA_VERSION=17
DEFAULT_GRADLE_VERSION=8.13
DEFAULT_TOMCAT_VERSION=10

export DEFAULT_JAVA_VERSION
export DEFAULT_GRADLE_VERSION
export DEFAULT_TOMCAT_VERSION

echo "
##
## Choose which setup you want to run:
##
##   s - Starter setup
##   j - Java & Gradle
##   b - Build setup
##   t - Tomcat
##   z - Biznuvo setup
##   a - All
##
"

read -p "?? Select setup type: [sbtz] " respType

_basic() {
	printf "%s\n" $GITDIR/001-software.sh \
		$GITDIR/002-network.sh \
		$GITDIR/003-cifs.sh \
		$GITDIR/090-user.sh \
		$GITDIR/099-misc.sh
}

_java() {
	printf "%s\n" $GITDIR/101-java.sh \
		$GITDIR/102-gradle.sh
}

_builder() {
	printf "%s\n" $GITDIR/201-github-ssh.sh
}

_tomcat() {
	printf "%s\n" $GITDIR/301-tomcat.sh
}

_biznuvo() {
	printf "%s\n" $GITDIR/401-tomcat-ssl.sh \
		$GITDIR/402-prepare-biznuvo.sh
}

if [ -n "$respType" ]; then
	case $respType in
	s)
		echo "# Processing Starter setup"
		sh -c "$(curl $(_basic))"
		;;
	
	j)
		echo "# Processing Java & Gradle"
		sh -c "$(curl $(_basic) $(_java))"
		;;

	J)
		echo "# Processing Java & Gradle [only]"
		sh -c "$(curl $(_java))"
		;;

	b)
		echo "# Processing Build setup"
		sh -c "$(curl $(_basic) $(_java) $(_builder))"
		;;

	B)
		echo "# Processing Build setup [only]"
		sh -c "$(curl $(_builder))"
		;;

	t)
		echo "# Processing Tomcat"
		sh -c "$(curl $(_basic) $(_java) $(_tomcat))"
		;;

	T)
		echo "# Processing Tomcat [only]"
		sh -c "$(curl $(_tomcat))"
		;;

	z)
		echo "# Processing Biznuvo setup"
		sh -c "$(curl $(_basic) $(_java) $(_tomcat) $(_biznuvo))"
		;;

	Z)
		echo "# Processing Biznuvo setup [only]"
		sh -c "$(curl $(_biznuvo))"
		;;

	a)
		echo "# Processing Biznuvo setup"
		sh -c "$(curl $(_basic) $(_java) $(_builder) $(_tomcat) $(_biznuvo))"
		;;
	esac
fi

if [ -e /tmp/dofinal ]; then
	sh -c "$(cat /tmp/dofinal)"
fi

if [ -e /tmp/doreboot ]; then
    read -t 5 -p "Press ENTER before reboot"
	reboot
fi
