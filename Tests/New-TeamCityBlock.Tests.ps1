$projectRoot = Resolve-Path "${PSScriptRoot}\.."
$moduleRoot = Split-Path (Resolve-Path "${projectRoot}\**\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "${moduleName}.psm1") -Force

Describe 'New-TeamCityBlock' {
    InModuleScope $moduleName {
    
        Context 'Inside TeamCity' {
            Mock Test-TeamCity { Write-Output $true }
    
            It 'Starts a new block' {
                New-TeamCityBlock -Name 'test' | Should Be "##teamcity[blockOpened name='test']"
            }
    
            It 'Starts a new block with description' {
                New-TeamCityBlock -Name 'test' -Description 'description' | Should Be "##teamcity[blockOpened name='test' description='description']"
            }

            It 'Does not fail with empty pipeline' {
                Out-Null | New-TeamCityBlock | Should Be $null
            }
        }
    
        Context 'Outside TeamCity' {
            Mock Test-TeamCity { Write-Output $false }
    
            It 'Given name, emit no output' {
                New-TeamCityBlock -Name 'test' | Should Be $null
            }
    
            It 'Given name and description, emit no output' {
                New-TeamCityBlock -Name 'test' -Description 'description' | Should Be $null
            }

            It 'Forcibly starts a new block' {
                New-TeamCityBlock -Name 'test' -Force | Should Be "##teamcity[blockOpened name='test']"
            }
    
            It 'Forcibly starts a new block with description' {
                New-TeamCityBlock -Name 'test' -Description 'description' -Force | Should Be "##teamcity[blockOpened name='test' description='description']"
            }

            It 'Does not fail with empty pipeline' {
                Out-Null | New-TeamCityBlock | Should Be $null
            }
        }
    }
}