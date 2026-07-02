# catches: a Slugify that PASSES its tests but RE-INLINES the lowercase/accent/whitespace logic
#          instead of CONSUMING Normalizer.Normalize - leaving the Normalizer helper dead and
#          violating the plan's producer->consumer design. Slugify's OUTPUT is identical either way,
#          so the tests-pass guardrail cannot see this; only a structural check that Slugify actually
#          CALLS Normalizer.Normalize catches it (cross-module consumer discipline, catalogue
#          "structural vs keyword" + dotnet.md §2/§15 method-call anchoring). Matches the CALL
#          construct `Normalizer.Normalize(` (not a bare `Normalizer` token that a using/comment
#          satisfies), strips comments first, and is scoped to the ONE file this task owns.
$file = 'src/TextTools/TextExtensions.cs'
$raw = Get-Content -Raw -Path $file
$code = [regex]::Replace($raw, '/\*[\s\S]*?\*/', ' ')
$code = [regex]::Replace($code, '//[^\r\n]*', ' ')
if ($code -notmatch 'Normalizer\s*\.\s*Normalize\s*\(') {
    Write-Output "$file does not call Normalizer.Normalize(...) - Slugify must CONSUME the Normalizer helper, not re-inline the normalization logic (the plan's producer->consumer design)"
    exit 1
}
exit 0
