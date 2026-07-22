#!/usr/bin/env bash

info "Installing Smart DNS Panel"

set -Eeuo pipefail

main() {

    require_root

    check_dependencies

    main_menu

}

main "$@"