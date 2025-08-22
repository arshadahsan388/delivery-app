@echo off
echo Installing Flutter SDK for Local Express Delivery App...
echo.

echo Step 1: Download Flutter SDK
echo Please download Flutter from: https://docs.flutter.dev/get-started/install/windows
echo Recommended location: C:\src\flutter
echo.

echo Step 2: Add to PATH
echo 1. Open System Properties ^> Environment Variables
echo 2. Edit User PATH variable
echo 3. Add: C:\src\flutter\bin
echo.

echo Step 3: Verify Installation
echo After adding to PATH, run: flutter doctor
echo.

echo Step 4: Install Android dependencies
echo flutter doctor will guide you through:
echo - Android Studio installation
echo - Android SDK setup
echo - Accept Android licenses
echo.

echo Step 5: Setup your Local Express project
echo cd "C:\Users\Ahsan\Desktop\delivery"
echo flutter pub get
echo flutter run
echo.

pause
