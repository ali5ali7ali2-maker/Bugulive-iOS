//
//  AppDelegate.h
//  BuguLive
//
//  Created by xfg on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuspenionWindow.h"
#import "BGBaseAppDelegate.h"
#import "AFNetworking.h"
#import "BGLiveBaseController.h"
#import "BGTabBarController.h"
#import "BGNavigationController.h"

#import "BogoNoNetworkView.h"


@interface AppDelegate : BGBaseAppDelegate

@property (nonatomic, strong) SuspenionWindow               *sus_window;

@property(nonatomic, strong) BogoNoNetworkView *noNetworkView;

@property (nonatomic, assign) AFNetworkReachabilityStatus   reachabilityStatus;

@property (nonatomic, assign) BOOL                          isTabBarShouldLoginIMSDK;

@property (nonatomic, strong) BGNavigationController        *webViewNav;                // 需要我们重写get，去保存老的web页面，这样 好与H5交互

+ (instancetype)sharedAppDelegate;

- (void)entertabBar;

- (void)isShowHud:(BOOL)isShow hideTime:(float)hideTime;

- (void)hideHud;

- (void)beginEnterMianUI;

@end

