#!/bin/sh
set -eu

SOURCE="https://github.com/ashwin-pc/pi-web/archive/refs/heads/main.tar.gz"

echo "Installing Pi Web from ${SOURCE}..."

if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm is required to install Pi Web." >&2
    exit 1
fi

PACKAGE_ROOT="$(npm root --global)/@ashwin-pc/pi-web"
GLOBAL_BIN="$(npm prefix --global)/bin"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "${TMP_DIR}"
}
trap cleanup EXIT INT TERM

# Fetch the complete GitHub source archive through npm. Installing the URL
# directly would ignore Pi Web's lockfile and re-resolve transitive ranges.
ARCHIVE="$(cd "${TMP_DIR}" && npm pack --silent "${SOURCE}")"
mkdir -p "${TMP_DIR}/source"
tar -xzf "${TMP_DIR}/${ARCHIVE}" --strip-components=1 -C "${TMP_DIR}/source"

if [ ! -f "${TMP_DIR}/source/package-lock.json" ]; then
    echo "Error: Pi Web source archive does not contain package-lock.json." >&2
    exit 1
fi

rm -rf "${PACKAGE_ROOT}"
mkdir -p "$(dirname "${PACKAGE_ROOT}")"
cp -a "${TMP_DIR}/source" "${PACKAGE_ROOT}"

# Use the repository lockfile so GitHub-main installations are reproducible and
# do not depend on partially published transitive dependency sets.
npm ci --prefix "${PACKAGE_ROOT}" --include=dev
npm run build --prefix "${PACKAGE_ROOT}"
npm prune --prefix "${PACKAGE_ROOT}" --omit=dev

if [ ! -f "${PACKAGE_ROOT}/dist/index.html" ]; then
    echo "Error: Pi Web frontend build output was not created." >&2
    exit 1
fi

mkdir -p "${GLOBAL_BIN}"
ln -sf "${PACKAGE_ROOT}/bin/pi-web.js" "${GLOBAL_BIN}/pi-web"

if ! command -v pi-web >/dev/null 2>&1; then
    echo "Error: Pi Web was installed, but the 'pi-web' command is not on PATH." >&2
    exit 1
fi

echo "Pi Web installed successfully."
