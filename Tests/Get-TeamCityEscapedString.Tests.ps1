$projectRoot = Resolve-Path "${PSScriptRoot}\.."
$moduleRoot = Split-Path (Resolve-Path "${projectRoot}\**\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "${moduleName}.psm1") -Force

Describe "Get-TeamCityEscapedString" {
    $characterEscapeMap = @(
        @{ Name = 'Pipe'; Character = '|'; Escaped = '||'; },
        @{ Name = 'Single-Quote'; Character = "'"; Escaped = "|'"; },
        @{ Name = 'Carriage Return'; Character = '\r'; Escaped = '|r'; },
        @{ Name = 'Line Feed'; Character = '\n'; Escaped = '|n'; },
        @{ Name = 'Square Bracket (Open)'; Character = '['; Escaped = '|['; },
        @{ Name = 'Square Bracket (Close)'; Character = ']'; Escaped = '|]'; }
    )

    It 'Escapes <Name>' -TestCases $characterEscapeMap {
        Param($Name, $Character, $Escaped)
        $Character | Get-TeamCityEscapedString | Should Be $Escaped
    }

    It 'Accepts input from parameters' {
        Get-TeamCityEscapedString -String "test" | Should Be "test"
    }

    It 'Accepts input from pipeline' {
        "test" | Get-TeamCityEscapedString | Should Be "test"
    }
}