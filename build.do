# shellcheck shell=sh
# vi:et lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2025 David Rabkin
# SPDX-License-Identifier: 0BSD
redo-ifchange \
	./client/client \
	./client/Containerfile \
	./server/server \
	./server/Containerfile \
	./podman-compose.yml

# shellcheck disable=SC2034 # Variable appears unused.
readonly \
	BASE_APP_VERSION=0.9.20250828 \
	BASE_MIN_VERSION=0.9.20240202 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 Install\ Shellbase.\\n
	exit 1
}
set -- "$@" --quiet

# shellcheck disable=SC1090 # File not following.
. "$BSH"
validate_cmd podman podman-compose
STOP_VM=YES
out="$(podman machine start 2>&1)" || {
	[ $? = 125 ] || die "$out"
	printf >&2 'VM already running or starting.\n'
	STOP_VM=NO
}
out="$(podman-compose build 2>&1)" || die "$out"

# shellcheck disable=SC2015 # A && B || C is not if-then-else.
[ "$STOP_VM" = YES ] && podman machine stop || :
