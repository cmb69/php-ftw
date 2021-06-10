$ErrorActionPreference = "Stop"

$Env:Path = "$pwd\phpbin;$Env:Path"
$Env:TEST_PHP_EXECUTABLE = "$pwd\phpbin\php.exe"
$Env:TEST_PHP_JUNIT = "$pwd\tests-results.xml"

Set-Location "tests"

php "run-tests.php" "-j4" "-g" "FAIL,BORK,WARN,LEAK" "Zend\tests"
