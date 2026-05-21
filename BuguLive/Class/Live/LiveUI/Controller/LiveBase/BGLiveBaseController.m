//
//  BGLiveBaseController.m
//  BugoLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BGLiveBaseController.h"
#import "CountDownView.h"
#import "MusicCenterManager.h"
#import <CallKit/CallKit.h>

@interface BGLiveBaseController ()

@property(nonatomic, strong) UIImageView *otherPushBgView;
@property(nonatomic, strong) UILabel *otherPushLabel;

@end

@implementation BGLiveBaseController

- (void)dealloc
{
    [self releaseAll];
}

- (void)releaseAll
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setMode:_audioSesstionMode error:nil];
}

- (void)initCurrentLiveItem:(id<FWShowLiveRoomAble>)liveItem
{
    CurrentLiveInfo *tmpLiveItem;
    if ([liveItem isKindOfClass:[CurrentLiveInfo class]])
    {
        tmpLiveItem = (CurrentLiveInfo *)liveItem;
    }

    IMAHost *host = [IMAPlatform sharedInstance].host;
    NSString *loginId = [host imUserId];

    if (liveItem.liveType == FW_LIVE_TYPE_AUDIENCE && [loginId isEqualToString:[[liveItem liveHost] imUserId]])
    {
        _isReEnterChatGroup = YES;
        [self performSelector:@selector(hostBackTip) withObject:nil afterDelay:4];
    }

    _roomIDStr = StringFromInt([liveItem liveAVRoomId]);

    if ([liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        _isHost = NO;
    }
    else
    {
        _isHost = [loginId isEqualToString:[[liveItem liveHost] imUserId]];
        if (_isHost)
        {
            liveItem.liveType = FW_LIVE_TYPE_HOST;
        }
    }

    if (tmpLiveItem.live_in)
    {
        if (tmpLiveItem.live_in == FW_LIVE_STATE_ING)
        {
            _liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        else if (tmpLiveItem.live_in == FW_LIVE_STATE_RELIVE)
        {
            _liveType = FW_LIVE_TYPE_RELIVE;
        }
        else
        {
            _liveType = liveItem.liveType;
        }
    }
    else
    {
        _liveType = liveItem.liveType;
    }

    _sdkType = liveItem.sdkType;
    _sdkType = [[GlobalVariables sharedInstance].appModel.sdk_type intValue];
    _mickType = FW_MICK_TYPE_AGORA;

    self.liveItem = liveItem;
    [self.liveItem setIsHost:_isHost];

    SUS_WINDOW.isHost = _isHost;
    SUS_WINDOW.liveType = (int)_liveType;
}

- (void)hostBackTip
{
    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
    sendCustomMsgModel.msgType = MSG_ANCHOR_BACK;
    sendCustomMsgModel.msg = ASLocalizedString(@"主播回来啦，视频即将恢复~");
    sendCustomMsgModel.chatGroupID = [self.liveItem liveIMChatRoomId];
    [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
}

- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem modelArr:(NSArray *)modelArr
{
    if (self = [super init])
    {
        _isAtForeground = YES;
        _vagueImgUrl = [liveItem vagueImgUrl];
        _iMMsgHandler = [BGIMMsgHandler sharedInstance];
        _enterChatGroupTimes = 3;
        _bgTaskIdentifier = UIBackgroundTaskInvalid;
        _modelArr = [NSMutableArray arrayWithArray:modelArr];
        [self initCurrentLiveItem:liveItem];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.tintColor = kClearColor;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self vagueBackGround];
    [self checkNetWorkBeforeLive];

    _lossRateSendTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultMargin, 135, 0, 0)];
    _lossRateSendTipLabel.textColor = [UIColor whiteColor];
    _lossRateSendTipLabel.font = [UIFont systemFontOfSize:15.0];
    _lossRateSendTipLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _lossRateSendTipLabel.shadowOffset = CGSizeMake(1, 1);
    _lossRateSendTipLabel.hidden = YES;
    [self.view addSubview:_lossRateSendTipLabel];

    if ([GlobalVariables sharedInstance].isOtherPush) {
        [self.view addSubview:self.otherPushBgView];
        [self.view addSubview:self.otherPushLabel];
    }
}

#pragma mark - ----------------------- 添加相关监听 -----------------------
- (void)addAVSDKObservers
{
    NSError *error = nil;
    AVAudioSession *aSession = [AVAudioSession sharedInstance];

    _audioSesstionCategory = [aSession category];
    _audioSesstionMode = [aSession mode];

    [aSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];
    [aSession setMode:AVAudioSessionModeDefault error:&error];
    [aSession setActive:YES error:&error];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillTeminal:) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

// ✅ استبدال AudioSessionGetProperty المحذوفة بـ AVAudioSession الحديثة
- (BOOL)isOtherAudioPlaying
{
    return [[AVAudioSession sharedInstance] isOtherAudioPlaying];
}

- (void)onAppBecomeActive:(NSNotification *)notification
{
    if (![self isOtherAudioPlaying])
    {
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
}

#pragma mark app将要销毁
- (void)onAppWillTeminal:(NSNotification *)notification
{
    // reserved for subclass
}

#pragma mark - ----------------------- 进入、退出直播 -----------------------
- (void)alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    [BGUtils closeKeyboard];

    if (_iMMsgHandler.isExitRooming)
    {
        if (failed)
        {
            failed(FWCode_Normal_Error, ASLocalizedString(@"正在退出直播中"));
        }
        return;
    }

    MUSIC_CENTER_MANAGER.musicPlayingState = NO;
    _isDirectCloseLive = isDirectCloseLive;

    if (_isHost && _liveType == FW_LIVE_TYPE_HOST && isHostShowAlert)
    {
        FWWeakify(self)
        [FanweMessage alert:nil message:ASLocalizedString(@"您当前正在直播，是否退出直播？") destructiveAction:^{
            FWStrongify(self)
            [self realExitLive:succ failed:failed];
        } cancelAction:^{
            MUSIC_CENTER_MANAGER.musicPlayingState = YES;
        }];
    }
    else
    {
        [self realExitLive:succ failed:failed];
    }
}

- (void)realExitLive:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    _iMMsgHandler.isExitRooming = YES;
    [self exitChatGroup];
    [self removePhoneListener];
    [self onServiceExitLive:_isDirectCloseLive succ:succ failed:failed];
}

- (void)realExitLiveChatGroup
{
    __weak BGIMMsgHandler *im = _iMMsgHandler;
    [[IMAPlatform sharedInstance] asyncExitAVChatRoom:self.liveItem succ:^{
        [im removeGroupChatListener];
        NSLog(@"直播间退出群:%@ 成功1", [self.liveItem liveIMChatRoomId]);
    } fail:^(int code, NSString *msg) {
        [im removeGroupChatListener];
        NSLog(@"直播间退出群:%@ 失败1，错误码：%d，错误原因：%@", [self.liveItem liveIMChatRoomId], code, msg);
    }];
}

- (void)exitChatGroup
{
    __weak typeof(self) ws = self;
    [ws realExitLiveChatGroup];
    if (!_isHost)
    {
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_VIEWER_QUIT;
        sendCustomMsgModel.chatGroupID = [self.liveItem liveIMChatRoomId];
        [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:^{
        } fail:^(int code, NSString *msg) {
        }];
    }
}

#pragma mark - ----------------------- 模糊背景 -----------------------
- (void)vagueBackGround
{
    _vagueImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (_vagueImgUrl && ![_vagueImgUrl isEqualToString:@""])
    {
        [_vagueImgView sd_setImageWithURL:[NSURL URLWithString:_vagueImgUrl]];
    }
    else
    {
        [_vagueImgView setImage:[UIImage imageNamed:@"wel"]];
    }
    [self.view addSubview:_vagueImgView];
    [self.view bringSubviewToFront:_vagueImgView];

    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:beffect];
    view.frame = self.view.bounds;
    [_vagueImgView addSubview:view];
}

- (void)hideVagueImgView
{
    FWWeakify(self)
    [UIView animateWithDuration:0.2f animations:^{
        FWStrongify(self)
        self.vagueImgView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        self.vagueImgView.alpha = 0.f;
    } completion:^(BOOL finished) {
        FWStrongify(self)
        self.vagueImgView.hidden = YES;
    }];

    if (_isHost)
    {
        [CountDownView showCountDownViewInLiveVCwithFrame:CGRectMake(0, 0, 250, 250) inViewController:self block:nil];
        _hasShowVagueImg = YES;
    }
}

@end


#pragma mark - BGLiveBaseController (ProtectedMethod)
@implementation BGLiveBaseController (ProtectedMethod)

- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    [self initCurrentLiveItem:liveItem];
}

- (void)enterChatGroupSucc:(CurrentLiveInfo *)liveInfo
{
    [_iMMsgHandler setGroupChatListener:self.liveItem block:^(id selfPtr) {
        TCShowLiveListItem *liveRoom = (TCShowLiveListItem *)self.liveItem;

        if (![BGUtils isBlankString:liveInfo.group_id])
        {
            liveRoom.chatRoomId = liveInfo.group_id;
        }

        if ([BGUtils isBlankString:liveRoom.host.uid])
        {
            liveRoom.host.uid = liveInfo.podcast.user.user_id;
        }
        liveRoom.host.username = liveInfo.podcast.user.nick_name;
        liveRoom.host.avatar = liveInfo.podcast.user.head_image;
        self.liveItem = liveRoom;

        if (!_isHost && (liveInfo.join_room_prompt == 1 || [[IMAPlatform sharedInstance].host getUserRank] >= self.BuguLive.appModel.jr_user_level))
        {
            SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
            sendCustomMsgModel.msgType = MSG_VIEWER_JOIN;
            sendCustomMsgModel.chatGroupID = [self.liveItem liveIMChatRoomId];
            sendCustomMsgModel.is_guardian = liveInfo.is_guardian;
            sendCustomMsgModel.noble_icon = liveInfo.noble_icon;
            sendCustomMsgModel.guardianModel = [GlobalVariables sharedInstance].guardianModel;
            [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
        }
    }];
}

- (void)startEnterChatGroup:(NSString *)chatGroupID succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    _hasEnterChatGroup = YES;

    if (![BGUtils isBlankString:chatGroupID])
    {
        [self.liveItem setLiveIMChatRoomId:chatGroupID];
    }

    FWWeakify(self)
    [[IMAPlatform sharedInstance] asyncEnterAVChatRoom:self.liveItem isHost:_isReEnterChatGroup ? NO : _isHost succ:^(id<AVRoomAble> room) {
        FWStrongify(self)
        if (self.liveInfo)
        {
            [self enterChatGroupSucc:self.liveInfo];
        }
        [self.liveItem setLiveIMChatRoomId:[room liveIMChatRoomId]];
        [self addPhoneListener];
        [self performSelector:@selector(addNetListener) withObject:nil afterDelay:3];
        if (succ) { succ(); }

    } fail:^(int code, NSString *msg) {
        FWStrongify(self)
        self.enterChatGroupTimes--;
        if (self.enterChatGroupTimes)
        {
            [self startEnterChatGroup:@"" succ:succ failed:failed];
        }
        else
        {
            if (failed) { failed(code, msg); }
            [BGHUDHelper alert:ASLocalizedString(@"加入聊天室失败，请稍候尝试") action:^{}];
            DebugLog(@"=========加入直播聊天室失败 code: %d , msg = %@", code, msg);
        }
    }];
}

- (void)onServiceExitLive:(BOOL)isDirectCloseLive succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    // 供子类重写
}

- (void)onExitLiveUI
{
    _iMMsgHandler.isExitRooming = NO;
    _iMMsgHandler.isEnterRooming = NO;
    self.BuguLive.liveState = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setMode:_audioSesstionMode error:nil];

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [SuspenionWindow resetSusWindowPramaWhenLiveClosedComplete:nil];
}

#pragma mark - ----------------------- 网络、电话、进入前后台监听 -----------------------
- (void)checkNetWorkBeforeLive
{
    __weak typeof(self) ws = self;
    __weak BGIMMsgHandler *msgHandler = _iMMsgHandler;

    switch ([AppDelegate sharedAppDelegate].reachabilityStatus)
    {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            [self addAVSDKObservers];
            msgHandler.isEnterRooming = YES;
            [ws startEnterChatGroup:@"" succ:nil failed:nil];
        }
            break;

        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
        default:
        {
            NSString *tip = [NSString stringWithFormat:ASLocalizedString(@"当前无网络，无法%@直播"), _isHost ? ASLocalizedString(@"创建") : ASLocalizedString(@"加入")];
            [self tipMessage:tip delay:2 completion:^{
                [self onExitLiveUI];
            }];
        }
            break;
    }
}

- (void)addNetListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)ReachabilityDidChange:(NSNotification *)not
{
    NSDictionary *userInfo = not.userInfo;
    AFNetworkReachabilityStatus reachabilityStatus = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    switch (reachabilityStatus)
    {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
            break;

        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
        default:
        {
            [FanweMessage alert:[NSString stringWithFormat:ASLocalizedString(@"当前无网络，无法继续%@直播！"), _isHost ? @"" : ASLocalizedString(@"观看")]];
        }
            break;
    }
}

// ✅ استبدال CTCallCenter/CTCall بـ CXCallObserver من CallKit
#pragma mark 添加电话监听
- (void)addPhoneListener
{
    if (!_callObserver)
    {
        _callObserver = [[CXCallObserver alloc] init];
        [_callObserver setDelegate:self queue:dispatch_get_main_queue()];
    }
}

#pragma mark 移除电话监听
- (void)removePhoneListener
{
    [_callObserver setDelegate:nil queue:nil];
    _callObserver = nil;
}

// ✅ CXCallObserverDelegate - بديل handlePhostEvent
- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call
{
    if (call.hasEnded)
    {
        // الهاتف انتهى
        if (_hasHandleCall)
        {
            DebugLog(@"电话中断处理：在前台接的电话，挂断后立即回到前台");
            [self phoneInterruptioning:NO];
        }
        else
        {
            DebugLog(@"电话中断处理：退到后台接话：不处理");
        }
    }
    else if (!call.hasConnected && !call.isOutgoing)
    {
        // رنين وارد
        if (!_isPhoneInterupt && _isAtForeground)
        {
            _isPhoneInterupt = YES;
            _hasHandleCall = YES;
            [self phoneInterruptioning:YES];
        }
    }
}

- (void)isInterruptioning:(BOOL)interruptioning
{
    if (interruptioning)
    {
        // ✅ حفظ الـ background task identifier وإنهاؤه صح
        if (_bgTaskIdentifier == UIBackgroundTaskInvalid)
        {
            __weak typeof(self) ws = self;
            _bgTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [ws endBackgroundTask];
            }];
        }

        if (_isAtForeground)
        {
            _isAtForeground = NO;
            _backGroundTime = [[NSDate date] timeIntervalSince1970];

            if (_liveType == FW_LIVE_TYPE_HOST)
            {
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_ANCHOR_LEAVE;
                sendCustomMsgModel.msg = ASLocalizedString(@"主播离开一下，精彩不中断，不要走开哦");
                sendCustomMsgModel.chatGroupID = [self.liveItem liveIMChatRoomId];
                [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
            }
        }
    }
    else
    {
        // ✅ إنهاء الـ background task عند العودة للـ foreground
        [self endBackgroundTask];

        if (!_isAtForeground)
        {
            _isAtForeground = YES;
            _foreGroundTime = [[NSDate date] timeIntervalSince1970];

            if (_liveType == FW_LIVE_TYPE_HOST)
            {
                [self hostBackTip];
            }
        }
    }
}

- (void)endBackgroundTask
{
    if (_bgTaskIdentifier != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:_bgTaskIdentifier];
        _bgTaskIdentifier = UIBackgroundTaskInvalid;
    }
}

- (void)onAppEnterForeground
{
    [self isInterruptioning:NO];
}

- (void)onAppEnterBackground
{
    [self isInterruptioning:YES];
}

- (void)phoneInterruptioning:(BOOL)interruptioning
{
    [self isInterruptioning:interruptioning];
    if (!interruptioning)
    {
        _hasHandleCall = NO;
        _isPhoneInterupt = NO;
    }
}

- (void)onAudioInterruption:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSNumber *interuptionType = [interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey];
    if (interuptionType.intValue == AVAudioSessionInterruptionTypeBegan)
    {
        DebugLog(@"初中断");
    }
    else if (interuptionType.intValue == AVAudioSessionInterruptionTypeEnded)
    {
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
}

- (void)isShowFollow:(NSNotification *)notification
{
}

- (void)audioRouteChangeListenerCallback:(NSNotification *)notification
{
    // 供子类重写
}

- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)(void))completion
{
    [[BGHUDHelper sharedInstance] tipMessage:msg delay:seconds completion:completion];
}

- (UIImageView *)otherPushBgView
{
    if (!_otherPushBgView)
    {
        _otherPushBgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _otherPushBgView.image = [UIImage imageNamed:@"外设直播_背景图"];
        _otherPushBgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _otherPushBgView;
}

- (UILabel *)otherPushLabel
{
    if (!_otherPushLabel)
    {
        _otherPushLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _otherPushLabel.text = ASLocalizedString(@"其他设备推流中");
        _otherPushLabel.textColor = kWhiteColor;
        _otherPushLabel.font = [UIFont systemFontOfSize:18];
        _otherPushLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _otherPushLabel;
}

@end