# Generates assets/images/feature_graphic.png (1024x500)
# Usage: Run from project root (yds_app):
#   .\scripts\generate_feature_graphic.ps1

$png = Join-Path (Get-Location) "assets/images/feature_graphic.png"
$width = 1024
$height = 500

try {
    Add-Type -AssemblyName System.Drawing
    $bmp = New-Object System.Drawing.Bitmap $width, $height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

    $rect = New-Object System.Drawing.Rectangle 0,0,$width,$height
    $startColor = [System.Drawing.Color]::FromArgb(79,70,229)
    $endColor = [System.Drawing.Color]::FromArgb(6,182,212)
    $lnBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $startColor, $endColor, [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
    $g.FillRectangle($lnBrush, $rect)

    # Draw app name
    $font = New-Object System.Drawing.Font("Segoe UI",48,[System.Drawing.FontStyle]::Bold)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Near
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

    $textRect = New-Object System.Drawing.RectangleF 40,80,700,300
    $whiteBrush = [System.Drawing.Brushes]::White
    $g.DrawString("YDS 1000 Kelime", $font, $whiteBrush, $textRect, $sf)

    # Draw tagline
    $font2 = New-Object System.Drawing.Font("Segoe UI",20,[System.Drawing.FontStyle]::Regular)
    $tagRect = New-Object System.Drawing.RectangleF 40,160,700,300
    $g.DrawString("Spaced Repetition ile İngilizce Kelime Öğrenin", $font2, $whiteBrush, $tagRect, $sf)

    # Draw a rounded rectangle mock of phone with app icon on the right
    $iconRect = New-Object System.Drawing.Rectangle 760,100,200,200
    $g.FillRectangle([System.Drawing.Brushes]::White, $iconRect)
    $smallFont = New-Object System.Drawing.Font("Segoe UI",48,[System.Drawing.FontStyle]::Bold)
    $sfCenter = New-Object System.Drawing.StringFormat
    $sfCenter.Alignment = [System.Drawing.StringAlignment]::Center
    $sfCenter.LineAlignment = [System.Drawing.StringAlignment]::Center
    $iconRectF = New-Object System.Drawing.RectangleF 760.0,100.0,200.0,200.0
    $g.DrawString("YDS", $smallFont, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(79,70,229))), $iconRectF, $sfCenter)

    $bmp.Save($png, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Feature graphic created at: $png"
} catch {
    Write-Host "Failed to create feature graphic: $_" -ForegroundColor Red
    exit 1
}
