//
//  LiveCenterManager.m
//  BuguLive
//
//  Created by 岳克奎 on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "LiveCenterManager.h"
#define JUMP_HOME_PAGE 0
#import "BGVoiceController.h"
#import "RoomCloseMoreView.h"
#import "UIButton+XYButton.h"

@implementation LiveCenterManager

BogoSingletonM(Instance);

#pragma mark ------------------------------------------- 直播间开启部分 -------------------------------------------

- (void)showLiveOfAPIPramaDic:(NSMutableDictionary *)dic isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block
{
    [[AppDelegate sharedAppDelegate] isShowHud:YES hideTime:6];
    SUS_WINDOW.isSusWindow = isSusWindow;
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;

    __weak typeof(self) weak_Self = self;
    [[LiveCenterAPIManager sharedInstance] liveCenterAPIOfShowHostLiveOfDic:dic block:^(NSDictionary *responseJson, BOOL finished, NSError *error) {
        [[AppDelegate sharedAppDelegate] hideHud];
        if (finished && !error && responseJson)
        {
            IMAHost *host = [IMAPlatform sharedInstance].host;
            TCShowUser *user = [[TCShowUser alloc] init];
            user.avatar = [host imUserIconUrl];
            user.uid = [host imUserId];
            user.username = [host imUserName];

            TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
            liveRoom.host = user;
            liveRoom.avRoomId = [responseJson toInt:@"room_id"];
            liveRoom.title = [NSString stringWithFormat:@"%d", liveRoom.avRoomId];
            liveRoom.vagueImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict toString:@"head_image"];
            liveRoom.liveType = SUS_WINDOW.liveType;
            liveRoom.isHost = SUS_WINDOW.isHost;

            UIViewController *tempLiveViewController = [weak_Self showNewLiveOfTCShowLiveListItem:liveRoom withModelArr:nil];
            if (isSusWindow)
            {
                [weak_Self showSusWindowPartOfIsSusWindow:isSusWindow isSmallScreen:isSmallScreen liveViewControleller:tempLiveViewController block:^(BOOL isFinished) {
                    if (block) { block(isFinished); }
                }];
            }
            else
            {
                if (block) { block(YES); }
            }
        }
        else
        {
            if (block) { block(NO); }
        }
    }];
}

- (void)showLiveOfAPIResponseJson:(NSMutableDictionary *)responseJson isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block
{
    SUS_WINDOW.isSusWindow = isSusWindow;
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;

    __weak typeof(self) weak_Self = self;
    IMAHost *host = [IMAPlatform sharedInstance].host;
    if (!host)
    {
        [[BGIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        if (block) { block(NO); }
        return;
    }

    [GlobalVariables sharedInstance].appModel.spear_live = @"1";
    TCShowUser *user = [[TCShowUser alloc] init];
    user.avatar = [host imUserIconUrl];
    user.uid = [host imUserId];
    user.username = [host imUserName];

    TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
    liveRoom.host = user;
    liveRoom.avRoomId = [responseJson toInt:@"room_id"];
    liveRoom.title = [NSString stringWithFormat:@"%d", liveRoom.avRoomId];
    liveRoom.vagueImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict toString:@"head_image"];
    liveRoom.liveType = SUS_WINDOW.liveType;
    liveRoom.isHost = SUS_WINDOW.isHost;
    liveRoom.is_voice = ([responseJson toInt:@"is_voice"] == 1) ? 1 : 0;

    UIViewController *tempLiveViewController = [weak_Self showNewLiveOfTCShowLiveListItem:liveRoom withModelArr:nil];
    if (isSusWindow)
    {
        [weak_Self showSusWindowPartOfIsSusWindow:isSusWindow isSmallScreen:isSmallScreen liveViewControleller:tempLiveViewController block:^(BOOL isFinished) {
            if (block) { block(isFinished); }
        }];
    }
    else
    {
        if (block) { block(YES); }
    }
}

- (void)showLiveOfAudienceLiveofPramaDic:(NSMutableDictionary *)dic isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block
{
    if (!isSusWindow && isSmallScreen)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"直播间预加载参数出错")];
    }

    if (![[IMAPlatform sharedInstance].host conformsToProtocol:@protocol(AVUserAble)])
    {
        [[BGHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
            [[BGIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        } completion:^{}];
        return;
    }

    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
    item.chatRoomId = dic[@"group_id"];
    item.avRoomId = (int)[dic[@"room_id"] integerValue];
    item.title = StringFromInt(item.avRoomId);
    item.vagueImgUrl = dic[@"head_image"];

    TCShowUser *showUser = [[TCShowUser alloc] init];
    showUser.uid = dic[@"user_id"];
    showUser.avatar = item.vagueImgUrl;
    item.host = showUser;
    item.is_voice = ([dic[@"is_voice"] integerValue] == 1) ? 1 : 0;

    if ([dic[@"live_in"] integerValue] == FW_LIVE_STATE_ING)
    {
        item.liveType = FW_LIVE_TYPE_AUDIENCE;
    }
    else if ([dic[@"live_in"] integerValue] == FW_LIVE_STATE_RELIVE)
    {
        item.liveType = FW_LIVE_TYPE_RELIVE;
    }
    else
    {
        [FanweMessage alert:ASLocalizedString(@"视频已结束或正在创建中！")];
        return;
    }

    SUS_WINDOW.sdkType = [[GlobalVariables sharedInstance].appModel.sdk_type intValue];
    SUS_WINDOW.liveType = (int)item.liveType;
    SUS_WINDOW.isSusWindow = isSusWindow;
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    SUS_WINDOW.isHost = NO;

    __weak typeof(self) weak_Self = self;
    UIViewController *tempLiveViewController = [weak_Self showNewLiveOfTCShowLiveListItem:item withModelArr:nil];
    if (SUS_WINDOW.isSusWindow)
    {
        [SUS_WINDOW makeKeyWindow];
        SUS_WINDOW.hidden = NO;
        [weak_Self showSusWindowPartOfIsSusWindow:isSusWindow isSmallScreen:isSmallScreen liveViewControleller:tempLiveViewController block:^(BOOL isFinished) {}];
    }
}

- (void)showLiveOfAudienceLiveofTCShowLiveListItem:(TCShowLiveListItem *)item modelArr:(NSArray *)modelArr isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"video" forKey:@"ctl"];
    [dict setObject:@"check_status" forKey:@"act"];
    [dict setValue:StringFromInt(item.avRoomId) forKey:@"room_id"];

    if (item.is_voice)
    {
        [dict setValue:@"voice" forKey:@"ctl"];
        [dict setValue:@"voice_status" forKey:@"act"];
    }

    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
        if ([responseJson toInt:@"status"] == 1)
        {
            [GlobalVariables sharedInstance].isOtherPush = NO;

            if (item.liveType == FW_LIVE_TYPE_RELIVE && JUMP_HOME_PAGE)
            {
                SHomePageVC *tmpController = [[SHomePageVC alloc] init];
                tmpController.user_id = item.host.uid;
                tmpController.type = 0;
                [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
                return;
            }

            SUS_WINDOW.liveType = [[GlobalVariables sharedInstance].appModel.sdk_type intValue];
            SUS_WINDOW.isSusWindow = isSusWindow;
            SUS_WINDOW.isSmallSusWindow = isSmallScreen;
            SUS_WINDOW.isHost = NO;

            __weak typeof(self) weak_Self = self;
            UIViewController *tempLiveViewController = [weak_Self showNewLiveOfTCShowLiveListItem:item withModelArr:modelArr];
            if (SUS_WINDOW.isSusWindow)
            {
                [SUS_WINDOW makeKeyWindow];
                SUS_WINDOW.hidden = NO;
                [weak_Self showSusWindowPartOfIsSusWindow:isSusWindow isSmallScreen:isSmallScreen liveViewControleller:tempLiveViewController block:^(BOOL isFinished) {}];
            }
        }
        else
        {
            [BGHUDHelper alert:responseJson[@"error"]];
        }
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
}

#pragma mark - private methods

- (UIViewController *)showNewLiveOfTCShowLiveListItem:(TCShowLiveListItem *)item withModelArr:(NSArray *)modelArr
{
    SUS_WINDOW.sdkType = [[GlobalVariables sharedInstance].appModel.sdk_type integerValue];

    if (item.is_voice == 1)
    {
        BGVoiceController *liveVC = [[BGVoiceController alloc] initWith:item modelArr:modelArr];
        SUS_WINDOW.recordFWTLiveController = liveVC;
        if (SUS_WINDOW.isSusWindow)
        {
            SUS_WINDOW.rootViewController = [[UINavigationController alloc] initWithRootViewController:liveVC];
        }
        else
        {
            [APP_DELEGATE pushViewController:liveVC animated:YES];
        }
        return liveVC;
    }

    if (SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_TXY)
    {
        BGTLiveController *liveVC = [[BGTLiveController alloc] initWith:item modelArr:modelArr];
        SUS_WINDOW.recordFWTLiveController = liveVC;
        if (SUS_WINDOW.isSusWindow)
        {
            SUS_WINDOW.rootViewController = [[UINavigationController alloc] initWithRootViewController:liveVC];
        }
        else
        {
            [APP_DELEGATE pushViewController:liveVC animated:YES];
        }
        return liveVC;
    }
    else if (SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_KSY)
    {
        BGKSYLiveController *liveVC = [[BGKSYLiveController alloc] initWith:item modelArr:modelArr];
        SUS_WINDOW.threeFWKSYLiveController = liveVC;
        if (SUS_WINDOW.isSusWindow)
        {
            SUS_WINDOW.rootViewController = [[UINavigationController alloc] initWithRootViewController:liveVC];
        }
        else
        {
            [APP_DELEGATE pushViewController:liveVC animated:YES];
        }
        return liveVC;
    }
    else if (SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_VOICE)
    {
        BGVoiceController *liveVC = [[BGVoiceController alloc] initWith:item modelArr:modelArr];
        SUS_WINDOW.recordFWTLiveController = liveVC;
        if (SUS_WINDOW.isSusWindow)
        {
            SUS_WINDOW.rootViewController = [[UINavigationController alloc] initWithRootViewController:liveVC];
        }
        else
        {
            [APP_DELEGATE pushViewController:liveVC animated:YES];
        }
        return liveVC;
    }

    return nil;
}

- (void)showSusWindowPartOfIsSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen liveViewControleller:(UIViewController *)liveViewControleller block:(FWIsFinishedBlock)block
{
    [SUS_WINDOW makeKeyWindow];
    SUS_WINDOW.hidden = NO;
    SUS_WINDOW.isSusWindow = isSusWindow;
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    [SuspenionWindow showLoadGeatureOfSusWindow];
    [SuspenionWindow showAnimationOfSusWindowSizeBlock:^(BOOL finished) {
        if (block) { block(finished); }
    }];
}

#pragma mark ------------------------------------------- 直播间关闭部分 -------------------------------------------

- (void)closeLiveOfPramaOfLiveViewController:(UIViewController *)liveViewController paiTimeNum:(int)paiTimeNum alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert colseLivecomplete:(FWIsFinishedBlock)block
{
    MUSIC_CENTER_MANAGER.musicPlayingState = NO;

    if (!liveViewController)
    {
        if (block) { block(NO); }
        return;
    }

    SUS_WINDOW.isDirectCloseLive = isDirectCloseLive;
    SUS_WINDOW.isHostShowAlert = isHostShowAlert;
    [BGUtils closeKeyboard];

    __weak typeof(self) weak_Self = self;
    [SuspenionWindow closeSuswindowUIComplete:^(BOOL finished) {
        SUS_WINDOW.window_Pan_Ges.enabled = NO;
        if (finished)
        {
            [weak_Self closeLiveAfterClosedOfSusWindowUIOfLiveViewController:liveViewController paiTimeNum:paiTimeNum closeComplete:^(BOOL isFinished) {
                if (block) { block(isFinished); }
            }];
        }
    }];
}

- (void)closeLiveAfterClosedOfSusWindowUIOfLiveViewController:(UIViewController *)liveViewControlelr paiTimeNum:(int)paiTimeNum closeComplete:(FWIsFinishedBlock)block
{
    __weak typeof(self) weak_Self = self;

    // ✅ إصلاح: safe cast مع nil check قبل أي استخدام
    __weak BGTLiveController *tLiveC = nil;
    __weak BGKSYLiveController *ksyLiveC = nil;

    if (SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_TXY && [liveViewControlelr isKindOfClass:[BGTLiveController class]])
    {
        tLiveC = (BGTLiveController *)liveViewControlelr;
        tLiveC.isDirectCloseLive = SUS_WINDOW.isDirectCloseLive;
        [tLiveC.publishController.txLivePublisher pauseBGM];
    }
    if (SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_KSY && [liveViewControlelr isKindOfClass:[BGKSYLiveController class]])
    {
        ksyLiveC = (BGKSYLiveController *)liveViewControlelr;
        ksyLiveC.isDirectCloseLive = SUS_WINDOW.isDirectCloseLive;
    }

    if (paiTimeNum)
    {
        if (SUS_WINDOW.liveType == FW_LIVE_TYPE_HOST)
        {
            if (block) { block(NO); }
            return;
        }
        else if (SUS_WINDOW.liveType == FW_LIVE_TYPE_AUDIENCE && SUS_WINDOW.isHostShowAlert)
        {
            [weak_Self closeLiveRealOfSDKWithLiveViewController:liveViewControlelr complete:^(BOOL isFinished) {
                if (block) { block(YES); }
            }];
        }
    }

    if (SUS_WINDOW.liveType == FW_LIVE_TYPE_HOST)
    {
        // ✅ إصلاح: BGVoiceController عنده exit path خاص بيه
        if ([liveViewControlelr isKindOfClass:[BGVoiceController class]])
        {
            __weak __typeof(self) weakSelf = self;
            BGVoiceController *voiceVC = (BGVoiceController *)liveViewControlelr;

            RoomCloseMoreView *moreView = [RoomCloseMoreView getView];
            moreView.frame = liveViewControlelr.view.bounds;

            [moreView.shareBtn addTapBlock:^(UIButton *btn) {
                [moreView hide];
                [voiceVC.liveServiceController clickShareBtn:nil];
            }];

            [moreView.cancelBtn addTapBlock:^(UIButton *btn) {
                [moreView hide];
            }];

            [moreView.colseBtn addTapBlock:^(UIButton *btn) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:@"voice" forKey:@"ctl"];
                [dict setValue:@"close_voice" forKey:@"act"];
                [dict setValue:voiceVC.liveInfo.room_id forKey:@"room_id"];

                [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                    // ✅ إصلاح: استخدام realExitLive على BGVoiceController صح
                    [voiceVC realExitLive:^{
                        [weakSelf resetSuswindowPramaComple:^(BOOL isFinished) {
                            if (block) { block(YES); }
                        }];
                    } failed:^(int errId, NSString *errMsg) {
                        [weakSelf resetSuswindowPramaComple:^(BOOL isFinished) {
                            if (block) { block(YES); }
                        }];
                    }];
                } FailureBlock:^(NSError *error) {
                    NSLog(@"结束PK请求失败error:%@", error);
                }];
            }];

            [liveViewControlelr.view addSubview:moreView];
            [moreView show:liveViewControlelr.view type:FDPopTypeCenter];
        }
        else
        {
            [FanweMessage alert:nil message:ASLocalizedString(@"确定要结束直播吗？") destructiveAction:^{
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:@"pk_tencent" forKey:@"ctl"];
                [dict setValue:@"request_end_pk" forKey:@"act"];
                [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                    NSLog([responseJson toInt:@"status"] == 1 ? @"结束PK请求成功" : @"结束PK请求失败");
                } FailureBlock:^(NSError *error) {
                    NSLog(@"结束PK请求失败error:%@", error);
                }];

                [weak_Self closeLiveRealOfSDKWithLiveViewController:liveViewControlelr complete:^(BOOL isFinished) {
                    if (block) { block(YES); }
                }];
            } cancelAction:^{
                if (block) { block(NO); }
            }];
        }
    }

    if (SUS_WINDOW.liveType == FW_LIVE_TYPE_RELIVE || SUS_WINDOW.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if ([liveViewControlelr isKindOfClass:[BGVoiceController class]])
        {
            __weak __typeof(self) weakSelf = self;
            BGVoiceController *voiceVC = (BGVoiceController *)liveViewControlelr;

            RoomCloseMoreView *moreView = [RoomCloseMoreView getView];
            moreView.frame = liveViewControlelr.view.bounds;

            [moreView.shareBtn addTapBlock:^(UIButton *btn) {
                [moreView hide];
                [voiceVC.liveServiceController clickShareBtn:nil];
            }];

            [moreView.cancelBtn addTapBlock:^(UIButton *btn) {
                [moreView hide];
            }];

            // ✅ إصلاح: استخدام realExitLive على BGVoiceController
            [moreView.colseBtn addTapBlock:^(UIButton *btn) {
                [voiceVC realExitLive:^{
                    [weakSelf resetSuswindowPramaComple:^(BOOL isFinished) {
                        if (block) { block(YES); }
                    }];
                } failed:^(int errId, NSString *errMsg) {
                    [weakSelf resetSuswindowPramaComple:^(BOOL isFinished) {
                        if (block) { block(YES); }
                    }];
                }];
            }];

            [liveViewControlelr.view addSubview:moreView];
            [moreView show:liveViewControlelr.view type:FDPopTypeCenter];
        }
        else
        {
            [weak_Self closeLiveRealOfSDKWithLiveViewController:liveViewControlelr complete:^(BOOL isFinished) {
                if (block) { block(YES); }
            }];
        }
    }
}

// ✅ إصلاح: أضفت handling لـ BGVoiceController
- (void)closeLiveRealOfSDKWithLiveViewController:(UIViewController *)liveViewController complete:(FWIsFinishedBlock)block
{
    __weak typeof(self) weak_self = self;

    // ✅ BGVoiceController — exit path خاص بيه
    if ([liveViewController isKindOfClass:[BGVoiceController class]])
    {
        BGVoiceController *voiceVC = (BGVoiceController *)liveViewController;
        [voiceVC realExitLive:^{
            [weak_self resetSuswindowPramaComple:^(BOOL isFinished) {
                if (block) { block(YES); }
            }];
        } failed:^(int errId, NSString *errMsg) {
            [weak_self resetSuswindowPramaComple:^(BOOL isFinished) {
                if (block) { block(YES); }
            }];
        }];
        return;
    }

    // ✅ BGTLiveController — مع nil check وisKindOfClass
    if (SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_TXY && [liveViewController isKindOfClass:[BGTLiveController class]])
    {
        BGTLiveController *tLiveC = (BGTLiveController *)liveViewController;
        [tLiveC realExitLive:^{
            [weak_self resetSuswindowPramaComple:^(BOOL isFinished) {
                if (block) { block(YES); }
            }];
        } failed:^(int errId, NSString *errMsg) {
            [weak_self resetSuswindowPramaComple:^(BOOL isFinished) {
                if (block) { block(YES); }
            }];
        }];
        return;
    }

    // ✅ BGKSYLiveController — مع nil check وisKindOfClass
    if (SUS_WINDOW.sdkType == FW_LIVESDK_TYPE_KSY && [liveViewController isKindOfClass:[BGKSYLiveController class]])
    {
        BGKSYLiveController *ksyLiveC = (BGKSYLiveController *)liveViewController;
        [ksyLiveC realExitLive:^{
            [weak_self resetSuswindowPramaComple:^(BOOL isFinished) {
                if (block) { block(YES); }
            }];
        } failed:^(int errId, NSString *errMsg) {
            [weak_self resetSuswindowPramaComple:^(BOOL isFinished) {
                if (block) { block(YES); }
            }];
        }];
        return;
    }

    // fallback لو مفيش match
    if (block) { block(YES); }
}

- (void)resetSuswindowPramaComple:(FWIsFinishedBlock)block
{
    if (![BGUtils isBlankString:SUS_WINDOW.switchedRoomId])
    {
        NSString *tmpStr = SUS_WINDOW.switchedRoomId;
        SUS_WINDOW.switchedRoomId = nil;

        [BGLiveSDKViewModel checkVideoStatus:tmpStr successBlock:^(NSDictionary *responseJson) {
            TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
            item.chatRoomId = [responseJson toString:@"group_id"];
            item.avRoomId = [[responseJson toString:@"room_id"] intValue];
            item.title = [responseJson toString:@"room_id"];

            NSInteger live_in = [responseJson toInt:@"live_in"];
            if (live_in == FW_LIVE_STATE_ING)
            {
                item.liveType = FW_LIVE_TYPE_AUDIENCE;
                BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
                [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofTCShowLiveListItem:item modelArr:nil isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL isFinished) {}];
            }
            else
            {
                [FanweMessage alert:ASLocalizedString(@"该直播已结束")];
            }
        } failureBlock:^(NSError *error) {}];
    }

    if (!SUS_WINDOW.isDirectCloseLive)
    {
        if (block) { block(NO); }
        return;
    }

    [SuspenionWindow resetSusWindowPramaWhenLiveClosedComplete:^(BOOL finished) {
        if (block) { block(finished); }
    }];
}

- (void)showChangeLiveScreenSOfIsSmallScreen:(BOOL)isSmallScreen complete:(FWIsFinishedBlock)block
{
    if (!SUS_WINDOW.isSusWindow) return;
    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    [SuspenionWindow showAnimationOfSusWindowSizeBlock:^(BOOL finished) {
        if (block) { block(finished); }
    }];
}

#pragma mark - 竞拍区域

- (void)showChangeAuctionLiveScreenSOfIsSmallScreen:(BOOL)isSmallScreen nextViewController:(UIViewController *)nextViewController delegateWindowRCNameStr:(NSString *)delegateWindowRCNameStr complete:(FWIsFinishedBlock)block
{
    if (!SUS_WINDOW.isSusWindow) return;

    if (!((isSmallScreen && nextViewController) || (!isSmallScreen && ![delegateWindowRCNameStr isEmpty])))
    {
        [FanweMessage alertHUD:ASLocalizedString(@"参数错误!")];
        return;
    }

    SUS_WINDOW.isSmallSusWindow = isSmallScreen;
    if (isSmallScreen && nextViewController)
    {
        BGNavigationController *nav = [[BGNavigationController alloc] initWithRootViewController:nextViewController];
        APP_DELEGATE.window.rootViewController = nav;
    }

    [SuspenionWindow showAnimationOfSusWindowSizeBlock:^(BOOL finished) {
        if (finished && !isSmallScreen && ![delegateWindowRCNameStr isEmpty])
        {
            [SuspenionWindow closeSanwichLayerOfNetRootVCStr:delegateWindowRCNameStr complete:^(BOOL finished) {
                if (block) { block(finished); }
            }];
        }
        else
        {
            if (block) { block(finished); }
        }
    }];
}

#pragma mark - 踢下线通知

- (void)showOffLineWarningwithIMAPlatform:(IMAPlatform *)imAPlatform complete:(FWIsFinishedBlock)block
{
    void (^exitLive)(void) = ^{
        if (SUS_WINDOW.liveType == 0 || SUS_WINDOW.liveType == 1 || SUS_WINDOW.liveType == 2)
        {
            if (SUS_WINDOW.recordFWTLiveController)
            {
                [SUS_WINDOW.recordFWTLiveController alertExitLive:YES isHostShowAlert:NO succ:^{
                    [imAPlatform doLogout];
                } failed:^(int errId, NSString *errMsg) {
                    [imAPlatform doLogout];
                }];
            }
            else if (SUS_WINDOW.threeFWKSYLiveController)
            {
                [SUS_WINDOW.threeFWKSYLiveController alertExitLive:YES isHostShowAlert:NO succ:^{
                    [imAPlatform doLogout];
                } failed:^(int errId, NSString *errMsg) {
                    [imAPlatform doLogout];
                }];
            }
            else
            {
                [imAPlatform doLogout];
            }
        }
    };

    [FanweMessage alert:ASLocalizedString(@"下线通知") message:ASLocalizedString(@"您的账号在其他设备登录，如果不是您的操作，请及时修改密码") destructiveAction:^{
        if (block) { block(YES); }
        exitLive();
    } cancelAction:^{
        if (block) { block(YES); }
        exitLive();
    }];
}

#pragma mark - 进入直播

- (void)showLiveOfTCShowLiveListItem:(TCShowLiveListItem *)liveListItem andLiveWindowType:(LiveWindowType)liveWindowType andLiveType:(FW_LIVE_TYPE)liveType andLiveSDKType:(FW_LIVESDK_TYPE)liveSDKType andCompleteBlock:(FWIsFinishedBlock)block
{
    BOOL isOpenSusWindow = NO;
    BOOL isOpenNormalWindow = NO;
    UIViewController *liveVC;

    if (liveSDKType == FW_LIVESDK_TYPE_TXY)
    {
        liveVC = [[BGTLiveController alloc] initWith:liveListItem modelArr:nil];
        [_stSuspensionWindow setDelegate:(BGTLiveController *)liveVC];
    }
    else if (liveSDKType == FW_LIVESDK_TYPE_KSY)
    {
        liveVC = [BGKSYLiveController showLiveViewCwith:liveListItem];
        [_stSuspensionWindow setDelegate:(BGKSYLiveController *)liveVC];
    }
    else if (liveSDKType == FW_LIVESDK_TYPE_VOICE)
    {
        liveVC = [[BGVoiceController alloc] initWith:liveListItem modelArr:nil];
        [_stSuspensionWindow setDelegate:(BGVoiceController *)liveVC];
    }
    else
    {
        if (block) { block(NO); }
        return;
    }

    if (liveWindowType == liveWindowTypeOfSusOfFullSize || liveWindowType == LiveWindowTypeOfSusSmallSize)
    {
        isOpenSusWindow = YES;
    }
    else if (liveWindowType == LiveWindowTypeOfNormolOfFullSize || liveWindowType == LiveWindowTypeOfNormolSmallSize)
    {
        isOpenNormalWindow = YES;
    }

    if ((isOpenSusWindow && !isOpenNormalWindow) || (!isOpenSusWindow && isOpenNormalWindow))
    {
        if (isOpenSusWindow)
        {
            _stSuspensionWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:liveVC];
            _stSuspensionWindow.windowLevel = 3005;
            [_stSuspensionWindow makeKeyWindow];
            _stSuspensionWindow.hidden = NO;
        }
        else
        {
            [APP_DELEGATE pushViewController:liveVC animated:YES];
        }

        [self setLiveSDKType:liveSDKType];
        [self setLiveType:liveType];
        [self setRecordLiveViewC:liveVC];
        [self setLiveWindowType:liveWindowType];
        if (block) { block(YES); }
    }
    else
    {
        if (block) { block(NO); }
    }
}

#pragma mark - 关直播

- (void)showCloseLiveComplete:(FWIsFinishedBlock)block
{
    if (!_recordLiveViewC)
    {
        if (block) { block(NO); }
        return;
    }

    [BGUtils closeKeyboard];

    if (_liveWindowType == LiveWindowTypeOfSusSmallSize)
    {
        [self setLiveWindowType:liveWindowTypeOfSusOfFullSize];
    }
    else if (_liveWindowType == liveWindowTypeOfSusOfFullSize || _liveWindowType == LiveWindowTypeOfNormolOfFullSize)
    {
        [self setLiveWindowType:_liveWindowType];
    }
    else
    {
        if (block) { block(NO); }
        return;
    }

    if (block) { block(YES); }
}

- (BOOL)judgeIsSusWindow { return NO; }
- (BOOL)judgeIsSmallSusWindow { return NO; }

#pragma mark - get/set

- (STSuspensionWindow *)stSuspensionWindow
{
    if (!_stSuspensionWindow)
    {
        _stSuspensionWindow = [STSuspensionWindow showWindowTypeOfSTBaseSuspensionWindowOfFrameRect:CGRectMake(0, 0, kScreenW, kScreenH) ofSTBaseSuspensionWindowLevelValue:3050 complete:^(BOOL finished, STSuspensionWindow *stSuspensionWindow) {}];
    }
    return _stSuspensionWindow;
}

- (void)setLiveWindowType:(LiveWindowType)liveWindowType
{
    if (_liveWindowType != liveWindowType)
    {
        if (_stSuspensionWindow)
        {
            _liveWindowType = liveWindowType;
        }
        [_stSuspensionWindow setStSusWindowShowState:stSusWindowShowYES];
        [_stSuspensionWindow setIsSmallSize:(liveWindowType == LiveWindowTypeOfNormolSmallSize ? YES : NO)];
    }
}

- (void)setItemModel:(TCShowLiveListItem *)itemModel
{
    _itemModel = itemModel;
}

@end