//
//  FDUIDefine.h
//  FDUIKitObjC
//
//  Created by fandongtongxue on 2020/2/26.
//

#ifndef FDUIDefine_h
#define FDUIDefine_h

#define FD_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define FD_ScreenHeight [UIScreen mainScreen].bounds.size.height

static inline CGFloat FDStatusBarHeight(void) {
    CGFloat statusBarHeight = 20.0;
    if (@available(iOS 13.0, *)) {
        for (UIScene *connectedScene in [UIApplication sharedApplication].connectedScenes) {
            if (![connectedScene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }
            UIWindowScene *windowScene = (UIWindowScene *)connectedScene;
            statusBarHeight = windowScene.statusBarManager.statusBarFrame.size.height;
            if (statusBarHeight <= 0) {
                UIWindow *window = windowScene.windows.firstObject;
                statusBarHeight = window.safeAreaInsets.top;
            }
            if (statusBarHeight > 0) {
                break;
            }
        }
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight > 0 ? statusBarHeight : 20.0;
}

#define FD_StatusBar_Height FDStatusBarHeight()
#define FD_Navigation_Height 44
#define FD_Bottom_Height (FD_StatusBar_Height > 20.0 ? 83 : 49)
#define FD_Bottom_SafeArea_Height (FD_StatusBar_Height > 20.0 ? 34 : 0)
#define FD_Top_Height (FD_StatusBar_Height + FD_Navigation_Height)

#endif /* FDUIDefine_h */
