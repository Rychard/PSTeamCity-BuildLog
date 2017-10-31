$projectRoot = Resolve-Path "${PSScriptRoot}\.."
$moduleRoot = Split-Path (Resolve-Path "${projectRoot}\**\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "${moduleName}.psm1") -Force

Describe 'Import-TeamCityProperty' {
    InModuleScope $moduleName {
        $xml = '<?xml version="1.0" ?><properties><entry key="sample.property">test</entry></properties>'
        $expectedJson = @{ 'TeamCity.sample.property' = 'test' } | ConvertTo-Json
        $xmlPath = "${TestDrive}\\input.xml"
        Set-Content -Path $xmlPath -Value $xml

        It 'Reads values from XML' {
            $expectedJson = @{ 'TeamCity.sample.property' = 'test' } | ConvertTo-Json
            Import-TeamCityProperty -File $xmlPath -Force | ConvertTo-Json | Should Be $expectedJson
        }

        It 'Sets variables' {
            Mock Set-Variable { }
            Import-TeamCityProperty -File $xmlPath -Force
            Assert-MockCalled -CommandName Set-Variable
        }

        It 'Can suppress output' {
            Import-TeamCityProperty -File $xmlPath -Force -Quiet | Should Be $null
        }

        It 'Allows custom prefix' {
            $expectedJson = @{ 'Custom.sample.property' = 'test' } | ConvertTo-Json
            Import-TeamCityProperty -File $xmlPath -Force -Prefix "Custom." | ConvertTo-Json | Should Be $expectedJson
        }
    }
}