# Android Keystore Setup Instructions

## IMPORTANT: Before Publishing to Google Play Store

You must generate an Android keystore (release key) to sign your app. Follow these steps:

### Step 1: Install Java JDK (if not already installed)

Download and install Java JDK 17 or newer from:
https://www.oracle.com/java/technologies/downloads/

### Step 2: Generate Keystore

Open PowerShell in this directory (yds_app) and run:

```powershell
.\scripts\generate_keystore.ps1
```

This will create `yds-release-key.jks` file and configure `android/key.properties`.

### Step 3: Verify Files

After running the script, ensure these files exist:
- `yds-release-key.jks` (in project root)
- `android/key.properties` (already created)

### Step 4: Secure Your Keystore

**CRITICAL**: Keep the keystore file and passwords safe:
1. Back up `yds-release-key.jks` to a secure location
2. Never commit `yds-release-key.jks` to version control (already in .gitignore)
3. Store passwords in a secure password manager

### Step 5: Build Release APK/AAB

After keystore is set up, you can build:

```bash
flutter build appbundle --release
```

or for APK:

```bash
flutter build apk --release
```

## CI/CD Integration

For GitHub Actions or other CI/CD systems:
1. Store `yds-release-key.jks` as a repository secret (base64 encoded)
2. Store passwords as secrets
3. Decode and use during build process

Example GitHub Actions setup:
```yaml
- name: Decode keystore
  run: echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > yds-release-key.jks
```

## Troubleshooting

If keytool is not found:
1. Verify Java JDK is installed: `java -version`
2. Ensure Java bin folder is in PATH
3. Or specify JAVA_HOME: `$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"`

## Reference

- Android Signing: https://developer.android.com/studio/publish/app-signing
- Keystore and Certificates: https://developer.android.com/studio/publish/app-signing#generate-key
