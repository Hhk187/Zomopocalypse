# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Option A**: A new relaxed gameplay mode with reduced zombie threat
  - Zombie spawn delay increased from 3.0 to 10.0 seconds
  - Maximum concurrent zombies reduced from 15 to 5
  - AI detection radius reduced from 15.0 to 8.0 units
  - AI chase speed reduced to 70% of normal
  - Zombie damage reduced to 75% and health to 80%
  - Configuration available in `res://scripts/option_a_config.gd`
  - Global toggle available in `Singleton/global.gd` (OPTION_A_ENABLED constant)

### Changed
- **Build/Export Workflow**: Export builds are now triggered by lightweight tag pushes
  - Tag format: `v*` (e.g., `v1.0.0`, `v1.2.3`)
  - To create and push a lightweight tag: `git tag v1.2.3 && git push origin v1.2.3`
  - Manual trigger still available via GitHub Actions UI (workflow_dispatch)
  - No longer runs automatically on push to main branch

### How to Use Option A
1. Option A is enabled by default via the `OPTION_A_ENABLED` constant in `Singleton/global.gd`
2. To disable Option A, set `OPTION_A_ENABLED = false` in `Singleton/global.gd`
3. Advanced users can modify specific settings in `scripts/option_a_config.gd`

### How to Trigger Export Builds
1. Create a lightweight tag: `git tag v1.2.3` (replace with your version)
2. Push the tag to GitHub: `git push origin v1.2.3`
3. The export workflow will automatically run for the tagged commit
4. Alternatively, trigger manually from GitHub Actions UI using the "Run workflow" button
