#!/bin/bash

_githash() {
    git rev-parse --short HEAD
}

_latestbuild() {
    find build -name "biznuvo-install"'*' -printf "%T@ %p\n" | sort -nr | head -1 | cut -d\  -f2
}

_gitlog_from() {
    sed -n '/==== BUILD LOG ====/q;p' ${1}
}

_buildlog_from() {
    sed -n '/==== BUILD LOG ====/,$p' ${1} | tail -n +2
}

NAME=${1}
BRANCH=${2}
JAVA=${3:-8}

LOCKFILE="${HOME}/.locks/${NAME}.lock"

cd ${HOME}/repos

if [ ! -d "${NAME}" ]; then
	git clone git@github.com:BizNuvoSuperApp/biznuvo-server-v2.git --branch $BRANCH --single-branch $NAME
	newbuild=true
fi

if [ ! -d "${NAME}" ]; then
	printf "Invalid build branch %s @ %s\n" "${NAME}" "${BRANCH}"
	exit 1
fi

cd ${NAME}
LOGFILE=$(mktemp)

if [ "${newbuild}" == true ]; then
	flock -n $LOCKFILE ${HOME}/automation/build.sh ${JAVA} > ${LOGFILE}
else
	flock -n $LOCKFILE ${HOME}/automation/build-if-changed.sh ${JAVA} > ${LOGFILE}
fi

if [ $? == 0 ]; then
    BUILD_VERSION=$(_githash)
    LATEST_BUILD=$(_latestbuild)

    mv ${LATEST_BUILD} /var/sftp/biznuvo/downloads/${NAME}-$(basename ${LATEST_BUILD} .tgz)-${BUILD_VERSION}.tgz

    printf "Subject: Build %s Success

Successfully built: %s
Commit Hash: %s

Git Log:

%s
" ${BRANCH} ${BRANCH} ${BUILD_VERSION} "$(_gitlog_from ${LOGFILE})"

else
    BUILD_VERSION=$(_githash)
    LATEST_BUILD=$(_latestbuild)

    printf "Subject: Build %s Failed

Failed build: %s
Commit Hash: %s

Git Log:

%s

----

Build Log:

%s
" ${BRANCH} ${BRANCH} ${BUILD_VERSION} "$(_gitlog_from ${LOGFILE})" "$(_buildlog_from ${LOGFILE})"

fi
