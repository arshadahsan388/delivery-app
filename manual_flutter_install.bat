@echo off
echo Flutter Manual Installation Helper
echo ================================
echo.

echo Step 1: Download Flutter SDK
echo Go to: https://docs.flutter.dev/get-started/install/windows
echo Download the ZIP file to your Downloads folder
echo.

echo Step 2: Extract Flutter
echo 1. Right-click on the downloaded flutter_windows_x.x.x-stable.zip
echo 2. Select "Extract All..."
echo 3. Extract to: C:\src\
echo    (This will create C:\src\flutter\)
echo.

echo Step 3: Verify Installation
echo After extraction, you should have:
echo C:\src\flutter\bin\flutter.exe
echo.

echo Step 4: Test Flutter
echo Open a new Command Prompt and run:
echo flutter --version
echo flutter doctor
echo.

echo Step 5: Setup Your Project
echo cd "C:\Users\Ahsan\Desktop\delivery"
echo flutter pub get
echo flutter doctor
echo flutter run
echo.

echo Note: PATH is already configured to C:\src\flutter\bin
echo You just need to extract Flutter to C:\src\
echo.

pause
