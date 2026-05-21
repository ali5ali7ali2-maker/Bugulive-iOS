//
//  BGNavigationController.m
//  BuguLive
//
//  Created by xfg on 2017/6/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGNavigationController.h"

@interface BGNavigationController ()

@end

@implementation BGNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.view.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarAppearance];
}

- (void)setNavigationBarAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:[BGUtils imageWithColor:kNavBarThemeColor]  forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kAppGrayColor1;     // 设置item颜色
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];  // 统一设置item字体大小
    [UINavigationBar appearance].titleTextAttributes=textAttrs;
    
    if (@available(iOS 13.0, *)) {
           UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
           appearance.shadowImage = [UIImage imageWithColor:kWhiteColor];
           [appearance configureWithOpaqueBackground];
           appearance.backgroundColor =  kWhiteColor;
           
           self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
           [self.navigationBar setShadowImage:nil];
           [self.navigationBar setShadowImage:[UIImage imageWithColor:kWhiteColor]];
           
           [self.navigationBar setBackgroundImage:       [UIImage imageWithColor:kWhiteColor] forBarMetrics:UIBarMetricsDefault];
           
           
       } else {
           // Fallback on earlier versions
       }
    
//    if (@available(iOS 13.0, *)) {
//         
//         UINavigationBarAppearance *barApp = [[UINavigationBarAppearance alloc] init];
//         [barApp configureWithOpaqueBackground];
//         barApp.titleTextAttributes = textAttrs;
//         barApp.backgroundColor = kNavBarThemeColor;
//         self.navigationBar.standardAppearance = barApp;
//         self.navigationBar.scrollEdgeAppearance = barApp;
//     }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

@end
