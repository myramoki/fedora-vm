GITDIR="https://raw.githubusercontent.com/myramoki/fedora-vm/main"
GITBASIC="
	$GITDIR/001-software.sh \
	$GITDIR/002-network.sh \
	$GITDIR/003-cifs.sh \
	$GITDIR/999-pause.sh \
"

echo "
##
## Choose which setup you want to run:
##
##   s - Basic starter setup [default]
##   b - Builder setup (Java, Gradle and SSH Keys)
##   t - Basic Tomcat setup with Java
##   z - Biznuvo setup
##
"

read -p "?? Select setup type: [sbtz] " respType

if [ -n "$respType" ]; then
	case $respType in
	b)
		echo "# Processing setup-builder"
		sh -c "$(curl $GITBASIC \
			$GITDIR/101-java.sh \
			$GITDIR/102-gradle.sh \
			$GITDIR/501-github-ssh.sh \
		)"
		;;
	
	B)
		echo "# Processing setup-builder"
		sh -c "$(curl \
			$GITDIR/101-java.sh \
			$GITDIR/102-gradle.sh \
			$GITDIR/501-github-ssh.sh \
		)"
		;;

	t)
		echo "# Processing setup-tomcat"
		sh -c "$(curl $GITBASIC \
			$GITDIR/101-java.sh \
			$GITDIR/102-gradle.sh \
        	$GITDIR/999-pause.sh \
			$GITDIR/201-tomcat.sh \
		)"
		;;

	T)
		echo "# Processing setup-tomcat"
		sh -c "$(curl \
			$GITDIR/101-java.sh \
			$GITDIR/102-gradle.sh \
        	$GITDIR/999-pause.sh \
			$GITDIR/201-tomcat.sh \
		)"
		;;

	z)
		echo "# Processing setup-biznuvo"
		sh -c "$(curl $GITBASIC \
			$GITDIR/101-java.sh \
			$GITDIR/102-gradle.sh \
        	$GITDIR/999-pause.sh \
			$GITDIR/201-tomcat.sh \
			$GITDIR/301-tomcat-ssl.sh \
        	$GITDIR/999-pause.sh \
			$GITDIR/701-prepare-biznuvo.sh \
		)"
		;;

	Z)
		echo "# Processing setup-biznuvo"
		sh -c "$(curl \
			$GITDIR/101-java.sh \
			$GITDIR/102-gradle.sh \
        	$GITDIR/999-pause.sh \
			$GITDIR/201-tomcat.sh \
			$GITDIR/301-tomcat-ssl.sh \
        	$GITDIR/999-pause.sh \
			$GITDIR/701-prepare-biznuvo.sh \
		)"
		;;

	*)
		echo "# Processing setup-basic"
		sh -c "$(curl $GITBASIC)"
		;;
	esac
fi

if [ -e /tmp/dofinal ]; then
	sh -c "$(cat /tmp/dofinal)"
fi

if [ -e /tmp/doreboot ]; then
    read -p "Press ENTER before reboot" resp
	reboot
fi
