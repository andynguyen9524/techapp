# AI Agent Instructions for TechApp

This guide helps AI coding agents understand the essential patterns and workflows of this Flutter project.

## Project Overview
- Cross-platform Flutter mobile application (iOS, Android, web, desktop)
- Uses Material Design for consistent UI/UX
- Follows standard Flutter project structure with platform-specific code in respective directories

## Architecture
- **Entry Point**: `lib/main.dart` - Main application bootstrap and root widget
- **Platform Directories**:
  - `android/` - Android platform code and configuration
  - `ios/` - iOS platform code and Swift/Objective-C sources
  - `web/` - Web platform assets and configuration
  - `linux/`, `macos/`, `windows/` - Desktop platform implementations

## Development Workflow
1. **Environment Setup**:
   ```bash
   flutter pub get           # Install dependencies
   flutter doctor           # Verify development environment
   ```

2. **Running the App**:
   ```bash
   flutter run              # Run on connected device/simulator
   flutter run -d chrome    # Run web version
   ```

3. **Building**:
   ```bash
   flutter build ios       # Build iOS app
   flutter build apk      # Build Android APK
   flutter build web      # Build web version
   ```

## Project Conventions
- Uses standard Flutter application structure
- Material Design widgets and theming
- Debug banner disabled by default in `MaterialApp` configuration
- Version controlled by pubspec.yaml (current: 0.1.0)

## Dependencies
- Flutter SDK (^3.8.0)
- flutter_lints: ^5.0.0 for code quality
- Material Design components

## Common Tasks
1. **Adding Dependencies**:
   - Add to `pubspec.yaml` under appropriate section
   - Run `flutter pub get`

2. **Platform-Specific Code**:
   - iOS: Modify `ios/Runner/` for native code
   - Android: Modify `android/app/` for Kotlin/Java code
   - Web: Customize `web/index.html` for web-specific features

## Testing
- Use `flutter_test` package for widget tests
- Place test files in `test/` directory with `_test.dart` suffix
- Run tests with `flutter test`