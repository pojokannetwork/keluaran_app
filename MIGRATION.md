# Flutter Gradle Migration Guide

This document describes the migration from an unsupported Flutter project structure to a standard Flutter app structure with proper Android/iOS platform support.

## What Changed

### 1. Platform Structure Added
- **android/**: Complete Android platform structure with Gradle configuration
- **ios/**: Complete iOS platform structure with Xcode project
- **test/**: Test directory with basic smoke test

### 2. Build Configuration
- **android/app/build.gradle.kts**: Updated with proper package name `com.pojokannetwork.keluaran_app`
- **android/app/src/main/AndroidManifest.xml**: Updated app label to "Keluaran Analitik"
- Added signing configuration support for release builds

### 3. Library Structure Fixed
- Moved `lib/services/lib/widgets/frequency_chart.dart` to proper location `lib/widgets/frequency_chart.dart`
- Removed nested `lib/services/lib/` directory structure

### 4. Configuration Files Added
- **.gitignore**: Standard Flutter .gitignore with keystore exclusions
- **.metadata**: Flutter project metadata for migrations
- **android/key.properties.template**: Template for keystore configuration

### 5. CI/CD Updates
- Added `flutter --version` step to GitHub Actions workflow
- Added `flutter doctor -v` step for environment diagnostics
- Workflow remains at repository root (no working-directory changes needed)

## Keystore and Signing Configuration

### For Local Development

1. Generate a keystore if you don't have one:
   ```bash
   keytool -genkey -v -keystore android/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias keluaran_app
   ```

2. Copy the template and fill in your values:
   ```bash
   cp android/key.properties.template android/key.properties
   ```

3. Edit `android/key.properties` with your actual values:
   ```properties
   storeFile=keystore.jks
   storePassword=your_actual_store_password
   keyAlias=keluaran_app
   keyPassword=your_actual_key_password
   ```

4. **IMPORTANT**: Never commit `android/key.properties` or `android/keystore.jks` to version control!

### For CI/CD (GitHub Actions)

The current workflow builds with debug signing. To enable release signing in CI:

1. Encode your keystore as base64:
   ```bash
   base64 android/keystore.jks > keystore.base64
   ```

2. Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):
   - `KEYSTORE_BASE64`: Contents of keystore.base64
   - `KEYSTORE_PASSWORD`: Your keystore password
   - `KEY_ALIAS`: Your key alias (e.g., "keluaran_app")
   - `KEY_PASSWORD`: Your key password

3. Update `.github/workflows/main.yml` to decode and use the keystore (optional, currently using debug signing).

## Testing Locally

### Install Dependencies
```bash
flutter pub get
```

### Run in Debug Mode
```bash
flutter run
```

### Build Release APK
```bash
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Run Tests
```bash
flutter test
```

## CI/CD Notes

### Current Setup
- Workflow runs on every push to `main` branch
- Uses `ubuntu-latest` runner
- Builds release APK (with debug signing by default)
- Uploads APK as artifact

### Troubleshooting
- The `flutter doctor -v` step helps diagnose environment issues
- The `flutter --version` step shows exact Flutter version being used
- Check Android SDK and build tools are properly configured

## Manual Review Needed

### Native Code Changes (if any existed before)
If the previous project had custom native Android or iOS code:
- **MainActivity**: Check if custom initialization was needed
- **Plugins**: Verify all plugin configurations are correct
- **Permissions**: Review AndroidManifest.xml for custom permissions

The current migration assumes no custom native code. If you had custom native implementations:
1. Review old native code (if backed up)
2. Port changes to new structure in `android/app/src/main/`
3. Add TODO comments for manual review

### Dependencies
All Flutter dependencies from `pubspec.yaml` were preserved:
- flutter SDK
- http ^1.2.0
- html ^0.15.4
- sqflite ^2.3.0
- path ^1.9.0
- charts_flutter ^0.12.0

Run `flutter pub outdated` to check for updates.

## Migration Checklist

- [x] Create new Flutter app skeleton
- [x] Migrate lib/ contents to new structure
- [x] Fix nested lib/ directory issues
- [x] Preserve pubspec.yaml
- [x] Add Android platform structure
- [x] Add iOS platform structure
- [x] Update package name and app label
- [x] Add signing config placeholders
- [x] Create .gitignore
- [x] Create .metadata
- [x] Update GitHub Actions workflow
- [x] Add flutter doctor step to CI
- [x] Create migration documentation

## Next Steps

1. **Test locally**: Run `flutter pub get` and `flutter run` to verify the app works
2. **Add keystore**: If building release versions, create and configure keystore
3. **Review CI**: Push changes and verify GitHub Actions builds successfully
4. **Update secrets**: Add keystore secrets to GitHub if release signing needed
5. **Validate features**: Test all app functionality (fetch, cache, charts, filters)

## Support

If you encounter issues:
1. Check `flutter doctor -v` output
2. Verify all dependencies installed with `flutter pub get`
3. Review GitHub Actions logs for build errors
4. Check that Flutter SDK version is compatible (>=3.3.0 <4.0.0)
