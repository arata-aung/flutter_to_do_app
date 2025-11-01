## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

## Hive
-keep class hive.** { *; }
-keep class * extends hive.HiveObject { *; }
-keep class **$HiveFieldAdapter { *; }
-keepclassmembers class * extends hive.HiveObject { *; }
