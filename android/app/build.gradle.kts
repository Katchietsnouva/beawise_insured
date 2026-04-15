plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.insured"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.insured"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // minSdk = flutter.minSdkVersion
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ndk {
        //     // // abiFilters 'arm64-v8a'
        //     // abiFilters("arm64-v8a")
        //     abiFilters.add("arm64-v8a")
        // }

        // externalNativeBuild {
        //     ndkBuild {
        //         // No-op if you don’t have native code
        //     }
        // }

        // // Or, if you just want abiFilters for APK splitting:
        // splits {
        //     abi {
        //         isEnable = true
        //         reset()
        //         include("arm64-v8a") // Only arm64-v8a
        //         isUniversalApk = false
        //     }
        // }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            // Enable shrinking and obfuscation to save more space
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}



// plugins {
//     id("com.android.application")
//     id("kotlin-android")
//     id("dev.flutter.flutter-gradle-plugin")
// }

// android {
//     namespace = "com.example.insured"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = flutter.ndkVersion

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_17
//         targetCompatibility = JavaVersion.VERSION_17
//     }

//     kotlinOptions {
//         // Correct way to fix the jvmTarget deprecation
//         compilerOptions {
//                     jvmTarget = "17" // ✅ Works with Flutter + Kotlin 1.8.x

//         }
//     }

//     defaultConfig {
//         applicationId = "com.example.insured"
//         minSdk = 26
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName

//         // This tells Gradle: "Only compile for my phone's architecture"
//         ndk {
//             abiFilters.add("arm64-v8a")
//         }
//     }

//     buildTypes {
//         release {
//             signingConfig = signingConfigs.getByName("debug")
            
//             // CRITICAL for size reduction
//             isMinifyEnabled = true
//             isShrinkResources = true
//             proguardFiles(
//                 getDefaultProguardFile("proguard-android-optimize.txt"), 
//                 "proguard-rules.pro"
//             )
//         }
//     }
// }

// flutter {
//     source = "../.."
// }