param (
    [Parameter(Mandatory)] $version,
    [Parameter(Mandatory)] $arch,
    [Parameter(Mandatory)] $ts
)

$ErrorActionPreference = "Stop"

if ($version.Contains(".")) {
    Invoke-WebRequest "https://github.com/php/php-src/archive/refs/tags/php-$version.zip" -Outfile "php-$version.zip"
} else {
    Invoke-WebRequest "https://github.com/php/php-src/archive/$version.zip" -Outfile "php-$version.zip"
}
7z "x" "php-$version.zip"
Move-Item "php-src-php-$version" "php-$version-src"
7z "a" "artifacts-$ts-$arch\php-$version-src.zip" "php-$version-src"
Move-Item "php-$version-src" "php/vs16/$arch/php-$version"
