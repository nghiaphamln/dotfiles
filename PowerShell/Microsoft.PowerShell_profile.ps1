# Description: PowerShell profile script to customize the shell environment.
# Author: nghiapm

# Load Chocolatey profile if it exists
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Load Oh My Posh with a custom theme
oh-my-posh init pwsh --config "C:\Users\phamm\Documents\PowerShell\Theme\zash.omp.json" | Invoke-Expression

# Enable Terminal Icons for enhanced visual experience
Import-Module -Name Terminal-Icons

# Configure PSReadLine for command prediction and history
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Set custom aliases for convenience
Set-Alias -Name ll -Value Get-ChildItem

# Alias 'vi' to open Neovim
function vi { nvim . }

function fcd {
    param (
        [Parameter(Mandatory=$false)]
        [string]$Path
    )

    $directoryMap = @{
        "nexorion" = "D:\working\nexorion"
        "sendo" = "D:\working\sendo-farm"
        "tenefic" = "D:\working\tenefic-games"
    }

    if (-not $Path) {
        Write-Host "Available shortcuts:" -ForegroundColor Cyan
        $directoryMap.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host "  $($_.Key): $($_.Value)" -ForegroundColor Green
        }
        return
    }

    if ($directoryMap.ContainsKey($Path)) {
        Set-Location -Path $directoryMap[$Path]
        Write-Host "Moved to: $($directoryMap[$Path])" -ForegroundColor Green
    } else {
        Write-Host "Unknown shortcut: $Path" -ForegroundColor Red
        Write-Host "Available shortcuts:" -ForegroundColor Cyan
        $directoryMap.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host "  $($_.Key): $($_.Value)" -ForegroundColor Green
        }
    }
}

# Display a welcome message
Write-Host "Welcome back, nghiapm! Ready to code?" -ForegroundColor Green
