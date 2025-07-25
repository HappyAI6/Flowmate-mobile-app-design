# FlowMate - Flutter Mobile App

FlowMate is a beautifully designed all-in-one productivity app that helps you manage tasks, schedule, notes, and focus sessions in one seamless experience. This Flutter app is a complete conversion from the original React web application, ready for deployment to Google Play Store and Apple App Store.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.24.4-blue" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Dart-3.5.0-blue" alt="Dart Version">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green" alt="Platform">
  <img src="https://img.shields.io/badge/Store%20Ready-Yes-green" alt="Store Ready">
</p>

## ✨ Features

### 🏠 Home Dashboard
- Welcome screen with personalized greetings
- Quick overview widgets for all productivity areas
- At-a-glance view of today's tasks and upcoming events
- Progress tracking with visual indicators
- Clean, card-based interface with gradient backgrounds

### ✅ Task Management
- Intuitive task creation, editing, and deletion
- Visual progress indicators and completion tracking
- Priority levels (High, Medium, Low) with color coding
- Due date management with overdue indicators
- Task filtering (All, Pending, Completed)
- Persistent local storage

### 📅 Calendar & Events
- Monthly calendar view (Coming Soon)
- Quick event creation and management
- Event details with time and descriptions
- Visual indicators for different event types

### 📝 Smart Notes
- Card-based note interface with previews
- Rich text editing capabilities
- Quick note creation with floating action button
- Search and organization features

### ⏱️ Focus Timer (Pomodoro)
- Customizable Pomodoro timer with work/break intervals
- Start, pause, and reset controls
- Session tracking and completion counter
- Productivity analytics and insights

### 🎨 Beautiful Design
- **Color Palette**: Modern purple and blue gradients
- **Typography**: Inter font family with proper weight hierarchy
- **Layout**: Clean, minimalist design with rounded cards
- **Navigation**: Bottom tab bar with intuitive icons
- **Accessibility**: High contrast and accessibility-friendly design
- **Dark Mode**: Complete dark theme support

## 📱 Platform Support

- **iOS**: 12.0+ (App Store deployment ready)
- **Android**: API level 21+ (Google Play Store deployment ready)
- **Cross-Platform**: Shared codebase for both platforms

## 🚀 Getting Started

### Prerequisites

- Flutter 3.24.4 or higher
- Dart 3.5.0 or higher
- Android Studio / Xcode (for device testing)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flowmate_app
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # For Android
   flutter run -d android

   # For iOS (requires macOS)
   flutter run -d ios

   # For both platforms in development
   flutter run
   ```

### Build for Production

#### Android
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release
```

#### iOS (requires macOS and Xcode)
```bash
flutter build ios --release
```

## 🏗️ Project Structure

```
flowmate_app/
├── lib/
│   ├── models/                 # Data models with Hive annotations
│   │   ├── user.dart
│   │   ├── task.dart
│   │   ├── note.dart
│   │   └── event.dart
│   ├── providers/              # State management with Provider
│   │   └── app_provider.dart
│   ├── screens/                # Main application screens
│   │   ├── auth/               # Authentication screens
│   │   │   ├── welcome_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── splash_screen.dart
│   │   ├── main_wrapper.dart
│   │   ├── home_screen.dart
│   │   ├── tasks_screen.dart
│   │   ├── calendar_screen.dart
│   │   ├── notes_screen.dart
│   │   └── focus_screen.dart
│   ├── widgets/                # Reusable UI components
│   │   ├── task_card.dart
│   │   └── task_dialog.dart
│   ├── services/               # Business logic and data persistence
│   │   └── storage_service.dart
│   ├── utils/                  # Utilities and constants
│   │   └── app_theme.dart
│   └── main.dart               # App entry point
├── assets/                     # App assets
│   ├── images/
│   ├── icons/
│   ├── animations/
│   └── fonts/
├── android/                    # Android platform configuration
├── ios/                        # iOS platform configuration
└── test/                       # Unit and widget tests
```

## 📦 Dependencies

### Core Dependencies
- **flutter**: Framework
- **provider**: State management
- **hive**: Local database for offline storage
- **uuid**: Generate unique IDs

### UI & UX
- **google_fonts**: Custom typography
- **lucide_icons**: Modern icon set
- **flutter_svg**: SVG support
- **lottie**: Animations

### Platform & Storage
- **shared_preferences**: Simple key-value storage
- **path_provider**: File system paths
- **intl**: Internationalization and date formatting

## 🛠️ Development

### Running Tests
```bash
# Run unit tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
flutter format .

# Check for outdated dependencies
flutter pub outdated
```

### Building for Production
```bash
# Android release builds
flutter build apk --split-per-abi --release
flutter build appbundle --release

# iOS release build (requires macOS)
flutter build ios --release

# Check app size
flutter build apk --analyze-size
```

## 📱 Store Deployment

### Google Play Store
1. Build Android App Bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Complete store listing with screenshots and descriptions
4. Submit for review

### Apple App Store
1. Build iOS app: `flutter build ios --release`
2. Open `ios/Runner.xcworkspace` in Xcode
3. Archive and upload to App Store Connect
4. Complete app metadata and submit for review

## 🔧 Configuration

### App Icon
- Android: Place icons in `android/app/src/main/res/mipmap-*/`
- iOS: Use Xcode to configure app icons in `ios/Runner/Assets.xcassets/`

### App Name & Bundle ID
- Android: Update `android/app/src/main/AndroidManifest.xml`
- iOS: Update in Xcode project settings

### Permissions
Current permissions:
- Internet access (for future sync features)
- Storage access (for local data persistence)

## 🎯 Features Status

✅ **Completed**
- Authentication (Login/Signup)
- Home Dashboard
- Task Management (Full CRUD)
- Local Data Persistence
- Dark Mode Support
- Beautiful UI/UX
- Bottom Navigation

🚧 **In Development**
- Calendar Screen (Full Implementation)
- Notes Screen (Full Implementation)
- Focus Timer Screen (Full Implementation)

🔮 **Planned**
- Cloud Sync
- Push Notifications
- Widget Support
- Export/Import Features

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by modern productivity apps
- Built with Flutter and Dart
- Uses Material Design principles
- Inter font family for typography

## 📞 Support

For support, please open an issue on GitHub or contact [your-email@example.com]

---

**FlowMate** - Your all-in-one productivity companion 🌊
