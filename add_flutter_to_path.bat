@echo off
echo Adding Flutter to PATH environment variable...
echo.

echo This script will add C:\src\flutter\bin to your PATH
echo Make sure you have extracted Flutter SDK to C:\src\flutter first
echo.

setx PATH "%PATH%;C:\src\flutter\bin"

echo.
echo Flutter path added successfully!
echo Please restart your terminal/command prompt for changes to take effect.
echo.

echo To verify installation, run: flutter doctor
echo.

pause
