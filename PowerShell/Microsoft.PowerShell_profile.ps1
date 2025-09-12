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

# Display a welcome message
Write-Host "Welcome back, nghiapm! Ready to code?" -ForegroundColor Green
