# استخراج تطبيق iOS (IPA) للتشغيل على الموبايل

## المتطلبات
1. Mac + Xcode.
2. حساب Apple Developer فيه Team صالح للتوقيع.
3. Provisioning مناسب (Ad Hoc أو Development) مع UDID جهازك.
4. المشروع يحتوي Pods مثبتة.

## 1) تجهيز المشروع على Mac
نفذ داخل جذر المشروع:

```bash
chmod +x RUN_ON_MAC.command
chmod +x scripts/*.sh
./RUN_ON_MAC.command
```

## 2) استخراج IPA
نفذ:

```bash
bash scripts/export_ipa.sh "TEAM_ID" "BUNDLE_ID" "BuguLive"
```

مثال:

```bash
bash scripts/export_ipa.sh "ABCD123456" "com.yourcompany.bugulive" "BuguLive"
```

## 3) مكان ملف IPA
بعد نجاح الاستخراج ستجد الملف داخل:
- build/ipa/

## 4) تثبيت IPA على الايفون
خيارات التثبيت:
1. عبر Xcode > Devices and Simulators > Install App.
2. عبر Apple Configurator 2.
3. عبر TestFlight (إذا بنيت بإعداد توزيع مناسب).

## 5) ملاحظات مهمة
1. بدون Mac لا يمكن استخراج IPA موقّع لتشغيله على iPhone.
2. إذا فشل التوقيع، غالبا السبب Team ID أو Provisioning Profile أو Bundle ID.
3. إذا فشل export، أرسل لي أول 30 سطر من الخطأ وسأصلحه لك مباشرة.
