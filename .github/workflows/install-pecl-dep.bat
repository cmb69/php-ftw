setlocal

set ext=%1
set config=%2
set prefix=%3

curl -Lso %ext%.tgz https://pecl.php.net/get/%ext%
7z x %ext%.tgz
7z x -y %ext%.tar
cd %ext%-*
call phpize
call configure --with-php-build=..\..\deps %config% --with-prefix=%prefix%
nmake
nmake install
