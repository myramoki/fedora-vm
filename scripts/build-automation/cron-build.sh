#!/bin/bash

_githash() {
    git rev-parse --short HEAD
}

BRANCH=${1}
JAVA=${2:-8}

LOCKFILE="${HOME}/.locks/${NAME}.lock"
DESTDIR=/var/sftp/biznuvo/downloads

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p ${HOME}/repos
cd ${HOME}/repos

if [ ! -d "${BRANCH}" ]; then
    git clone git@github.com:BizNuvoSuperApp/biznuvo-server-v2.git --quiet --branch ${BRANCH} --single-branch ${BRANCH} 2>&1 >/dev/null
    newbuild=true
fi

if [ ! -d "${BRANCH}" ]; then
    printf "Invalid build branch %s\n" "${BRANCH}"
    exit 64
fi

cd ${BRANCH}

LOGFILE=$(mktemp cblog.XXXXXXXX)
LOCK_CONFLICT=250
NO_BUILD=100

if [ "${newbuild}" == true ]; then
    flock -E ${LOCK_CONFLICT} -n $LOCKFILE ${SCRIPT_DIR}/build.sh ${JAVA} > ${LOGFILE}
else
    flock -E ${LOCK_CONFLICT} -n $LOCKFILE ${SCRIPT_DIR}/build-if-changed.sh ${JAVA} > ${LOGFILE}
fi

case ${?} in
${LOCK_CONFLICT}|${NO_BUILD})
    exit
    ;;

0)
    BUILD_BRANCH=$(echo ${BRANCH} | tr '/' '-')
    BUILD_VERSION=$(_githash)
    LATEST_BUILD_PKG=$(find build -name 'biznuvo-install-*' -printf "%T@ %p\n" | sort -nr | head -1 | cut -d\  -f2)
    BUILD_DATE=$(basename ${LATEST_BUILD_PKG} | sed -e 's/biznuvo-install-//' -e 's/.tgz//')
    BUILD_LOCATION="biznuvo-${BUILD_BRANCH}-${BUILD_DATE}-${BUILD_VERSION}.tgz"

    mv ${LATEST_BUILD_PKG} ${DESTDIR}/${BUILD_LOCATION}

    (
        echo "\
            Subject: Build ${BRANCH} :: SUCCESS

            BUILD SUCCESS

            Branch: ${BRANCH}
            Commit: ${BUILD_VERSION}

            Archive: sftp://something/downloads/${BUILD_LOCATION}

        " | sed 's/^[[:space:]]*//'

        if [ "${newbuild}" != true ]; then
            sed -n '/==== BUILD LOG ====/q;p' ${LOGFILE}
        fi

        # cat ${LOGFILE}
    ) | msmtp buildnotify

    ;;

*)
    BUILD_VERSION=$(_githash)

    (
        echo "\
            Subject: Build ${BRANCH} :: FAILURE

            BUILD FAILURE

            Branch: ${BRANCH}
            Commit: ${BUILD_VERSION}

        " | sed 's/^[[:space:]]*//'

        cat ${LOGFILE}
    ) | msmtp buildnotify

    ;;
esac
