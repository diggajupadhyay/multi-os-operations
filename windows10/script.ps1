## Start of the Program

function Uninstall-App {
    param (
        [string]$AppName
    )

    # Ensure lowercase for consistency
    $AppName = $AppName.ToLower()

    # Validate user input
    $choice = Read-Host "Do you want to uninstall $AppName? (y/n)"
    $validChoices = @("y", "n")

    while ($choice -notin $validChoices) {
        Write-Host "Invalid choice. Please enter 'y' or 'n'."
        $choice = Read-Host "Do you want to uninstall $AppName? (y/n)"
    }

    if ($choice -eq 'y') {
        Get-AppxPackage $AppName -AllUsers | Remove-AppxPackage
        Write-Host "$AppName uninstalled successfully." -ForegroundColor Green
    } else {
        Write-Host "$AppName will not be uninstalled." -ForegroundColor Yellow
    }
}

# List of apps to potentially uninstall (lowercase for consistency)
$appNames = @(
    "*microsoftteams*",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.windowscommunicationsapps",
    "*bing*",
    "*3dbuilder*",
    "*officehub*",
    "*ZuneMusic*",
    "*ZuneVideo*",
    "*GetHelp*",
    "*MicrosoftOfficeHub*",
    "*skype*",
    "*camera*",
    "*solitaire*",
    "*maps*",
    "*getstarted*",
    "*onenote*",
    "*people*",
    "Microsoft.YourPhone",
    "*soundrecorder*",
    "*SpotifyAB.SpotifyMusic*",
    "*messenger*",
    "*facebook*",
    "*instagram*",
    "*whatsapp*",
    "*netflix*",
    "*Todos*",
    "*MicrosoftStickyNotes*",
    "*WindowsFeedbackHub*",
    "*Paint*",
    "*MixedReality*",
    "*Clipchamp*",
    "*CapturePicker*",
    "Microsoft.549981C3F5F10"
)

# Start of app uninstallation
Write-Host "Welcome to App Uninstallation Script!" -ForegroundColor Green

# Uninstall each app based on user choice
foreach ($appName in $appNames) {
    Uninstall-App -AppName $appName
}



# Start of System Configuration
Write-Host "Welcome to the System Configuration Script!" -ForegroundColor Green

# Perform each system configuration action
Configure-System -Action "Disable Telemetry" -RegistryPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -RegistryName "AllowTelemetry" -RegistryValue 0
Configure-System -Action "Disable Bing Search from Start Menu" -RegistryPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -RegistryName "BingSearchEnabled" -RegistryValue 0
Configure-System -Action "Disable Wifi-Sense" -RegistryPath "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -RegistryName "Value" -RegistryValue 0
Configure-System -Action "Disable Teredo" -ServiceName "Teredo" -ServiceStartupType "Block"
Configure-System -Action "Disable Activity History" -ServiceName "DiagTrack" -ServiceStartupType "Manual"
Configure-System -Action "Disable Location Tracking" -RegistryPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -RegistryName "DisableSensors" -RegistryValue 1
Configure-System -Action "Disable Homegroup" -ServiceName "HomeGroupListener" -ServiceStartupType "Manual"
Configure-System -Action "Disable Storage Sense" -RegistryPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -RegistryName "01" -RegistryValue 0
Configure-System -Action "Disable Hibernation" -Command "powercfg /h off"
Configure-System -Action "Enable NumLock on Startup" -RegistryPath "HKCU:\Control Panel\Keyboard" -RegistryName "InitialKeyboardIndicators" -RegistryValue 2
Configure-System -Action "Disable Mouse Acceleration" -RegistryPath "HKCU:\Control Panel\Mouse" -RegistryName "MouseSpeed" -RegistryValue 0
Configure-System -Action "Add & Activate Ultimate Performance Profile" -Command "powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61", "powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61"
Configure-System -Action "Enable Dark Theme" -RegistryPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -RegistryName "AppsUseLightTheme" -RegistryValue 0

Write-Host "Script completed successfully!"


# Function to install required apps
function Install-App {
    param (
        [string]$AppName
    )

    $choice = Read-Host "Do you want to install $AppName? (y/n)"

    if ($choice -eq 'y') {
        winget install --id $AppName --source winget
    } else {
        Write-Host "$AppName will not be installed." -ForegroundColor Yellow
    }
}

# Start of Script
Write-Host "Welcome to the Required Apps Installation Script!" -ForegroundColor Green

# List of apps to install
$apps = @(
    "Git.Git",
    "Microsoft.PowerShell",
    "Microsoft.WindowsTerminal",
    "Nvidia.GeForceExperience",
    "Mozilla.Firefox",
    "LibreWolf.LibreWolf",
    "Mozilla.Thunderbird",
    "Discord.Discord",
    "Nextcloud.NextcloudDesktop",
    "TheDocumentFoundation.LibreOffice",
    "KDE.Kate",
    "GIMP.GIMP",
    "ImageMagick.ImageMagick",
    "KDE.Kdenlive",
    "VideoLAN.VLC",
    "KRTirtho.Spotube",
    "Valve.Steam",
    "EpicGames.EpicGamesLauncher",
    "OBSProject.OBSStudio",
    "Audacity.Audacity",
    "yt-dlg.yt-dlg",
    "StrawberryMusicPlayer.Strawberry",
    "SharkLabs.ClownfishVoiceChanger",
    "Chocolatey.Chocolatey",
    "Safing.Portmaster"
)

# Install each app based on user choice
foreach ($app in $apps) {
    Install-App -AppName $app
}

Write-Host "Required Apps installed successfully!"

# Additional Apps not in Winget Repository
function Additional-App {
    param (
        [string]$AppName
    )

    $choice = Read-Host "Do you want to install $AppName? (y/n)"

    if ($choice -eq 'y') {
        choco install $AppName
    } else {
        Write-Host "$AppName will not be installed." -ForegroundColor Yellow
    }
}

# Start of Script
Write-Host "Welcome to the Additional Apps Installation Script!" -ForegroundColor Green

# List of additional apps to install
$apps = @(
    "vmware-workstation-player"
)

# Install each app based on user choice
foreach ($app in $apps) {
    Additional-App -AppName $app
}

Write-Host "Additional Apps installed successfully!"
