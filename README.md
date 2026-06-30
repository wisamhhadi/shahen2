# Shahenco

نسخة منظمة ونظيفة من مشروع إدارة شحن البضائع.

## الهيكل

```text
backend/          Django backend and admin panel
mobile/captain/   Flutter captain app
mobile/mandob/    Flutter mandob app
docs/             Project audit and notes
```

## ما تم استبعاده من النسخة النظيفة

- ملفات البناء مثل `build/`
- البيئات المحلية مثل `.venv/`
- ملفات IDE مثل `.idea/`
- ملفات iOS/Android المولدة مثل `Pods/`, `.gradle/`, `.dart_tool/`
- قاعدة SQLite المحلية `db.sqlite3`
- ملفات media/staticfiles المولدة
- النسخ المضغوطة وملفات APK

## ملاحظات مهمة

- الباك إند المعتمد في هذه النسخة مأخوذ من مشروع `uae`.
- المشروع لم يتم تشغيله أو اختبار بنائه بعد بعد التنظيم.
- راجع تقرير التدقيق في `docs/PROJECT_AUDIT.md` قبل النشر أو التسليم.

## خطوات مقترحة لاحقا

1. ضبط إعدادات Django لتقرأ من `.env`.
2. تثبيت إصدارات الاعتمادات.
3. تشغيل الباك إند محليا.
4. تشغيل تطبيقات Flutter وتحليل الأخطاء.
5. إضافة اختبارات أساسية للـ API وتدفقات تسجيل الدخول.

## تشغيل الباك إند محليا

```powershell
python -m venv .venv
.\.venv\Scripts\python -m pip install -r backend\requirements.txt
Copy-Item backend\.env.example backend\.env
Set-Location backend
..\.venv\Scripts\python manage.py migrate --noinput
..\.venv\Scripts\python manage.py createcachetable
..\.venv\Scripts\python manage.py runserver
```

## فحص تطبيقات Flutter

```powershell
Set-Location mobile\captain
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings

Set-Location ..\mandob
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings
```

راجع `docs/MOBILE_ANALYSIS.md` لملخص نتائج التحليل.

## أمان API

الباك إند يدعم الآن قراءة `API_AUTH_REQUIRED` من `backend/.env`.

- في التطوير المحلي اتركها `False` لتسهيل التجربة.
- في الإنتاج اجعلها `True` حتى تتطلب أغلب مسارات `api/v1/<app>/<model>` هيدر:

```text
authorization: token <token-key>
```

توجد قائمة سماح للبيانات العامة مثل الدول والمحافظات واللغات، وقائمة سماح لإنشاء حسابات المستخدمين والكابتن والمندوب وشركة النقل.

راجع `docs/BACKEND_SECURITY.md` لتفاصيل الفحص والتغييرات.

## ملفات حساسة

قبل تشغيل تطبيق المندوب مع Firebase أو خرائط Google، راجع `docs/SECRETS.md`.
