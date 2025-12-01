# Prepare store screenshots: resize to 1242x2208 and organize
[Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null
[Reflection.Assembly]::LoadWithPartialName('System.Drawing.Imaging') | Out-Null

$sourceDir = ".\assets\screenshot"
$targetDir = ".\store_screenshots\android\phone"
$targetWidth = 1242
$targetHeight = 2208

# Create target directory if it doesn't exist
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Write-Host "Created directory: $targetDir"
}

# Get all PNG files and process them
$pngFiles = Get-ChildItem -Path $sourceDir -Filter *.png | Sort-Object Name
$fileCount = 0

foreach ($file in $pngFiles) {
    try {
        $fileCount++
        $outputName = "android_phone_{0:D2}.png" -f $fileCount
        $outputPath = Join-Path $targetDir $outputName
        
        # Load original image
        $originalImage = New-Object System.Drawing.Bitmap($file.FullName)
        $originalWidth = $originalImage.Width
        $originalHeight = $originalImage.Height
        
        # Create resized bitmap with white background
        $resizedBitmap = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight)
        $resizedBitmap.SetResolution($originalImage.HorizontalResolution, $originalImage.VerticalResolution)
        
        # Fill with white background
        $graphics = [System.Drawing.Graphics]::FromImage($resizedBitmap)
        $graphics.Clear([System.Drawing.Color]::White)
        
        # Calculate scaling to fit within 1242x2208 while maintaining aspect ratio
        $scaleX = $targetWidth / $originalWidth
        $scaleY = $targetHeight / $originalHeight
        $scale = [Math]::Min($scaleX, $scaleY)
        
        $newWidth = [int]($originalWidth * $scale)
        $newHeight = [int]($originalHeight * $scale)
        
        # Center the scaled image
        $x = [int](($targetWidth - $newWidth) / 2)
        $y = [int](($targetHeight - $newHeight) / 2)
        
        # Draw the original image scaled
        $graphics.DrawImage($originalImage, $x, $y, $newWidth, $newHeight)
        $graphics.Dispose()
        
        # Save as JPEG without encoder params (simpler approach)
        $jpegOutputPath = $outputPath -replace '\.png$', '.jpg'
        $resizedBitmap.Save($jpegOutputPath)
        $resizedBitmap.Dispose()
        $originalImage.Dispose()
        
        $msg = "Resized $($file.Name) to $($outputName -replace '\.png$', '.jpg') (${newWidth}x${newHeight})"
        Write-Host "OK: $msg"
    } catch {
        Write-Host "ERROR processing $($file.Name): $_"
    }
}

Write-Host "Done: $fileCount files processed and saved to $targetDir"
