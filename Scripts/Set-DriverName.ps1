<#
.SYNOPSIS
    Sets the driver name used by Blur.

.DESCRIPTION
    Prompts the user to enter a driver name of up to 16 characters and writes
    it to a file called 'Driver' in the current directory. This file is read
    by the BlurNameChanger DLL hook at runtime to override the Windows username
    that Blur displays as the player's driver name.

    The file will be created if it does not exist, or overwritten if it does.

.NOTES
    Author:  BlurNameChanger
    Version: 1.0

.EXAMPLE
    .\Set-DriverName.ps1

    Prompts for a name and writes it to .\Driver.
#>

# Loop until the user provides a non-empty name within the 16-character limit
do {
    $Username = Read-Host "Enter driver name (max 16 characters)"

    if ($Username.Length -eq 0) {
        Write-Host "Name cannot be empty. Please try again." -ForegroundColor Yellow
    } elseif ($Username.Length -gt 16) {
        Write-Host "Name is too long ($($Username.Length) characters). Maximum is 16. Please try again." -ForegroundColor Yellow
    }
} while ($Username.Length -eq 0 -or $Username.Length -gt 16)

$DriverFilePath = Resolve-Path $(Join-Path $PSScriptRoot '..\Driver')

# Write the name to the Driver file as plain ASCII with no trailing newline.
# -NoNewline is important: ReadFile() in the DLL reads raw bytes, so a trailing
# newline would be included in the driver name shown in-game.
# -Encoding ascii matches the LPSTR (char*) type the DLL passes to GetUserNameA.
$Username | Out-File -FilePath $DriverFilePath -Encoding ascii -NoNewline

Write-Host "Driver name set to '$Username'. `nFile can be located at '$DriverFilePath'" -ForegroundColor Green
pause
