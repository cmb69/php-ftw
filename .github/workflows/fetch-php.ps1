param (
    [Parameter(Mandatory)] $version,
    [Parameter(Mandatory)] $arch,
    [Parameter(Mandatory)] $ts
)

$ErrorActionPreference = "Stop"

$tspart = if ($ts -eq "nts") {"nts-Win32"} else {"Win32"}

$fname = "php-$version-$tspart-vs16-$arch.zip"
$url = "https://windows.php.net/downloads/releases/$fname"
Invoke-WebRequest $url -OutFile $fname
7z "x" $fname "-ophpbin"

$fname = "php-test-pack-$version.zip"
$url = "https://windows.php.net/downloads/releases/$fname"
Invoke-WebRequest $url -OutFile $fname
7z "x" $fname "-otests"
