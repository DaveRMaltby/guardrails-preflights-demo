## Harness contract (do not remove)
- Read input state from the JSON file at the GUARDRAILS_STATE_IN path provided in
  the appended sections; write ONLY new/changed keys as a JSON object to
  GUARDRAILS_STATE_OUT.
- Write everything you publish under your task's FOLDER NAME as the single top-level
  key — the name of the directory this task.json lives in (here
  `04-implement-slugify`), NOT the stableId. The harness REJECTS a fragment
  keyed by anything else (every attempt), so:
  `{ "04-implement-slugify": { "someKey": "someValue" } }`.
- If a previous-attempt feedback section is appended, this is a RETRY: fix those
  specific failures; do not start over.
- If you cannot proceed without a human decision, write
  {"needsHuman": "<question>"} to the state-out path and stop.

## Task
Implement `TextExtensions.Slugify(string s)` in `src/TextTools/TextExtensions.cs` by filling real
logic into the stub (replace the `throw new NotImplementedException();`). Slugify MUST be built ON
TOP OF `Normalizer.Normalize` — call `Normalizer.Normalize(s)` to do the lowercase / accent-strip /
whitespace-collapse half of the job, then layer ONLY the slug-specific steps on its result:
- replace every run of non-alphanumeric characters with a single hyphen `-`,
- trim any leading or trailing hyphens.

Do NOT re-inline the lowercase / accent-stripping / whitespace logic that `Normalizer.Normalize`
already provides — the design requires Slugify to CONSUME the `Normalizer` helper, not duplicate it.

Make the `FullyQualifiedName~SlugifyTests` tests pass WITHOUT modifying the tests — editing
`tests/TextTools.Tests/SlugifyTests.cs` is OUTSIDE this task's writeScope and fails the harness's
git-diff check. Do NOT modify the existing `Reverse`/`WordCount` methods beyond leaving them intact.
If the authored tests are genuinely wrong or incompatible, write `{"needsHuman": "<why>"}` to the
state-out path rather than changing them. Publish nothing to state.
