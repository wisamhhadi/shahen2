# ⚙️ تغيير اسم الحزمة
flutter pub run change_app_package_name:main com.example.almandobuae

# 🎨 تغيير الأيقونة (إذا كنت قد جهّزت الأيقونة الجديدة في pubspec.yaml)
flutter pub run flutter_launcher_icons:main

# ✏️ تغيير اسم التطبيق في AndroidManifest.xml
(Get-Content android\app\src\main\AndroidManifest.xml) `
    -replace 'android:label="[^"]*"', 'android:label="UAE Mandob"' |
    Set-Content android\app\src\main\AndroidManifest.xml

# 🚀 بناء APK
flutter build apk --release

Write-Host "App duplicated successfully!"
