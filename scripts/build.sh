#!/usr/bin/env bash

# src: https://gist.github.com/fbucek/f986da3cc3a9bbbd1573bdcb23fed2e1
set -e # error -> trap -> exit
function info() { echo -e "[\033[0;34m $@ \033[0m]"; } # blue: [ info message ]
function pass() { echo -e "[\033[0;32mPASS\033[0m] $@"; } # green: [PASS]
function fail() { FAIL="true"; echo -e "[\033[0;31mFAIL\033[0m] $@"; } # red: [FAIL]
trap 'LASTRES=$?; LAST=$BASH_COMMAND; if [[ LASTRES -ne 0 ]]; then fail "Command: \"$LAST\" exited with exit code: $LASTRES"; elif [ "$FAIL" == "true"  ]; then fail finished with error; else echo -e "[\033[0;32m Finished $@ \033[0m]";fi' EXIT
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" # this source dir

ROOT_DIR=$SRCDIR/..

cd ${ROOT_DIR}

# When CARGO_TARGET_DIR is not used -> setup to actuall target dir
if [ -z ${CARGO_TARGET_DIR} ]; then
    export CARGO_TARGET_DIR=${ROOT_DIR}/target;
fi

info "yarn install"
yarn install

info "Build tauri app"
# Have to remove binary in order to rebuild
rm -f ${CARGO_TARGET_DIR}/release/tauriapp
yarn tauri build

info "Run tauri app"
${CARGO_TARGET_DIR}/release/tauriapp
