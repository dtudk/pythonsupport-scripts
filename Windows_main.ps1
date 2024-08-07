# check for environmental variable DEVELOPERMODEPIS 
# if 1 set path_temp to 'philipnickel' otherwise set path_temp to 'dtudk'


$developerPath =  "https://raw.githubusercontent.com/$PS_remote/pythonsupport-scripts/$PS_branch/Windows_auto_python.ps1"


$productionPath =  "https://raw.githubusercontent.com/dtudk/pythonsupport-scripts/main/Windows_auto_python.ps1"


if ($env:DEVELOPERMODEPS -eq 1) { $path_temp = $developerPath } else { $path_temp = $productionPath}


# link to full python installation 
PowerShell -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest -Uri '$path_temp' -UseBasicParsing).Content}"

# link to full VSC installation
PowerShell -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest -Uri '$path_temp' -UseBasicParsing).Content}"


# Link to placeholder
#

# PowerShell -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/dtudk/pythonsupport-scripts/main/AutoInstallWindows_placeholder.ps1' -UseBasicParsing).Content}"

