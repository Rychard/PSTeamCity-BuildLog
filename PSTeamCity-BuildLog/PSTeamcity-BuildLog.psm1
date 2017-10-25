Set-StrictMode -Version Latest

#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
@($Public + $Private) | ForEach-Object {
    $fileToImport = $_
    Try
    {
        . $fileToImport.FullName
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($fileToImport.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName