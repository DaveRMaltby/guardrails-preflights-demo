# catches: a stale / dirty starting workspace where Slugify or Normalizer ALREADY EXISTS before the
#          plan runs - which would make the whole producer->consumer TDD story a no-op (the "red" of
#          the inserted author-tests tasks would be a false red, and the plan would "pass" without
#          building anything). This is the NEGATIVE / assert-absent baseline: it is the plan-level,
#          one-shot form of the tests-fail-on-current-code / tests-fail-on-stubs anti-tautology
#          archetype (not a new archetype - cross-referenced, not forked; SKILL Step 5 / catalogue
#          "Negative baseline = the existing TDD-red checks"). Matches the STRUCTURAL declaration (a
#          real method / class), not a bare token, and strips comments first so a mention in an XML-doc
#          comment cannot false-FAIL this check (comment-blind-scan mirror, dotnet.md §11).
$srcFiles = Get-ChildItem -Path 'src/TextTools' -Filter '*.cs' -Recurse -File |
    Where-Object { $_.FullName -notmatch '[\\/](bin|obj)[\\/]' }

$problems = @()
foreach ($f in $srcFiles) {
    $raw = Get-Content -Raw -Path $f.FullName
    # Strip C# comments so a doc-comment mention ("/// Slugify ...") is not mistaken for real code.
    $code = [regex]::Replace($raw, '/\*[\s\S]*?\*/', ' ')
    $code = [regex]::Replace($code, '//[^\r\n]*', ' ')
    if ($code -match '(?m)\bstring\s+Slugify\s*\(') {
        $problems += ("$($f.Name) already declares a Slugify method")
    }
    if ($code -match '(?m)\b(class|record|struct)\s+Normalizer\b') {
        $problems += ("$($f.Name) already declares a Normalizer type")
    }
}
if ($problems.Count -gt 0) {
    Write-Output "Slugify / Normalizer are supposed to be ABSENT at the start of this plan, but real declarations already exist:"
    $problems | ForEach-Object { Write-Output ("  - " + $_) }
    Write-Output "the starting workspace is not clean - remove the pre-existing Slugify/Normalizer (or re-clone) before running this plan; otherwise the producer->consumer TDD red is a false red"
    exit 1
}
exit 0
