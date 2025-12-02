# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **Build/Export Workflow**: Export builds are now triggered by lightweight tag pushes
  - Tag format: `v*` (e.g., `v1.0.0`, `v1.2.3`)
  - To create and push a lightweight tag: `git tag v1.2.3 && git push origin v1.2.3`
  - Manual trigger still available via GitHub Actions UI (workflow_dispatch)
  - No longer runs automatically on push to main branch

### How to Trigger Export Builds
1. Create a lightweight tag: `git tag v1.2.3` (replace with your version)
2. Push the tag to GitHub: `git push origin v1.2.3`
3. The export workflow will automatically run for the tagged commit
4. Alternatively, trigger manually from GitHub Actions UI using the "Run workflow" button
