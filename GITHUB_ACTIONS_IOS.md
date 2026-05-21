# بناء مشروع iOS عبر GitHub Actions

## هل يمكن البناء بدون Mac محلي؟
نعم. هذا المشروع يمكن بناؤه على macOS runner داخل GitHub Actions.

## ماذا أضفت لك
- Workflow جاهز: `.github/workflows/ios-ci.yml`

## ماذا يفعل الـ Workflow
1. يجلب الكود.
2. يثبت Xcode.
3. يثبت CocoaPods.
4. ينفذ `pod install`.
5. يبني المشروع على iOS Simulator (Debug).
6. يرفع سجل البناء كـ artifact.

## التشغيل
1. ارفع المشروع إلى GitHub.
2. ادخل تبويب Actions.
3. شغّل `iOS CI` يدويًا (workflow_dispatch) أو عبر push.

## ملاحظات مهمة
1. هذا الـ workflow يبني على Simulator فقط (لا يحتاج شهادات Signing).
2. إذا أردت استخراج IPA للتثبيت على iPhone، نحتاج خطوة Archive/Export وتكوين شهادات:
   - `APPLE_CERT_BASE64`
   - `APPLE_CERT_PASSWORD`
   - `APPLE_PROVISION_PROFILE_BASE64`
   - `KEYCHAIN_PASSWORD`
   - `TEAM_ID`
3. أول نتيجة مهمة الآن: التأكد أن المشروع يبني بنجاح على GitHub أولًا.

## إذا فشل البناء
- افتح artifact باسم `ios-build-log` وأرسل أول 30 سطر خطأ، وسأصلح الـ workflow والكود مباشرة.
