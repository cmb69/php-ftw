<?php

list($version, $arch, $ts, $extension) = array_slice($argv, 1);

$versions = [
    "7.4" => "vc15",
    "8.0" => "vs16",
    "8.1" => "vs16",
    "8.2" => "vs16",
];
if (!array_key_exists($version, $versions)) {
    throw new Exception("Unsupported version: $version");
}
echo "::set-output name=vs::{$versions[$version]}\n";

$ini = parse_ini_file(__DIR__ . "/pecl.ini", true, INI_SCANNER_RAW);
if (!array_key_exists($extension, $ini)) {
    throw new Exception("Unsupported extension: $extension");
}
echo "::set-output name=config::{$ini[$extension]['config']}\n";

if (array_key_exists("libs", $ini[$extension])) {
    $libs = $ini[$extension]["libs"];
} else {
    $libs = "''";
}
echo "::set-output name=libs::{$libs}\n";

$lines = [];
if (array_key_exists("exts", $ini[$extension])) {
    $exts = $ini[$extension]["exts"];
    foreach (explode(",", $exts) as $ext) {
        if (array_key_exists($ext, $ini)) {
            $lines[] = "{$ext}\t{$ini[$ext]["config"]}\n";
        } else {
            throw new Exception("Unsupported dependency extension: $extension");
        }
    }
}
file_put_contents("./extensions.csv", $lines);

$sxe = simplexml_load_file("./package.xml");
$sxe->registerXPathNamespace("p", "http://pear.php.net/dtd/package-2.0");
$docs = array_map(
    function ($sxe) {
        return str_replace("/", "\\", (string) $sxe["name"]);
    },
    $sxe->xpath("//p:file[@role='doc']")
);
$docs = implode(" ", $docs);
echo "::set-output name=docs::{$docs}\n";

$builddir = "";
if ($arch === "x64") {
    $builddir .= "x64\\";
}
$builddir .= "Release";
if ($ts === "ts") {
    $builddir .= "_TS";
}
echo "::set-output name=builddir::{$builddir}\n";
