#!/bin/bash
set -e

source dev-container-features-test-lib

check "pi-web is available" command -v pi-web
check "Pi Web package is installed globally" npm list --global --depth=0 @ashwin-pc/pi-web
check "Pi Web frontend is built" bash -c 'test -f "$(npm root --global)/@ashwin-pc/pi-web/dist/index.html"'
check "Pi Web is serving port 8787" bash -c 'for _ in {1..30}; do if node -e "fetch(\"http://127.0.0.1:8787/\").then(response => process.exit(response.ok ? 0 : 1)).catch(() => process.exit(1))"; then exit 0; fi; sleep 1; done; cat /tmp/dev-server.log >&2; exit 1'

reportResults
