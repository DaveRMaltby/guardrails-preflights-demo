# catches: task 04 (the Slugify CONSUMER) starting its attempt loop against a segment worktree in
#          which the PRODUCER's contribution - Normalizer.Normalize - has NOT actually landed. This
#          is the JIT dependency-delivery preflight (SKILL Step 4 four-folder / tasks/<id>/preflights):
#          it runs in THIS task's own segment worktree at taskBase, BEFORE the attempt loop, so the
#          agent never burns a turn building Slugify against possibly-absent producer bytes. Polarity
#          is POSITIVE-MONOTONE-SAFE (assert PRESENT, never "not yet present") - a task-level check
#          runs per-attempt against a segment that only GROWS, so a negative assertion would flip
#          false as soon as an unrelated file lands. Matches the STRUCTURAL declaration (a real static
#          Normalize method on a Normalizer type), not a bare token; strips comments first so an
#          XML-doc mention cannot false-PASS this presence check (dotnet.md §11).
$src = 'src/TextTools/Normalizer.cs'
if (-not (Test-Path $src)) {
    Write-Output "$src is not present in this task's inherited working tree - the Normalizer producer (task 02) has not been delivered into task 04's segment; the Slugify consumer cannot build against it yet"
    exit 1
}
$raw = Get-Content -Raw -Path $src
# Strip C# comments so a doc-comment mention of Normalize is not mistaken for the real declaration.
$code = [regex]::Replace($raw, '/\*[\s\S]*?\*/', ' ')
$code = [regex]::Replace($code, '//[^\r\n]*', ' ')
if ($code -notmatch '(?m)\bstatic\s+string\s+Normalize\s*\(') {
    Write-Output "$src does not declare a `static string Normalize(...)` method - the Normalizer.Normalize symbol the Slugify consumer depends on is not present in the inherited bytes (producer task 02 not delivered)"
    exit 1
}
exit 0
