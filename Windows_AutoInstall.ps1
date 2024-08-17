
if (-not $env:REMOTE_PS) {
    $env:REMOTE_PS = "dtudk/pythonsupport-scripts"
}
if (-not $env:BRANCH_PS) {
    $env:BRANCH_PS = "main"
}


$url_ps =  "https://raw.githubusercontent.com/$env:REMOTE_PS/$env:BRANCH_PS"


Write-Output "Path before invoking webrequests: $url_ps"


# link to placeholder script 
PowerShell -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest -Uri '$url_ps/Windows_placeholder.ps1' -UseBasicParsing).Content}"



