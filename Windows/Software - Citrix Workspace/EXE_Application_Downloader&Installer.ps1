<#
Version: 1.0
Author: 
- Brandon Miller-Mumford
Script: EXE_Application_Downloader&Installer.ps1
Description:
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

param (
    [string]$DownloadUrl,
    [string]$InstallerArgs
)

# Function to download the executable
function Download-File {
    param (
        [string]$url,
        [string]$output
    )

    try {
        Write-Output "Downloading $url to $output"
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        Write-Output "Download complete"
    } catch {
        Write-Error "Failed to download file: $_"
        exit 1
    }
}

# Function to install the application silently
function Install-Application {
    param (
        [string]$installerPath,
        [string]$arguments
    )

    try {
        Write-Output "Starting silent installation of $installerPath with arguments $arguments"
        Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait
        Write-Output "Installation complete"
    } catch {
        Write-Error "Installation failed: $_"
        exit 1
    }
}

# Main script logic
$installerPath = "$env:TEMP\installer.exe"

# Download the file
Download-File -url $DownloadUrl -output $installerPath

# Install the application with additional arguments
Install-Application -installerPath $installerPath -arguments $InstallerArgs

# Clean up
Remove-Item -Path $installerPath -Force
Write-Output "Cleanup complete"