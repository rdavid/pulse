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
	INTERVAL=5 \
	SERVER_HOST="${SERVER_HOST:-server}" \
	SERVER_PORT="${SERVER_PORT:-8080}"
. base.sh

# Sends data to the server every INTERVAL seconds.
loop() {
	local cnt=0 lne msg
	while :; do
		lne="$(prettyuptime)"
		msg="$(printf %s\\n "$lne" | nc 2>&1 "$SERVER_HOST" "$SERVER_PORT")" ||
			loge E "$msg"
		cnt=$((cnt + 1))
		log "Sent $cnt times, wait for ${INTERVAL}s."
		sleep "$INTERVAL"
	done
}

# Validates and sends data in a loop.
main() {
	validate_cmd nc
	log "$(whoami)" is sending data to "$SERVER_HOST":"$SERVER_PORT".
	loop
}

# Starting point.
main "$@"
