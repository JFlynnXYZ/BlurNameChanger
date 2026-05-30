#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Adds Windows Firewall inbound and outbound rules for Blur.exe.

.DESCRIPTION
    Resolves Blur.exe relative to the script's own location (not the working
    directory) so it works correctly when launched elevated via UAC.
    Must be run as Administrator.

.EXAMPLE
    .\Add-BlurFirewallRules.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
$ExeFullPath   = Join-Path $PSScriptRoot '..\Blur.exe'
$RuleNameIn    = 'Blur - Inbound'
$RuleNameOut   = 'Blur - Outbound'
$RuleGroup     = 'Blur Game'
$RuleProtocol  = 'Any'   # Change to 'TCP' or 'UDP' if you want to restrict

# ---------------------------------------------------------------------------
# Verify executable exists
# ---------------------------------------------------------------------------
if (-not (Test-Path -Path $ExeFullPath -PathType Leaf)) {
    Write-Error $("Executable not found at '$ExeFullPath'. Ensure " + 
				  "BLUR\Blur.exe exists in the same folder as this script.")
    exit 1
}

Write-Host "Executable resolved to: $ExeFullPath" -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# Helper - create rule only if it doesn't already exist
# ---------------------------------------------------------------------------
function Add-FirewallRuleIfMissing {
    param(
        [string] $Name,
        [string] $Direction,   # 'Inbound' or 'Outbound'
        [string] $Program,
        [string] $Group,
        [string] $Protocol
    )

    $existing = Get-NetFirewallRule -DisplayName $Name -ErrorAction SilentlyContinue

    if ($existing) {
        Write-Host "  [SKIP] Rule already exists: '$Name'" -ForegroundColor Yellow
        return
    }

    New-NetFirewallRule `
        -DisplayName  $Name      `
        -Direction    $Direction `
        -Program      $Program   `
        -Action       Allow      `
        -Protocol     $Protocol  `
        -Group        $Group     `
        -Enabled      True       `
        -Profile      Any        | Out-Null

    Write-Host "  [OK]   Created $Direction rule: '$Name'" -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Create rules
# ---------------------------------------------------------------------------
Write-Host "`nConfiguring Windows Firewall rules..." -ForegroundColor Cyan

Add-FirewallRuleIfMissing `
    -Name      $RuleNameIn  `
    -Direction 'Inbound'    `
    -Program   $ExeFullPath `
    -Group     $RuleGroup   `
    -Protocol  $RuleProtocol

Add-FirewallRuleIfMissing `
    -Name      $RuleNameOut `
    -Direction 'Outbound'   `
    -Program   $ExeFullPath `
    -Group     $RuleGroup   `
    -Protocol  $RuleProtocol

Write-Host "`nDone. Firewall rules for Blur.exe are active.`n" -ForegroundColor Cyan