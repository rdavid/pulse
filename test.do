# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2025-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Builds the images and runs the round-trip test with podman-compose.
# Starts the podman VM when needed and stops it afterwards.
redo-ifchange \
	./client/client \
	./client/Containerfile \
	./server/server \
	./server/Containerfile \
	./*.yml

# Variable appears unused:
#  shellcheck disable=SC2034
readonly \
	BASE_APP_VERSION=0.9.20260711 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase.\n'
	exit 1
}
set -- "$@" --quiet

# File not following:
#  shellcheck disable=SC1090
. "$BSH"
cmd_exists podman podman-compose || die
STOP_VM=YES
out="$(podman machine start 2>&1)" || {
	[ $? = 125 ] || die "$out"
	printf >&2 'VM already running or starting.\n'
	STOP_VM=NO
}
mkdir -p ./dat
out="$(podman-compose --file podman-compose-test.yml up --build 2>&1)" ||
	die "$out"

# A && B || C is not if-then-else:
#  shellcheck disable=SC2015
[ "$STOP_VM" = YES ] && podman machine stop || :
