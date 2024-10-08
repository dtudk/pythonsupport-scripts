$_prefix = "PYS:"

# Function to refresh environment variables in the current session
function Refresh-Env {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
}


# Function to handle errors and exit
function Exit-Message {
    Write-Output "Oh no! Something went wrong."
    Write-Output "Please visit the following web page for more info:"
    Write-Output ""
    Write-Output "   https://pythonsupport.dtu.dk/install/windows/automated-error.html "
    Write-Output ""
    Write-Output "or contact the Python Support Team:"
    Write-Output ""
    Write-Output "   pythonsupport@dtu.dk"
    Write-Output ""
    Write-Output "Or visit us during our office hours"
    exit 1
}

# Check and set execution policy if necessary
$executionPolicies = Get-ExecutionPolicy -List
$currentUserPolicy = $executionPolicies | Where-Object { $_.Scope -eq "CurrentUser" } | Select-Object -ExpandProperty ExecutionPolicy
$localMachinePolicy = $executionPolicies | Where-Object { $_.Scope -eq "LocalMachine" } | Select-Object -ExpandProperty ExecutionPolicy

if ($currentUserPolicy -ne "RemoteSigned" -and $currentUserPolicy -ne "Bypass" -and $currentUserPolicy -ne "Unrestricted" -and
    $localMachinePolicy -ne "RemoteSigned" -and $localMachinePolicy -ne "Unrestricted" -and $localMachinePolicy -ne "Bypass") {
    Set-ExecutionPolicy -WarningAction:SilentlyContinue RemoteSigned -Scope CurrentUser -Force
}



# Check if VS Code is already installed
$vsc_paths = Get-Command -ErrorAction:SilentlyContinue code
if ( $vsc_paths.Count -gt 0 ) {
    Write-Output "$_prefix Visual Studio Code is already installed. Skipping VS Code installation.."
} else {
    # Download the VS Code installer
    $vscodeUrl = "https://update.code.visualstudio.com/latest/win32-x64-user/stable"
    $vscodeInstallerPath = "$env:USERPROFILE\Downloads\vscode-installer.exe"

    Write-Output "$_prefix Downloading installer for Visual Studio Code..."
    Invoke-WebRequest -Uri $vscodeUrl -OutFile $vscodeInstallerPath
    if ($?) {
        Write-Output "$_prefix VS Code installer downloaded."
    } else {
        Exit-Message
    }

    Write-Output "$_prefix Installing Visual Studio Code..."
    # Install VS Code
    Start-Process -FilePath $vscodeInstallerPath -ArgumentList "/verysilent /norestart /mergetasks=!runcode" -Wait
    if ($?) {
        Write-Output "$_prefix VS Code installed."
    } else {
        Exit-Message
    }
}

# Refresh environment variables
Refresh-Env
if ($?) {
    Write-Output "$_prefix Environment variables refreshed."
} else {
    Exit-Message
}

Write-Output "$_prefix Installing extensions for Visual Studio Code"
# Install VS Code extensions
code --install-extension ms-python.python
if ($?) {
    Write-Output "$_prefix Python extension installed."
} else {
    Exit-Message
}

code --install-extension ms-toolsai.jupyter
if ($?) {
    Write-Output "$_prefix Jupyter extension installed."
} else {
    Exit-Message
}

code --install-extension tomoki1207.pdf
if ($?) {
    Write-Output "$_prefix PDF extension installed."
} else {
    Exit-Message
}

Write-Output "$_prefix Installed Visual Studio Code successfully!"
