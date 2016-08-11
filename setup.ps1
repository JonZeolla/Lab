# =========================
# Author:          Jon Zeolla (JZeolla)
# Last update:     2016-08-10
# File Type:       PowerShell Script
# Version:         1.0
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
$dirInstallers = "$dirDesktop\lab\.storage\"
$dirLogs = "$dirDesktop\lab\logs\"

## Set meta
$ver = "1.0"
$lastUpdate = "2016-08-10"
$startTime = Get-Date -format yyyy-MM-dd-HH.mm.ss
$startTimeResults = Get-Date
$Log = "$dirLogs\$startTime.txt"
$githubTag = "ProximityAttacks"

## Set up window size for better logging
# If you want to adjust this be sure that the buffersize for width is at a minimum the same size as the windowsize for width
$pshost = get-host
$pswindow = $pshost.ui.rawui

# Set buffer
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 100
$pswindow.buffersize = $newsize

# Set window
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 100
$pswindow.windowsize = $newsize

## Start logging
Start-Transcript -path $Log -append | Out-Null

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

Write-Host "`n`nPress any key to continue . . ."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")

# Stop logging
Stop-Transcript | Out-Null

# This fixes the transcript formatting without adding a `r`n to each
# line and making it look horrible in the terminal window,
# or manually duplicating all terminal output to the log
$FixFormat = Get-Content $Log
$FixFormat > $Log

