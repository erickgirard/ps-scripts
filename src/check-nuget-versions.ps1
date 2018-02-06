function Get-Nuget-Versions
{
    Param (
        [string] $name,
        [string] $path = "."
    )

    if(-not($name))
    {
        Write-Error "$name param is required"
    }

    $files = Get-ChildItem $path -Recurse -Filter "packages.config" | Foreach-Object{ $_.FullName }
    $versions = New-Object System.Collections.ArrayList

    foreach($file in $files)
    {
        [xml]$package = Get-Content -Path $file

        foreach($node in $package.packages.ChildNodes)
        {
            if($node.Attributes["id"].'#text' -eq $name) 
            {
                ($versions.Add("$($node.Attributes["id"].'#text') $($node.Attributes["version"].'#text') $($file)")) | Out-Null
            }
        }
    }

    foreach($version in $versions | Sort-Object)
    {
        Write-Host $version
    }
}
