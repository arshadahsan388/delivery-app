@echo off
echo Setting up Android SDK for Flutter APK building...
echo.

REM Create Android SDK directory
set ANDROID_HOME=C:\Android\Sdk
if not exist "%ANDROID_HOME%" mkdir "%ANDROID_HOME%"

echo 1. Download Android Command Line Tools from:
echo    https://developer.android.com/studio#command-tools
echo.
echo 2. Extract the downloaded zip file to:
echo    %ANDROID_HOME%\cmdline-tools\latest\
echo.
echo 3. Run these commands in Command Prompt as Administrator:
echo.
echo    cd "%ANDROID_HOME%\cmdline-tools\latest\bin"
echo    sdkmanager --install "platform-tools" "platforms;android-34" "build-tools;34.0.0"
echo    sdkmanager --licenses
echo.
echo 4. Add these environment variables:
echo    ANDROID_HOME=%ANDROID_HOME%
echo    PATH=%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\cmdline-tools\latest\bin;%%PATH%%
echo.

REM Try to set environment variables for current session
setx ANDROID_HOME "%ANDROID_HOME%" /M 2>nul
setx PATH "%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\cmdline-tools\latest\bin;%PATH%" /M 2>nul

echo 5. After setup, restart your terminal and run:
echo    flutter doctor
echo    flutter build apk --release
echo.
pause
