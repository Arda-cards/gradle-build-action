# changelog

[![Keep a Changelog](https://img.shields.io/badge/Keep%20a%20Changelog-1.0.0-informational)](https://keepachangelog.com/en/1.0.0/)
[![Semantic Versioning](https://img.shields.io/badge/Sematic%20Versioning-2.0.0-informational)](https://semver.org/spec/v2.0.0.html)
![clq validated](https://img.shields.io/badge/clq-validated-success)

Keep the newest entry at top, format date according to ISO 8601: `YYYY-MM-DD`.

Categories, defined in [changemap.json](.github/clq/changemap.json):

- *major* release trigger:
  - `Changed` for changes in existing functionality.
  - `Removed` for now removed features.
- *minor* release trigger:
  - `Added` for new features.
  - `Deprecated` for soon-to-be removed features.
- *bugfix* release trigger:
  - `Fixed` for any bugfixes.
  - `Security` in case of vulnerabilities.

## [1.2.0] - 2025-01-19

### Added

- Export the name and version of the chart as `chart_name`, `chart_version` if this action published it.
- Registries are now passed to the action as input

#### Fixed

- Fix build badge to refer to the new build filename

## [1.1.0] - 2025-01-09

### Added

- publish single helm chart from `build/helm/charts/` if on the main branch
- publish single docker image from `build/jib-image.tar` if on the main branch

### Fixed

- remove explicit call to helmPackage, it is part of the build sequence

## [1.0.0] - 2025-01-08

### Added

- build kotlin, docker, helm
