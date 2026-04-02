# SAL Intelligence Hub — Streamlit watchdog: restarts `streamlit run app.py` if the process exits.
# Usage (from repo root):  powershell -ExecutionPolicy Bypass -File scripts/streamlit_watchdog.ps1
# Optional: $env:STREAMLIT_PORT = "8501"

$ErrorActionPreference = "Continue"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

$port = if ($env:STREAMLIT_PORT) { $env:STREAMLIT_PORT } else { "8501" }

while ($true) {
    Write-Host "[sal-watchdog] Starting Streamlit on port $port at $(Get-Date -Format o)"
    python -m streamlit run app.py --server.headless true --server.port $port
    $code = $LASTEXITCODE
    Write-Host "[sal-watchdog] Streamlit exited (code=$code). Restarting in 2s..."
    Start-Sleep -Seconds 2
}
