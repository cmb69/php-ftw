$ErrorActionPreference = "Stop"

$Env:Path = "$pwd\phpbin;$Env:Path"
$Env:TEST_PHP_EXECUTABLE = "$pwd\phpbin\php.exe"
$Env:TEST_PHP_JUNIT = "$pwd\tests-results.xml"

Set-Location "tests"

Remove-Item "tests-to-run.txt" -ErrorAction "Ignore"
foreach ($line in Get-Content "..\dirs-to-test.txt") {
    $ttr = Get-ChildItem -Path $line -Filter "*.phpt" -Recurse
    foreach ($t in $ttr) {
        Add-Content "tests-to-run.txt" ($t | Resolve-Path -Relative)
    }
}

php "run-tests.php" "-j4" "-g" "FAIL,BORK,WARN,LEAK" "--context" "0" "-r" "tests-to-run.txt"
