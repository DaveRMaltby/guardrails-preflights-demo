# catches: a test file that does not COMPILE - garbage, or a real syntax/type error. With the
#          minimal Normalizer stub in place the test project MUST build; a non-compiling "test"
#          exits `dotnet test` non-zero IDENTICALLY to a compiling-but-failing one, so without this
#          the TDD "red" signal is gameable by garbage (#155, dotnet.md §4.1).
dotnet build tests/TextTools.Tests --nologo -v q
if ($LASTEXITCODE -ne 0) {
    Write-Output "tests/TextTools.Tests does not build - NormalizerTests.cs or the Normalizer stub is not type-correct"
    exit 1
}
exit 0
