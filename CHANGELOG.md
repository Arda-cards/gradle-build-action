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

## [3.0.1] - 2025-03-10

### Fixed

- script would not publish the helm chart because it built the wrong relative path.

## [3.0.0] - 2025-03-04

### Changed

- A build can build, test and publish, or skip the publication step;  
  use the new `kind` argument for this. A version is required to publish.
- The build requires name and PAT of a user with read access to packages in order to get dependencies

### Removed

- do not use the `buildImage` target, it is up to gradle to decide what a `build` does.

### Added

- support for GitHGub debug mode: The action turns on `-xv` when the workflow runs in debug mode.

### Fixed

- CHANGELOG.md had a 4-level header in 1.2.0; it must be 3-level

## [2.0.0] - 2025-01-19

### Changed

- Registries are now passed to the action as input: the two required inputs `docker_registry` and `helm_registry`.

## 1.2.0 - 2025-01-19  [YANKED]

### Added

- Export the name and version of the chart as `chart_name`, `chart_version` if this action published it.

### Fixed

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
