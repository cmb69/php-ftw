$ErrorActionPreference = "Stop"

$Env:Path = "$pwd\phpbin;$Env:Path"
$Env:TEST_PHP_EXECUTABLE = "$pwd\phpbin\php.exe"

Set-Location "tests"

php "run-tests.php" "-j4" "Zend\tests"
