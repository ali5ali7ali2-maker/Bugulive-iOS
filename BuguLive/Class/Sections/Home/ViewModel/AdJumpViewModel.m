//
//  AdJumpViewModel.m
//  BuguLive
//
//  Created by xfg on 16/10/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AdJumpViewModel.h"
#import "LeaderboardViewController.h"

@implementation AdJumpViewModel

+ (id)adToOthersWith:(HMHotBannerModel *)bannerModel
{
    if (bannerModel.type == 0)      // 跳转到普通webview
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:bannerModel.url isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = bannerModel.title;
        return tmpController;
    }
    else if(bannerModel.type == 1)      // 跳转到排行榜
    {
        
        
        if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
        {
            return nil;
        }
        LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
        lbVCtr.isHiddenTabbar = YES;
        return lbVCtr;
    }
    
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        return nil;
    }
    
    LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
    lbVCtr.isHiddenTabbar = YES;
    return lbVCtr;
    
}

@end
