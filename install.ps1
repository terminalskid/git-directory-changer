$installDir = "$env:USERPROFILE\.gitloc\bin"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Copy git-loc.py
Copy-Item ".\git-loc.py" "$installDir\git-loc.py" -Force

# Batch shim for git-loc
$shim = "@echo off`npython `"$installDir\git-loc.py`" %*"
Set-Content "$installDir\git-loc.bat" $shim

# Batch shim for gclone
$gcloneShim = "@echo off`npython `"$installDir\git-loc.py`" gclone %*"
Set-Content "$installDir\gclone.bat" $gcloneShim

# Batch shim for gloco
$glocoShim = "@echo off`npython `"$installDir\git-loc.py`" gloco %*"
Set-Content "$installDir\gloco.bat" $glocoShim

# Add installDir to PATH if missing
$oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($oldPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$oldPath;$installDir", "User")
}

Write-Host "Git Location Changer installed with gclone and gloco. Restart terminal."
