# catches: a union / merged HEAD that left git conflict markers in the produced files, produced an
#          empty source file, dropped the Slugify->Normalizer consumption, or duplicated a definition
#          across the AI-merge. This is the terminal folder's scope:"integration" invariant (the
#          re-homed GR2018 content teeth, GR2028) and it MUST be UNION-SAFE = CONDITIONAL (#125/#165):
#          gate on each contribution being PRESENT, THEN verify it - never REQUIRE presence, so it
#          passes trivially at an intermediate union where a producing task has not integrated yet.
# scope:"integration" -> re-runs at every non-FF union and on the terminal merged HEAD.
$ws = $env:GUARDRAILS_WORKSPACE
if ([string]::IsNullOrEmpty($ws)) { $ws = (Get-Location).Path }

# --- Produced files: conflict-marker-free + non-empty (gate-then-verify) ---
foreach ($rel in @('src/TextTools/Normalizer.cs', 'src/TextTools/TextExtensions.cs')) {
    $p = Join-Path $ws $rel
    if (-not (Test-Path $p)) { continue }   # not integrated at this union yet - fine
    $content = Get-Content -Raw -Path $p
    if ([string]::IsNullOrWhiteSpace($content)) {
        Write-Output "$rel is empty on the merged bytes"
        exit 1
    }
    if ($content -match '<<<<<<<' -or $content -match '=======' -or $content -match '>>>>>>>') {
        Write-Output "$rel contains git conflict markers - the union did not cleanly integrate"
        exit 1
    }
}

# --- Conditional contribution: IF Slugify has landed, it must CONSUME Normalizer.Normalize ---
$te = Join-Path $ws 'src/TextTools/TextExtensions.cs'
if (Test-Path $te) {
    $raw = Get-Content -Raw -Path $te
    $code = [regex]::Replace($raw, '/\*[\s\S]*?\*/', ' ')
    $code = [regex]::Replace($code, '//[^\r\n]*', ' ')
    if ($code -match '(?m)\bstring\s+Slugify\s*\(') {          # Slugify contribution landed
        if ($code -notmatch 'Normalizer\s*\.\s*Normalize\s*\(') {
            Write-Output "TextExtensions.cs declares Slugify but the merged bytes do not call Normalizer.Normalize - the producer->consumer wiring was dropped in the union"
            exit 1
        }
        # --- Duplicate-definition guard (#175): the AI-merge of two branches that each appended a
        #     Slugify definition to different regions keeps BOTH with no conflict marker (CS0101). ---
        if (([regex]::Matches($code, '(?m)\bstring\s+Slugify\s*\(')).Count -gt 1) {
            Write-Output "TextExtensions.cs declares Slugify more than once on the merged bytes - duplicate definition from the AI-merge (CS0101)"
            exit 1
        }
    }
}

# --- Duplicate-definition guard on the Normalizer type (#175) ---
$nz = Join-Path $ws 'src/TextTools/Normalizer.cs'
if (Test-Path $nz) {
    $raw = Get-Content -Raw -Path $nz
    $code = [regex]::Replace($raw, '/\*[\s\S]*?\*/', ' ')
    $code = [regex]::Replace($code, '//[^\r\n]*', ' ')
    if (([regex]::Matches($code, '(?m)\bclass\s+Normalizer\b')).Count -gt 1) {
        Write-Output "Normalizer.cs declares class Normalizer more than once on the merged bytes - duplicate definition from the AI-merge (CS0101)"
        exit 1
    }
}
exit 0
