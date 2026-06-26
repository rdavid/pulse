# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2025-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
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

# Variable appears unused:
#  shellcheck disable=SC2034
readonly \
	BASE_APP_VERSION=0.9.20260627 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase.\n'
	exit 1
}
set -- "$@" --quiet

# File not following:
#  shellcheck disable=SC1090
. "$BSH"
cmd_exists actionlint && actionlint
cmd_exists hadolint &&
	hadolint \
		./client/Containerfile \
		./server/Containerfile
cmd_exists shellcheck &&
	shellcheck \
		./*.do \
		./client/client \
		./server/server
cmd_exists shfmt &&
	shfmt -d \
		./*.do \
		./client/client \
		./server/server
cmd_exists typos && typos
cmd_exists yamllint &&
	yamllint \
		./.github/*.yml \
		./.github/workflows/*.yml \
		./*.yml

# Handles the missing last tool gracefully without failing the script.
:
