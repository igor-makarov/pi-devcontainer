#!/bin/sh
set -eu

VERSION="${VERSION:-latest}"
SETTINGS="${SETTINGS:-}"
PACKAGE="@earendil-works/pi-coding-agent@${VERSION}"

# The Dev Container CLI writes string options as double-quoted shell
# assignments without escaping embedded quotes. Read the original value from
# the Feature environment file so JSON quotes are preserved.
if [ -f "./devcontainer-features.env" ]; then
    RAW_SETTINGS="$(sed -n 's/^SETTINGS="\(.*\)"$/\1/p' ./devcontainer-features.env)"
    if [ -n "${RAW_SETTINGS}" ]; then
        SETTINGS="${RAW_SETTINGS}"
    fi
fi

echo "Installing Pi coding agent (${PACKAGE})..."

if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm is required to install Pi." >&2
    exit 1
fi

npm install --global --ignore-scripts "${PACKAGE}"

if [ -n "${SETTINGS}" ]; then
    TARGET_USER="${_REMOTE_USER:-${_CONTAINER_USER:-root}}"
    case "${TARGET_USER}" in
        ""|automatic|none)
            TARGET_USER="root"
            ;;
    esac

    if ! id "${TARGET_USER}" >/dev/null 2>&1; then
        echo "Error: Cannot configure Pi because remote user '${TARGET_USER}' does not exist." >&2
        exit 1
    fi

    TARGET_HOME="${_REMOTE_USER_HOME:-}"
    if [ -z "${TARGET_HOME}" ]; then
        TARGET_HOME="$(awk -F: -v user="${TARGET_USER}" '$1 == user { print $6; exit }' /etc/passwd)"
    fi
    if [ -z "${TARGET_HOME}" ]; then
        echo "Error: Cannot determine the home directory for '${TARGET_USER}'." >&2
        exit 1
    fi

    SETTINGS_DIR="${TARGET_HOME}/.pi/agent"
    SETTINGS_FILE="${SETTINGS_DIR}/settings.json"
    SETTINGS_TMP="$(mktemp)"

    if ! node -e '
const value = JSON.parse(process.argv[1]);
if (value === null || Array.isArray(value) || typeof value !== "object") {
    throw new Error("settings must be a JSON object");
}
process.stdout.write(`${JSON.stringify(value, null, 2)}\n`);
' "${SETTINGS}" > "${SETTINGS_TMP}"; then
        rm -f "${SETTINGS_TMP}"
        echo "Error: Pi settings must be a valid JSON object." >&2
        exit 1
    fi

    mkdir -p "${SETTINGS_DIR}"
    mv "${SETTINGS_TMP}" "${SETTINGS_FILE}"
    chmod 700 "${TARGET_HOME}/.pi" "${SETTINGS_DIR}"
    chmod 600 "${SETTINGS_FILE}"
    TARGET_UID="$(id -u "${TARGET_USER}")"
    TARGET_GID="$(id -g "${TARGET_USER}")"
    chown "${TARGET_UID}:${TARGET_GID}" "${TARGET_HOME}/.pi" "${SETTINGS_DIR}" "${SETTINGS_FILE}"

    echo "Pi settings written to ${SETTINGS_FILE}."
fi

if ! command -v pi >/dev/null 2>&1; then
    echo "Error: Pi was installed, but the 'pi' command is not on PATH." >&2
    exit 1
fi

pi --version
