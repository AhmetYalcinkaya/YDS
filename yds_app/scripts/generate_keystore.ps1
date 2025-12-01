# PowerShell script to generate Android keystore for release signing
# Usage: Open PowerShell in project root (yds_app) and run:
#   .\scripts\generate_keystore.ps1

param(
    [string]$storePassword = "yds@2024secure",
    [string]$keyPassword = "yds@2024secure"
)

$keystorePath = "yds-release-key.jks"
$keyAlias = "yds_key"
$validity = 10000

# Check if keystore already exists
if (Test-Path $keystorePath) {
    Write-Host "Keystore already exists at: $keystorePath" -ForegroundColor Yellow
    Write-Host "Skipping keystore generation."
    exit 0
}

Write-Host "Generating Android release keystore..."

# Try to find keytool in various locations
$keytoolPaths = @(
    "C:\Program Files\Java\jdk*\bin\keytool.exe",
    "C:\Program Files (x86)\Java\jdk*\bin\keytool.exe",
    "${env:JAVA_HOME}\bin\keytool.exe",
    "keytool.exe"
)

$keytool = $null

foreach ($path in $keytoolPaths) {
    $matches = Get-Item -Path $path -ErrorAction SilentlyContinue
    if ($matches) {
        $keytool = $matches[0].FullName
        break
    }
}

if (-not $keytool) {
    Write-Host "ERROR: keytool not found. Please install Java JDK or set JAVA_HOME environment variable." -ForegroundColor Red
    exit 1
}

Write-Host "Found keytool at: $keytool"

try {
    & $keytool -genkey -v `
        -keystore $keystorePath `
        -keyalg RSA `
        -keysize 2048 `
        -validity $validity `
        -alias $keyAlias `
        -dname "CN=YDS App, O=YDS, L=Istanbul, S=Istanbul, C=TR" `
        -storepass $storePassword `
        -keypass $keyPassword

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Keystore generated successfully!" -ForegroundColor Green
        Write-Host "Keystore file: $keystorePath"
        Write-Host "Store password: $storePassword"
        Write-Host "Key password: $keyPassword"
        Write-Host "Key alias: $keyAlias"
        Write-Host ""
        Write-Host "IMPORTANT: Keep this keystore file safe. Back it up before publishing."
        Write-Host "The passwords have been stored in android/key.properties"
        exit 0
    } else {
        Write-Host "Failed to generate keystore" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
}
