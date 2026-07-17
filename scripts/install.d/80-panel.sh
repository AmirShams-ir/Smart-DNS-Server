#!/usr/bin/env bash

info "Installing Smart DNS Panel"

set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${BASE_DIR}/lib/ui.sh"
source "${BASE_DIR}/lib/core.sh"
source "${BASE_DIR}/lib/stats.sh"
source "${BASE_DIR}/lib/capture.sh"
source "${BASE_DIR}/lib/parser.sh"
source "${BASE_DIR}/lib/block.sh"
source "${BASE_DIR}/lib/upstream.sh"

main() {

    require_root

    check_dependencies

    main_menu

}

main "$@"