# Git Directory Changer

A tiny tool that makes Git always clone repositories into your preferred folder automatically. No more navigating to your favorite folder every time you run `git clone`.

## Features

Set a default folder for all your Git repositories  
Works on Windows (PowerShell) and Linux/macOS (bash/zsh)  
Adds a `gclone` command to your shell that automatically clones into your default folder  
Permanent setup and works across terminal sessions  
Easy to customize the default folder  

## Installation

### Windows PowerShell

Clone this repository and run the installer
```
git clone https://github.com/terminalskid/git-directory-changer.git  
cd git-directory-changer  
.\install.ps1
```
Restart PowerShell to apply changes  

By default repositories will be cloned into `D:\GitRepos`  
You can change this folder by editing the `$defaultFolder` variable inside `install.ps1` before running the installer  

### Linux / macOS bash or zsh

Clone this repository and run the installer

```

git clone https://github.com/terminalskid/git-directory-changer.git  
cd git-directory-changer  
bash install.sh
```
Restart your terminal to apply changes  

By default repositories will be cloned into `~/GitRepos`  
You can change this folder by editing the `GIT_DEFAULT` variable inside `install.sh` where it currently says ~~/GitRepos to whatever you want before running the installer  

## Usage

After installation use the `gclone` command to clone repositories into your default folder
```

gclone https://github.com/username/repo.git
```
Repositories are automatically cloned into your default folder  
No need to manually `cd` to the folder every time  

Optional: For new repositories you create with `git init` you can manually navigate to your default folder  
You can also add a `ginit` function in the installer scripts to initialize new repos automatically in your default folder  

## Customization

Change the default folder by editing the variables in the installer scripts  
Change function names by renaming `gclone` in the installer scripts  
Works with PowerShell bash or zsh Restart your shell after installation to apply changes  

## License

MIT License see LICENSE for details  

## Summary

This tool makes managing your Git repositories easier by enforcing a consistent folder structure and giving you a one-command clone setup  
Works cross-platform easy to customize and permanent across sessions
