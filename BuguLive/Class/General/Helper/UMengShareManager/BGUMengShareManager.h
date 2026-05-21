//
//  BGUMengShareManager.h
//  BuguLive
//
//  Created by xfg on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import "ShareModel.h"
#import "BogoSingleton.h"

typedef void (^FWUMengSuccBlock)(UMSocialShareResponse *response);

@interface BGUMengShareManager : BGBaseViewModel

// 单例模式
BogoSingletonH(Instance);

// 弹出分享面板
- (void)showShareViewInControllr:(UIViewController *)vc shareModel:(ShareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed;

// 根据分享类型进行分享
- (void)shareTo:(UIViewController *)vc platformType:(UMSocialPlatformType)platformType shareModel:(ShareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed;

@end
