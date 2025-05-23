#!/bin/bash

# Uses JAVA_VERSION and LOGFILE exported from cron-build.sh

log() {
    printf "%s : %s\n" "$(date +%Y/%m/%d-%H:%M:%S)" "${1}" >> ${LOGFILE}
}

output() {
    printf "%s\n" "${1}"
}

# ----

case "${JAVA_VERSION}" in
8)      export JAVA_HOME=/usr/lib/jvm/java-1.8.0 ;;
21)     export JAVA_HOME=/usr/lib/jvm/java-21 ;;
esac

log "Building ${BRANCH}"

output "==== GIT NEW COMMITS ====" \
&& git log @..@{u}
&& output "\n\n==== GIT PULL ====" \
&& git pull \
&& output "\n\n==== BUILD LOG ====" \
&& ./create-archives.sh pkg 2>&1
