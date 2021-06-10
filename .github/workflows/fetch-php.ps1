param (
    [Parameter(Mandatory)] $version,
    [Parameter(Mandatory)] $arch,
    [Parameter(Mandatory)] $ts
)

$ErrorActionPreference = "Stop"

$fname = "php-8.0.7-nts-Win32-vs16-x64.zip"
$url = "https://windows.php.net/downloads/releases/$fname"
Invoke-WebRequest $url -OutFile $fname
7z "x" $fname "-ophpbin"

$fname = "php-test-pack-8.0.7.zip"
$url = "https://windows.php.net/downloads/releases/$fname"
Invoke-WebRequest $url -OutFile $fname
7z "x" $fname "-otests"
