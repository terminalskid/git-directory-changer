$installDir = "$env:USERPROFILE\.gitloc\bin"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Copy python script
Copy-Item ".\git-loc.py" "$installDir\git-loc.py" -Force

# Create Windows .bat wrappers
Set-Content "$installDir\git-loc.bat" "@echo off`npython `"$installDir\git-loc.py`" %*"
Set-Content "$installDir\gclone.bat" "@echo off`npython `"$installDir\git-loc.py`" gclone %*"
Set-Content "$installDir\gloco.bat" "@echo off`npython `"$installDir\git-loc.py`" gloco %*"

# Add PowerShell aliases to user profile
$profileFile = $PROFILE
if (!(Test-Path $profileFile)) {
    New-Item -ItemType File -Force -Path $profileFile
}
$aliases = @(
    "Set-Alias gloco `"$installDir\gloco.bat`"",
    "Set-Alias gclone `"$installDir\gclone.bat`"",
    "Set-Alias git-loc `"$installDir\git-loc.bat`""
)
$content = Get-Content $profileFile -ErrorAction SilentlyContinue
foreach ($alias in $aliases) {
    if ($content -notcontains $alias) {
        Add-Content $profileFile $alias
    }
}

# Check Python
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Warning "Python is not on PATH. Add Python to PATH for gclone/gloco to work."
}

Write-Host "Git Location Changer installed with gclone and gloco. Restart terminal to use commands."
