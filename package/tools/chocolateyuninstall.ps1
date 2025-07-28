# microsoft-office-deployment uninstall

$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$binDir = "$($toolsDir)\..\bin"
$logDir = "$($toolsDir)\..\logs"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    file           = "$($binDir)\setup.exe"
    silentArgs     = "/configure $($binDir)\Uninstall.xml"
    validExitCodes = @(
        0, # success
        3010, # success, restart required
        2147781575, # pending restart required
        2147205120  # pending restart required for setup update
    )
}

Uninstall-ChocolateyPackage @packageArgs
