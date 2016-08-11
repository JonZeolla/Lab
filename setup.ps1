# =========================
# Author:          Jon Zeolla (JZeolla)
# Last update:     2016-08-10
# File Type:       PowerShell Script
# Version:         1.1
# Repository:      https://github.com/JonZeolla/lab
# Description:     This is a general purpose PowerShell script to set up my labs.
#
# Notes
# - This script is intentionally not executable to assist with autocompletion on linux.
# - Anything that has a placeholder value is tagged with TODO.
#
# =========================

## Set directories
$dirDesktop = "C:\Users\testing\Desktop"
$dirInstallers = "$dirDesktop\lab\.storage"
$dirLogs = "$dirDesktop\lab\logs"
$dirRepo = "$dirDesktop\lab"

## Set meta
$ver = "1.1"
$lastUpdate = "2016-08-10"
$startTimeResults = Get-Date
$githubTag = "ProximityAttacks"

## Talk to the user
Write-Host "==================================================================================================="
Write-Host "Setup up the $githubTag lab"
Write-Host "==================================================================================================="
Write-Host "Written by: JonZeolla"
Write-Host "Version: $ver"
Write-Host "Last updated: $lastUpdate"
Write-Host "==================================================================================================="
Write-Host "Start time: $startTimeResults"
Write-Host "===================================================================================================`n"

Invoke-Expression $dirRepo\configure.ps1

Write-Host "`n`nPress any key to continue . . ."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")

