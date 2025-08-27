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
	BASE_APP_VERSION=0.9.20250827
. base.sh

# Cycle.
main() {
	local i=0
	while :; do
		log "$(whoami)" "$LISTEN_HOST":"$LISTEN_PORT" "$i".
		sleep 5
		i=$((i + 1))
	done
}

# Starting point.
main "$@"
