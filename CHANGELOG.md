# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Version Management**: Added `config/version` field to `project.godot` for centralized version control
  - Version is automatically extracted during export builds
  - Build artifacts now include version number in their names (e.g., `web-build-v1.0.0`)

### Changed
- **Build/Export Workflow**: Export builds are now triggered by lightweight tag pushes
  - Tag format: `v*` (e.g., `v1.0.0`, `v1.2.3`)
  - To create and push a lightweight tag: `git tag v1.2.3 && git push origin v1.2.3`
  - Manual trigger still available via GitHub Actions UI (workflow_dispatch)
  - No longer runs automatically on push to main branch
  - Version is read from `project.godot` and used in artifact names

### How to Update Version
1. Edit `project.godot` and update the `config/version` field under `[application]`
2. Commit the change: `git commit -am "chore: bump version to X.Y.Z"`
3. Create a tag: `git tag vX.Y.Z`
4. Push both: `git push && git push origin vX.Y.Z`

### How to Trigger Export Builds
1. Create a lightweight tag: `git tag v1.2.3` (replace with your version)
2. Push the tag to GitHub: `git push origin v1.2.3`
3. The export workflow will automatically run for the tagged commit
4. Alternatively, trigger manually from GitHub Actions UI using the "Run workflow" button
