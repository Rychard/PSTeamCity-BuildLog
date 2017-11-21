[CmdletBinding(PositionalBinding=$false)]
Param(
)

$PathModule = '.\PSTeamCity-BuildLog'
$PathTests = '.\Tests'

if(-not (Get-Module -Name PSScriptAnalyzer)) {
    Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser
}

Invoke-ScriptAnalyzer -Path $PathModule -Recurse

Invoke-Pester