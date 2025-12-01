# iOS Signing & Provisioning Setup

## Prerequisites

- Apple Developer Account (paid, $99/year)
- macOS machine with Xcode (for final signing and IPA generation)
- Mac provisioning (can be done on Windows via terminal, but full IPA build requires macOS)

## Step 1: Apple Developer Account

1. Go to https://developer.apple.com/account/
2. Sign in with your Apple ID
3. If new, enroll in Apple Developer Program ($99/year)

## Step 2: Create App ID

1. Go to Certificates, Identifiers & Profiles → Identifiers
2. Click "+" to create new Identifier
3. Select "App IDs"
4. Fill in:
   - App Type: App
   - Description: "YDS 1000 Kelime"
   - Bundle ID: "com.yds.app" (match Android applicationId pattern)
5. Keep Capabilities as default
6. Click Register

## Step 3: Create Signing Certificate

1. Go to Certificates, Identifiers & Profiles → Certificates
2. Click "+" to create new Certificate
3. Select "Apple Distribution" (for App Store)
4. Follow the guide:
   - Create Certificate Signing Request (CSR) on your Mac
   - Upload CSR
   - Download certificate (.cer)
5. Double-click to import into Keychain

### On Mac (to create CSR):
```bash
# Open Keychain Access → Certificate Assistant → Request a Certificate
# Or use command line:
# (Usually done via Xcode or Keychain Access GUI)
```

## Step 4: Create Provisioning Profile

1. Go to Profiles
2. Click "+" to create new Profile
3. Select "App Store"
4. Choose your App ID (com.yds.app)
5. Select your Distribution Certificate
6. Enter Profile Name: "YDS-Distribution"
7. Download and double-click to install

## Step 5: Xcode Configuration (on macOS)

Open project in Xcode on your Mac:

```bash
open ios/Runner.xcworkspace
```

### Configure Signing & Capabilities:

1. Select "Runner" target
2. Go to Signing & Capabilities tab
3. Set Team ID (from Apple Developer Account)
4. Bundle Identifier: "com.yds.app"
5. Ensure Distribution Certificate is selected

## Step 6: Update iOS Project Files

Ensure `ios/Runner/Info.plist` has:
- Bundle ID: `com.yds.app`
- Version: `1.0.0`
- Build: `1`

Already configured in this project.

## Step 7: Build for Distribution (on macOS)

```bash
cd ios
pod install --repo-update
cd ..

# Build IPA for App Store
flutter build ipa --release

# Or build for testing
flutter build ipa --release --export-options-template
```

## Step 8: Upload to App Store Connect

1. Go to https://appstoreconnect.apple.com/
2. Create new App
3. Fill in:
   - App Name: "YDS 1000 Kelime"
   - Bundle ID: "com.yds.app"
   - SKU (unique identifier)
4. Upload IPA using Xcode or Apple Transporter
5. Add app metadata (screenshots, description, etc.)
6. Submit for review

## Windows-based Development Flow

Since you're on Windows, here's the workflow:

1. **On macOS (if available):**
   - Clone repo
   - Run `flutter build ipa --release`
   - Upload to App Store Connect

2. **Alternative - Use GitHub Actions on macOS Runner:**
   - Commit code to GitHub
   - GitHub Actions with macOS runner builds and uploads IPA
   - See CI/CD section for example

3. **Manual on Windows:**
   - Prepare all configuration on Windows
   - Transfer code to macOS (cloud sync, GitHub, etc.)
   - Build and upload on Mac

## CI/CD Integration (Recommended)

Use GitHub Actions with macOS runner to automate iOS builds:

```yaml
name: Build iOS

on:
  push:
    tags:
      - 'v*'

jobs:
  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.13.0'
      
      - name: Install Pod Dependencies
        run: |
          cd ios
          pod install --repo-update
          cd ..
      
      - name: Build IPA
        run: flutter build ipa --release
      
      - name: Upload to App Store
        run: |
          xcrun altool --upload-app -f build/ios/ipa/yds_app.ipa \
            -t ios \
            -u ${{ secrets.APPLE_ID_EMAIL }} \
            -p ${{ secrets.APPLE_ID_PASSWORD }}
```

## Troubleshooting

### "Team ID not set"
- Go to Xcode → Signing & Capabilities
- Ensure Team is selected (not "None")

### "Provisioning Profile Doesn't Support Push Notifications"
- Edit Provisioning Profile in Developer Portal
- Check Capabilities

### "Certificate not trusted"
- Ensure you installed the certificate (double-click .cer in Keychain)
- Check that Distribution Certificate is selected in Xcode

### "Code Signing Style Automatic/Manual"
- In Xcode: Build Settings → Code Signing Style
- Set to "Automatic" for Xcode to manage
- Or set to "Manual" and specify exact certificate/profile

## References

- Apple Developer: https://developer.apple.com/account/
- App Store Connect: https://appstoreconnect.apple.com/
- Flutter iOS Deployment: https://flutter.dev/deployment/ios
- Code Signing Guide: https://developer.apple.com/support/code-signing/
