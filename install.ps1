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

$batGdc = @"
@echo off
setlocal
set SCRIPT="%~dp0git-loc.py"
where py >nul 2>nul
if %ERRORLEVEL%==0 (
  py -3 %SCRIPT% menu %*
) else (
  python %SCRIPT% menu %*
)
"@
Set-Content "$installDir\gdc.bat" $batGdc -NoNewline

$installDir = $installDir -replace '\\', '\\'

Write-Host "Checking if install directory exists..."
if (-not (Test-Path $installDir)) {
  Write-Host "Creating install directory: $installDir"
  New-Item -ItemType Directory -Force -Path $installDir | Out-Null
  Write-Host "Created directory"
}

Write-Host "Checking current user PATH..."
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($null -eq $userPath) { $userPath = "" }

if ($userPath -notlike "*$installDir*") {
  Write-Host "Adding $installDir to user PATH..."
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$installDir", "User")
  Write-Host "Added to user PATH"
}
else {
  Write-Host "$installDir already in user PATH"
}

Write-Host "Updating current session PATH..."
$env:Path = "$env:Path;$installDir"
Write-Host "Updated current session PATH"

Write-Host "Checking Python availability..."
$pyCmd = Get-Command py -ErrorAction SilentlyContinue
if ($pyCmd) {
  Write-Host "Found Python via 'py' command"
}
else {
  $pyCmd = Get-Command python -ErrorAction SilentlyContinue
  if ($pyCmd) {
    Write-Host "Found Python via 'python' command"
  }
  else {
    Write-Warning "Python was not found. Install Python and add it to PATH."
  }
}

if (-not $DefaultFolder) {
  $suggest = "D:\GitRepos"
  $DefaultFolder = Read-Host "Enter default Git folder [$suggest]"
  if (-not $DefaultFolder) { $DefaultFolder = $suggest }
}

Write-Host "Setting default Git folder..."
& "$installDir\git-loc.bat" set $DefaultFolder
Write-Host "Default Git folder set to $DefaultFolder"

Write-Host "`n=== Installation Complete ==="
Write-Host "Commands installed: gclone, gloco, gdc, git-loc"
Write-Host "Install directory: $installDir"
Write-Host "`nTesting if gclone is available..."
$gcloneTest = Get-Command gclone -ErrorAction SilentlyContinue
if ($gcloneTest) {
  Write-Host "gclone is available! Try it now: gclone --help"
}
else {
  Write-Host "gclone not found in current session. Try:"
  Write-Host "  1. Restart your terminal"
  Write-Host "  2. Or run: set PATH=%PATH%;$installDir"
  Write-Host "  3. Then test again: gclone --help"
  Write-Host "`nManual usage: You can always run directly:"
  Write-Host "  $installDir\gclone.bat <repo-url>"
}
Write-Host "`nFor help, run: gdc (menu) or git-loc docs"
