# guardrails-preflights-demo

A small **brownfield** .NET repo used to demonstrate **Guardrails two-scope preflights**.

## What's here

- **`TextTools`** — an existing .NET 8 class library (the brownfield base). It ships two
  string helpers on `TextExtensions`: `Reverse` and `WordCount`, with an xUnit test
  project (`TextTools.Tests`) whose tests are **green today**.
- **`docs/plans/add-slugify.md`** — the feature plan. It describes adding a `Slugify`
  helper that is built on top of a new `Normalizer` helper. This markdown is the input
  that gets run through **`/plan-breakdown`** to generate a Guardrails task DAG, then
  executed by the **`guardrails`** harness.

## The two-scope preflights concept this demo shows

The `add-slugify` plan is shaped so the breakdown naturally produces preflights at two
scopes:

- **Plan-level Full Flight Checks** — run once before the plan's tasks:
  - a **positive baseline** asserting the existing `Reverse` / `WordCount` tests are green
    before any work starts ("never build on red"), and
  - a **negative baseline** asserting the feature isn't already present (`Slugify` /
    `Normalizer` don't exist yet), so a later green result is real work, not a no-op.
- **Task-level, just-in-time dependency-delivery preflight** — the feature splits into a
  producer → consumer pair: **(A)** add `Normalizer` + tests, then **(B)** implement
  `Slugify` on top of `Normalizer` + tests. Task **B** carries a JIT preflight that waits
  on **A** actually being delivered — B consumes `Normalizer.Normalize` and cannot compile
  or pass until A exists.

## Build and test

```sh
dotnet build TextTools.sln
dotnet test TextTools.sln
```
