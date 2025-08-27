#!/bin/sh
# vi:et lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2025 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# The script uses local variables which are not POSIX but supported by most
# shells. See:
#  https://stackoverflow.com/q/18597697
# shellcheck disable=SC3043 # Uses local variables.
# shellcheck disable=SC1091,SC2034 # File not following, variable unused.
readonly \
	BASE_APP_VERSION=0.9.20250828 \
	LISTEN_PORT="${LISTEN_PORT:-8080}"
. base.sh

# Loop
loop() {
	local cnt=0 lne
	while :; do
		nc -l -p "$LISTEN_PORT" | {
			IFS= read -r lne
			[ -n "$lne" ] && store "$lne"
		}
		cnt=$((cnt + 1))
		log Stored "$cnt" times.
		sleep 1
	done
}

# Validates and listens in a loop.
main() {
	validate_cmd nc
	log "$(whoami)" is listening on "$LISTEN_PORT".
	loop
}

# Keeps the first argument in DB.
store() {
	log DB: "$1"
}

# Starting point.
main "$@"
