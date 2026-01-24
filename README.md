# Git Directory Changer

A small cross‑platform helper that clones all repositories into your preferred folder. Set it once, then use a single command to clone into that folder every time.

## Features

- Set a default folder for all Git repositories
- Works on Windows (PowerShell) and Linux/macOS (bash/zsh)
- Provides `gclone` and `gloco` convenience commands
- Persists across terminal sessions

## Install

### Windows (PowerShell)

```
git clone https://github.com/terminalskid/git-directory-changer.git
cd git-directory-changer
.\install.ps1
```

Enter a default folder when prompted (e.g. `D:\GitRepos`). The installer places wrappers in `%USERPROFILE%\.gitloc\bin` and adds that directory to PATH.

### Linux / macOS (bash or zsh)

```
git clone https://github.com/terminalskid/git-directory-changer.git
cd git-directory-changer
bash install.sh
```

Enter a default folder when prompted (default `~/GitRepos`). The installer places wrappers in `~/.gitloc/bin` and appends that directory to PATH in your shell rc file.

## Usage

- Clone into the default folder:

```
gclone https://github.com/username/repo.git
```

- Show the current default folder:

```
gloco
```

- Set or change the default folder:

```
git-loc set /path/to/folder
```

- Reset configuration:

```
git-loc reset
```

## Notes

- Requires Python. The installers detect `python3`/`python` on Unix and `py`/`python` on Windows.
- Commands become available in new shells after installation; the installer also updates PATH for the current session.
