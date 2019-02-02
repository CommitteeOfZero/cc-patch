foreach($file in Get-ChildItem -Path "G:\Games\SGTL\cc_work\terribuild\cc-edited-images\bg\*_steam*",
                                     "G:\Games\SGTL\cc_work\terribuild\cc-edited-images\system\*_steam*") {
    $fileSteam = [string] $file
    $fileNoSteam = $fileSteam -replace "_steam", ""
    Remove-Item -ErrorAction SilentlyContinue $fileNoSteam
    Move-Item $fileSteam $fileNoSteam
}