$RootDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Starting backend..." -ForegroundColor Cyan

$Backend = Start-Process `
    -FilePath "powershell" `
    -ArgumentList "-NoExit", "-Command", `
        "Set-Location '$RootDir\backend'; .\.venv\Scripts\Activate.ps1; python -m uvicorn app.main:app --reload" `
    -PassThru

Write-Host "Starting frontend..." -ForegroundColor Green

$Frontend = Start-Process `
    -FilePath "powershell" `
    -ArgumentList "-NoExit", "-Command", `
        "Set-Location '$RootDir\frontend'; npm run dev" `
    -PassThru

try {
    Wait-Process -Id $Backend.Id, $Frontend.Id
}
finally {
    Write-Host "Stopping services..." -ForegroundColor Yellow

    Stop-Process -Id $Backend.Id -Force -ErrorAction SilentlyContinue
    Stop-Process -Id $Frontend.Id -Force -ErrorAction SilentlyContinue
}
