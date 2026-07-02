# catches: the Slugify/Normalizer work regressing anything elsewhere in the solution, OR a project
#          that builds alone but breaks the whole solution. This is the terminal Full-Flight END gate:
#          a full solution build + the WHOLE test suite (Reverse, WordCount, Normalizer, Slugify all
#          green) on the merged plan-branch HEAD. It is LOCAL (no `scope` key) BY DESIGN (#165): a full
#          build / full suite is a TERMINAL POSTCONDITION, not a union-safe invariant - at an
#          intermediate TDD union the merged bytes hold test files referencing types whose
#          implementation task has not run yet, so a full build/suite would FALSE-RED there and roll a
#          correct wave back. It runs ONLY here, once, after every task has merged. Re-emits the
#          failing assertion/exception lines at the END so they reach the harness retry-feedback tail
#          (#179, dotnet.md §4.2), not just `[FAIL] <name>`.
dotnet build TextTools.sln -c Release --nologo
if ($LASTEXITCODE -ne 0) {
    Write-Output "solution build failed on the merged HEAD - a project builds alone but breaks the solution"
    exit 1
}
$out = dotnet test TextTools.sln --nologo 2>&1
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
    Write-Output "full test suite has failures on the merged HEAD after the Slugify/Normalizer work (see failure details above)"
    exit 1
}
exit 0
