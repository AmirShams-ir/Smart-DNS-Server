
## [Unreleased] - Rearm & Reliability Fixes

- Fixed Automatic Rearm interval mismatch between the control panel and systemd.
- Added a systemd drop-in for the configured recurring Rearm interval.
- Added a dedicated boot timer for the initial Rearm without resetting the recurring interval.
- Synchronized Enable/Disable state with `AUTO_REARM`.
- Made the generated `rearm.service` use the actual project path.
- Added a lock to prevent concurrent Rearm executions.
- Fixed the broken installation panel module and uninstall timer handling.
- Wired cache/security/resolver settings to `defaults.conf`.
- Fixed CRLF line endings in shell/config files, including `lib/dns-monitor.sh`.
- Hardened `/etc/resolv.conf` handling.
# Changelog

## 1.0.0-beta1

### Added

- Initial project structure
- Installer
- Configuration system
- Unbound integration
- Benchmark engine (planned)
- Race engine (planned)
- Block engine (planned)
