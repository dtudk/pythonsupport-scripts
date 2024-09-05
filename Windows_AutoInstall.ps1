
if (-not $env:REMOTE_PS) {
    $env:REMOTE_PS = "dtudk/pythonsupport-scripts"
}
if (-not $env:BRANCH_PS) {
    $env:BRANCH_PS = "main"
}


$url_ps =  "https://raw.githubusercontent.com/$env:REMOTE_PS/$env:BRANCH_PS/Windows"


Write-Output "Path before invoking webrequests: $url_ps"


Write-Output "Running Windows_python.ps1"
# link to full python installation 
PowerShell -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest -Uri '$url_ps/Python/Install.ps1' -UseBasicParsing).Content}"



# Only start if python succesfull 
#
if ($?) {
PowerShell -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest -Uri '$url_ps/VSC/Install.ps1' -UseBasicParsing).Content}"
} else {
  Write-Output "Python installation failed. Skipping VS Code installation and aborting."
  exit 0
}

Write-Output ""
Write-Output "Script has finished. You may now close the terminal..."
