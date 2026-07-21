# Flutter Android Release Builds (ProGuard & R8)

When developing Flutter apps, ALWAYS keep in mind the differences between Debug and Release builds on Android:

1. **R8 Minification (ProGuard)**: Release builds (`flutter build apk` or `flutter build appbundle`) run R8 code minification by default. This strips generic type information (like Gson `TypeToken` used in `flutter_local_notifications`). If the app crashes in Release but works in Debug, always check for minification issues and add explicit keep rules in `android/app/proguard-rules.pro` and configure it in `build.gradle`.
2. **Resource Shrinking**: Unused resources are aggressively stripped in Release builds. If Dart code dynamically references raw Android resources (like `.wav` or `.mp3` files in `res/raw` via strings), the Android Resource Shrinker will delete them. Prevent this by creating a `res/raw/keep.xml` with `tools:keep="@raw/your_file"`.
3. **Android 14 Exact Alarms**: When installed from Google Play, Android 14 denies `SCHEDULE_EXACT_ALARM` by default. Relying on it will crash the app. If possible, remove the permission completely from `AndroidManifest.xml` and use `inexactAllowWhileIdle` alarms.
4. **Blind Release Debugging**: If a crash only happens in Release mode (e.g., from the store), catch exceptions in Dart and display `e.toString()` directly in the UI (e.g., using a SnackBar). This immediately identifies the root cause without needing logcat.
