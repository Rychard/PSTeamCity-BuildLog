$projectRoot = Resolve-Path "${PSScriptRoot}\.."
$moduleRoot = Split-Path (Resolve-Path "${projectRoot}\**\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf
$moduleImport = Join-Path $moduleRoot "${moduleName}.psm1"

Remove-Module PSTeamCity-BuildLog
Import-Module $moduleImport -Force

Describe 'Import-TeamCityProperty' {
    InModuleScope $moduleName {
        $xml = '<?xml version="1.0" ?><properties><entry key="sample.property">test</entry></properties>'
        $expectedJson = @{ 'TeamCity.sample.property' = 'test' } | ConvertTo-Json
        $xmlPath = "${TestDrive}\input.xml"
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

        It 'Reads values from nested property files' {
            $propPath = "${TestDrive}\input2"
            $xmlPath2 = "${propPath}.xml"
            $xml2 = '<?xml version="1.0" ?><properties><entry key="nested.property">test</entry></properties>'
            Set-Content -Path $xmlPath2 -Value $xml2
            
            $xmlPath = "${TestDrive}\input.xml"
            $xml = "<?xml version=`"1.0`" ?><properties><entry key=`"sample.properties.file`">${propPath}</entry></properties>"
            Set-Content -Path $xmlPath -Value $xml

            $expectedJson = @{ 
                'TeamCity.nested.property' = 'test'
                'TeamCity.sample.properties.file' = $propPath
            } | ConvertTo-Json
            Import-TeamCityProperty -File $xmlPath -Recurse -Force | ConvertTo-Json | Should Be $expectedJson
        }
    }
}