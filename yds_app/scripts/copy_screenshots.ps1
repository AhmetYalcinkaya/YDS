$sourceDir = ".\assets\screenshot"
$targetDir = ".\store_screenshots\android\phone"

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
Write-Host "Created directory: $targetDir"

$pngFiles = Get-ChildItem -Path $sourceDir -Filter *.png | Sort-Object Name
$i = 1
foreach ($file in $pngFiles) {
    $outputName = "android_phone_{0:D2}.png" -f $i
    $outputPath = Join-Path $targetDir $outputName
    Copy-Item -Path $file.FullName -Destination $outputPath -Force
    Write-Host "Copied: $($file.Name) -> $outputName"
    $i++
}
Write-Host "Done: $($i-1) screenshots copied to $targetDir"
