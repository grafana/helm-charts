---
name: write-tests
description: Plan and write helm-unittest tests for a chart. Discovers component structure, maps test coverage gaps, and scopes work before writing anything.
user_invocable: true
---

# /write-tests [chart] [component]

## Argument handling

**If no arguments are provided**, ask the user which chart they want to work on, then proceed as if they provided just the chart name.

**If only `<chart>` is provided**, run the full discovery and coverage analysis below before asking any questions.

**If `<chart> <component>` is provided**, skip discovery and go straight to the [Scoping questions](#scoping-questions) section for that component.

---

## Discovery and coverage analysis (single-argument path)

Work through these steps silently — do not narrate each step. Produce a single structured report at the end.

### 1. Understand the chart structure

- Read `charts/<chart>/Chart.yaml` — note the chart type, version, and any subchart dependencies.
- Read the top level of `charts/<chart>/values.yaml` to understand the major configuration axes (e.g. a `deploymentMode` flag, top-level component enable flags).
- Glob `charts/<chart>/templates/**` to get the full template file list.
- Identify **component groups**: subdirectories under `templates/` are natural groups. If the chart has no subdirectories (flat `templates/`), treat the whole chart as a single component.

### 2. Map existing test coverage

- Glob `charts/<chart>/tests/**` to see what test files already exist.
- For each component group, count:
  - How many renderable templates exist (exclude `_*.tpl` helper/partial files)
  - How many have a corresponding test file in `charts/<chart>/tests/<component>/`

### 3. Assess complexity

Determine whether the chart is **simple** (flat templates, no deployment modes, <10 renderable templates) or **complex** (subdirectories, conditional deployment modes, or >10 renderable templates).

- For a **simple chart**: present a single coverage table and ask whether to proceed with the whole chart at once.
- For a **complex chart**: group templates into logical work units and present the breakdown table below.

### 4. Present the coverage report

Output a table of component groups with coverage status:

```
## <chart> — Test Coverage Analysis

| Component | Renderable templates | Test files | Coverage |
|---|---|---|---|
| core / root-level | N | N | None / Partial / Good |
| gateway | N | N | None |
| ingester | N | N | None |
...

### Notes
- <any important observations about deployment modes, required values, test complexity>

### Suggested starting point
<recommend the lowest-risk, highest-value component to start with and briefly explain why>

---
Which component would you like to tackle first?
```

Wait for the user to choose a component before proceeding.

---

## Scoping questions

Once a component is identified (either via argument or user selection), ask the following before writing anything:

1. **Scope within the component** — all templates in this component, or specific ones?
2. **Existing tests** — if partial tests already exist, should they be extended or are new test files being added alongside?
3. **Coverage depth** — happy-path only (default values render correctly), or full branch coverage (every `if`/`with`/`range` conditional)?
4. **Any known gotchas** — e.g. for loki: which `deploymentMode` values are in scope?

After the user answers, summarise the agreed scope in one short paragraph, then begin writing tests using the test-writer agent for each individual template, or proceed inline if the scope is narrow enough.

---

## Reference: test-writer conventions

When writing tests directly (not delegating), follow the conventions in the test-writer subagent:
- Test files mirror the template path: `charts/<chart>/tests/<component>/<template>.yaml` (convention: `<template>_test.yaml`, but any `.yaml` filename is valid — the repository uses `--file 'tests/**/*.yaml'`)
- Always set deployment-mode-style flags explicitly — never rely on defaults when a chart has conditional rendering modes
- Run `make helm-unittest HELM_UNITTEST_CHART=<chart>` after each file to validate before moving on
- Prefer `equal` and `contains` over `exists` — specific assertions catch regressions
