#!/bin/bash
set -e

source dev-container-features-test-lib

check "pinned Pi version is installed" npm list --global --depth=0 @earendil-works/pi-coding-agent@0.82.1

reportResults
