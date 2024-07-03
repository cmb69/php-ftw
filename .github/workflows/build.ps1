param (
    [Parameter(Mandatory)] $version,
    [Parameter(Mandatory)] $arch,
    [Parameter(Mandatory)] $ts
)

$ErrorActionPreference = "Stop"

Set-Location "php\vs16\$arch\php-$version"

New-Item "..\obj" -ItemType "directory"
Copy-Item "..\config.$ts.bat"

$task = New-Item "task.bat" -Force
Add-Content $task 'set LDFLAGS="/d2:-AllowCompatibleILVersions" 2>&1'
Add-Content $task "call phpsdk_deps.bat -s staging -u 2>&1"
Add-Content $task "if errorlevel 1 exit 1"
Add-Content $task "call buildconf.bat 2>&1"
Add-Content $task "if errorlevel 1 exit 2"
Add-Content $task "call config.$ts.bat 2>&1"
Add-Content $task "if errorlevel 1 exit 3"
Add-Content $task "nmake 2>&1"
Add-Content $task "if errorlevel 1 exit 4"
Add-Content $task "call phpsdk_pgo --init 2>&1"
Add-Content $task "if errorlevel 1 exit 5"
Add-Content $task "call phpsdk_pgo --train --scenario default 2>&1"
Add-Content $task "if errorlevel 1 exit 6"
Add-Content $task "call phpsdk_pgo --train --scenario cache 2>&1"
Add-Content $task "if errorlevel 1 exit 7"
Add-Content $task "nmake clean-pgo 2>&1"
Add-Content $task "if errorlevel 1 exit 8"
Add-Content $task "sed -i ""s/enable-pgi/with-pgo/"" config.$ts.bat 2>&1"
Add-Content $task "if errorlevel 1 exit 9"
Add-Content $task "call config.$ts.bat 2>&1"
Add-Content $task "if errorlevel 1 exit 10"
Add-Content $task "nmake && nmake snap 2>&1"
Add-Content $task "if errorlevel 1 exit 11"

& "..\..\..\..\php-sdk\phpsdk-vs17-$arch.bat" -t $task
if (-not $?) {
    throw "build failed with errorlevel $LastExitCode"
}

$artifacts = if ($ts -eq "ts") {"..\obj\Release_TS\php-*.zip"} else {"..\obj\Release\php-*.zip"}
xcopy $artifacts "..\..\..\..\artifacts\*"
