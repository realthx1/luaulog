# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2025-10-27

### Changed
* Renamed Verbose log level to Trace, backwards compatability included. ([PR #3](https://github.com/realthx1/luaulog/pull/3))

### Fixed
* Fixed roblox-log-sink not outputting more than 1 argument. ([issue #2](https://github.com/realthx1/luaulog/issues/2))

## [0.2.1] - 2025-10-22
Finally getting back to developing this library.

### Changed
* Switched to pesde for package management.

### Fixed
* Replaced some types with old type solver friendly alternatives.

## [0.2.0] - 2025-08-14

### Added
* **Filters** - they can be used to filter what sinks, enrichers and even entire loggers are used.

### Changed
* Major project restructure.
* Optimized common enrichers (**30x speed increase**, pure logger takes 4us to run instead of 60us).

## [0.1.0] - 2025-08-17

### Added
Initial.