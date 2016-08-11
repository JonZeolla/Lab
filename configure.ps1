# =========================
# Author:          Jon Zeolla (JZeolla)
# Last update:     2016-08-10
# File Type:       PowerShell Script
# Version:         1.1
# Repository:      https://github.com/JonZeolla/lab
# Description:     This is a PowerShell script to set up a MSR605 on a windows system using the ProximityAttacks lab.
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
$startTime = Get-Date -format yyyy-MM-dd-HH.mm.ss
$startTimeResults = Get-Date
$Log = "$dirLogs\$startTime.txt"
$githubTag = "ProximityAttacks"

## Start logging
Start-Transcript -path $Log -append | Out-Null

## Talk to the user
Write-Host "==================================================================================================="
Write-Host "Configure the MSR605 for some mag stripe reading and writing fun for the $githubTag lab"
Write-Host "==================================================================================================="
Write-Host "Written by: JonZeolla"
Write-Host "Version: $ver"
Write-Host "Last updated: $lastUpdate"
Write-Host "==================================================================================================="
Write-Host "Start time: $startTimeResults"
Write-Host "===================================================================================================`n"

## Start the install process
# Install the driver first
$driver=Start-Process "$dirInstallers\MSR605_driver.exe" -Wait
if ($LASTEXITCODE -eq 0)
{ Write-Host "Successfully installed the driver for the MSR605" }
else
{ Write-Host "Error installing the driver for the MSR605" }

# Prompt to plug in the device
Write-Host "Please plug in the MSR605.`n`nPress any key to continue . . ."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")

# Install the software
$software=Start-Process "$dirInstallers\MSR605_software.exe" -Wait
if ($LASTEXITCODE -eq 0)
{ Write-Host "Successfully installed the software for the MSR605" }
else
{ Write-Host "Error installing the software for the MSR605" }

# Stop logging
Stop-Transcript | Out-Null

# This fixes the transcript formatting without adding a `r`n to each 
# line and making it look horrible in the terminal window,
# or manually duplicating all terminal output to the log
$FixFormat = Get-Content $Log
$FixFormat > $Log

