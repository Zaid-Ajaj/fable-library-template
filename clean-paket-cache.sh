#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

PAKET_EXE=.paket/paket.exe
FAKE_EXE=packages/build/FAKE/tools/FAKE.exe

FSIARGS=""
FSIARGS2=""
OS=${OS:-"unknown"}
if [ "$OS" != "Windows_NT" ]
then
  # Can't use FSIARGS="--fsiargs -d:MONO" in zsh, so split it up
  # (Can't use arrays since dash can't handle them)
  FSIARGS="--fsiargs"
  FSIARGS2="-d:MONO"
fi

run() {
  if [ "$OS" != "Windows_NT" ]
  then
    echo "Running on linux/macs => using Mono"
    mono "$@"
  else
    "$@"
  fi
}

# remove paket.lock
[ -e paket.lock ] && rm paket.lock
[ -e ./paket-files/paket.restore.cached ] && rm ./paket-files/paket.restore.cached

rm -rf ./src/bin
rm -rf ./src/obj
rm -rf ./test/bin
rm -rf ./test/obj