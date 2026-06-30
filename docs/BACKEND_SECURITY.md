# تقرير تحسين أمان الباك إند

تاريخ التحديث: 2026-06-30

## ما تم تنفيذه

- إضافة authentication مخصص يدعم توكنات:
  - `UserToken`
  - `CaptainToken`
  - `DeliveryCompanyToken`
  - `MandobToken`
- تفعيل قراءة إعداد `API_AUTH_REQUIRED` من `backend/.env`.
- إضافة allowlist للبيانات العامة مثل الدول والمحافظات واللغات.
- إضافة allowlist لإنشاء حسابات المستخدمين الأساسية:
  - `user/User`
  - `captain/Captain`
  - `mandob/Mandob`
  - `deliverycompany/DeliveryCompany`
- الإبقاء على مسارات تسجيل الدخول عامة.

## صيغة التوكن المدعومة

```text
authorization: token <token-key>
```

وهذه هي الصيغة المستخدمة حاليا في تطبيقات Flutter.

## نتيجة التحقق

مع حماية API مفعلة:

- `GET /api/v1/core/Country` يرجع `200`
- `GET /api/v1/order/Order` بدون توكن يرجع `401`

## ملاحظات

- `backend/.env.example` يترك `API_AUTH_REQUIRED=False` للتطوير المحلي.
- في الإنتاج يجب ضبطها إلى `True`.
- هذه خطوة حماية أولية، وليست نظام صلاحيات تفصيلي لكل دور.

