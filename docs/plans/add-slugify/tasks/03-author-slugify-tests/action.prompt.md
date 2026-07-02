## Harness contract (do not remove)
- Read input state from the JSON file at the GUARDRAILS_STATE_IN path provided in
  the appended sections; write ONLY new/changed keys as a JSON object to
  GUARDRAILS_STATE_OUT.
- Write everything you publish under your task's FOLDER NAME as the single top-level
  key — the name of the directory this task.json lives in (here
  `03-author-slugify-tests`), NOT the stableId. The harness REJECTS a fragment
  keyed by anything else (every attempt), so:
  `{ "03-author-slugify-tests": { "someKey": "someValue" } }`.
- If a previous-attempt feedback section is appended, this is a RETRY: fix those
  specific failures; do not start over.
- If you cannot proceed without a human decision, write
  {"needsHuman": "<question>"} to the state-out path and stop.

## Task
Author xUnit unit tests in `tests/TextTools.Tests/SlugifyTests.cs` that encode the
`TextExtensions.Slugify(string s)` contract BEFORE it is implemented, plus the **minimal
stub** the tests compile against: add a `public static string Slugify(string s)` method to the
EXISTING `TextExtensions` class in `src/TextTools/TextExtensions.cs` whose body is
`throw new NotImplementedException();`.

**Scope boundary (harness-enforced):** Write only to
`tests/TextTools.Tests/SlugifyTests.cs` and `src/TextTools/TextExtensions.cs` (adding the Slugify
stub). After this task completes, the harness runs a `git diff` check and rejects any edit outside
these paths — including changes to `Normalizer.cs`, neighbouring test files, or the `.csproj`. Do
NOT modify the existing `Reverse`/`WordCount` methods. An out-of-scope edit fails the task
immediately and consumes a retry. If you hit a compile error caused by a missing symbol in another
file (for example `Normalizer`), do NOT edit that file — write
`{"needsHuman": "<what is missing>"}` to the state-out path and stop.

The tests must encode the slug behavior from the plan (mirror the existing xUnit conventions in
`tests/TextTools.Tests/TextExtensionsTests.cs`):
- `Slugify("Héllo, World!")` == `"hello-world"`,
- `Slugify("  Multiple   Spaces  ")` == `"multiple-spaces"`,
- `Slugify("Café del Mar")` == `"cafe-del-mar"`,
- a leading/trailing punctuation case that proves stray hyphens are trimmed
  (e.g. `Slugify("!!!Wow!!!")` == `"wow"`).

Do NOT reference `Normalizer` in the tests or the stub — the tests call `TextExtensions.Slugify`
only; `Normalizer` is an implementation detail the NEXT task wires in. The tests MUST **compile**
(against the stub) and **FAIL** (the stub throws) — failing is intentional, NOT compiling is a
mistake to fix. Do NOT implement the real Slugify logic in this task. Publish nothing to state.
