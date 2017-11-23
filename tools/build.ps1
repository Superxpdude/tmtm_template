##############################
#.SYNOPSIS
# The automatic build script for arma missions
#
#.DESCRIPTION
# Refer to AUTOBUILD.md for usage and requirements
#  
#.EXAMPLE
# ./build.ps1
# 
#.NOTES
# The script takes no arguments and is supposed to launch from the tools folder
# Author: Komachi
##############################
function Get-ScriptPath() {
    return $MyInvocation.PSScriptRoot
}

function Verify-Buildable ([string]$Mission) {
    if ((Get-Item -Path "$Mission\.mission.json" -ErrorAction SilentlyContinue).Exists) {
        return $true
    }
    else {
        return $false
    }
}

function Verify-Deps() {
    try {
        $suppress = Get-Command git.exe -ErrorAction Stop -ErrorVariable "getcommanderror"
        $suppress = Get-Command FileBank.exe -ErrorAction Stop -ErrorVariable "getcommanderror"
        $suppress = Get-Command CfgConvert.exe -ErrorAction Stop -ErrorVariable "getcommanderror"
    }
    catch {
        Write-Host "[CRITICAL] One of the build dependencies is missing! Verify that git.exe, FileBank.exe and CfgConvert.exe is in your `$PATH enviroment variable" -ForegroundColor White -BackgroundColor Red
        Write-Host $getcommanderror.message.Split(":")[1] -ForegroundColor Yellow
        exit
    }
}

function New-Mission ([System.IO.DirectoryInfo]$Mission,[System.IO.DirectoryInfo]$Destination) {
    $MissionInfoFile = Get-Content "$mission\.mission.json"
    # Convert to JSON
    $MissionInfo = $MissionInfoFile | ConvertFrom-Json
    $LastLocation = Get-Location
    Set-Location $Mission
    # Describe and autotag if version not present
    $version = git.exe describe master
    if ($LASTEXITCODE -ne 0) {
        git.exe tag -a $MissionInfo.Version -m 'Auto Version Tag'
        $version = git describe master
        Write-Host "[INFO] Version tag $version created! Don't forget to push it to your remote by calling git push --tags" -ForegroundColor Cyan
    }
    if ($version.Split("-")[0] -ne $MissionInfo.Version) {
        git.exe tag -a $MissionInfo.Version -m "Auto Version Tag"
        $version = git.exe describe master
        Write-Host "[INFO] Version tag $version created! Don't forget to push it to your remote by calling git push --tags" -ForegroundColor Cyan
    }
    $MissionString = [string]::Format("{0}_{1}-{2}.{3}.pbo", $MissionInfo.Prefix, $MissionInfo.InternalName, $version, $MissionInfo.MapName)
    $FinalDestination = "$Destination\"+$Mission.BaseName+".pbo"
    # Prepare description.ext
    $Description = Get-Content "$Mission\description.ext"
    $NewDescription = $Description -replace '(author(\ |)=(\ |))("(|.+)");', [string]::Format('$1"{0}";', $MissionInfo.Author)
    $NewDescription = $NewDescription -replace '(briefingName(\ |)=(\ |))("(|.+)");', [string]::Format('$1"{0} {1} {2}";', $MissionInfo.Prefix, $MissionInfo.Name, $version)
    Set-Content -Path "$Mission\description.ext" -Value $NewDescription
    # Backup non-binarized mission.sqm
    Copy-Item -Path "$Mission\mission.sqm" -Destination "$Mission\mission.sqm.tmp" -Force
    # Binarize
    CfgConvert.exe -bin -dst "$Mission\mission.sqm" "$Mission\mission.sqm"
    # Start Packing
    Set-Location -Path ..
    FileBank.exe -exclude "$ScriptPath\exclude.lst" -dst $Destination (Get-Item $mission).BaseName
    if ($LASTEXITCODE -eq 0) {
        $Item = Get-Item $FinalDestination
        Move-Item -Path $Item -Destination $Destination\$MissionString -Force 
        Set-Location $LastLocation
        # Clean-up and restore old mission.sqm & description.ext
        Move-Item -Path "$Mission\mission.sqm.tmp" -Destination "$Mission\mission.sqm" -Force
        Set-Content -Path "$Mission\description.ext" -Value $Description
        return $Item
    }
    else {
        Write-Host "[ERROR] Something went wrong during packing process" -ForegroundColor White -BackgroundColor Red
        # Clean-up and restore old mission.sqm & description.ext
        Move-Item -Path "$Mission\mission.sqm.tmp" -Destination "$Mission\mission.sqm" -Force
        Set-Content -Path "$Mission\description.ext" -Value $Description
        return 1
    }
}

$ScriptPath = Get-ScriptPath
Verify-Deps
Set-Location $ScriptPath
Write-Host ([string]::Format("[INFO] Starting Build process")) -ForegroundColor Cyan
$InputMissionDir = Get-Item -Path "../"

Write-Host ([string]::Format("[INFO] Automated building of {0} has started.", (Get-Item $InputMissionDir).BaseName)) -ForegroundColor Cyan
$Verify = Verify-Buildable -Mission $InputMissionDir
if ($Verify) {
    $Folder = New-Item -ItemType Directory -Path "$ScriptPath/../out" -Force
    $BuiltMission = New-Mission -Mission (Get-Item $InputMissionDir) -Destination $Folder
    if ($BuiltMission -eq 1)
    {
        Write-Host ([string]::Format("[CRITICAL] Build failure")) -ForegroundColor Red
    }
    else
    {
        Write-Host ([string]::Format("[INFO] BUILD SUCCESS: {0}", $BuiltMission.BaseName)) -ForegroundColor Green
    }
}
else {
    Write-Host "[ERROR] Missing manifest for building a mission!" -ForegroundColor Red
}

Set-Location $ScriptPath