# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2025-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Builds the images and runs the round-trip test with podman-compose. The
# variable STP tracks whether the script started the Podman VM and should
# stop it on exit. Exit code 125 from podman machine start means the VM is
# already running or is still starting up. The script closes the redo
# jobserver descriptors 3 and 4 for podman machine start, so the VM daemon
# does not inherit them and stall redo. Command output streams to the
# console through the shellbase loggers, while the script itself prints only
# OK to stdout, which redo captures as the target.
#
# Shellcheck cannot follow the sourced file or see variables it reads:
#  shellcheck disable=SC1091,SC2034
redo-ifchange \
	./client/client \
	./client/Containerfile \
	./server/server \
	./server/Containerfile \
	./*.yml
readonly \
	BASE_APP_VERSION=0.9.20261026 \
	BASE_MIN_VERSION=0.9.20260707
. base.sh
STP=true
cmd_run sh -c 'podman machine start 3>&- 4>&-' || {
	[ $? = 125 ] || die
	log Podman VM is already running.
	STP=false
}
mkdir -p ./dat
cmd_run podman-compose --file podman-compose-test.yml up --build
[ "$STP" = false ] || cmd_run podman machine stop
printf OK
