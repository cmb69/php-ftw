param (
    [Parameter(Mandatory)] $version,
    [Parameter(Mandatory)] $arch,
    [Parameter(Mandatory)] $ts
)

$ErrorActionPreference = "Stop"

$what = if ($version -match "[a-z]") {"qa"} else {"releases"}
$baseurl = "https://windows.php.net/downloads/$what"
$tspart = if ($ts -eq "nts") {"nts-Win32"} else {"Win32"}

$fname = "php-$version-$tspart-vs16-$arch.zip"
$url = "$baseurl/$fname"
Invoke-WebRequest $url -OutFile $fname
7z "x" $fname "-ophpbin"

$fname = "php-test-pack-$version.zip"
$url = "$baseurl/$fname"
Invoke-WebRequest $url -OutFile $fname
7z "x" $fname "-otests"
