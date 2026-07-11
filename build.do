# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2025-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Builds the client and server images with podman-compose. Starts the
# podman VM when needed and stops it afterwards. Command output streams to
# the console through the shellbase loggers, while the script itself prints
# only OK to stdout, which redo captures as the target.
#
# Variable appears unused and file not following:
#  shellcheck disable=SC2034,SC1090
redo-ifchange \
	./client/client \
	./client/Containerfile \
	./server/server \
	./server/Containerfile \
	./*.yml
readonly \
	BASE_APP_VERSION=0.9.20260711 \
	BASE_MIN_VERSION=0.9.20260707 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase.\n'
	exit 1
}
. "$BSH"
STP=true
cmd_run podman machine start || {
	[ $? = 125 ] || die
	log VM already running or starting.
	STP=false
}
cmd_run podman-compose build
[ "$STP" = false ] || cmd_run podman machine stop
printf OK
