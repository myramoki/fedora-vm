#!/bin/bash

JAVA=${1}

case "${JAVA}" in
8)      export JAVA_HOME=/usr/lib/jvm/java-1.8.0 ;;
21)     export JAVA_HOME=/usr/lib/jvm/java-21 ;;
esac

printf "\n==== GIT PULL LOG ====\n" \
&& git pull --log \
&& printf "\n\n==== BUILD LOG ====\n" \
&& ./create-archives.sh pkg 2>&1