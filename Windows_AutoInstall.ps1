
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



