# تشغيل مشروع BuguLive على Mac (خطة عملية)

## 1) المتطلبات الأساسية
1. macOS حديث + Xcode حديث (يفضل Xcode 15 أو 16).
2. تثبيت أدوات سطر أوامر Xcode.
3. تثبيت Homebrew.
4. تثبيت Ruby و CocoaPods.

أوامر التثبيت المقترحة:
- xcode-select --install
- /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
- brew install ruby
- echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc
- source ~/.zshrc
- gem install cocoapods
- pod --version

## 2) فتح المشروع الصحيح
1. افتح المجلد الجذر للمشروع.
2. نفذ:
- pod repo update
- pod install
3. افتح هذا الملف فقط في Xcode:
- BuguLive.xcworkspace

## 3) إعدادات سريعة قبل أول Build
1. من Target الخاص بالتطبيق:
- Signing & Capabilities: اختر Team صحيح.
- غيّر Bundle Identifier إلى معرفك إذا لزم.
2. من Build Settings:
- فعّل Always Embed Swift Standard Libraries = Yes إذا ظهر خطأ Swift runtime.

## 4) أول تشغيل
1. اختر Simulator حديث (iPhone 15 أو 16).
2. Product > Clean Build Folder.
3. Product > Build.
4. Product > Run.

## 5) إذا فشل pod install
1. نفذ تنظيف كاش بودز:
- pod deintegrate
- rm -rf Pods
- rm -f Podfile.lock
- pod install --repo-update
2. إذا ظهر خطأ ffi/ruby:
- sudo gem install ffi
- pod install --repo-update

## 6) إذا فشل Build بسبب تعارض مكتبات البث
المشروع يحتوي أكثر من SDK للبث/الصوت/IM، لذلك نفذ التالي:
1. ابدأ بتشغيل Debug بدون تفعيل كل ميزات البث المعقدة.
2. تأكد أن الاستدعاءات الخاصة بكل SDK تعمل في مسار واحد فقط وقت التشغيل.
3. إذا ظهر تضارب symbols، سجل اسم الملف والمكتبة المتعارضة ثم نحلها خطوة بخطوة.

## 7) مطلوب منك إرساله لي بعد أول محاولة
1. أول 30 سطر من خطأ build الفعلي.
2. اسم الجهاز أو Simulator الذي شغلت عليه.
3. هل الفشل في pod install أم build أم وقت run.

## 8) النتيجة المتوقعة بعد هذه الخطة
- المشروع يفتح على workspace الصحيح.
- Pods تتثبت بشكل نظيف.
- أول Build ناجح أو على الأقل تظهر لنا أخطاء دقيقة قابلة للإصلاح بسرعة.
