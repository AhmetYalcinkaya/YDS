# Store Submission Checklist & Assets

## Google Play Store Requirements

### App Content & Metadata

- [ ] **App Name**: YDS 1000 Kelime
- [ ] **Short Description** (80 chars max):
  > Learn 1000 essential English words with spaced repetition

- [ ] **Full Description** (4000 chars max):
  > YDS 1000 Kelime is a comprehensive English vocabulary learning app designed to help you master 1000 essential English words for YDS (Yabancı Dil Sınavı) and general English proficiency.
  >
  > Key Features:
  > - Spaced Repetition Algorithm: Optimized learning schedule based on scientific research
  > - 1000 Core Vocabulary Words: Covering YDS level requirements
  > - Example Sentences: Each word includes real-world usage examples
  > - Audio Pronunciation: Hear native speaker pronunciation
  > - Progress Tracking: Track your learning journey with detailed statistics
  > - Customizable Daily Goals: Set your own learning targets
  > - Favorites List: Save and prioritize words you find challenging
  > - Clean, Intuitive Interface: Learn without distractions
  >
  > Learning Experience:
  > - Review words at the optimal time based on your memory
  > - Earn streaks for consistent daily learning
  > - See your progress with charts and statistics
  > - Export/manage your learning data
  >
  > Perfect for:
  > - YDS exam preparation
  > - TOEFL/IELTS learners
  > - English language students
  > - Professionals improving their English
  >
  > Start learning today and master essential English vocabulary!

- [ ] **Category**: Education (or Reference)
- [ ] **Content Rating**: Everyone / 4+
- [ ] **Permissions**: Confirm usage (see Permissions section below)

### Graphics & Screenshots

#### Phone Screenshots (Required)
- [ ] **5-7 screenshots** of actual app in use
- **Dimensions**: 1080 x 1920 pixels (portrait)
- **File format**: PNG or JPG
- **Suggested screenshots**:
  1. Main study screen / word card
  2. Progress statistics
  3. Favorites list
  4. Daily streak counter
  5. Example sentence/translation
  6. Settings screen
  7. Achievements/stats overview

#### Feature Graphic (Required)
- [ ] **Dimensions**: 1024 x 500 pixels
- [ ] Show app name "YDS 1000 Kelime" prominently
- [ ] Highlight key feature: "Spaced Repetition Learning"
- [ ] Professional, attractive design

#### App Icon (Already Created)
- [ ] **Size**: 512 x 512 pixels minimum
- [ ] **File**: Already set in `assets/images/app_icon.png`
- [ ] Used by launcher icons generation

#### Optional: App Preview Video
- [ ] **Duration**: 15-30 seconds
- [ ] Show key app features in action
- [ ] Can be added later

### Privacy & Compliance

- [ ] **Privacy Policy**: Create and host online
  - Required URL format: https://yoursite.com/privacy-policy
  - Must address data collection, usage, and retention
  - See template below

- [ ] **Terms of Service** (optional but recommended)
  - https://yoursite.com/terms

- [ ] **Content Declarations**:
  - Are you collecting user data? → Yes (if analytics used)
  - What data? → Usage analytics, progress tracking
  - Is it personal? → No (anonymized)
  - Is it required for app functionality? → Yes
  - Do you share it with third parties? → No

### Permissions

- [ ] Verify `AndroidManifest.xml` permissions:
  - Internet: `android.permission.INTERNET`
  - Storage: Only if exporting (optional)
  - Audio: `android.permission.RECORD_AUDIO` (if using TTS microphone)

- [ ] **Example permissions in AndroidManifest.xml**:
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  ```

### Release Notes

- [ ] **Version 1.0.0 Release Notes**:
  > Initial release
  > - 1000 core English vocabulary words
  > - Spaced repetition learning algorithm
  > - Progress tracking and statistics
  > - Customizable daily learning goals
  > - Favorites and study history

### Ratings & Questionnaire

- [ ] Content Ratings: Fill questionnaire (likely "Everyone" category)
- [ ] Target age: 4+ or 12+
- [ ] Violence, adult content, etc.: No

---

## App Store (iOS) Requirements

### Metadata

- [ ] **App Name**: YDS 1000 Kelime
- [ ] **Subtitle**: Learn English Vocabulary (30 chars max)
- [ ] **Description**: (Same as Google Play, adjusted formatting)
- [ ] **Keywords**: vocabulary, English, learning, YDS, education, English words, spaced repetition

### Screenshots

- [ ] **iPhone Screenshots**:
  - 5.5" display: 1242 x 2208 pixels (portrait)
  - 6.5" display: 1242 x 2688 pixels (portrait)
  - Include 2-5 screenshots
  - Same key screens as Google Play

- [ ] **iPad Screenshots** (optional):
  - 2048 x 2732 pixels
  - 1536 x 2048 pixels

### App Icon & Branding

- [ ] **App Icon**: 1024 x 1024 pixels (already created)
- [ ] **Supported Devices**: iPhone, iPad
- [ ] **Minimum OS**: iOS 12.0+

### Privacy

- [ ] **Privacy Policy URL**: (same as above)
- [ ] **Privacy Practices**:
  - Declare what data you collect
  - Track data for analytics

### Contact Information

- [ ] **Support URL**: (if applicable)
- [ ] **Privacy Policy URL**: (must provide)
- [ ] **Marketing URL**: (optional)

---

## Privacy Policy Template

```markdown
# Privacy Policy - YDS 1000 Kelime

**Last Updated**: December 2024

## Overview
YDS 1000 Kelime ("App") is committed to protecting your privacy. This policy explains our practices.

## Data Collection
We collect:
- **Usage Data**: Lessons completed, words studied, time spent
- **Device Info**: Device type, OS version, app version
- **Analytics**: General app performance and feature usage

We do NOT collect:
- Personal identification information (names, emails, addresses)
- Financial information
- Location data
- Contacts or calendar data

## Data Usage
Collected data is used to:
- Improve app functionality and user experience
- Provide personalized learning recommendations
- Track and display your progress
- Fix bugs and improve performance
- Understand feature usage

## Data Sharing
We do NOT sell or share your data with third parties.

## Data Storage
Data is stored locally on your device and synced with our secure servers (if applicable).

## Your Rights
You can:
- Delete your account and all data
- Export your learning data
- Contact us for data requests

## Children's Privacy
This app may be used by children. We don't knowingly collect personal information from children under 13.

## Changes to Policy
We may update this policy. Changes will be posted here.

## Contact
For privacy questions: privacy@ydsapp.com

---
```

---

## Pre-Submission Checklist

### Technical
- [ ] App builds successfully: `flutter build appbundle --release` ✓
- [ ] App runs without crashes on emulator/device
- [ ] All permissions requested appropriately
- [ ] No hardcoded test/debug values
- [ ] App follows platform guidelines

### Content
- [ ] App name is appropriate and not trademarked
- [ ] Screenshots are accurate and professional
- [ ] Descriptions are clear and honest
- [ ] No misleading claims about features

### Legal
- [ ] Privacy policy is comprehensive
- [ ] Terms of service (if applicable)
- [ ] Proper licensing of assets (icons, images, fonts)
- [ ] No unauthorized use of third-party content

### Store Setup
- [ ] Google Play Developer account created ($25 one-time)
- [ ] Apple Developer account created ($99/year)
- [ ] Test accounts for internal testing created
- [ ] Beta testing groups configured (optional)

---

## Submission Steps

### Google Play Store

1. Go to Google Play Console: https://play.google.com/console
2. Create new app
3. Fill in app details (all sections above)
4. Upload AAB: `build/app/outputs/bundle/release/app-release.aab`
5. Add screenshots and feature graphic
6. Set pricing and distribution (Free or Paid)
7. Fill content rating questionnaire
8. Add privacy policy URL
9. Review and submit for moderation (usually 2-4 hours)

### App Store

1. Go to App Store Connect: https://appstoreconnect.apple.com
2. Create new app
3. Fill in app information
4. Upload build via Xcode or TestFlight
5. Add screenshots
6. Set pricing
7. Add privacy policy
8. Submit for review (usually 24-48 hours)

---

## Recommended Tools

- **Screenshot Design**: Figma, Canva, or Adobe Lightroom
- **Privacy Policy Generator**: https://www.freeprivacypolicy.com/
- **Screenshots Capture**: Built-in device screenshots
- **Video Recording**: Android Studio emulator screen recording or Camtasia

