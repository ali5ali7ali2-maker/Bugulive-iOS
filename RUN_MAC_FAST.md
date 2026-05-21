# تشغيل سريع (أمر واحد) على Mac

## نفذ هذا الأمر من جذر المشروع
bash scripts/run_all_ios_first_pass.sh

## ماذا يفعل الأمر تلقائيا
1. يفحص أدوات Xcode وRuby وCocoaPods.
2. يثبت CocoaPods إذا كانت غير موجودة.
3. ينظف دمج Pods القديم.
4. يعيد تثبيت الاعتماديات.
5. يبني المشروع Debug على iPhone 15 Simulator.
6. إذا فشل، يستخرج أول الأخطاء الأساسية تلقائيا.

## ملفات الناتج
- سجل البناء: build/ios_build.log
- سكريبتات التشغيل: scripts/

## في حال اختلاف اسم الـ Scheme
إذا لم يكن اسم Scheme هو BuguLive، افتح ملف:
- scripts/build_ios_debug.sh
وعدّل قيمة SCHEME حسب الاسم الظاهر من xcodebuild -list.

## في حال عدم وجود iPhone 15 Simulator
عدّل DESTINATION داخل:
- scripts/build_ios_debug.sh
إلى جهاز متاح عندك مثل iPhone 14 أو iPhone 16.
