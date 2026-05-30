@echo off

:: Re-launch as Administrator if not already elevated
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Run the PowerShell script with execution policy bypass (no security prompts)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0\Scripts\Add-BlurFirewallRules.ps1"

echo.
pause
