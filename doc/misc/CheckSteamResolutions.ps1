function Get-ImageDimensions {
    param ($filePath)

    $folderPath = Split-Path -Path $filePath -Parent
    $fileName = Split-Path -Path $filePath -Leaf


    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.namespace($folderPath)
    $objFile = $objFolder.ParseName($fileName)

    return $objFolder.GetDetailsOf($objFile, 31)
}

foreach ($file in $(gci -Path "G:\Games\SGTL\cc_work\terribuild\cc-edited-images\bg\*" -Include *.png, *.dds)) {
    $fileName = Split-Path -Path $file -Leaf
    $origPath = Join-Path -Path "G:\Steam\SteamApps\common\CHAOS;CHILD\USRDIR\bg1" -ChildPath $fileName
    if (-not $(Test-Path -Path $origPath)) {
        $origPath = Join-Path -Path "G:\Steam\SteamApps\common\CHAOS;CHILD\USRDIR\bg2" -ChildPath $fileName
        if (-not $(Test-Path -Path $origPath)) {
            $origPath = $null
        }
    }
    if ($origPath) {
        $dims = Get-ImageDimensions -filePath $file
        $origDims = Get-ImageDimensions -filePath $origPath
        if ($dims -ne $origDims) {
            Write-Host "Mismatch: $origPath - $dims => $origDims"
        }
    }
}