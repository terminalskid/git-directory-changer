param(
  [string]$DefaultFolder
)

$installDir = Join-Path $env:USERPROFILE ".gitloc\bin"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

Copy-Item ".\git-loc.py" "$installDir\git-loc.py" -Force

$batGitLoc = @"
@echo off
setlocal
set SCRIPT="%~dp0git-loc.py"
where py >nul 2>nul
if %ERRORLEVEL%==0 (
  py -3 %SCRIPT% %*
) else (
  python %SCRIPT% %*
)
"@
Set-Content "$installDir\git-loc.bat" $batGitLoc -NoNewline

$batGclone = @"
@echo off
setlocal
set SCRIPT="%~dp0git-loc.py"
where py >nul 2>nul
if %ERRORLEVEL%==0 (
  py -3 %SCRIPT% gclone %*
) else (
  python %SCRIPT% gclone %*
)
"@
Set-Content "$installDir\gclone.bat" $batGclone -NoNewline

$batGloco = @"
@echo off
setlocal
set SCRIPT="%~dp0git-loc.py"
where py >nul 2>nul
if %ERRORLEVEL%==0 (
  py -3 %SCRIPT% gloco %*
) else (
  python %SCRIPT% gloco %*
)
"@
Set-Content "$installDir\gloco.bat" $batGloco -NoNewline

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($null -eq $userPath) { $userPath = "" }
if ($userPath -notlike "*$installDir*") {
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$installDir", "User")
}
$env:Path = "$env:Path;$installDir"

$pyCmd = (Get-Command py -ErrorAction SilentlyContinue)
if ($null -eq $pyCmd) { $pyCmd = (Get-Command python -ErrorAction SilentlyContinue) }
if ($null -eq $pyCmd) {
  Write-Warning "Python was not found. Install Python and re-run this script if commands fail."
}

if (-not $DefaultFolder) {
  $suggest = "D:\GitRepos"
  $DefaultFolder = Read-Host "Enter default Git folder [$suggest]"
  if (-not $DefaultFolder) { $DefaultFolder = $suggest }
}

try {
  & "$installDir\git-loc.bat" set $DefaultFolder | Out-Null
  Write-Host "Default Git folder set to $DefaultFolder"
} catch {
  Write-Warning "Failed to set default folder. Run: git-loc set <path>"
}

Write-Host "Installed gclone, gloco, and git-loc. Restart terminal to persist PATH."
