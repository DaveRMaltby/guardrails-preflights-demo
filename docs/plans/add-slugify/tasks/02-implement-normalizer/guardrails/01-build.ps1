# catches: code that doesn't compile after the Normalizer implementation is filled in.
dotnet build src/TextTools --nologo -v q
if ($LASTEXITCODE -ne 0) {
    Write-Output "src/TextTools does not build after implementing Normalizer.Normalize"
    exit 1
}
exit 0
