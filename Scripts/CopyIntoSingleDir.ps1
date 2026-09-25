$SourceFolder = Split-Path -Path $PSScriptRoot -Parent
$DestinationFolder = Join-Path -Path $SourceFolder -ChildPath "All"

if (!(Test-Path -Path $DestinationFolder)) {
    New-Item -Path $DestinationFolder -ItemType Directory -Force | Out-Null
}

$Files = Get-ChildItem -Path $SourceFolder -Filter "*.IntLib" -Recurse -File | Where-Object { $_.DirectoryName -notmatch '\\All$' -and $_.DirectoryName -notmatch '\\All\\' }
foreach ($File in $Files) {
    $TargetFilePath = Join-Path -Path $DestinationFolder -ChildPath $File.Name
    
    if (Test-Path -Path $TargetFilePath) {
        $Counter = 1
        while (Test-Path -Path $TargetFilePath) {
            $NewName = "$($File.BaseName)_$Counter$($File.Extension)"
            $TargetFilePath = Join-Path -Path $DestinationFolder -ChildPath $NewName
            $Counter++
        }
    }
    
    Copy-Item -Path $File.FullName -Destination $TargetFilePath -Force
    Write-Host "Copied: $($File.Name) -> $TargetFilePath" -ForegroundColor Green
}

Write-Host "Extraction complete! Total files in All: $((Get-ChildItem -Path $DestinationFolder -Filter '*.IntLib' -File).Count)" -ForegroundColor Cyan
