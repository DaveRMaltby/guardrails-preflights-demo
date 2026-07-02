# Add `Slugify` to TextTools

## Context

`TextTools` is an existing .NET 8 class library. Today it ships two string helpers on
the static `TextExtensions` class — `Reverse(string s)` and `WordCount(string s)` — both
covered by xUnit tests that are **green right now**. We are adding a third helper that
turns arbitrary text into a URL-friendly slug.

Neither `Slugify` nor its supporting `Normalizer` helper exist yet at the start of this
work.

## The feature

Add `TextExtensions.Slugify(string s)`. A slug is a lowercase, hyphen-separated,
ASCII-safe rendering of the input, suitable for use in a URL. Specifically it:

- lowercases the text,
- strips diacritics / accents (so `é` becomes `e`, `ü` becomes `u`),
- replaces every run of non-alphanumeric characters with a **single** hyphen,
- trims any leading or trailing hyphens.

Example: `Slugify("Héllo, World!")` returns `"hello-world"`.

## Design and dependency (this drives the task ordering)

`Slugify` is **built on top of a new helper**, `Normalizer.Normalize(string s)`, rather
than doing everything inline. `Normalizer` is a new class in the `TextTools` library that
handles the text-cleanup half of the job:

- lowercases the input,
- strips diacritics / accents,
- collapses internal runs of whitespace to a single space and trims the ends.

`Slugify` then consumes `Normalizer.Normalize` and only adds the slug-specific step of
mapping non-alphanumeric characters to hyphens and trimming stray hyphens.

That splits the work into a **producer → consumer pair**:

- **(A) Add the `Normalizer` class + its tests.** This is the producer. It introduces
  `Normalizer.Normalize` and proves it with unit tests (lowercasing, accent stripping,
  whitespace collapsing).
- **(B) Implement `Slugify` using `Normalizer` + its tests.** This is the consumer. It
  calls `Normalizer.Normalize` and layers on the hyphenation rules.

**Task (B) MUST NOT be implemented until task (A) has actually been delivered.** `Slugify`
in (B) *consumes* `Normalizer.Normalize`, so it literally cannot compile — and its tests
cannot pass — until the `Normalizer` class from (A) exists in the library. B depends on a
real artifact produced by A, not merely on A being "started".

## Starting state

- The existing `Reverse` and `WordCount` tests are **green today** — that is the baseline
  the work must not break.
- `Slugify` and `Normalizer` **do not exist yet** at the start. There are no tests for
  them until this plan adds them.

## Acceptance

- `Slugify("Héllo, World!") == "hello-world"`.
- A couple more slug cases hold, e.g. `Slugify("  Multiple   Spaces  ") == "multiple-spaces"`
  and `Slugify("Café del Mar") == "cafe-del-mar"`.
- `Normalizer.Normalize` lowercases, strips accents, and collapses whitespace (its own
  tests prove this).
- The existing `Reverse` / `WordCount` tests **stay green** — no regressions.
- The full solution builds and the whole test suite is green.

## Stack

- .NET 8, xUnit.
- Verification is `dotnet build` on the solution and `dotnet test` on the whole suite.
