#!/bin/bash

log() {
	printf "%s: %s\n" "$(date --utc +%FT%TZ)" "${1}"
}

JAVA=${1}
UPSTREAM=${2:-'@{u}'}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

log "Fetching remote repository..."

git fetch

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
	log "No changes detected in git"
	exit 100
elif [ $LOCAL = $BASE ]; then
	BUILD_VERSION=$(git rev-parse HEAD)
	log "Changes detected, building new version: ${BUILD_VERSION}"
	${SCRIPT_DIR}/build.sh ${JAVA}
elif [ $REMOTE = $BASE ]; then
	log "Local changes detched, stashing"
	git stash
	${SCRIPT_DIR}/build.sh ${JAVA}
else
	log "Git is diverged, this is unexpected"
	exit 1
fi
