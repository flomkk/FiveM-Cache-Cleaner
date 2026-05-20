@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Erhöhe Rechte...
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/flomkk/FiveM-Cache-Cleaner/refs/heads/main/FiveM-Cache-Cleaner.ps1')"
echo.
pause