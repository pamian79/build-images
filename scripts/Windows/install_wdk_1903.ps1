Write-Host "Installing WDK 1903 (10.0.18362.1)..." -ForegroundColor Cyan

Write-Host "Downloading..."
$exePath = "$env:temp\wdksetup.exe"
(New-Object Net.WebClient).DownloadFile('https://go.microsoft.com/fwlink/?linkid=2085767', $exePath)
Write-Host "Installing..."
cmd /c start /wait $exePath /quiet
Remove-Item $exePath -Force -ErrorAction Ignore
Write-Host "OK"

$vsPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community"
if (-not (Test-Path $vsPath)) {
    $vsPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Preview"
}

if (-not (Test-Path $vsPath)) {
  return
}

Write-Host "Installing Visual Studio 2019 WDK extension..."

$vsVersion=& "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property installationVersion | Out-String
$vsVersion = $vsVersion -replace "`n|`r"
"`"$vsPath\Common7\IDE\VSIXInstaller.exe`"  /a /f /sp /q /skuName:Community /skuVersion:$vsVersion `"${env:ProgramFiles(x86)}\Windows Kits\10\Vsix\VS2019\WDK.vsix`"" | out-file ".\install-vsix.cmd" -Encoding ASCII
& .\install-vsix.cmd
Remove-Item .\install-vsix.cmd -Force -ErrorAction Ignore
Write-Host "OK"
