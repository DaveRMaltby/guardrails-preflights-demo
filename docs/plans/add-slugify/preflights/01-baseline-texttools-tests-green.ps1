# catches: a BROWNFIELD plan building on a RED base - the EXISTING Reverse/WordCount tests in
#          tests/TextTools.Tests are already failing on the STARTING code. Asserting them green
#          BEFORE the DAG runs means a later work task's tests-pass failure is attributable to
#          THAT task, not to pre-existing breakage, and the new Normalizer/Slugify tests' red is
#          unambiguous (red-because-missing, not red-because-already-broken) (#181). Re-emits the
#          failure DETAIL at the END so a red baseline's WHY reaches the halt feedback tail (#179,
#          dotnet.md §21/§4.2). Scoped via --filter to the PRE-EXISTING tests
#          (FullyQualifiedName~TextExtensionsTests) - it MUST NOT run the about-to-be-authored
#          NormalizerTests/SlugifyTests, and MUST NOT be a whole-project `dotnet test` (that hits
#          the #165/#176 compile-coupling trap once the new tests reference not-yet-built types).
$out = dotnet test tests/TextTools.Tests --filter "FullyQualifiedName~TextExtensionsTests" --nologo 2>&1
$out | ForEach-Object { Write-Output $_ }
if ($LASTEXITCODE -ne 0) {
    $detail = $out |
        Select-String -Pattern '\[FAIL\]|Error Message:|Assert\.|Exception|Stack Trace:|Expected:|Actual:' |
        ForEach-Object { $_.Line } |
        Select-Object -First 40
    Write-Output ""
    Write-Output "=== Failure details (re-emitted so they land in the harness feedback tail) ==="
    if ($detail) { $detail | ForEach-Object { Write-Output $_ } }
    else { Write-Output "(no assertion/exception lines matched - inspect the full log above)" }
    Write-Output "the existing Reverse/WordCount tests in tests/TextTools.Tests are already failing on the starting code - fix the pre-existing breakage before this plan builds on it (#181)"
    exit 1
}
exit 0
