﻿# microsoft-office-deployment install

$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$urlPackage = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_14729-20228.exe'
$checksumPackage = '02607cc89abcde9675c5e4f56d0f3f374b57dae962947fa13d40009bce5270d2fd388b7342fd5a80274d146dfcc3466a5622f37c50d684b28bac06e850a1512e'
$checksumTypePackage = 'SHA512'

$binDir = "$($toolsDir)\..\bin"
$logDir = "$($toolsDir)\..\logs"

$arch = 32
$sharedMachine = 0
$languages = "MatchOS"
$products = "HomeBusinessRetail" 
$updates = "TRUE"

if ($PackageParameters) {

    if ($PackageParameters["64bit"]) {
        Write-Host "Installing 64-bit version."
        $arch = 64
    }
    else {
        Write-Host "Installing 32-bit version."
    }

    if ($PackageParameters["DisableUpdate"]) {
        Write-Host "Update Disabled"
        $updates = "FALSE"
    }

    if ($PackageParameters["RemoveMSI"]) {
        Write-Host "Removing existing MSI versions of Office."
    }

    if ($PackageParameters["Shared"]) {
        Write-Host "Installing with Shared Computer Licensing for Remote Desktop Services."
        $sharedMachine = 1
    }

    if ($PackageParameters["Channel"]) {
        Write-Host "The following update channel has been selected $($PackageParameters["Channel"])"
        $channel = $PackageParameters["Channel"]
    }

    if ($PackageParameters["Language"]) {
        $languages = $PackageParameters["Language"].split(",")
        foreach ($language in $languages) {
            if (Get-Content "$($toolsDir)\lists\languagesList.txt" | Select-String $language) {
                Write-Host "Installing language variant $($language)"                 
            }
            else {
                if ($language.Count -gt 1 ) {
                    Write-Warning "$($language) not found"
                    $languages = $languages -ne $language
                }            
            }
        }
    }

    if ($PackageParameters["Product"]) {        
        $products = $PackageParameters["Product"].split(",")
        foreach ($product in $products) {
            if (Get-Content "$($toolsDir)\lists\officeList.txt" | Select-String $product) {
                Write-Host "Installation Product $($product)"                 
            }
            else {
                if ($products.Count -gt 1 ) {
                    Write-Warning "$($product) not found"
                    $products = $products -ne $product
                }
                else {
                    Write-Warning "$($product) not found we installed HomeBusinessRetail"
                    $products = "HomeBusinessRetail"
                }              
            }
        }
    }

    if ($PackageParameters["Exclude"]) {        
        $excludes = $PackageParameters["Exclude"].split(",")
        foreach ($exclude in $excludes) {
            if (Get-Content "$($toolsDir)\lists\excludeList.txt" | Select-String $exclude) {
                Write-Host "Excluded $($exclude)"                 
            }
            else {
                if ($excludes.Count -gt 1 ) {
                    Write-Warning "$($exclude) not found"
                    $excludes = $excludes -ne $exclude
                }            
            }
        }
    }
}
else {
    Write-Debug "No Package Parameters Passed in"
    Write-Host "Installing 32-bit version."
    Write-Host "Installing language variant $languages."
    Write-Host "Installation Product $product"
}

Import-Module -Name "$($toolsDir)\helpers.ps1"

$packageArgs = @{
    packageName    = 'Office-Deployment-Tool'
    fileType       = 'EXE'
    url            = $urlPackage
    checksum       = $checksumPackage
    checksumType   = $checksumTypePackage
    silentArgs     = "/extract:$($binDir) /log:$($logDir)\Office-Deployment-Tool.log /quiet /norestart"
    validExitCodes = @(
        0, # success
        3010, # success, restart required
        2147781575, # pending restart required
        2147205120  # pending restart required for setup update
    )
}

Install-ChocolateyPackage @packageArgs

$installConfigData = @"
<Configuration>
    $(
        if($channel -ne $null){ 
    "<Add OfficeClientEdition=""$($arch)"" Channel=""$($channel)"">"
        } else {
    "<Add OfficeClientEdition=""$($arch)"">"
        }
    )
    $(
        foreach($product in $products) {
"           <Product ID=""$($product)"">"
        foreach($language in $languages) {
"`r`n           <Language ID=""$($language)"" />"

        }
        foreach($exclude in $excludes) {
"`r`n           <ExcludeApp ID=""$($exclude)"" />"

        }
"`r`n       </Product>"
        }
    )
    </Add>  
    $(
        if($channel -ne $null){ 
    "<Updates Enabled=""$($updates)"" Channel=""$($channel)"" />"
        } else  {
    "<Updates Enabled=""$($updates)"" />"
        }
    )
    $(
        if($PackageParameters["RemoveMSI"]){
            "<RemoveMSI />"
        }
    )
    <Display Level="None" AcceptEULA="TRUE" />  
    <Logging Level="Standard" Path="$logDir" /> 
    <Property Name="SharedComputerLicensing" Value="$sharedMachine" />  
</Configuration>
"@
 
$uninstallConfigData = @"
<Configuration>
    <Remove>
    $(
        foreach($product in $products) {
"           <Product ID=""$($product)"">"
"`r`n       </Product>"
        }
    )
    </Remove>
    <Display Level="None" AcceptEULA="TRUE" />  
    <Logging Level="Standard" Path="$logDir" /> 
    <Property Name="FORCEAPPSHUTDOWN" Value="True" />
</Configuration>
"@

$installConfigData | Out-File "$($binDir)\Install.xml"
$uninstallConfigData | Out-File "$($binDir)\Uninstall.xml"
 
$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    file           = "$($binDir)\setup.exe"
    checksum       = '53CA42D6EEDB08AD3EFF2EB51E720673C3842C24D36B334FCA7358CE6AC19007'
    checksumType   = 'sha256'
    silentArgs     = "/configure $($binDir)\Install.xml"
    validExitCodes = @(
        0, # success
        3010, # success, restart required
        2147781575, # pending restart required
        2147205120  # pending restart required for setup update
    )
}

Install-ChocolateyInstallPackage @packageArgs
