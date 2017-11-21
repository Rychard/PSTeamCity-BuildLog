$projectRoot = Resolve-Path "${PSScriptRoot}\.."
$moduleRoot = Split-Path (Resolve-Path "${projectRoot}\**\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "${moduleName}.psm1") -Force

Describe 'Remove-TeamCityBlock' {
    InModuleScope $moduleName {
    
        Context 'Inside TeamCity' {
            Mock Test-TeamCity { Write-Output $true }
    
            It 'Closes a block' {
                Remove-TeamCityBlock -Name 'test' | Should Be "##teamcity[blockClosed name='test']"
            }

            It 'Does not fail with empty pipeline' {
                Out-Null | Remove-TeamCityBlock | Should Be $null
            }
        }
    
        Context 'Outside TeamCity' {
            Mock Test-TeamCity { Write-Output $false }
    
            It 'Emits no output' {
                Remove-TeamCityBlock -Name 'test' | Should Be $null
            }
    
            It 'Forcibly closes a block' {
                Remove-TeamCityBlock -Name 'test' -Force | Should Be "##teamcity[blockClosed name='test']"
            }

            It 'Does not fail with empty pipeline' {
                Out-Null | Remove-TeamCityBlock | Should Be $null
            }
        }
    }
}