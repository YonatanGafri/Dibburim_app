# 🕊️ Dibburim App — Local Development Setup Guide

This guide walks you through setting up your Windows machine to run the Dibburim Flutter app locally on an Android Emulator.

> **Prerequisites you already have:** ✅ VS Code, ✅ Git

---

## Step 1: Install Java JDK 17

Flutter's Android toolchain requires Java 17+.

1. Download **OpenJDK 17** from [Adoptium (Eclipse Temurin)](https://adoptium.net/temurin/releases/?version=17&os=windows&arch=x64&package=jdk).
2. Run the installer — **check the box** to set `JAVA_HOME` automatically.
3. Verify installation:
   ```powershell
   java -version
   ```
   You should see output like `openjdk version "17.x.x"`.

---

## Step 2: Install Android Studio

Android Studio provides the Android SDK, build tools, and emulator.

1. Download from [developer.android.com/studio](https://developer.android.com/studio).
2. Run the installer with **default settings**.
3. On first launch, the Setup Wizard will download the **Android SDK**, **SDK Build-Tools**, and **Android Emulator** — let it finish.
4. After setup, go to **Tools → SDK Manager**:
   - Under **SDK Platforms** tab: ensure **Android 14 (API 34)** is checked and installed.
   - Under **SDK Tools** tab: ensure these are installed:
     - ✅ Android SDK Build-Tools
     - ✅ Android SDK Command-line Tools (latest)
     - ✅ Android Emulator
     - ✅ Android SDK Platform-Tools
5. Click **Apply** to install any missing components.

> **Note the SDK path** — it's usually `C:\Users\<you>\AppData\Local\Android\Sdk`. You'll need it in Step 4.

---

## Step 3: Install the Flutter SDK

1. Download the **latest stable Flutter SDK** from [flutter.dev/docs/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows/mobile).
2. Extract the `.zip` to a permanent location, e.g.:
   ```
   C:\dev\flutter
   ```
   > ⚠️ **Do NOT** place it inside `Program Files` or any path with spaces.

3. **Add Flutter to your PATH:**
   - Open **Start Menu** → search "Environment Variables" → click **Edit the system environment variables**.
   - Click **Environment Variables** → under **User variables**, select `Path` → **Edit**.
   - Click **New** and add: `C:\dev\flutter\bin`
   - Click **OK** on all dialogs.

4. **Restart your terminal** (close and reopen PowerShell/CMD).

5. Verify:
   ```powershell
   flutter --version
   ```

---

## Step 4: Install VS Code Flutter Extensions

Open VS Code and install these extensions (search in the Extensions panel `Ctrl+Shift+X`):

| Extension | Publisher |
|-----------|-----------|
| **Flutter** | Dart Code |
| **Dart** | Dart Code |

These give you syntax highlighting, hot reload, debugging, and device selection.

---

## Step 5: Run Flutter Doctor

This checks your entire toolchain:

```powershell
flutter doctor
```

You should see **green checkmarks** (✓) for:
- ✅ Flutter
- ✅ Android toolchain
- ✅ Android Studio
- ✅ VS Code

If Android licenses are not accepted, run:
```powershell
flutter doctor --android-licenses
```
Type `y` to accept each license.

---

## Step 6: Create & Launch an Android Emulator

### Option A: Via Android Studio (Recommended)

1. Open **Android Studio**.
2. Go to **Tools → Device Manager** (or click the phone icon in the toolbar).
3. Click **Create Virtual Device**.
4. Select **Pixel 7** (or any phone) → click **Next**.
5. Select **API 34** system image (download it if needed) → click **Next**.
6. Give it a name (e.g., "Pixel_7_API_34") → click **Finish**.
7. Click the **▶ Play** button next to the device to launch the emulator.

### Option B: Via Command Line

```powershell
# List available system images
flutter emulators

# Create an emulator
flutter emulators --create --name Pixel_7

# Launch it
flutter emulators --launch Pixel_7
```

> 💡 **Tip:** Keep the emulator running in the background while developing. Flutter connects to it automatically.

---

## Step 7: Run the Dibburim App

Open a terminal in the project directory and run:

```powershell
# Navigate to the project
cd "C:\Users\yonat\OneDrive\Desktop\Dibburim app"

# Install dependencies
flutter pub get

# Run the app on the connected emulator
flutter run
```

### What to expect:
- First build takes **2-5 minutes** (Gradle downloads dependencies).
- Subsequent builds are much faster.
- You'll see the app launch on the emulator!

### Hot Reload (instant preview):
While the app is running:
- Press **`r`** in the terminal for **Hot Reload** (applies changes instantly).
- Press **`R`** for **Hot Restart** (restarts the app state).
- Press **`q`** to quit.

Or use VS Code:
- Open `lib/main.dart` → press **F5** to launch with debugger.
- Save any file → **Hot Reload happens automatically**.

---

## Quick Reference Commands

| Command | Purpose |
|---------|---------|
| `flutter pub get` | Install/update dependencies |
| `flutter run` | Run on connected device/emulator |
| `flutter analyze` | Check code for errors |
| `flutter build apk` | Build release APK |
| `flutter clean` | Clean build cache (fixes weird errors) |
| `flutter doctor` | Check environment health |

---

## Troubleshooting

### "No devices found"
- Make sure the emulator is running (check Android Studio → Device Manager).
- Run `flutter devices` to see connected devices.

### "JAVA_HOME not set"
- Set it manually: **System Environment Variables** → New variable:
  - Name: `JAVA_HOME`
  - Value: `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot` (your actual path)

### "Android SDK not found"
- Set `ANDROID_HOME` environment variable to your SDK path:
  - Usually: `C:\Users\yonat\AppData\Local\Android\Sdk`

### Slow first build
- This is normal. Gradle downloads ~500MB of dependencies on first build.
- Ensure you have a stable internet connection.

---

*You're all set! Follow Steps 1-6, then come back and run Step 7 to see the app live.* 🎉
