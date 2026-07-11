# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2025-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Removes the container artifacts and the generated redo targets.
podman system prune --all --force && podman rmi --all --force
rm -f ./1 ./build ./clean ./lint ./test
