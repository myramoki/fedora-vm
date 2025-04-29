GITDIR="https://raw.githubusercontent.com/myramoki/fedora-vm/main"
export GITDIR

SUDO_USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
export SUDO_USER_HOME

DEFAULT_JAVA_VERSION=21
DEFAULT_GRADLE_VERSION=8.14
DEFAULT_TOMCAT_VERSION=9

export DEFAULT_JAVA_VERSION
export DEFAULT_GRADLE_VERSION
export DEFAULT_TOMCAT_VERSION

echo "
##
## Choose which setup you want to run, use capital version to incremental install:
##
##   s - Starter setup
##   J - Java [only]
##   G - Gradle [only]
##   b - Build setup [starter, java, builder]
##   B - Build setup [builder only]
##   t - Tomcat [starter, java, tomcat]
##   T - Tomcat [tomcat only]
##   z - Biznuvo setup [starter, java, gradle, tomcat, biznuvo]
##   Z - Biznuvo setup [biznuvo only]
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
	printf "%s\n" $GITDIR/101-java.sh
}

_gradle() {
	printf "%s\n" $GITDIR/102-gradle.sh
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

	J)
		echo "# Processing Java [only]"
		sh -c "$(curl $(_java))"
		;;

	G)
		echo "# Processing Gradle [only]"
		sh -c "$(curl $(_gradle))"
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
		sh -c "$(curl $(_basic) $(_java) $(_gradle) $(_tomcat) $(_biznuvo))"
		;;

	Z)
		echo "# Processing Biznuvo setup [only]"
		sh -c "$(curl $(_biznuvo))"
		;;

	a)
		echo "# Processing Biznuvo setup"
		sh -c "$(curl $(_basic) $(_java) $(_gradle) $(_builder) $(_tomcat) $(_biznuvo))"
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
