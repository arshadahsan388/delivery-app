# Flutter Installation Verification

After adding Flutter to PATH, run these commands to verify:

```bash
# Check if Flutter is accessible
flutter --version

# Run Flutter doctor to check setup
flutter doctor

# Expected output should show Flutter version like:
# Flutter 3.24.3 • channel stable
```

## Troubleshooting:

If `flutter` command is still not found:

1. **Check PATH was added correctly:**

   ```cmd
   echo %PATH%
   ```

   Should contain: `C:\src\flutter\bin`

2. **Restart computer** if needed

3. **Verify Flutter location:**

   ```cmd
   dir C:\src\flutter\bin
   ```

   Should show `flutter.exe`

4. **Run from full path:**
   ```cmd
   C:\src\flutter\bin\flutter doctor
   ```

## After Flutter Works:

```bash
cd "C:\Users\Ahsan\Desktop\delivery"
flutter pub get
flutter doctor
flutter run
```
