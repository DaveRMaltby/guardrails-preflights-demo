# catches: tautological tests - tests that PASS against the NotImplementedException Slugify stub
#          encode nothing about the slug behavior. Because guardrail 01 already proved the build is
#          GREEN, a non-zero exit HERE unambiguously means the tests RAN and FAILED against the
#          throwing stub = TDD red (#155, dotnet.md §4.1). A zero exit means the behavior is already
#          present (or the tests assert nothing) - either way the tests are tautological.
# INVERSE check: a NON-zero exit is SUCCESS, so it does NOT re-emit failure detail (#179).
dotnet test tests/TextTools.Tests --filter "FullyQualifiedName~SlugifyTests" --nologo
if ($LASTEXITCODE -eq 0) {
    Write-Output "the Slugify tests PASS against the NotImplementedException stub - they are tautological (no real behavior is asserted)"
    exit 1
}
exit 0
