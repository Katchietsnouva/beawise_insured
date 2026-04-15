flutter gen-l10n
flutter build apk --release --split-per-abi --no-tree-shake-icons
flutter build ipa --release --no-tree-shake-icons
<!-- flutter build apk --release  --analyze-size --split-per-abi --no-tree-shake-icons --split-debug-info=build/debug-info -->
flutter build apk --release --target-platform android-arm64 --split-debug-info=build/debug-info
flutter build apk --release --target-platform android-arm64

<!-- to analyse size --> 
flutter build apk --release --analyze-size --no-tree-shake-icons --target-platform android-arm64
dart devtools --appSizeBase=/home/nouvaneonsinc/.flutter-devtools/apk-code-size-analysis_01.json

<!-- to analyse witout release -->
flutter build apk --target-platform --analyze-size android-arm64

least_sized_app.md
flutter build apk --release --target-platform android-arm64
flutter build apk --release --split-per-abi --no-tree-shake-icons









nouvaneonsinc@nouvaneonsinc-engine:~/Documents/linux_dev_sq/Flutter/insured$ flutter build apk --release --analyze-size --target-platform android-arm64
Font asset "Font-Awesome-7-Brands-Regular-400.otf" was tree-shaken, reducing it from 199352 to 1432 bytes (99.3% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app.
Font asset "CupertinoIcons.ttf" was tree-shaken, reducing it from 257628 to 848 bytes (99.7% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app.
Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 15020 bytes (99.1% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app.
Running Gradle task 'assembleRelease'...                          169.5s
✓ Built build/app/outputs/flutter-apk/app-release.apk (279.0MB)
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
app-release.apk (total compressed)                                        266 MB
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  META-INF/
    androidx                                                               11 KB
  assets/
    dexopt                                                                  1 KB
    flutter_assets                                                          8 MB
    hobbes.tflite.jpg                                                       5 MB
    manifest.json                                                          53 KB
    mlkit-google-ocr-models                                                 1 MB
    mlkit_barcode_models                                                  860 KB
    mlkit_facemesh                                                          3 MB
    mlkit_label_default_model                                               2 MB
    mlkit_odt_default_classifier                                            2 MB
    mlkit_odt_localizer                                                     1 MB
    mlkit_pose                                                             12 MB
    mobile_acceleration                                                    16 KB
    models_bundled                                                          4 MB
    packmapping.pb                                                          8 KB
    selfiesegmentation_mlkit-256x256-2021_01_19-v1215.f16.tflite          243 KB
    sensitive_model_pqrnn.tflite.jpg                                     1014 KB
    tflite_langid.tflite.jpg                                              308 KB
  classes.dex                                                               4 MB
  lib/
    arm64-v8a                                                              92 MB
    Dart AOT symbols accounted decompressed size                            8 MB
      package:flutter                                                       3 MB
      package:insured                                                     588 KB
      dart:mixin_deduplication                                            338 KB
      package:flutter_localizations                                       293 KB
      dart:core                                                           286 KB
      dart:ui                                                             231 KB
      dart:typed_data                                                     188 KB
      dart:io                                                             148 KB
      package:webview_flutter_android                                     128 KB
      dart:async                                                          119 KB
      package:intl                                                        118 KB
      package:riverpod                                                     92 KB
      dart:collection                                                      85 KB
      package:go_router                                                    81 KB
      package:material_color_utilities                                     71 KB
      dart:convert                                                         58 KB
      package:source_span                                                  43 KB
      package:vector_math/
        vector_math_64.dart                                                37 KB
      package:characters                                                   37 KB
      package:path                                                         26 KB
    armeabi-v7a                                                            48 MB
    x86_64                                                                 83 MB
  kotlin/
    collections                                                             2 KB
    concurrent                                                              1 KB
    kotlin.kotlin_builtins                                                  5 KB
    ranges                                                                  1 KB
    reflect                                                                 1 KB
  okhttp3/
    internal                                                               33 KB
  org/
    apache                                                                 51 KB
  AndroidManifest.xml                                                       5 KB
  res/
    1I.9.png                                                                2 KB
    1J.9.png                                                                2 KB
    5J.9.png                                                                1 KB
    7R.json                                                                 5 KB
    G2.9.png                                                                1 KB
    I3.9.png                                                                1 KB
    IX.9.png                                                                2 KB
    Li.9.png                                                                2 KB
    MF.9.png                                                                3 KB
    NA.9.png                                                                2 KB
    Oi.xml                                                                  1 KB
    VZ.xml                                                                  1 KB
    ZL.9.png                                                                1 KB
    _p.png                                                                  1 KB
    color-v23                                                               2 KB
    color                                                                   1 KB
    dO.xml                                                                  1 KB
    h7.9.png                                                                1 KB
    io.9.png                                                                1 KB
    nf.png                                                                  1 KB
    o-.png                                                                  1 KB
    qD.9.png                                                                3 KB
    rj.9.png                                                                1 KB
    t1.xml                                                                  1 KB
    us.9.png                                                                2 KB
    w2.9.png                                                                1 KB
    zV.9.png                                                                2 KB
    zw.9.png                                                                1 KB
  resources.arsc                                                          348 KB
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
A summary of your APK analysis can be found at: /home/nouvaneonsinc/.flutter-devtools/apk-code-size-analysis_01.json

To analyze your app size in Dart DevTools, run the following command:
dart devtools --appSizeBase=/home/nouvaneonsinc/.flutter-devtools/apk-code-size-analysis_01.json
nouvaneonsinc@nouvaneonsinc-engine:~/Documents/linux_dev_sq/Flutter/insured$ 



























Your phone **already told us the correct ABI**:

```
adb shell getprop ro.product.cpu.abi
arm64-v8a
```

So the **smallest APK that will run on your phone is**:

```
app-arm64-v8a-release.apk (25.1MB)
```

The other two APKs you built are for **different CPUs**:

| APK                           | CPU type       | For your phone |
| ----------------------------- | -------------- | -------------- |
| app-armeabi-v7a-release.apk   | 32-bit ARM     | ❌              |
| **app-arm64-v8a-release.apk** | **64-bit ARM** | ✅              |
| app-x86_64-release.apk        | emulator/Intel | ❌              |

---

# ✅ Correct command to build the smallest APK for your phone

You can build **only arm64** instead of all 3.

```bash
flutter build apk --release --target-platform android-arm64
```

This will produce only:

```
build/app/outputs/flutter-apk/app-release.apk
```

which contains **only arm64 code**, so it stays small.

---

# ✅ Install it on your phone

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

or if updating:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

# ⚡ Smallest possible Flutter APK (recommended command)

Use this:

```bash
flutter build apk --release --target-platform android-arm64 --split-debug-info=build/debug-info
```

Benefits:

• removes debug symbols
• smaller APK
• still keeps crash stack traces

---

# 📦 Expected sizes

Typical Flutter sizes:

| Build          | Size         |
| -------------- | ------------ |
| universal APK  | 45–70 MB     |
| split per ABI  | 22–27 MB     |
| **arm64 only** | **23–25 MB** |

Your **25.1MB is already normal**.

---

# 🚀 If you want **MUCH smaller installs (15-20MB)**

Use **Android App Bundle** instead:

```bash
flutter build appbundle --release
```

This produces:

```
build/app/outputs/bundle/release/app-release.aab
```

When uploaded to **Google Play**, Play generates device-specific installs (much smaller).

---

# ⚡ Quick summary

Best command for **your phone**:

```bash
flutter build apk --release --target-platform android-arm64
```

Install:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

💡 If you want, I can also show you **5 tricks that shrink Flutter APKs from ~25MB → ~16MB** (without breaking anything).






















Here are **5 real techniques used in production Flutter apps to reduce APK size from ~25MB → ~16-19MB** without breaking functionality. 🚀

---

# 1️⃣ Enable code shrinking (R8 / ProGuard)

This removes unused Java/Kotlin code.

Open:

```
android/app/build.gradle
```

Make sure **release** looks like this:

```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

This can reduce **1–3 MB**.

---

# 2️⃣ Enable Flutter icon tree shaking

You accidentally **disabled it** earlier.

You ran:

```
--no-tree-shake-icons
```

That **keeps ALL Material icons**, which adds **~1.5MB**.

Use this instead:

```bash
flutter build apk --release --target-platform android-arm64
```

(no `--no-tree-shake-icons`)

Savings: **~1–2MB**

---

# 3️⃣ Remove unused fonts

Flutter automatically bundles fonts like:

* MaterialIcons
* CupertinoIcons

If you don't use Cupertino icons remove this from `pubspec.yaml`:

```yaml
cupertino_icons:
```

Savings: **~500KB – 1MB**

---

# 4️⃣ Compress assets (very important)

Your project includes:

```
assets/3d/
assets/models/
```

3D files like **.glb / .gltf** can be huge.

Use **gltfpack** to compress them.

Example:

```bash
gltfpack -i model.glb -o model_optimized.glb
```

Savings per model:

| Before | After |
| ------ | ----- |
| 4MB    | 1.2MB |

If you have multiple models this can save **10+ MB**.

---

# 5️⃣ Use `--split-debug-info`

Removes debug symbol metadata.

Build with:

```bash
flutter build apk \
--release \
--target-platform android-arm64 \
--split-debug-info=build/debug-info
```

Savings: **1–3MB**

---

# ⭐ Best final build command (recommended)

Use this:

```bash
flutter build apk \
--release \
--target-platform android-arm64 \
--split-debug-info=build/debug-info
```

Then install:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

# 📦 Realistic size results

| Step              | Size        |
| ----------------- | ----------- |
| Default Flutter   | ~45MB       |
| Split ABI         | ~25MB       |
| Shrink + icons    | ~21MB       |
| Asset compression | **16–19MB** |

---

# ⚡ Bonus: The **BIGGEST hidden Flutter APK killer**

Some packages bundle **native libraries**.

Check your APK contents:

```bash
flutter build apk --analyze-size
```

This shows exactly **what is making your APK big**.

---

✅ If you want, I can also show you a **crazy Flutter trick that gets APKs down to ~12MB** (used by some production apps).

















To analyze what is making your APK large, run:

```bash
flutter build apk --release --analyze-size --target-platform android-arm64
```

### What this does

* Builds a **release APK** for **arm64 only** (same as your phone).
* Generates a **size analysis file**.
* Opens a **visual treemap in your browser** showing what takes space.

After the build finishes you’ll see something like:

```
A summary of your APK analysis can be found at:
build/app/outputs/flutter-apk/app-release.apk
build/app/outputs/symbols/app-release.apk.json
```

Flutter will also print a command like:

```
flutter pub global run devtools
```

Then open **DevTools → App Size Tool**.

---

### Easier way (automatic)

Just run:

```bash
flutter build apk --release --analyze-size --target-platform android-arm64
```

Flutter usually launches **DevTools automatically** and shows a **size treemap**.

You will see sections like:

| Section          | What it means         |
| ---------------- | --------------------- |
| Dart AOT         | compiled Dart code    |
| Assets           | images, models, fonts |
| Native Libraries | Android `.so` files   |
| Flutter Engine   | Flutter runtime       |

---

### What to look for

Common things that inflate size:

* **assets/** images or 3D models
* **MaterialIcons-Regular.otf**
* **packages like camera / mlkit / webview**
* large `.so` native libraries

---

### Typical Flutter size breakdown

Example:

```
Flutter Engine      6 MB
Dart AOT            4 MB
Assets              8 MB
Fonts               1.5 MB
Plugins             3 MB
```

This immediately shows **what to optimize**.

---

### If you want

After you run it, **paste the output here** or show the **treemap summary**, and I can tell you **exactly where your 25MB is coming from and how to cut it down further.**



























nouvaneonsinc@nouvaneonsinc-engine:~/Documents/linux_dev_sq/Flutter/insured$ flutter build apk --release --split-per-abi --no-tree-shake-icons
Checking the license for package Android SDK Build-Tools 35 in /home/nouvaneonsinc/Android/Sdk/licenses
License for package Android SDK Build-Tools 35 accepted.
Preparing "Install Android SDK Build-Tools 35 v.35.0.0".
"Install Android SDK Build-Tools 35 v.35.0.0" ready.
Installing Android SDK Build-Tools 35 in /home/nouvaneonsinc/Android/Sdk/build-tools/35.0.0
"Install Android SDK Build-Tools 35 v.35.0.0" complete.
"Install Android SDK Build-Tools 35 v.35.0.0" finished.
[=========                              ] 25%                                   
[=========                              ] 25% Fetch remote repository...        
[=======================================] 100% Fetch remote repository...       
Note: /home/nouvaneonsinc/.pub-cache/hosted/pub.dev/android_intent_plus-6.0.0/android/src/main/java/dev/fluttercommunity/plus/androidintent/MethodCallHandlerImpl.java uses unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
Running Gradle task 'assembleRelease'...                          579.5s
✓ Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (22.6MB)
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (25.1MB)
✓ Built build/app/outputs/flutter-apk/app-x86_64-release.apk (26.4MB)
nouvaneonsinc@nouvaneonsinc-engine:~/Documents/linux_dev_sq/Flutter/insured$ 






so i wanna run mt app in apk phone in thelesast size pfssible my phoen is an androindn phone and in s have:
 
 
 

nouvaneonsinc@nouvaneonsinc-engine:~$ adb version
Android Debug Bridge version 1.0.41
Version 28.0.2-debian
Installed as /usr/lib/android-sdk/platform-tools/adb
nouvaneonsinc@nouvaneonsinc-engine:~$ adb devices
List of devices attached
11290153BP015883 device
nouvaneonsinc@nouvaneonsinc-engine:~$ adb shell getprop ro.product.model
itel A665L
nouvaneonsinc@nouvaneonsinc-engine:~$ adb shell getprop ro.product.model
itel A665L
nouvaneonsinc@nouvaneonsinc-engine:~$ adb shell getprop ro.product.manufacturer
ITEL
nouvaneonsinc@nouvaneonsinc-engine:~$ adb shell getprop ro.build.version.release
13
nouvaneonsinc@nouvaneonsinc-engine:~$ adb shell getprop ro.build.version.sdk
33
nouvaneonsinc@nouvaneonsinc-engine:~$ adb shell getprop ro.build.display.id
A665L-SE673SBCEFHJKLMNOPQRSTUVWX-TGo-OP-260116V1755
nouvaneonsinc@nouvaneonsinc-engine:~$ adb shell getprop
 
 
so i wanna build te least sized version on my pone



nouvaneonsinc@nouvaneonsinc-engine:~$ adb shell getprop ro.product.cpu.abi
arm64-v8a
nouvaneonsinc@nouvaneonsinc-engine:~$ 














To build the smallest possible APK for your itel A665L (Android 13, SDK 33), we'll use Flutter's release build options with ABI splitting. This creates separate, smaller APKs for specific CPU architectures (e.g., arm64-v8a or armeabi-v7a), instead of one fat APK with everything. Your phone is a budget Android device, so it likely uses armeabi-v7a (32-bit) or arm64-v8a (64-bit)—we'll confirm that first.

### Step 1: Confirm Your Phone's CPU Architecture (ABI)
Run this ADB command to get the primary ABI (this determines which split APK to install):
```
adb shell getprop ro.product.cpu.abi
```
- If it returns `arm64-v8a`, your phone is 64-bit (most common for Android 13 devices).
- If `armeabi-v7a`, it's 32-bit.
- (Rarely `x86` or `x86_64`—ignore those for now.)

Example output: `arm64-v8a`

If it's arm64-v8a, we'll target that for the smallest size.

### Step 2: Build the Smallest APK(s)
In your Flutter project directory (e.g., ~/Documents/linux_dev_sq/Flutter/insured):
1. Clean and get dependencies:
   ```
   flutter clean
   flutter pub get
   ```

2. Build release APKs with ABI splitting (this generates 2-3 small APKs ~10-20MB each, vs. one ~50-100MB fat APK):
   ```
   flutter build apk --release --split-per-abi --no-tree-shake-icons
   ```
   - `--release`: Optimized for size/performance.
   - `--split-per-abi`: Creates ABI-specific APKs (smallest individually).
   - `--no-tree-shake-icons`: Keeps all icons (from your pubspec—safe if you have many).
   - Output: In `build/app/outputs/flutter-apk/` you'll see files like:
     - `app-armeabi-v7a-release.apk` (32-bit, ~15MB)
     - `app-arm64-v8a-release.apk` (64-bit, ~20MB)
     - (Maybe `app-x86_64-release.apk`—ignore if not your ABI)

   Total build time: ~1-2 minutes.

### Step 3: Install the Smallest Matching APK on Your Phone
- Based on your ABI from Step 1, pick the file (e.g., for arm64-v8a: `app-arm64-v8a-release.apk`).
- Install via ADB (phone must be connected/authorized):
  ```
  adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
  ```
  - Replace with your actual file name/ABI.
  - If "Failure [INSTALL_FAILED_ALREADY_EXISTS]": Uninstall existing app first (`adb uninstall com.example.insured`—replace with your app's package name from `android/app/build.gradle`).

### Tips for Even Smaller Size
- **Remove Unused Assets**: Your pubspec has duplicates (e.g., `assets/3d/` and `assets/models/`)—consolidate to one folder, remove unused GLB files. Each GLB can add 1-5MB.
- **Optimize Models**: Compress GLB files (use tools like gltfpack or online compressors) before bundling.
- **No Universal APK**: Avoid `flutter build apk --release` without split—it's larger (~2x size).
- **Test**: Run `flutter run --release` on your phone via USB for quick testing (builds/installs automatically, but not split).
- **If Build Fails**: Ensure minSdkVersion in `android/app/build.gradle` is <=33 (default 16 is fine). Update Flutter if needed (`flutter upgrade`).

This should give you an APK under 20MB installed. If errors, share the exact build output or ABI result.