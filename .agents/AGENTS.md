# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Grafana Community Helm Charts** repository — a collection of Helm charts for Grafana ecosystem components. Charts are published to both a Helm repository (`grafana-community`) and as OCI artifacts on `ghcr.io`.

## Charts

All charts live under `charts/` with a subfolder for each chart.  The subfolder names must match the chart name as described in the Chart.yaml file `.name`.

Each chart follows standard Helm structure (`Chart.yaml`, `values.yaml`, `templates/`). Some charts will organize components into subdirectories (e.g., `templates/compactor/`, `templates/ingester/`).

## pre-commit testing

### helm-unittests

Pull Requests against this repository require that all charts which implement helm-unittests(https://github.com/helm-unittest/helm-unittest) must pass all of their unittests.  This can be done via a single command run from the repository root:

```bash
make helm-unittest
```

## Contributing Conventions

- **One chart per PR**: CI enforces that PRs only change a single chart.
- **PR title format**: Must start with `[chart-name] ` (e.g., `[grafana] Add new feature`).
- **Version bumps**: Every chart change (excluding files listed in `.helmignore`) requires a SemVer version bump in `Chart.yaml`. Major bumps for breaking changes.
- **DCO sign-off**: Commits must include `Signed-off-by` line (`git commit -s`).
- **Squash merge only**: The repository only allows squash merges.
- **CODEOWNERS/MAINTAINERS**: Auto-generated from `Chart.yaml` maintainer entries by `scripts/generate-codeowners.sh` and `scripts/generate-maintainers.sh`. Do not edit `.github/CODEOWNERS` or `MAINTAINERS.md` directly.
- **Minimum Kubernetes version**: Charts target `^1.25.0-0` (`kubeVersion` in `Chart.yaml`).

## Dependency Management

Renovate manages automated dependency updates. Charts with subchart dependencies (e.g., `tempo-distributed` depends on `minio`, `grafana-agent-operator`, `rollout-operator`) declare them in `Chart.yaml`. Dependency repositories used in CI/release:

```
bitnami, grafana, grafana-community, prometheus-community, minio
```
