#!/bin/sh
set -eu

SOURCE="https://github.com/ashwin-pc/pi-web/archive/refs/heads/main.tar.gz"

echo "Installing Pi Web from ${SOURCE}..."

if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm is required to install Pi Web." >&2
    exit 1
fi

npm install --global "${SOURCE}"

PACKAGE_ROOT="$(npm root --global)/@ashwin-pc/pi-web"
if [ ! -f "${PACKAGE_ROOT}/package.json" ]; then
    echo "Error: Pi Web package directory was not found after installation." >&2
    exit 1
fi

# GitHub's source archive does not contain the compiled frontend. Install the
# development dependencies long enough to build it, then remove them.
npm install --prefix "${PACKAGE_ROOT}" --include=dev
npm run build --prefix "${PACKAGE_ROOT}"
npm prune --prefix "${PACKAGE_ROOT}" --omit=dev

if [ ! -f "${PACKAGE_ROOT}/dist/index.html" ]; then
    echo "Error: Pi Web frontend build output was not created." >&2
    exit 1
fi

if ! command -v pi-web >/dev/null 2>&1; then
    echo "Error: Pi Web was installed, but the 'pi-web' command is not on PATH." >&2
    exit 1
fi

echo "Pi Web installed successfully."
