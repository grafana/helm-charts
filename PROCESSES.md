# Processes

This document outlines the processes and procedures for common tasks in this charts repository.

## Contribution ladder

### Chart maintainer

Chart maintainers are defined in the chart itself.
To add or remove maintainers, update the chart’s `Chart.yaml`.

The pull request that updates the maintainers list should also update the [CODEOWNERS](./.github/CODEOWNERS) file so the new maintainer can be requested for review and (where applicable) approve pull requests.

At least one existing chart maintainer must approve the PR. In addition, one repository admin must approve it.
After the PR is merged, an admin is responsible for granting the new maintainer write permissions to this repository.

Each maintainer is defined in the chart’s `Chart.yaml` under the `maintainers` section, using the following format:

```yaml
maintainers:
- name:   # A freely chosen display name. Required.
  email:  # A contact email address. Optional.
  url:    # The URL of the GitHub profile, using the format https://github.com/<username>. Required.
```

### Community admins (including repo admins)

Chart admins are responsible for managing the repository (for example: housekeeping and adding new chart maintainers).
They are also the point of contact for existing chart maintainers.
While chart admins can also serve as chart maintainers, they should still respect the chart maintainers for each chart.

Helm chart admins may not have enough permissions to invite new GitHub users as [outside collaborators](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-outside-collaborators/adding-outside-collaborators-to-repositories-in-your-organization) to the `grafana-community/helm-charts` repository.  
For help, ask in the [Grafana Slack channel `#helm-charts`](https://app.slack.com/client/T05675Y01/C0A2MNYDXV4).

Becoming an admin requires a majority vote from all existing admins.  
The process is tracked through GitHub issues in the [grafana-community/helm-charts](https://github.com/grafana-community/helm-charts/) repository.

See [this example](https://github.com/prometheus-community/helm-charts/issues/5137).

### Overall ownership (Grafana Labs)

Grafana Labs oversees the ecosystem and the GitHub organization and has additional capabilities:

* Provides strategic direction
* Acts as an escalation point for major issues or decisions

## Review process

A chart maintainer should review each PR.
If everything is fine (for example, it passes the [Technical Requirements](https://github.com/grafana-community/helm-charts/blob/main/CONTRIBUTING.md#technical-requirements)), the PR should be [approved](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/approving-a-pull-request-with-required-reviews).

The person who approves the PR should also merge it.
If the reviewer wants someone else to take a look, they should note that in a comment so it’s transparent.

Since a chart maintainer cannot approve their own PRs, every chart should have at least two maintainers.
If a chart does not have two maintainers, or if none of the other maintainers reviews a PR within two weeks, the maintainer who opened the PR may request a review from a repository admin.

## GitHub settings

Not everyone can see which settings are configured for this repository, so they are documented here.
The settings described below should only be changed after a PR documenting the change has been approved.

### Merge settings

Only squash merge is allowed in this repository:

> Allow squash merging
> Combine all commits from the head branch into a single commit in the base branch.

"Allow merge commits" and "Allow rebase merging" are disabled to keep the history simple and clean.

### Repository access

Repository access and permissions are managed via GitHub teams.

| GitHub Team | Repository Access |
| ----------- | ---- |
| Chart Maintainers | Write |
| Chart Admins | Admin |

It also makes sense to have more than one admin so changes from one admin can be reviewed by another.
At the moment, there are two admins.
