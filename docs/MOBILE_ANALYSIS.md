# تقرير تحليل تطبيقات Flutter

تاريخ الفحص: 2026-06-30

## الملخص

تم تشغيل `flutter pub get` و`flutter analyze` على تطبيقي:

- `mobile/captain`
- `mobile/mandob`

النتيجة العامة: لا توجد أخطاء Dart قاتلة ظاهرة عند تشغيل التحليل مع:

```powershell
flutter analyze --no-fatal-infos --no-fatal-warnings
```

لكن التحليل القياسي يعرض عددا كبيرا من warnings وinfos:

- تطبيق الكابتن: 410 issues
- تطبيق المندوب: 909 issues

## ما تم إصلاحه

- تم تحديث `intl` في تطبيق المندوب من `^0.19.0` إلى `^0.20.2` ليتوافق مع `flutter_localizations` في Flutter الحالي.

## أهم أنواع الملاحظات

- imports غير مستخدمة.
- استخدام `print` في كود إنتاجي.
- استخدام APIs قديمة مثل `withOpacity`.
- Widgets عامة بدون `key`.
- أسماء ملفات وكلاسات لا تتبع أسلوب Dart.
- متغيرات أو دوال غير مستخدمة.
- حالات null checks غير لازمة.

## التوصية

لا أنصح بمحاولة إصلاح كل الملاحظات دفعة واحدة لأنها كثيرة وقد تسبب تغييرات واسعة. الأفضل:

1. تشغيل التطبيقين أولا على emulator/device.
2. إصلاح الأخطاء التشغيلية إن ظهرت.
3. بعدها تنظيف lints على دفعات:
   - unused imports
   - null-safety warnings
   - deprecated APIs
   - naming/style

