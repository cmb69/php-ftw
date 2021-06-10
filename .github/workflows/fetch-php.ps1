param (
    [Parameter(Mandatory)] $version,
    [Parameter(Mandatory)] $arch,
    [Parameter(Mandatory)] $ts
)

$ErrorActionPreference = "Stop"

$url = "https://windows.php.net/downloads/releases/php-8.0.7-Win32-vs16-x64.zip"
Invoke-WebRequest $url -OutFile "php-8.0.7-Win32-vs16-x64.zip"
7z "x" "php-8.0.7-Win32-vs16-x64.zip" -ophp
