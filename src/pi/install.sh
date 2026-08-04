#!/bin/sh
set -eu

VERSION="${VERSION:-latest}"
PACKAGE="@earendil-works/pi-coding-agent@${VERSION}"

echo "Installing Pi coding agent (${PACKAGE})..."

if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm is required to install Pi." >&2
    exit 1
fi

npm install --global --ignore-scripts "${PACKAGE}"

if ! command -v pi >/dev/null 2>&1; then
    echo "Error: Pi was installed, but the 'pi' command is not on PATH." >&2
    exit 1
fi

pi --version
