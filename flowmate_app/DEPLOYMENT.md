# FlowMate - App Store Deployment Guide

This guide will walk you through deploying FlowMate to both Google Play Store and Apple App Store.

## 📋 Pre-Deployment Checklist

- [ ] App functionality is complete and tested
- [ ] App icons are created for all required sizes
- [ ] App name and bundle ID are finalized
- [ ] Privacy policy and terms of service are prepared
- [ ] App store screenshots are created
- [ ] App description and metadata are ready
- [ ] Test the app on real devices
- [ ] Run `flutter analyze` and `flutter test` with no errors

## 🤖 Google Play Store Deployment

### 1. Prepare for Release

1. **Update App Version**
   ```yaml
   # In pubspec.yaml
   version: 1.0.0+1  # Increment for each release
   ```

2. **Build Release APK/AAB**
   ```bash
   # For testing (APK)
   flutter build apk --release
   
   # For Play Store submission (AAB - recommended)
   flutter build appbundle --release
   ```

3. **Generate Signing Key** (First time only)
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

4. **Configure Key Properties**
   Create `android/key.properties`:
   ```properties
   storePassword=<password-from-previous-step>
   keyPassword=<password-from-previous-step>
   keyAlias=upload
   storeFile=<path-to-upload-keystore.jks>
   ```

5. **Update build.gradle**
   In `android/app/build.gradle`, add:
   ```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   android {
       ...
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

### 2. Google Play Console Setup

1. **Create Developer Account**
   - Go to [Google Play Console](https://play.google.com/console)
   - Pay $25 one-time registration fee
   - Complete account verification

2. **Create New App**
   - Click "Create app"
   - Choose app name: "FlowMate"
   - Select "App" as app type
   - Choose "Free" or "Paid"

3. **Upload App Bundle**
   - Go to "Release" → "Production"
   - Click "Create new release"
   - Upload your AAB file from `build/app/outputs/bundle/release/`

4. **Complete Store Listing**
   - **App Details**: Name, description, category
   - **Graphics**: Icon, screenshots, feature graphic
   - **Categorization**: Productivity
   - **Content Rating**: Complete questionnaire
   - **Target Audience**: Choose appropriate age groups
   - **Privacy Policy**: Add URL to your privacy policy

5. **Release Review**
   - Complete all required sections
   - Submit for review (typically 1-3 days)

## 🍎 Apple App Store Deployment

### 1. Prerequisites

- macOS with Xcode installed
- Apple Developer Program membership ($99/year)
- Valid Apple ID

### 2. Xcode Configuration

1. **Open iOS Project**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure Signing**
   - Select "Runner" project
   - Go to "Signing & Capabilities"
   - Select your team
   - Update Bundle Identifier (e.g., `com.yourcompany.flowmate`)

3. **Update App Information**
   - Display Name: "FlowMate"
   - Version: 1.0.0
   - Build: 1

4. **Add App Icons**
   - Add all required icon sizes to `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
   - Use tools like [App Icon Generator](https://appicon.co/)

### 3. Build for Release

1. **Build iOS App**
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode**
   - Open `ios/Runner.xcworkspace`
   - Select "Any iOS Device" as target
   - Product → Archive
   - Wait for archive to complete

3. **Upload to App Store**
   - Window → Organizer
   - Select your archive
   - Click "Distribute App"
   - Choose "App Store Connect"
   - Follow the upload process

### 4. App Store Connect

1. **Create App Record**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Click "My Apps" → "+"
   - Create new app with same Bundle ID

2. **Complete App Information**
   - **App Information**: Name, category, content rights
   - **Pricing**: Free or paid pricing
   - **App Store Information**: Description, keywords, screenshots
   - **Build**: Select uploaded build

3. **Screenshots Requirements**
   - iPhone: 6.5", 5.5" display sizes
   - iPad: 12.9", 11" display sizes (if supporting iPad)
   - Use Simulator or real devices for screenshots

4. **Submit for Review**
   - Complete all sections
   - Submit for review (typically 1-7 days)

## 📱 Required Assets

### App Icons
- **Android**: 
  - 48×48, 72×72, 96×96, 144×144, 192×192 (mdpi to xxxhdpi)
  - Adaptive icon: 108×108 with safe zone
- **iOS**: 
  - Multiple sizes from 20×20 to 1024×1024
  - Use [App Icon Generator](https://appicon.co/)

### Screenshots
- **Android**: At least 2 screenshots per supported device type
- **iOS**: Required for all supported device sizes
- Showcase key features: Dashboard, Tasks, Calendar, Notes, Focus Timer

### Store Graphics
- **Android**: Feature graphic (1024×500)
- **iOS**: Optional promotional artwork

## 🔧 Configuration Files

### Android Manifest Updates
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    <application
        android:label="FlowMate"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- Activity configuration -->
    </application>
</manifest>
```

### iOS Info.plist Updates
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>FlowMate</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for profile pictures.</string>
```

## 📊 Store Optimization

### Keywords (iOS)
- productivity, tasks, pomodoro, focus, notes, calendar, timer

### Description Template
```
Transform your productivity with FlowMate - the all-in-one app that combines task management, calendar scheduling, note-taking, and focus timing in one beautiful interface.

KEY FEATURES:
✅ Smart Task Management with priority levels
📅 Integrated Calendar for event scheduling  
📝 Quick Notes with rich text editing
⏱️ Pomodoro Focus Timer for better concentration
🎨 Beautiful, intuitive design with dark mode
📱 Works offline - sync across devices

Perfect for students, professionals, and anyone looking to boost their productivity and stay organized.

Download FlowMate now and start your journey to better productivity!
```

## 🚀 Release Checklist

### Before Submission
- [ ] Test app thoroughly on multiple devices
- [ ] Verify all features work offline
- [ ] Check dark mode compatibility
- [ ] Ensure app handles edge cases gracefully
- [ ] Test task creation, editing, and deletion
- [ ] Verify data persistence across app restarts
- [ ] Check accessibility features
- [ ] Review and proofread all store content

### After Approval
- [ ] Monitor crash reports and user feedback
- [ ] Plan updates and new features
- [ ] Respond to user reviews
- [ ] Monitor app performance metrics
- [ ] Prepare marketing materials

## 📈 Post-Launch

### Analytics Setup
Consider integrating:
- Firebase Analytics
- Crashlytics for crash reporting
- User engagement tracking

### Update Strategy
- Regular bug fixes and improvements
- Feature updates based on user feedback
- Seasonal UI updates
- Performance optimizations

## 🆘 Troubleshooting

### Common Issues
1. **Build Errors**: Check Flutter version compatibility
2. **Signing Issues**: Verify certificates and provisioning profiles
3. **Review Rejection**: Address feedback and resubmit
4. **Performance**: Optimize images and reduce app size

### Support Resources
- [Flutter Deployment Docs](https://docs.flutter.dev/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://developer.apple.com/help/app-store-connect/)

---

Good luck with your FlowMate app deployment! 🚀