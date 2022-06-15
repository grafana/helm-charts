# Changelog

All notable changes to this library will be documented in this file.

Entries should be ordered as follows:

- [CHANGE]
- [FEATURE]
- [ENHANCEMENT]
- [BUGFIX]

Entries should include a reference to the pull request that introduced the change.

## 1.6.0

- [FEATURE] Added self-monitoring option, with dashboards and Grafana Agent Operator custom resources to allow Loki to scrape it's own logs.

## 1.5.0

-[CHANGE] Set `persistentVolumeClaimRetentionPolicy` for read pods to `Delete` for both `whenDeleted` and `whenScaled` since this data is easy to replace by re-fetching from object storage. This should make for easier roll-outs of the stateful sets.

## 1.3.0

- [BUGFIX] Fix the storage heper functions to use the right properties (snake vs camel case) #1420
- [ENHANCEMENT] Add this changelog to the chart #1420
