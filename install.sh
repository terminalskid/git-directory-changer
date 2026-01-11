$installDir = "$env:USERPROFILE\.gitloc\bin"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

Copy-Item ".\git-loc.py" "$installDir\git-loc.py" -Force

# Batch shim for git-loc
$shim = "@echo off`npython `"$installDir\git-loc.py`" %*"
Set-Content "$installDir\git-loc.bat" $shim

# Batch shim for gclone
$gcloneShim = "@echo off`npython `"$installDir\git-loc.py`" gclone %*"
Set-Content "$installDir\gclone.bat" $gcloneShim

# Add to PATH if missing
$oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($oldPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$oldPath;$installDir", "User")
}

Write-Host "Git Location Changer installed with gclone. Restart terminal."
