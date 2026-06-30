# إعداد المفاتيح والملفات الحساسة

تم حذف مفاتيح Google/Firebase من نسخة GitHub حتى لا يتم نشرها علنا.

## الملفات التي يجب إضافتها محليا عند البناء

- `mobile/mandob/android/app/google-services.json`
- `mobile/mandob/ios/Runner/GoogleService-Info.plist`
- `mobile/mandob/lib/firebase_options.dart`

يمكن توليد ملفات Firebase مجددا عبر FlutterFire CLI:

```powershell
Set-Location mobile\mandob
flutterfire configure
```

## مفاتيح Google

تم استبدال مفاتيح Google الصريحة بالقيمة:

```text
YOUR_GOOGLE_API_KEY
```

قبل البناء للإنتاج، ضع المفتاح الصحيح في إعدادات Android/iOS أو مرره بطريقة آمنة حسب بيئة البناء.
