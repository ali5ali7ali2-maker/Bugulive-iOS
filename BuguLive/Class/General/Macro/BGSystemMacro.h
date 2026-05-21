//
//  BGSystemMacro.h
//  BuguLive
//
//  Created by xfg on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  系统宏

#ifndef FWSystemMacro_h
#define FWSystemMacro_h

#import "GlobalVariables.h"
#import "LLFans.h"

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


#define ASLocalizedString(key)  [NSString stringWithFormat:@"%@", [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"ASLocalized"]]

#define KAppLanguage @"appLanguage"
#define KAppLanguageFirst @"appLanguage_first"

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
#define isIPhoneX() IPHONE_X


//根据ip6的屏幕来拉伸
#define kRealValue(with) ((with)*(kScreenW/375.0f))

// 屏幕frame,bounds,size,scale
#define kScreenFrame            [UIScreen mainScreen].bounds
#define kScreenBounds           [UIScreen mainScreen].bounds
#define kScreenSize             [UIScreen mainScreen].bounds.size
#define kScreenScale            [UIScreen mainScreen].scale
#define kScreenW                [[UIScreen mainScreen] bounds].size.width
#define kScreenH                [[UIScreen mainScreen] bounds].size.height
#define kScaleW                 (kScreenW)*(kScreenScale)
#define kScaleH                 (kScreenH)*(kScreenScale)

#define KGiftViewHeight         kRealValue(358) + MG_BOTTOM_MARGIN
// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define kScaleWidth             [[UIScreen mainScreen] bounds].size.width/375.00
#define kScaleHeight            [[UIScreen mainScreen] bounds].size.height/667.00

// 主窗口的宽、高
#define kMainScreenWidth        MainScreenWidth()
#define kMainScreenHeight       MainScreenHeight()
static __inline__ CGFloat MainScreenWidth()
{
    if (@available(iOS 13.0, *)) {
        UIWindowScene *scene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] anyObject];
        if (scene) {
            BOOL isPortrait = scene.interfaceOrientation == UIInterfaceOrientationPortrait ||
                              scene.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
            return isPortrait ? [UIScreen mainScreen].bounds.size.width
                              : [UIScreen mainScreen].bounds.size.height;
        }
    }
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
        ? [UIScreen mainScreen].bounds.size.width
        : [UIScreen mainScreen].bounds.size.height;
    #pragma clang diagnostic pop
}

static __inline__ CGFloat MainScreenHeight()
{
    if (@available(iOS 13.0, *)) {
        UIWindowScene *scene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] anyObject];
        if (scene) {
            BOOL isPortrait = scene.interfaceOrientation == UIInterfaceOrientationPortrait ||
                              scene.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
            return isPortrait ? [UIScreen mainScreen].bounds.size.height
                              : [UIScreen mainScreen].bounds.size.width;
        }
    }
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
        ? [UIScreen mainScreen].bounds.size.height
        : [UIScreen mainScreen].bounds.size.width;
    #pragma clang diagnostic pop
}

// 状态栏、导航栏、标签栏高度
static __inline__ CGFloat StatusBarHeight()
{
    if (@available(iOS 13.0, *)) {
        UIWindowScene *scene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] anyObject];
        if (scene) {
            return scene.statusBarManager.statusBarFrame.size.height;
        }
        return IPHONE_X ? 44.0 : 20.0;
    }
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [UIApplication sharedApplication].statusBarFrame.size.height;
    #pragma clang diagnostic pop
}
#define kStatusBarHeight        StatusBarHeight()
#define kNavigationBarHeight    ([GlobalVariables sharedInstance].appNavigationBarHeight ? : self.navigationController.navigationBar.frame.size.height)
#define kTabBarHeight           ([GlobalVariables sharedInstance].appTabBarHeight ? : self.tabBarController.tabBar.frame.size.height)

// 顶部距离
#define MG_TOP_MARGIN (CGFloat)(isIPhoneX()  ? 35 : 22)
#define MG_BOTTOM_MARGIN 22
#define MG_BOTTOM_SAFE_HEIGHT (CGFloat)(isIPhoneX()  ? 34 : 0)
#define kTopHeight (kStatusBarHeight + kNavigationBarHeight)

#define scale_hight1            kScreenH < 600 ? 50 : 55
#define scale_hight             kScreenH > 667 ? 60 : scale_hight1

// 当前所在window
#define kCurrentWindow          [AppDelegate sharedAppDelegate].sus_window.rootViewController ? [AppDelegate sharedAppDelegate].sus_window : [AppDelegate sharedAppDelegate].window

//// 当前系统版本号
//#define kCurrentVersionNum      [UIDevice currentDevice].systemVersion.doubleValue

#endif /* FWSystemMacro_h */
