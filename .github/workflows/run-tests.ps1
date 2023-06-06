param (
    [Parameter(Mandatory)] $version,
    [Parameter(Mandatory)] $arch,
    [Parameter(Mandatory)] $ts,
    [Parameter(Mandatory)] [ValidateSet('nocache', 'opcache')] $opcache
)

$ErrorActionPreference = "Stop"

$ini = "$pwd\phpbin\php.ini"
Copy-Item "php.ini" $ini
Add-Content $ini "extension_dir=$pwd\phpbin\ext"

if ($opcache -eq "opcache") {
    New-Item "$pwd/file_cache" -ItemType "directory"
    if ($arch -eq "x64") {
        Add-Content $ini "opcache.memory_consumption=256"
        Add-Content $ini "opcache.interned_strings_buffer=16"
        Add-Content $ini "opcache.max_accelerated_files=8000"
        Add-Content $ini "opcache.jit_buffer_size=32M"
    } else {
        Add-Content $ini "opcache.memory_consumption=128"
        Add-Content $ini "opcache.interned_strings_buffer=8"
        Add-Content $ini "opcache.max_accelerated_files=4000"
        Add-Content $ini "opcache.jit_buffer_size=16M"
    }
    Add-Content $ini "opcache.revalidate_freq=60"
    Add-Content $ini "opcache.fast_shutdown=1"
    Add-Content $ini "opcache.enable=1"
    Add-Content $ini "opcache.enable_cli=1"
    Add-Content $ini "opcache.error_log=$pwd/opcache_error.log"
    Add-Content $ini "opcache.log_verbosity_level=2"
    Add-Content $ini "opcache.file_cache=$pwd/file_cache"
    Add-Content $ini "opcache.file_cache_fallback=1"
}

$Env:Path = "$pwd\phpbin;$Env:Path"
$Env:TEST_PHP_EXECUTABLE = "$pwd\phpbin\php.exe"
$Env:TEST_PHP_JUNIT = "$pwd\test-$arch-$ts-$opcache.xml"
$Env:SKIP_IO_CAPTURE_TESTS = 1

$Env:OPENSSL_CONF = "$pwd\phpbin\extras\ssl\openssl.cnf"

$env:MYSQL_TEST_PORT = "3306"
$Env:MYSQL_TEST_USER = "root"
$Env:MYSQL_TEST_PASSWD = ""
$Env:MYSQL_TEST_DB = "test"

$Env:PDO_MYSQL_TEST_DSN = "mysql:host=localhost;dbname=test"
$Env:PDO_MYSQL_TEST_USER = "root"
$Env:PDO_MYSQL_TEST_PASS = ""

Set-Location "tests"

Remove-Item "tests-to-run.txt" -ErrorAction "Ignore"
foreach ($line in Get-Content "..\dirs-to-test.txt") {
    $ttr = Get-ChildItem -Path $line -Filter "*.phpt" -Recurse
    foreach ($t in $ttr) {
        Add-Content "tests-to-run.txt" ($t | Resolve-Path -Relative)
    }
}

$workers = $Env:NUMBER_OF_PROCESSORS / 2 * 3

switch ($version.Substring(0, 3)) {
    "7.3" {
        $runner = "run-test.php"
        $workers = ""
        $progress = ""
    }
    "7.4" {
        $runner = "run-test.php"
        $workers = "-j$workers"
        $progress = ""
    }
    "8.2" {
        $runner = "run-tests.php"
        $workers = "-j$workers"
        $progress = "--no-progress"
    }
    "8.3" {
        $runner = "run-tests.php"
        $workers = "-j$workers"
        $progress = "--no-progress"
    }
    default {
        $runner = "run-tests.php"
        $workers = "-j$workers"
        $progress = ""
    }
}

php $runner $progress "-g" "FAIL,BORK,WARN,LEAK" "-r" "tests-to-run.txt"
