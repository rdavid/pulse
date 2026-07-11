# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2025-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Lints the project with whichever linters are installed, skipping the
# missing ones. Command output streams to the console through the shellbase
# loggers, while the script itself prints only OK to stdout, which redo
# captures as the target. Dash and mksh check syntax one file per
# invocation: a POSIX shell reads only its first operand as the script and
# hands any further operands to it as positional parameters, so files after
# the first would be silently skipped rather than checked.
#
# Variable appears unused and file not following:
#  shellcheck disable=SC2034,SC1090
redo-ifchange \
	./.github/*.yml \
	./.github/workflows/*.yml \
	./*.do \
	./client/client \
	./client/Containerfile \
	./server/server \
	./server/Containerfile \
	./*.yml \
	./README.adoc
readonly \
	BASE_APP_VERSION=0.9.20260711 \
	BASE_MIN_VERSION=0.9.20260630 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase.\n'
	exit 1
}
. "$BSH"
cmd_runif actionlint
for f in ./*.do ./client/client ./server/server; do
	cmd_runif dash -n "$f"
	cmd_runif mksh -n "$f"
done
cmd_runif hadolint \
	./client/Containerfile \
	./server/Containerfile
cmd_runif reuse lint
cmd_runif shellcheck \
	./*.do \
	./client/client \
	./server/server
cmd_runif shfmt -d \
	./*.do \
	./client/client \
	./server/server
cmd_runif typos
cmd_runif yamllint \
	./.github/*.yml \
	./.github/workflows/*.yml \
	./*.yml
cmd_runif zizmor --offline ./.github/
printf OK
