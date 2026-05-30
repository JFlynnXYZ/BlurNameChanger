@echo off
:: Run Set-DriverName.ps1 from the same directory as this batch file.
:: -ExecutionPolicy Bypass skips the PowerShell script execution policy
:: without permanently changing system settings or prompting the user.
:: %~dp0 resolves to the directory this batch file lives in, so both files
:: can be placed anywhere and it will still work.
powershell.exe -ExecutionPolicy Bypass -File "%~dp0\Scripts\Set-DriverName.ps1"
