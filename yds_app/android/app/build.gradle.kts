plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.yds.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // Try to load signing configuration from key.properties
    val keyPropertiesFile = File(rootDir, "android/key.properties")
    val signingPropsMap = mutableMapOf<String, String>()
    
    if (keyPropertiesFile.exists()) {
        keyPropertiesFile.forEachLine { line ->
            if (line.isNotBlank() && !line.startsWith("#")) {
                val parts = line.split("=", limit = 2)
                if (parts.size == 2) {
                    signingPropsMap[parts[0].trim()] = parts[1].trim()
                }
            }
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = signingPropsMap["keyAlias"] ?: ""
            keyPassword = signingPropsMap["keyPassword"] ?: ""
            storeFile = signingPropsMap["storeFile"]?.let { 
                file(it) 
            }
            storePassword = signingPropsMap["storePassword"] ?: ""
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.yds.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            // Use release signing config if key.properties is properly configured
            // Otherwise, fall back to debug for testing
            signingConfig = if (signingPropsMap["storeFile"] != null) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
