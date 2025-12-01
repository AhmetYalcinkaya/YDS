#!/bin/bash
# iOS setup helper script (run on macOS)
# Usage: ./scripts/ios_setup.sh

set -e

echo "========================================"
echo "YDS App - iOS Setup Helper"
echo "========================================"
echo ""

# Check if on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "ERROR: This script must be run on macOS"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter not found. Please install Flutter."
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcode-select &> /dev/null; then
    echo "ERROR: Xcode not found. Please install Xcode from App Store."
    exit 1
fi

echo "[1/5] Checking dependencies..."
flutter doctor

echo ""
echo "[2/5] Installing CocoaPods dependencies..."
cd ios
pod install --repo-update
cd ..

echo ""
echo "[3/5] Building for iOS (development)..."
flutter build ios --debug

echo ""
echo "[4/5] To build release IPA for App Store:"
echo "      flutter build ipa --release"
echo ""
echo "[5/5] Next steps:"
echo "      1. Open ios/Runner.xcworkspace in Xcode"
echo "      2. Go to Signing & Capabilities"
echo "      3. Set Team ID from Apple Developer Account"
echo "      4. Build and archive for distribution"
echo "      5. Upload to App Store Connect"
echo ""
echo "For more details, see IOS_SETUP.md"
