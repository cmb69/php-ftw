param (
    [Parameter(Mandatory)] $version,
    [Parameter(Mandatory)] $arch,
    [Parameter(Mandatory)] $ts
)

$ErrorActionPreference = "Stop"

$versions = @{
    "7.3" = "vc15"
    "7.4" = "vc15"
    "8.0" = "vs16"
    "8.1" = "vs16"
    "8.2" = "vs16"
    "8.3" = "vs16"
    "8.4" = "vs17"
}
$vs = $versions.($version.Substring(0, 3))
if (-not $vs) {
    throw "unsupported PHP version"
}

$what = if ($version -match "[a-z]") {"qa"} else {"releases"}
$baseurl = "https://windows.php.net/downloads/$what"
$tspart = if ($ts -eq "nts") {"nts-Win32"} else {"Win32"}

$fname = "php-$version-$tspart-$vs-$arch.zip"
$url = "$baseurl/$fname"
Invoke-WebRequest $url -OutFile $fname
7z "x" $fname "-ophpbin"

$fname = "php-test-pack-$version.zip"
$url = "$baseurl/$fname"
Invoke-WebRequest $url -OutFile $fname
7z "x" $fname "-otests"
