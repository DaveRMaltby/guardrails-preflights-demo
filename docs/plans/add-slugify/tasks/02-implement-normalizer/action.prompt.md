## Harness contract (do not remove)
- Read input state from the JSON file at the GUARDRAILS_STATE_IN path provided in
  the appended sections; write ONLY new/changed keys as a JSON object to
  GUARDRAILS_STATE_OUT.
- Write everything you publish under your task's FOLDER NAME as the single top-level
  key — the name of the directory this task.json lives in (here
  `02-implement-normalizer`), NOT the stableId. The harness REJECTS a fragment
  keyed by anything else (every attempt), so:
  `{ "02-implement-normalizer": { "someKey": "someValue" } }`.
- If a previous-attempt feedback section is appended, this is a RETRY: fix those
  specific failures; do not start over.
- If you cannot proceed without a human decision, write
  {"needsHuman": "<question>"} to the state-out path and stop.

## Task
Implement `Normalizer.Normalize(string s)` in `src/TextTools/Normalizer.cs` by filling real
logic into the stub (replace the `throw new NotImplementedException();`) so the tests in
`tests/TextTools.Tests/NormalizerTests.cs` pass. `Normalize` must:
- lowercase the input,
- strip diacritics / accents (decompose to `FormD`, drop `NonSpacingMark` code points, recompose),
- collapse internal runs of whitespace to a single space and trim the ends.

Make the `FullyQualifiedName~NormalizerTests` tests pass WITHOUT modifying the tests — editing
`tests/TextTools.Tests/NormalizerTests.cs` is OUTSIDE this task's writeScope and fails the
harness's git-diff check. If the authored tests are genuinely wrong or incompatible, write
`{"needsHuman": "<why>"}` to the state-out path rather than changing them. Publish nothing to
state.
