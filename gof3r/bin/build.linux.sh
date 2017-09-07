#!/usr/bin/env bash

#set -e
#set -x

mkdir -p build

rm -f gof3r
rm -f build/gof3r

GOOS=linux GOARCH=amd64  go build -a -ldflags "-s -w"

mv gof3r build/gof3r
