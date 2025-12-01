# Generates assets/images/app_icon.png from assets/images/app_icon.svg
# Usage: Open PowerShell in project root (yds_app) and run:
#   .\scripts\generate_app_icon.ps1

$svg = "assets/images/app_icon.svg"
# Ensure output path is relative to current working directory (where script is run)
$png = Join-Path (Get-Location) "assets/images/app_icon.png"

if (Test-Path $svg) {
    Write-Host "Found SVG: $svg"

    # Try Inkscape
    $inkscape = "inkscape"
    $magick = "magick"

    $inkscapeAvailable = $false
    $magickAvailable = $false

    try {
        $proc = Get-Command $inkscape -ErrorAction Stop
        $inkscapeAvailable = $true
    } catch {}

    try {
        $proc = Get-Command $magick -ErrorAction Stop
        $magickAvailable = $true
    } catch {}

    if ($inkscapeAvailable) {
        Write-Host "Using Inkscape to export PNG..."
        inkscape $svg --export-filename=$png --export-width=1024 --export-height=1024
        Write-Host "PNG created: $png"
        exit 0
    }

    if ($magickAvailable) {
        Write-Host "Using ImageMagick (magick) to convert SVG..."
        magick $svg -resize 1024x1024 $png
        Write-Host "PNG created: $png"
        exit 0
    }

    Write-Host "No Inkscape or ImageMagick found. Creating a 1x1 transparent placeholder PNG."

        # Try System.Drawing fallback to generate a basic 1024x1024 PNG (Windows PowerShell/.NET Framework)
        try {
            Add-Type -AssemblyName System.Drawing
            $width = 1024
            $height = 1024
            $bmp = New-Object System.Drawing.Bitmap $width, $height
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $rect = New-Object System.Drawing.Rectangle 0,0,$width,$height
            $rectF = New-Object System.Drawing.RectangleF 0.0,0.0,$width,$height
            $startColor = [System.Drawing.Color]::FromArgb(79,70,229)
            $endColor = [System.Drawing.Color]::FromArgb(6,182,212)
            $lnBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $startColor, $endColor, [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal)
            $g.FillRectangle($lnBrush, $rect)
            $font = New-Object System.Drawing.Font("Segoe UI",200,[System.Drawing.FontStyle]::Bold)
            $sf = New-Object System.Drawing.StringFormat
            $sf.Alignment = [System.Drawing.StringAlignment]::Center
            $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
            $whiteBrush = [System.Drawing.Brushes]::White
            $g.DrawString("YDS", $font, $whiteBrush, $rectF, $sf)
            $bmp.Save($png, [System.Drawing.Imaging.ImageFormat]::Png)
            $g.Dispose()
            $bmp.Dispose()
            Write-Host "Generated PNG using System.Drawing at: $png"
            exit 0
        } catch {
            Write-Host "System.Drawing fallback failed: $_"
        }

    $base64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8Xw8AAr8B9pVwKQAAAABJRU5ErkJggg=="
    $bytes = [System.Convert]::FromBase64String($base64)
    [System.IO.File]::WriteAllBytes($png, $bytes)
    Write-Host "Placeholder PNG created at: $png"
    Write-Host "To produce a high-quality PNG, install Inkscape or ImageMagick and re-run this script."
} else {
    Write-Host "SVG not found at $svg. Please ensure assets/images/app_icon.svg exists." -ForegroundColor Red
    exit 1
}
