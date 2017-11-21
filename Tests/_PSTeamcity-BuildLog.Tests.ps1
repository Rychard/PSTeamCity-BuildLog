$projectRoot = Resolve-Path "${PSScriptRoot}\.."
$moduleRoot = Split-Path (Resolve-Path "${projectRoot}\**\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Describe "General project validation: ${moduleName}" {

    $scripts = Get-ChildItem -Path $projectRoot -Include *.ps1,*.psm1,*.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | ForEach-Object { 
        @{
            file = $_; 
            relative = (Resolve-Path -Path $_ -Relative);
        } 
    }
    It "Script <relative> should be valid powershell" -TestCases $testCase {
        Param($file, $relative)

        $file.FullName | Should Exist

        $contents = Get-Content -Path $file.FullName -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    It "Module '$moduleName' can import cleanly" {
        {Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -Force } | Should Not Throw
    }
}