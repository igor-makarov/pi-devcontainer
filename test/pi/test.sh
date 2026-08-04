#!/bin/bash
set -e

source dev-container-features-test-lib

check "pi is available" command -v pi
check "pi reports its version" pi --version
check "Pi npm package is installed globally" npm list --global --depth=0 @earendil-works/pi-coding-agent

reportResults
