# always clone into default folder
$env:GIT_DEFAULT = "D:\GitRepos"

function gclone {
    param([string]$url)
    cd $env:GIT_DEFAULT
    git clone $url
}
