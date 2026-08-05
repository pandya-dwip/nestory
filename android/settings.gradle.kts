pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // Pinned below AGP 9's built-in-Kotlin transition: file_picker already
    // skips applying org.jetbrains.kotlin.android on AGP9+ (expecting
    // built-in Kotlin), but flutter_plugin_android_lifecycle and
    // image_picker_android (latest published versions) still apply it
    // unconditionally — the two approaches can't coexist under AGP9 with
    // any single `android.builtInKotlin` setting. Staying on the AGP 8.x
    // line (highest release, to satisfy other androidx AAR minimums and
    // Flutter's own supported-version floor) keeps every plugin on the
    // traditional path uniformly.
    id("com.android.application") version "8.13.2" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
