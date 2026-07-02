# catches: an implementation whose output deviates from the Normalize spec (case, diacritics,
#          whitespace). Re-emits the assertion/exception lines at the END so they reach the harness
#          retry-feedback tail (the last ~60 lines of stdout) - default `dotnet test` prints them
#          mid-run and ends with only `[FAIL] <name>` + a count, so the tail would otherwise show
#          WHAT failed, not WHY (#179, dotnet.md §4.2).
$out = dotnet test tests/TextTools.Tests --filter "FullyQualifiedName~NormalizerTests" --nologo 2>&1
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
    Write-Output "Normalizer tests failing - Normalize not implemented to spec (see failure details above)"
    exit 1
}
exit 0
