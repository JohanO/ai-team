<#
.SYNOPSIS
Installs the AI team commands globally (~/.claude/commands).

.DESCRIPTION
Reads the template commands in .claude/commands (people/, workflows/ and team.md),
flattens them so they are available as /alice, /bob, /feature etc., and rewrites
the relative file references to absolute paths into this repo.
Re-run after editing a template command.
#>
[CmdletBinding()]
param(
    [string]$Destination = (Join-Path $HOME '.claude\commands')
)

$ErrorActionPreference = 'Stop'

$repoRoot = $PSScriptRoot
$source = Join-Path $repoRoot '.claude\commands'
$rootForward = $repoRoot -replace '\\', '/'

New-Item -ItemType Directory -Force $Destination | Out-Null

Get-ChildItem $source -Recurse -Filter *.md | ForEach-Object {
    $text = (Get-Content $_.FullName -Raw) -replace '(?m)^- ([\w./-]+\.md)[ \t]*(\r?)$', "- $rootForward/`$1`$2"

    # Fail early on references that don't exist in the repo
    [regex]::Matches($text, '(?m)^- (' + [regex]::Escape($rootForward) + '/\S+\.md)') | ForEach-Object {
        if (-not (Test-Path $_.Groups[1].Value)) {
            Write-Warning "$($_.Groups[1].Value) is referenced but does not exist"
        }
    }

    Set-Content -Path (Join-Path $Destination $_.Name) -Value $text -NoNewline -Encoding utf8
    Write-Host "Installed /$($_.BaseName)"
}
