## Harness contract (do not remove)
- Read input state from the JSON file at the GUARDRAILS_STATE_IN path provided in
  the appended sections; write ONLY new/changed keys as a JSON object to
  GUARDRAILS_STATE_OUT.
- Write everything you publish under your task's FOLDER NAME as the single top-level
  key — the name of the directory this task.json lives in (here
  `01-author-normalizer-tests`), NOT the stableId. The harness REJECTS a fragment
  keyed by anything else (every attempt), so:
  `{ "01-author-normalizer-tests": { "someKey": "someValue" } }`.
- If a previous-attempt feedback section is appended, this is a RETRY: fix those
  specific failures; do not start over.
- If you cannot proceed without a human decision, write
  {"needsHuman": "<question>"} to the state-out path and stop.

## Task
Author xUnit unit tests in `tests/TextTools.Tests/NormalizerTests.cs` that encode the
`Normalizer.Normalize(string s)` contract BEFORE it is implemented, plus the **minimal
stub** the tests compile against in `src/TextTools/Normalizer.cs`.

**Scope boundary (harness-enforced):** Write only to
`tests/TextTools.Tests/NormalizerTests.cs` and `src/TextTools/Normalizer.cs` (the stub).
After this task completes, the harness runs a `git diff` check and rejects any edit outside
these paths — including changes to other production files (`TextExtensions.cs`), neighbouring
test files, or the `.csproj`. An out-of-scope edit fails the task immediately and consumes a
retry. If you hit a compile error caused by a missing symbol in another file, do NOT edit that
file — write `{"needsHuman": "<what is missing>"}` to the state-out path and stop.

The stub is a real `Normalizer` class in namespace `TextTools` with a public static method
`public static string Normalize(string s)` whose body is `throw new NotImplementedException();`
— just enough for the test project to COMPILE. Mirror the existing test conventions in
`tests/TextTools.Tests/TextExtensionsTests.cs` (xUnit `[Fact]`/`[Theory]` + `[InlineData]`,
`Assert.Equal`). The tests must encode the behavior described in the plan:
- lowercases the input (`"HELLO"` → `"hello"`);
- strips diacritics / accents (`"Héllo"` → `"hello"`, `"Café"` → `"cafe"`, `"über"` → `"uber"`);
- collapses internal runs of whitespace to a single space AND trims the ends
  (`"  a   b  "` → `"a b"`).

The tests MUST **compile** (against the stub) and **FAIL** (the stub throws) — failing is
intentional, NOT compiling is a mistake to fix. Do NOT implement the real Normalize logic in
this task. Publish nothing to state.
