#!/bin/bash
set -e

source dev-container-features-test-lib

settings_match() {
    node -e '
const fs = require("node:fs");
const settings = JSON.parse(fs.readFileSync("/home/vscode/.pi/agent/settings.json", "utf8"));
if (
    settings.defaultProvider !== "anthropic" ||
    settings.defaultThinkingLevel !== "high" ||
    settings.enableInstallTelemetry !== false ||
    settings.compaction?.reserveTokens !== 8192
) {
    process.exit(1);
}
'
}

settings_are_private_and_owned_by_remote_user() {
    [ "$(stat -c '%U:%G %a' /home/vscode/.pi/agent/settings.json)" = "vscode:vscode 600" ] &&
        [ "$(stat -c '%U:%G %a' /home/vscode/.pi/agent)" = "vscode:vscode 700" ]
}

check "Pi settings file is created" test -f /home/vscode/.pi/agent/settings.json
check "Pi settings contain the configured object" settings_match
check "Pi settings are private and owned by the remote user" settings_are_private_and_owned_by_remote_user

reportResults
