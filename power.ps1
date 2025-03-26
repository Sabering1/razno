# Set volume to 100%
$volume = (New-Object -ComObject WScript.Shell)
$volume.SendKeys([char]175 * 50)  # Increase volume to max

# Define download URLs (Replace with your GitHub raw links)
$mp3Url = "https://raw.githubusercontent.com/Sabering1/razno/main/output_file.mp3"
$jpgUrl = "https://raw.githubusercontent.com/Sabering1/razno/main/wallpaper.jpg# Ensure PowerShell runs as Administrator if needed
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!"
    exit
}

# Set volume to 100% (using Windows Audio API)
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Audio {
    [DllImport("user32.dll")]
    public static extern int SendMessageW(int hWnd, int Msg, int wParam, int lParam);
    public static void SetVolumeMax() {
        for (int i = 0; i < 50; i++) {
            SendMessageW(0xFFFF, 0x319, 0x0, 0xA0000); // Increases volume
        }
    }
}
"@
[Audio]::SetVolumeMax()

# Define download URLs (Replace with your GitHub raw links)
$mp3Url = "https://raw.githubusercontent.com/Sabering1/razno/main/output_file.mp3"
$jpgUrl = "https://raw.githubusercontent.com/Sabering1/razno/main/wallpaper.jpg"

# Define file paths
$mp3Path = "$env:TEMP\audio.mp3"
$jpgPath = "$env:TEMP\wallpaper.jpg"

# Download files
Invoke-WebRequest -Uri $mp3Url -OutFile $mp3Path
Invoke-WebRequest -Uri $jpgUrl -OutFile $jpgPath

# Set wallpaper properly
$wallpaperKey = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $wallpaperKey -Name Wallpaper -Value $jpgPath
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True

# Ensure wallpaper applies immediately
Start-Process "rundll32.exe" -ArgumentList "user32.dll, UpdatePerUserSystemParameters" -NoNewWindow -Wait

# Play MP3 in a hidden window using Windows Media Player
$wmp = New-Object -ComObject WMPlayer.OCX
$wmp.URL = $mp3Path
$wmp.controls.play()
Start-Sleep 2  # Wait for WMP to initialize

# Hide Windows Media Player properly
$process = Get-Process | Where-Object { $_.MainWindowTitle -match "Windows Media Player" }
if ($process) {
    $process | ForEach-Object { $_.CloseMainWindow() }
}
"

# Define file paths
$mp3Path = "$env:TEMP\audio.mp3"
$jpgPath = "$env:TEMP\wallpaper.jpg"

# Download files
Invoke-WebRequest -Uri $mp3Url -OutFile $mp3Path
Invoke-WebRequest -Uri $jpgUrl -OutFile $jpgPath

# Set wallpaper
$wallpaperKey = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $wallpaperKey -Name Wallpaper -Value $jpgPath
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True

# Play MP3 in hidden window
$wmp = New-Object -ComObject WMPlayer.OCX
$wmp.URL = $mp3Path
$wmp.controls.play()
Start-Sleep 2  # Wait for WMP to initialize
$wmp.Visible = $false
