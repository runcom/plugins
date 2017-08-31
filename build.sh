#!/usr/bin/env bash
set -e

ORG_PATH="github.com/containernetworking"
export REPO_PATH="${ORG_PATH}/plugins"

if [ ! -h gopath/src/${REPO_PATH} ]; then
	mkdir -p gopath/src/${ORG_PATH}
	ln -s ../../../.. gopath/src/${REPO_PATH} || exit 255
fi

export GO15VENDOREXPERIMENT=1
export GOPATH=${PWD}/gopath

mkdir -p "${PWD}/bin"

echo "Building plugins"
PLUGINS="plugins/main/bridge"
for d in $PLUGINS; do
	if [ -d "$d" ]; then
		plugin="$(basename "$d")"
		echo "  $plugin"
		# use go install so we don't duplicate work
		go build -o "${PWD}/bin/$plugin" -pkgdir "$GOPATH/pkg" "$@" "$REPO_PATH/$d"
	fi
done
