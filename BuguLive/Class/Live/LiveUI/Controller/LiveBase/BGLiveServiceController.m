//
//  BGLiveServiceController.m
//  BugoLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BGLiveServiceController.h"
#import "BGMD5UTils.h"
#import "PKUserListViewController.h"
#define MESSAGE_SURVIVAL_TIME           20
#define BARRAGE_VIEW_ANIMATE_TIME       10
#import "CarAnimationPlayer.h"
#import "WardPopView.h"
//#import "WardOpenView.h"
#import "BogoWardOpenView.h"
#import "WardTipView.h"
#import "WardPrivilegeButton.h"
#import "WardPopViewModel.h"

#import "MGShopView.h"
#import "BogoShopKit.h"
#import "BogoNetworkKit.h"
#import "BogoGoodDetailViewController.h"
#import "BogoRechargePopView.h"
#import <ImSDK_Plus/ImSDK_Plus.h>
#import "BGOpenRedPackView.h"
#import "BGRedPackModel.h"
#import "BogoGuardianModel.h"

#import "BGOpenRedPackView.h"
#import "BGRedPackModel.h"
#import "RoomSetViewController.h"
@interface BGLiveServiceController ()<CarAnimationPlayerDelegate,BogoLiveCartPopViewDelegate>

@property (nonatomic, strong) WardTipView *tipView;

@property(nonatomic, strong) MMAlertView *pkAcceptAlert;

@property(nonatomic, strong) MGShopView *shopView;

@property(nonatomic, strong) BogoLiveCartPopView *cartPopView;

@property(nonatomic, strong) BogoRechargePopView *rechargePopView;



@end

@implementation BGLiveServiceController

#pragma mark ------------------------ 直播生命周期 -----------------------
- (void)releaseAll
{
    _liveController = nil;
    
    _addGiftRunLoopRef = nil;
    _getGiftRunLoopRef = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_giftLoopTimer)
    {
        [_giftLoopTimer invalidate];
        _giftLoopTimer = nil;
    }
    if (_heartTimer)
    {
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
    
//    // 关闭竞拍相关的定时器
//    [self.auctionTool closeTimer];
    
    self.rechargeView.viewController = nil;
}

- (void)dealloc
{
    [self releaseAll];
}

#pragma mark 开始直播
- (void)startLive
{
    [_liveUIViewController startLive];
}

#pragma mark 暂停直播
- (void)pauseLive
{
    if (_heartTimer)
    {
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
    
    if (_giftLoopTimer)
    {
        [_giftLoopTimer invalidate];
        _giftLoopTimer = nil;
    }
    
    [_liveUIViewController pauseLive];
}

#pragma mark 重新开始直播
- (void)resumeLive
{
    if (_isHost)
    {
        [self startLiveTimer];
    }
    [self biginGiftLoop];
    [_liveUIViewController resumeLive];
}

#pragma mark 重新加载直播间的游戏数据
- (void)reloadGame
{
    _liveUIViewController.liveView.shouldReloadGame = YES;
    _liveUIViewController.liveView.sureOnceGame = NO;
    [self reloadGameData];
}

#pragma mark 结束直播
- (void)endLive
{
    [self releaseAll];
    
    [_liveUIViewController endLive];
    [_liveUIViewController.view removeFromSuperview];
}

#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super init])
    {
        _liveItem = liveItem;
        [GlobalVariables sharedInstance].isBeingPK = NO;
        _roomIDStr = StringFromInt([_liveItem liveAVRoomId]);
        _isHost = [liveItem isHost];
        _liveController = liveController;
        
        _liveUIViewController = [[BGLiveUIViewController alloc] initWith:_liveItem liveController:liveController];
        _liveUIViewController.serviceDelegate = self;
        
        
        [self addChild:_liveUIViewController inRect:self.view.bounds];
        [self.view bringSubviewToFront:_closeBtn];
        
        _liveUIViewController.liveView.serveceDelegate = self;
        _liveUIViewController.liveView.topView.toServicedelegate = self;
        _liveUIViewController.liveView.msgView.delegate = self;
        
        _iMMsgHandler = [BGIMMsgHandler sharedInstance];
        _iMMsgHandler.iMMsgListener = self;
        
        // 创建插件中心
        if (_isHost)
        {
            [self creatPluginCenter];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pkToPunish:) name:kPKChangeToPunish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPunish) name:@"endPunish" object:nil];
    
    //把某个人静音
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMuteUser:) name:@"NOTIFY_onMuteUser" object:nil];

}
- (void)onMuteUser:(NSNotification *)noti {
    NSDictionary *responseDict = noti.object;
    NSString *uid = responseDict[@"uid"];
    
    
    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
    sendCustomMsgModel.msgType = MSG_LianMai_Mute;
    sendCustomMsgModel.to_user_id = uid;
    sendCustomMsgModel.chatGroupID = [_liveItem liveIMChatRoomId];
    sendCustomMsgModel.mute_status = 1;
    [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
}
#pragma mark - kPKChangeToPunish
- (void)pkToPunish:(NSNotification *)noti{
    NSDictionary *responseDict = noti.object;

    NSString *win_user_id = [NSString stringWithFormat:@"%@",responseDict[@"win_user_id"]];
    
    NSString *time = [NSString stringWithFormat:@"%@",responseDict[@"time"]];
    
    NSString *pk_ticket1 = responseDict[@"pk_ticket1"];
    NSString *pk_ticket2 = responseDict[@"pk_ticket2"];
    if([win_user_id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier])
        
    {
        [FanweMessage alert:ASLocalizedString(@"恭贺您pk取得胜利")];
    }
    //2020-1-4 pk结束
    self.pluginCenterBgView.hidden = YES;
    
    [self->_liveUIViewController pkVivewEnd:win_user_id anddic:responseDict];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger emcee_user_id1 = [responseDict[@"emcee_user_id1"] integerValue];
        NSInteger user_id = _currentLiveInfo.user_id.integerValue;
        NSInteger imUserId = [IMAPlatform sharedInstance].host.imUserId.integerValue;
        if (emcee_user_id1 == user_id || emcee_user_id1 == imUserId) {
            [self->_liveUIViewController.fpkProgress setLeftValue:pk_ticket1.floatValue];
            [self->_liveUIViewController.fpkProgress setRightValue:pk_ticket2.floatValue];
        }else{
            [self->_liveUIViewController.fpkProgress setLeftValue:pk_ticket2.floatValue];
            [self->_liveUIViewController.fpkProgress setRightValue:pk_ticket1.floatValue];
        }
        
        [self->_liveUIViewController switchToPunish:117+time.intValue];

    });
}

#pragma mark - pk操作
-(void)pkController:(int)type WidthData:(id)obj
{
    if ([GlobalVariables sharedInstance].isBeingLinkMic) {
        [FanweMessage alertHUD:ASLocalizedString(@"连麦中不能pk")];
        return;
    }
    
    //发起pk
    if(type == 0)
    {
        UserModel *user = obj;
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_REQEUST_PK;
        sendCustomMsgModel.msgReceiver = user;
        sendCustomMsgModel.pkid = user.pk_id;
        [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:^{
            NSLog(ASLocalizedString(@"发送PK消息成功"));
        } fail:^(int code, NSString *msg) {
            NSLog(ASLocalizedString(@"发送PK消息失败msg:%@"),msg);
        }];
//        [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
    }
    else if(type == 1)//同意操作
    {
        
        UserModel *user = obj;

        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

        if(![GlobalVariables sharedInstance].openAgora)
        {
            [mDict setObject:@"pk_tencent" forKey:@"ctl"];
        }
        else
        {
            [mDict setObject:@"pk_agora" forKey:@"ctl"];
        }
        [mDict setObject:@"request_accept_pk" forKey:@"act"];
        [mDict setObject:user.user_id.length ? user.user_id : @""  forKey:@"pk_emcee_id"];
        [mDict setObject:user.pk_id.length ? user.pk_id : @"" forKey:@"pk_id"];
        
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
            if ([responseJson toInt:@"status"] == 1)
            {
                NSString *pid = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"pk_id"]];
                
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_ACCEPT_PK;
                sendCustomMsgModel.msgReceiver = user;
            
                [_liveUIViewController pkViewWith:pid ];
                
                [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel widthPID:pid succ:^{
                    
                } fail:^(int code, NSString *msg) {
                    
                }];
            }
            else
            {
                [[BGHUDHelper sharedInstance] tipMessage:[responseJson valueForKey:@"error"]];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
//        request_start_pk
        
    }
    else if(type == 2)//拒绝pk
    {
        
        UserModel *user = obj;
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

        if(![GlobalVariables sharedInstance].openAgora)
        {
            [mDict setObject:@"pk_tencent" forKey:@"ctl"];
        }
        else
        {
            [mDict setObject:@"pk_agora" forKey:@"ctl"];
        }
        
        [mDict setObject:@"request_refused_pk" forKey:@"act"];
        [mDict setObject:user.user_id.length ? user.user_id : @""  forKey:@"pk_emcee_id"];
        [mDict setObject:user.pk_id.length ? user.pk_id : @"" forKey:@"pk_id"];
        
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
            if ([responseJson toInt:@"status"] == 1)
            {
                NSString *pid = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"pk_id"]];
                
                UserModel *user = obj;
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_REJECT_PK;
                sendCustomMsgModel.msgReceiver = user;
                
                [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:^{
                    
                } fail:^(int code, NSString *msg) {
                    
                }];

            }
            else
            {
//                [[BGHUDHelper sharedInstance] tipMessage:[responseJson valueForKey:@"error"]];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    }else if(type == 3)//取消pk
        {
            
            UserModel *user = obj;
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

            if(![GlobalVariables sharedInstance].openAgora)
            {
                [mDict setObject:@"pk_tencent" forKey:@"ctl"];
            }
            else
            {
                [mDict setObject:@"pk_agora" forKey:@"ctl"];
            }
            [mDict setObject:@"request_refused_pk" forKey:@"act"];
            [mDict setObject:user.user_id.length ? user.user_id : @""  forKey:@"pk_emcee_id"];
            [mDict setObject:user.pk_id.length ? user.pk_id : @"" forKey:@"pk_id"];
            
            [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
                if ([responseJson toInt:@"status"] == 1)
                {
                    NSString *pid = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"pk_id"]];
                    
                    UserModel *user = obj;
                    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                    sendCustomMsgModel.msgType = MSG_CANCEL_PK;
                    sendCustomMsgModel.msgReceiver = user;
                    
                    [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:^{
                        
                    } fail:^(int code, NSString *msg) {
                        
                    }];
                }
                else
                {
    
                }
            } FailureBlock:^(NSError *error) {
                
            }];
            
        }
    [_pkAcceptAlert hide];
    _pkAcceptAlert = nil;
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    
    _roomIDStr = StringFromInt([_liveItem liveAVRoomId]);
    _isHost = [liveItem isHost];
    
    [_liveUIViewController refreshLiveItem:_liveItem liveInfo:liveInfo];
    
    [self setupFinishView:liveInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kClearColor;

}

#pragma mark 初始化变量
- (void)initFWVariables
{
    [super initFWVariables];
    
    // 礼物相关
    // 为了不影响视频，runloop线程优先级较低，可根据自身需要去调整
    _addGiftRunLoopRef = [AddGiftRunLoop sharedAddGiftRunLoop];
    _getGiftRunLoopRef = [GetGiftRunLoop sharedGetGiftRunLoop];
    
    _gifAnimateArray = [NSMutableArray array];
    _aCYCarViewwArray = [NSMutableArray array];

    
    _gifAnimateArray = [NSMutableArray array];
    _giftMessageMArray = [NSMutableArray array];
    _giftMessageMDict = [NSMutableDictionary dictionary];
    _giftMessageViewMArray = [NSMutableArray array];
    _otherRoomBitGiftArray = [NSMutableArray array];
    
    [self loadGiftView:[GiftListManager sharedInstance].giftMArray];
    [self performSelector:@selector(biginGiftLoop) onThread:_getGiftRunLoopRef.thread withObject:_giftMessageMArray waitUntilDone:NO];
    
    // 弹幕消息视图队列
    _barrageViewArray = [[NSMutableArray alloc] init];
    // 高级别观众进入视图队列
    _aETViewArray = [[NSMutableArray alloc] init];
    //中奖队列
    _winTipViewArray = [[NSMutableArray alloc]init];
    
    //座驾视图
    _aCYCarView = [[CarAnimationPlayer alloc] initWithFrame:self.view.bounds];
    _aCYCarView.delegate = self;
    [self.view addSubview:_aCYCarView];
    _aCYCarView.hidden = YES;
}

#pragma mark UI创建
- (void)initFWUI
{
    [super initFWUI];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _closeBtn.frame = CGRectMake(kScreenW-kDefaultMargin-kLogoContainerViewHeight, kStatusBarHeight+kDefaultMargin/2, kLogoContainerViewHeight, kLogoContainerViewHeight);
    _closeBtn.backgroundColor = [UIColor clearColor];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"lr_top_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(onClickClose:) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.hidden = YES;
    [self.view addSubview:_closeBtn];
    
    _anchorLeaveTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDefaultMargin, (kScreenH-35)/3, kScreenW-kDefaultMargin*2, 35)];
    _anchorLeaveTipLabel.textColor = [UIColor whiteColor];
    _anchorLeaveTipLabel.text = ASLocalizedString(@"主播暂时离开下，马上回来！");
    _anchorLeaveTipLabel.font = [UIFont systemFontOfSize:15.0];
    _anchorLeaveTipLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _anchorLeaveTipLabel.shadowOffset = CGSizeMake(1, 1);
    _anchorLeaveTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_anchorLeaveTipLabel];
    _anchorLeaveTipLabel.hidden = YES;
    
//    // 高级别观众进入提示动画页面
//    _aETView = [[AudienceEnteringTipView alloc]initWithMyFrame:CGRectMake(-kScreenW, kAudienceEnteringTipViewHeight, kScreenW, 35)];
//    [_liveUIViewController.liveView addSubview:_aETView];
//    _aETView.hidden = YES;
    
    //中奖提示
    _winTipView = [[WinTipView alloc]initWithFrame:CGRectMake(kScreenW, kOpenTipViewHeight, kScreenW - 20, 44)];
    [_liveUIViewController.liveView addSubview:_winTipView];
    _winTipView.hidden = YES;
}

#pragma mark 加载数据
- (void)initFWData
{
    [super initFWData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGame) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickClose:) name:KLOGIN_OUT_Notification object:nil];
    
    // 是否显示关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowFollow:) name:@"liveIsShowFollow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPunish) name:@"endPunish" object:nil];
    // 今日任务完成关闭每日任务
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeEverydayTask) name:@"closeEverydayTask" object:nil];
}



#pragma mark - ----------------------- 非SDK业务逻辑 -----------------------
#pragma mark 开启主播心跳监听定时器
- (void)startLiveTimer
{
    if (_heartTimer)
    {
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
    
    NSInteger monitorSecond = 0;
    if (self.BuguLive.appModel.monitor_second)
    {
        monitorSecond = self.BuguLive.appModel.monitor_second;
    }
    else
    {
        monitorSecond = 5;
    }
    _heartTimer = [NSTimer scheduledTimerWithTimeInterval:monitorSecond target:self selector:@selector(onPostHeartBeat) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_heartTimer forMode:NSRunLoopCommonModes];
}

#pragma mark 主播心跳监听
- (void)onPostHeartBeat
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"monitor" forKey:@"act"];
    [mDict setObject:_roomIDStr.length ? _roomIDStr : @"" forKey:@"room_id"];
    [mDict setObject:@"-1" forKey:@"watch_number"]; //观看人数
    [mDict setObject:[NSString stringWithFormat:@"%ld",(long)_voteNumber] forKey:@"vote_number"]; //主播当前印票
    
    if ([_liveItem liveType] == FW_LIVE_TYPE_HOST)
    {
        [mDict setObject:[_liveController getLiveQuality] forKey:@"live_quality"];
    }
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if ([responseJson objectForKey:@"live"])
            {
                if (self.liveUIViewController.livePay.hostLeftPView.threeLabel)
                {
                   [self.liveUIViewController.livePay.hostLeftPView addThreeLabWithStr:[NSString stringWithFormat:ASLocalizedString(@"直播间付费人数:%d"),[[responseJson objectForKey:@"live"] toInt:@"live_viewer"]]];
                }else
                {
                    if (self.liveUIViewController.livePay.hostLeftPView.secondLabel)
                    {
                       [self.liveUIViewController.livePay.hostLeftPView addSecondLabWithStr:[NSString stringWithFormat:ASLocalizedString(@"直播间付费人数:%d"),[[responseJson objectForKey:@"live"] toInt:@"live_viewer"]]];
                    }
                }
                [self.liveUIViewController.liveView.topView refreshTicketCount:[NSString stringWithFormat:@"%d",[[responseJson objectForKey:@"live"] toInt:@"ticket"]]];
                
                self.liveUIViewController.liveView.topView.timeView.liveAudience.text = [NSString stringWithFormat:@"%d",[[responseJson objectForKey:@"live"] toInt:@"watch_number"]];
                NSLog(@"number --- > %d",[[responseJson objectForKey:@"live"] toInt:@"watch_number"]);
                if ([[responseJson objectForKey:@"live"] toInt:@"allow_mention"] == 1 || [[responseJson objectForKey:@"live"] toInt:@"allow_live_pay"] == 1)
                {
                    [self.liveUIViewController createPayLiveView:responseJson];
                }
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 主播进入房间状态回调
- (void)getVideoState:(NSMutableDictionary *)parmMDict
{
    [self.httpsManager POSTWithParameters:parmMDict SuccessBlock:^(NSDictionary *responseJson){
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

-(void)protocolGetVideoWithRoomID:(NSString *)roomID{
    
    if (self.isHost) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolGetVideoWithRoomID:)]) {
        [self.delegate protocolGetVideoWithRoomID:roomID];
    }
}

#pragma mark 进入直播室成功后的相关业务：获得视频信息
- (void)getVideo:(FWLiveGetVideoCompletion)succ roomID:(NSString *)roomID failed:(FWErrorBlock)failed
{
    
    if ([BGUtils isBlankString:roomID]) {
        roomID = [NSString stringWithFormat:@"%@",_roomIDStr];
    }
    _roomIDStr = roomID;
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"get_video2" forKey:@"act"];
    
    if(self.isVoice)
    {
        [mDict setObject:@"voice" forKey:@"ctl"];

        [mDict setObject:@"get_voice" forKey:@"act"];
    }
    else
    {
        [mDict setObject:@"video" forKey:@"ctl"];

        [mDict setObject:@"get_video2" forKey:@"act"];
    }
    
    NSString *MD5String = [NSString stringWithFormat:@"%@%@%@",TXYSdkAppId,[[IMAPlatform sharedInstance].host imUserId],_roomIDStr];
    if (![BGUtils isBlankString:MD5String])
    {
        [mDict setObject:[NSString stringWithFormat:@"%@",[BGMD5UTils getmd5WithString:MD5String]] forKey:@"sign"];
    }
    
    if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        [mDict setObject:@"1" forKey:@"is_vod"]; // 0:观看直播;1:点播
    }
    else
    {
        [mDict setObject:@"0" forKey:@"is_vod"]; // 0:观看直播;1:点播
    }
    if (!_privateKeyString.length)
    {
        if ([UIPasteboard generalPasteboard].string.length)
        {
            if ([[[UIPasteboard generalPasteboard].string componentsSeparatedByString:[GTMBase64 decodeBase64:@"8J+UkQ=="]] count] > 1)
            {
                _privateKeyString = [[[UIPasteboard generalPasteboard].string componentsSeparatedByString:[GTMBase64 decodeBase64:@"8J+UkQ=="]] objectAtIndex:1];
            }
        }
    }
    
    if (_privateKeyString.length)
    {
        [mDict setObject:_privateKeyString forKey:@"private_key"];
        [UIPasteboard generalPasteboard].string = @"";
    }
    
    if (![BGUtils isBlankString:_roomIDStr])
    {
        [mDict setObject:_roomIDStr forKey:@"room_id"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
            FWStrongify(self)
            // status: status=1表示抗议正常进入直播间,status=0表示不能正常进入直播间,status=2表示关闭直播间
            if ([responseJson toInt:@"status"] == 1)
            {
                self.currentLiveInfo = [CurrentLiveInfo mj_objectWithKeyValues:responseJson];
                [self getGuardianInfo];
                
                NSString *is_guartian = responseJson[@"is_guardian"];
                [GlobalVariables sharedInstance].is_guartian = [NSString stringWithFormat:@"%@",is_guartian];
                
                NSString *isShop = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"is_shop"]];
//                self.liveUIViewController.liveView.bottomView.shopBtn.hidden = ![isShop isEqualToString:@"1"];
                ;
                [GlobalVariables sharedInstance].isShop = [[GlobalVariables sharedInstance].userModel.shop_status isEqualToString:@"1"] ? YES : NO;
//                [isShop isEqualToString:@"1"];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict setValue:@"guardians" forKey:@"ctl"];
                [dict setValue:@"get_guardians_privilege" forKey:@"act"];
                [dict setValue:self.currentLiveInfo.user_id forKey:@"host_id"];
                [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                    if ([responseJson toInt:@"status"] == 1) {
                        
                        BogoGuardianModel *model = [BogoGuardianModel modelWithDictionary:[responseJson valueForKey:@"list"]];
                        [GlobalVariables sharedInstance].guardianModel = model;
                        
                        //10.09
                        
                        
                        
                        if (StrValid(self.currentLiveInfo.shop_goods.title)) {
                            self.liveUIViewController.shopExplainView.model = self.currentLiveInfo.shop_goods;
                            
                            [self.liveUIViewController.shopExplainView show:self.liveUIViewController.view offsetY:kScreenH - MG_BOTTOM_MARGIN - kRealValue(184) - kRealValue(50 + 20)];

                            [_liveUIViewController.liveView bringSubviewToFront:_liveUIViewController.liveView.giftView];
                        }
                        
                        NSString *pkId = @"pkId";
                        if (pkId.integerValue > 0) {
                            
                        }
                        
                        if (succ)
                        {
                            succ(self.currentLiveInfo);
                        }
                        
                    }else{
                        NSLog(ASLocalizedString(@"守护类型接口请求失败responseJson:%@"),responseJson);
                    }
                } FailureBlock:^(NSError *error) {
                    NSLog(ASLocalizedString(@"守护类型接口请求失败error:%@"),error);
                }];
                
                
                
                
                
                [self getVideoSuccess:responseJson];
                
            }
            else if ([responseJson toInt:@"status"] == 2)
            {
                NSString *audienceTotalStr = [responseJson toString:@"show_num"];
                
                if (_isHost)
                {
                    [self showHostFinishView:audienceTotalStr andVote:@"" andHasDel:NO];
                }
                else
                {
                    CustomMessageModel *cmm = [[CustomMessageModel alloc] init];
                    cmm.showNum = [audienceTotalStr intValue];
                    [self showAudienceFinishView:cmm];
                }
                
                if (failed)
                {
                    failed(FWCode_Biz_Error, @"");
                }
            }
            else if ([responseJson toInt:@"status"] == 0)
            {
                if ([responseJson toInt:@"is_live_pay"] == 1)
                {
                    if (succ)
                    {
                        [self.liveUIViewController beginEnterPayLive:responseJson closeBtn:self.closeBtn];
                        self.currentLiveInfo = [CurrentLiveInfo mj_objectWithKeyValues:responseJson];
                        succ(self.currentLiveInfo);
                    }
                }
                else if([self.BuguLive.appModel.open_vip intValue] == 1)
                {
                    if ([responseJson toInt:@"is_vip"] == 1)
                    {
                        if (succ)
                        {
                            [self.liveUIViewController beginEnterPayLive:responseJson closeBtn:self.closeBtn];
                            self.currentLiveInfo = [CurrentLiveInfo mj_objectWithKeyValues:responseJson];
                            succ(self.currentLiveInfo);
                        }
                    }
                    else
                    {
                        if (failed)
                        {
                            failed(FWCode_Vip_Cancel, [responseJson toString:@"error"]);
                        }
                    }
                }
                else
                {
                    if (failed)
                    {
                        failed(FWCode_Biz_Error, [responseJson toString:@"error"]);
                    }
                }
            }
            
            //设置座驾
            [IMAPlatform sharedInstance].host.has_car = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"has_car"]];
            [IMAPlatform sharedInstance].host.car_name = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"car_name"]];
            [IMAPlatform sharedInstance].host.car_svga = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"noble_car_url"]];
            [IMAPlatform sharedInstance].host.is_vip = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"is_vip"]];
            
        } FailureBlock:^(NSError *error) {
            if (failed)
            {
                failed(FWCode_Net_Error, ASLocalizedString(@"网络加载失败"));
            }
        }];
    }
}
//获取守护权限
-(void)getGuardianInfo{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"guardians" forKey:@"ctl"];
    [dict setValue:@"get_guardians_privilege" forKey:@"act"];
    [dict setValue:self.currentLiveInfo.user_id forKey:@"host_id"];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            
            BogoGuardianModel *model = [BogoGuardianModel modelWithDictionary:[responseJson valueForKey:@"list"]];
            [GlobalVariables sharedInstance].guardianModel = model;
        }else{
            NSLog(ASLocalizedString(@"守护类型接口请求失败responseJson:%@"),responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"守护类型接口请求失败error:%@"),error);
    }];
    
}

#pragma mark 请求get_video2接口成功处理
- (void)getVideoSuccess:(NSDictionary *)responseJson
{
    // 获取观众列表
    [self.liveUIViewController.liveView.topView refreshAudienceList:responseJson];
    //[_liveUIViewController showWishView];
    // 用来判断是否在直播间内
    LiveState *liveState = [[LiveState alloc] init];
    liveState.roomId = StringFromInt([_liveItem liveAVRoomId]);
    liveState.liveHostId = [[_liveItem liveHost] imUserId];
    if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        liveState.isLiveHost = YES;
    }
    else
    {
        liveState.isLiveHost = NO;
    }
    self.BuguLive.liveState = liveState;
    
    // 直播间整体刷新
    TCShowLiveListItem *liveRoom = (TCShowLiveListItem *)_liveItem;
    if (self.currentLiveInfo.podcast.user)
    {
        TCShowUser *showUser = [[TCShowUser alloc]init];
        showUser.uid = self.currentLiveInfo.podcast.user.user_id;
        showUser.username = self.currentLiveInfo.podcast.user.nick_name;
        showUser.avatar = self.currentLiveInfo.podcast.user.head_image;
        liveRoom.host = showUser;
        
        _liveItem = liveRoom;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCurrentLiveItem:liveInfo:)])
    {
        [self.delegate refreshCurrentLiveItem:_liveItem liveInfo:self.currentLiveInfo];
    }
    
    // 该观众在当前直播间的排序权重
    [IMAPlatform sharedInstance].host.sort_num = [responseJson toString:@"sort_num"];
    
   
    
    if (!_isHost)
    {
        if ([responseJson toInt:@"open_daily_task"] == 1)//观众打开
        {
            self.liveUIViewController.liveView.closeLiveBtn.hidden = NO;
        }
        
        if (_currentLiveInfo.online_status == 1)
        {
            _anchorLeaveTipLabel.hidden = YES;
        }
        else if([_liveItem liveType] != FW_LIVE_TYPE_RELIVE && _currentLiveInfo.online_status == 0)
        {
            _anchorLeaveTipLabel.hidden = NO;
        }
    }
    [self.liveUIViewController beginEnterPayLive:responseJson closeBtn:self.closeBtn];
    _voteNumber = [_currentLiveInfo.podcast.user.ticket integerValue];
    
    [self changePayView:self.liveUIViewController.liveView];
    
    if (!_isHost && _currentLiveInfo.podcast.has_focus == 0 && ![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        _isFollowAnchor = NO;
    }
    else
    {
        _isFollowAnchor = YES;
    }
    
    _privateShareString = [responseJson toString:@"private_share"];
    
    // 开启直播时如果有开启分享直播就在此处延时调用
    [self performSelector:@selector(hostShareLive) withObject:nil afterDelay:2];
    
    //判断是否是pk
    NSString *pk_id = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"pk_id"]];
    if([pk_id intValue]!=0)
    {
        [_liveUIViewController pkViewWith:pk_id];
    }
}

#pragma mark 主播退出直播间
- (void)hostExitLive:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    if (![BGUtils isBlankString:_roomIDStr])
    {
        if(_liveUIViewController.pkView != nil)
        {
            [_liveUIViewController pkVivewHidden];
        }
        
        //直播结束
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"video" forKey:@"ctl"];
        [mDict setObject:@"end_video" forKey:@"act"];
        [mDict setObject:_roomIDStr forKey:@"room_id"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                [self.liveUIViewController.liveView hideInputView];
                
                NSString *watch_number = [responseJson toString:@"watch_number"];
                if ([BGUtils isBlankString:watch_number])
                {
                    watch_number = @"0";
                }
                
                NSString *vote_number = [responseJson toString:@"vote_number"];
                if ([BGUtils isBlankString:vote_number])
                {
                    vote_number = @"0";
                }
                
                [self showHostFinishView:watch_number andVote:vote_number andHasDel:[responseJson toInt:@"has_delvideo"]];
                
                if(self.isVoice)
                {
                    [self clickedFinishLiveViewBackHomeBtn];
                }
                else{
                    [self showHostFinishView:watch_number andVote:vote_number andHasDel:[responseJson toInt:@"has_delvideo"]];
                }
                
                self.finishLiveView.liveTimeL.text = [BGUtils getMMSSFromSS:[responseJson valueForKey:@"time_len"]] ;
                
                if (succ)
                {
                    succ();
                }
            }
            else
            {
                [self showHostFinishView:@"" andVote:@"" andHasDel:[responseJson toInt:@"has_delvideo"]];
                
                if (succ)
                {
                    succ();
                }
            }
            
        } FailureBlock:^(NSError *error) {
            if (failed)
            {
                failed(FWCode_Net_Error, ASLocalizedString(@"网络加载失败"));
            }
        }];
    }
    else
    {
        if (failed)
        {
            failed(FWCode_Normal_Error, @"");
        }
    }
}

#pragma mark 业务上的"关闭"统一都调用这个，统一一个出口，防止出错
- (void)closeCurrentLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickCloseLive:isHostShowAlert:)])
    {
        [_delegate clickCloseLive:isDirectCloseLive isHostShowAlert:isHostShowAlert];
    }
}

-(void)clickCloseBtn:(TCShowLiveView *)showLiveView{
    [self onClickClose:nil];
}

#pragma mark 关闭操作
- (void)onClickClose:(id)sender
{
    
    BOOL isDirectCloseLive;
    BOOL showAlert;
    if (_isHost)
    {
        isDirectCloseLive = NO;
        showAlert = YES;
    }
    else
    {
        isDirectCloseLive = YES;
        showAlert = NO;
    }
    
    [_liveUIViewController ChatVCBgViewTap];
    
    DebugLog(@"=================：真正的点击了关闭按钮");
    showAlert = NO;
    [self closeCurrentLive:isDirectCloseLive isHostShowAlert:showAlert];
}

#pragma mark 有竞拍时点击关闭按钮

- (void)closeRoom
{
    BOOL isDirectCloseLive;
    if (_isHost)
    {
        isDirectCloseLive = NO;
    }
    else
    {
        isDirectCloseLive = YES;
    }
    DebugLog(@"=================：竞拍时真正的点击了关闭按钮");
    [self closeCurrentLive:isDirectCloseLive isHostShowAlert:YES];
}



#pragma mark 收到MSG_END_VIDEO 处理，该消息一般是观众会收到
- (void)receiveEndMsg:(CustomMessageModel *)customMessageModel
{
    if (!_isHost)
    {
        if (self.clickCloseBlock) {
            self.clickCloseBlock(YES);
        }
        DebugLog(@"=================：收到MSG_END_VIDEO 处理，该消息一般是观众会收到");
        if(self.isVoice)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(closeVoiceRoom)])
            {
                [self.delegate closeVoiceRoom];
            }
        }
        else
        {
            [self closeCurrentLive:NO isHostShowAlert:NO];
        }
        [self showAudienceFinishView:customMessageModel];
        [self releaseAll];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}
#pragma mark 收到MSG_SYSTEM_CLOSE_LIVE 处理，该消息一般是主播会收到
- (void)receiveSystemCloseMsg:(CustomMessageModel *)customMessageModel
{
    BOOL isDirectCloseLive;
    if (_isHost)
    {
        isDirectCloseLive = NO;
    }
    else
    {
        isDirectCloseLive = YES;
    }
    
    DebugLog(@"=================：收到MSG_SYSTEM_CLOSE_LIVE 处理，该消息一般是主播会收到");
    
    
    BOOL showAlert = NO;
    if (customMessageModel.type == 17) {
        showAlert = YES;
    }
    [self closeCurrentLive:isDirectCloseLive isHostShowAlert:showAlert];
}


#pragma mark - ----------------------- IM消息处理 -----------------------
#pragma mark 收到自定义C2C消息
- (void)onIMHandler:(BGIMMsgHandler *)receiver recvCustomC2C:(id<AVIMMsgAble>)msg
{
    if (![msg isKindOfClass:[CustomMessageModel class]])
    {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(recvCustomC2C:)])
    {
        [_delegate recvCustomC2C:msg];
    }
    
    CustomMessageModel *customMessageModel = (CustomMessageModel *)msg;
    switch (customMessageModel.type) {
        case MSG_SYSTEM_CLOSE_LIVE: // 17 违规直播，立即关闭直播；私密直播被主播踢出直播间
        {
            [self receiveSystemCloseMsg:customMessageModel];
            
            
        }
            break;
        case MSG_BACKGROUND_MONITORING://41:后台会员监控
        {
            [FanweMessage alert:customMessageModel.desc];
        }
            break;
        case MSG_ACCEPT_PK:
        {
            //接收到pk
            NSString *pid = [NSString stringWithFormat:@"%@",[customMessageModel.dicData valueForKey:@"pk_id"]];
            [_liveUIViewController pkViewWith:pid ];
            
        }
            break;
        case MSG_END_PK:
        {
            // 关闭键盘
            [BGUtils closeKeyboard];
        }
            break;
        case MSG_CANCEL_PK:  // 取消pk
        {
//            [MMAlertView hideAll];
            [_pkAcceptAlert hide];
            _pkAcceptAlert = nil;
            [self.liveUIViewController receiveCanclePk];
        }
           break;
            
        case MSG_REQEUST_PK:
        {
//            [MMAlertView hideAll];
            [self.liveUIViewController hiddenPKlist];
            [self PKAlertWith:customMessageModel];
        }
            break;
            
        case MSG_START_PK:
        {
            [self StartPK:customMessageModel];
        }
            break;
            
        case MSG_REJECT_PK:
        {
            [self.liveUIViewController hiddenPKlist];
            
            NSLog(ASLocalizedString(@"收到拒绝PK消息"));
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

            if(![GlobalVariables sharedInstance].openAgora)
            {
                [dict setObject:@"pk_tencent" forKey:@"ctl"];
            }
            else
            {
                [dict setObject:@"pk_agora" forKey:@"ctl"];
            }
            
            [dict setValue:@"request_Refused_pk" forKey:@"act"];
            [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                if ([responseJson toInt:@"status"] == 1) {
                    NSLog(ASLocalizedString(@"结束PK请求成功responseJson:%@"),responseJson);
                }else{
                    NSLog(ASLocalizedString(@"结束PK请求失败responseJson:%@"),responseJson);
                }
            } FailureBlock:^(NSError *error) {
                NSLog(ASLocalizedString(@"结束PK请求失败error:%@"),error);
            }];
            [_liveUIViewController receiveRejectPkWithMsg:customMessageModel.msg];
        }
            break;
       
        default:
            break;
    }
}

- (void) StartPK:(CustomMessageModel *)msg{
    
}

-(void)PKAlertWith:(CustomMessageModel *)msg
{
    [_pkAcceptAlert hide];
    _pkAcceptAlert = nil;
    _pkAcceptAlert = [FanweMessage alert:ASLocalizedString(@"pk消息")message:[NSString stringWithFormat:ASLocalizedString(@"%@请求与您pk"), msg.sender.nick_name] destructiveTitle:ASLocalizedString(@"同意")destructiveAction:^{
        UserModel *user = [[UserModel alloc] init];
        user.user_id = msg.sender.user_id;
        user.nick_name = msg.sender.nick_name;
        user.pk_id = msg.pkid;
        [self pkController:1 WidthData:user];
    } cancelTitle:ASLocalizedString(@"拒绝")cancelAction:^{
        UserModel *user = [[UserModel alloc] init];
        user.user_id = msg.sender.user_id;
        user.nick_name = msg.sender.nick_name;
        user.pk_id = msg.pkid;
        [self pkController:2 WidthData:user];
    }];
//    [_pkAcceptAlert show];
}

- (void)userlistRefresh
{
    if([self.delegate respondsToSelector:@selector(refreshUserListVoice)])
    {
        [self.delegate refreshUserListVoice];
    }
}


#pragma mark 收到自定义的Group消息
- (void)onIMHandler:(BGIMMsgHandler *)receiver recvCustomGroup:(id<AVIMMsgAble>)msg
{
    NSLog(ASLocalizedString(@"消息类型type:%ld"),(long)[msg msgType]);
    if (![msg isKindOfClass:[CustomMessageModel class]])
    {
        return;
    }
    
    CustomMessageModel *customMessageModel = (CustomMessageModel *)msg;
    
    
    if(customMessageModel.type == MSG_SHOP_SAY_TYPE)
    {
        customMessageModel.shopModel.isHost = _isHost;
        
        [self.cartPopView hide];
        
        self.cartPopView.lid = self.currentLiveInfo.room_id;
        
//        if (!_isHost) {
//        customMessageModel.shopModel.isHost = YES;
        self.liveUIViewController.shopExplainView.model = customMessageModel.shopModel;
        
//        if (!_isHost) {
//            self.liveUIViewController.shopExplainView.buyBtn.hidden = YES;
//            self.liveUIViewController.shopExplainView.priceLabel.textal
//        }
//            self.liveUIViewController.shopExplainView.hidden = NO;
        [self.liveUIViewController.shopExplainView show:self.liveUIViewController.view offsetY:kScreenH - MG_BOTTOM_MARGIN - kRealValue(184) - kRealValue(80 + 20)];
//        self.liveUIViewController.shopExplainView.

        [_liveUIViewController.liveView bringSubviewToFront:_liveUIViewController.liveView.giftView];
        
        return;
    }
    
    if(customMessageModel.type == MSG_SHOP_SAY_CANCLE_TYPE){//取消讲解
//        self.liveUIViewController.shopExplainView.hidden = YES;
        [self.liveUIViewController.shopExplainView hide];
        self.cartPopView.lid = self.currentLiveInfo.room_id;
    }
    
    
    if(customMessageModel.type == MSG_END_PK)
    {
        //暂时不消失,等待惩罚时间2分钟结束以后再结束pk
        //如果status == 启动倒计时
        //否则是直接中断pk
        if (customMessageModel.status == 1) {
            //do nothing
        }else if (customMessageModel.status == 3){
            return;
            if (!_isHost) {
                //非主播接收消息
                //pk结束
                NSString *win_user_id = [NSString stringWithFormat:@"%@",customMessageModel.win_user_id];
                NSString *time = [NSString stringWithFormat:@"%@",customMessageModel.time];
                if([win_user_id isEqualToString:[IMAPlatform sharedInstance].host.userId])
                {
//                    [FanweMessage alert:ASLocalizedString(@"恭贺您pk取得胜利")];
                }
                //2020-1-4 pk结束
                //[self->_liveUIViewController pkVivewEnd:win_user_id anddic:[NSDictionary dictionary]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_liveUIViewController switchToPunish:time.intValue];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_liveUIViewController pkVivewHidden];
            });
        }
    }
    
    if(customMessageModel.type == UPDATE_PK_TICKET)
    {
        
        [_liveUIViewController pkViewUpdateData:customMessageModel.dicData];
        return;
    }
    //
    
    if(customMessageModel.type == MSG_REFRESH_VOICE_MSG)
    {
        if([self.delegate respondsToSelector:@selector(refreshVoice:liveInfo:)])
        {
            [self.delegate refreshVoice:_liveItem liveInfo:customMessageModel];
        }
        return;
    }
    
    if(customMessageModel.type == MSG_START_PK)
    {
        if (_pkAcceptAlert) {
            [_pkAcceptAlert hide];
        }
        NSString *pid = [NSString stringWithFormat:@"%@",[customMessageModel.dicData valueForKey:@"pk_id"]];
      
        [_liveUIViewController pkViewWith:pid];
        
    }
    if (![customMessageModel.chatGroupID isEqualToString:[_liveItem liveIMChatRoomId]])
    {
        if (customMessageModel.type == MSG_REFRESH_AUDIENCE_LIST)
        {
            [[V2TIMManager sharedInstance] quitGroup:customMessageModel.chatGroupID succ:^{
                
            } fail:^(int code, NSString *msg) {
                
            }];
            
            
//            [[TIMGroupManager sharedInstance] quitGroup:customMessageModel.chatGroupID succ:^{
//                NSLog(ASLocalizedString(@"退出群:%@ 成功"),customMessageModel.chatGroupID);
//            } fail:^(int code, NSString *msg) {
//                NSLog(ASLocalizedString(@"退出群:%@ 失败，错误码：%d，错误原因：%@"),customMessageModel.chatGroupID,code,msg);
//            }];
        }
    }
    
    if (customMessageModel.type == MSG_OPEN_GUARD_SUCCESS) {
        //如果收到开通守护成功的消息,刷新数据
        [_liveUIViewController.liveView.topView requestWardData];
        
        [self receiveGlobalMsgModel:customMessageModel];
        
        
        return;
    }
    
    if (customMessageModel.type == MSG_WIN_PRIZE) {
        [self confirmPlayWinNotificationAnimation:customMessageModel];
        if ([customMessageModel.sender.user_id isEqualToString:[IMAPlatform sharedInstance].host.userId]) {
            [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:ASLocalizedString(@"恭喜您中奖%@倍"),customMessageModel.user_multiple]];
        }
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(recvCustomGroup:)])
    {
        [_delegate recvCustomGroup:customMessageModel];
    }
    
    switch (customMessageModel.type)
    {
        case MSG_NONE: //-1：无操作
            
            break;
            
        case MSG_TEXT: //0：正常文字聊天消息
            
            break;
        case MSG_SEND_GIFT_SUCCESS: //1：收到发送礼物成功消息
        {
            if (customMessageModel.total_ticket>_voteNumber)
            {
                _voteNumber = customMessageModel.total_ticket; //印票总数
            }
            
//            if (customMessageModel.total_num>_voteNumber)
//            {
//                _voteNumber = customMessageModel.total_ticket; //印票总数
//            }
            
//            [_liveUIViewController.liveView.topView refreshTicketCount:[NSString stringWithFormat:@"%ld",(long)_voteNumber]];
            [_liveUIViewController.liveView.topView refreshTicketCount:customMessageModel.total_num];

//            [_liveUIViewController.liveView.topView refreshHostNumCount:customMessageModel.total_num];
//             refreshTicketCount:[NSString stringWithFormat:@"%ld",(long)_voteNumber]];
            
            //0：普通动画  1：gif动画  2：真实动画
            if (customMessageModel.is_animated == 0)
            {
                [self performSelector:@selector(addGiftMessage:) onThread:_addGiftRunLoopRef.thread withObject:customMessageModel waitUntilDone:NO];
            }
            else if (customMessageModel.is_animated == 1)
            {
                [_gifAnimateArray addObject:customMessageModel];
            }
            else if (customMessageModel.is_animated == 2)
            {
                [_gifAnimateArray addObject:customMessageModel];
            }
//            //需要手动累计魅力值
//            if(self.isVoice)
//            {
//                [self.delegate ]
//            }
            //4-18 收到礼物需要更新心愿列表
            [self.liveUIViewController.liveView.livewWishView requestModel:_roomIDStr];
            
        }
            break;
        case MSG_POP_MSG://2：收到弹幕消息
        {
            if (customMessageModel.total_ticket>_voteNumber)
            {
                _voteNumber = customMessageModel.total_ticket; //印票总数
            }
            [_liveUIViewController.liveView.topView refreshTicketCount:[NSString stringWithFormat:@"%ld",(long)_voteNumber]];
            
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self addBarrageMessage:customMessageModel];
        }
            break;
        case MSG_CREATER_EXIT_ROOM://3：主播退出直播间，暂未用到
        {
            
        }
            break;
        case MSG_FORBID_SEND_MSG://4：禁言消息
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            break;
        case MSG_VIEWER_JOIN: //5：观众进入直播间消息
        {
            UserModel *userModel = [[UserModel alloc]init];
            userModel.user_id = customMessageModel.sender.user_id;
            userModel.nick_name = customMessageModel.sender.nick_name;
            userModel.head_image = customMessageModel.sender.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
            userModel.sort_num = customMessageModel.sender.sort_num;
            
            userModel.noble_stealth = customMessageModel.sender.noble_stealth;
            userModel.noble_icon = customMessageModel.sender.noble_icon;
            userModel.noble_avatar = customMessageModel.sender.noble_avatar;
            userModel.noble_is_avatar = customMessageModel.sender.noble_is_avatar;
            userModel.noble_vip_type = customMessageModel.sender.noble_vip_type;
            
            userModel.noble_car_name = customMessageModel.sender.noble_car_name;
            userModel.car_svga = customMessageModel.sender.car_svga;
            userModel.has_car =  customMessageModel.sender.has_car;
            userModel.isvip = customMessageModel.sender.is_vip;
            userModel.is_vip = customMessageModel.sender.is_vip;
            userModel.noble_car_url = customMessageModel.sender.noble_car_url;
            userModel.is_guardian = customMessageModel.sender.is_guardian;
            userModel.is_noble_mysterious = customMessageModel.sender.is_noble_mysterious;
            userModel.guardianModel = customMessageModel.guardianModel;
            
            userModel.guardian_icon = customMessageModel.sender.guardian_icon;
            userModel.guardian_gift = customMessageModel.sender.guardian_gift;
            userModel.guardian_skin = customMessageModel.sender.guardian_skin;
            userModel.guardian_img = customMessageModel.sender.guardian_img;
            userModel.guardian_broadcast = customMessageModel.sender.guardian_broadcast;
            
            
            
            //            userModel.is_guardian = customMessageModel.sender.is_guardian;
            [_liveUIViewController.liveView.topView onImUsersEnterLive:userModel];
            
            [self audienceEnterAnimate:userModel];
            [self CarAnimate:userModel];
        }
            break;
        case MSG_VIEWER_QUIT: //6：观众退出直播间消息
        {
            UserModel *userModel = [[UserModel alloc]init];
            userModel.user_id = customMessageModel.sender.user_id;
            userModel.nick_name = customMessageModel.sender.nick_name;
            userModel.head_image = customMessageModel.sender.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
            userModel.sort_num = customMessageModel.sender.sort_num;
            
            [_liveUIViewController.liveView.topView onImUsersExitLive:userModel];
        }
            break;
        case MSG_END_VIDEO: //7：直播结束消息
        {
            [self receiveEndMsg:customMessageModel];
        }
            break;
        case MSG_RED_PACKET: //8：红包
        {
            [_liveUIViewController.liveView showRedPacketWithCustomMessageModel:customMessageModel];
//            [_liveUIViewController.liveView.msgView insertMsg:msg];
            customMessageModel.delegate = self;
            [self addRedBagView:customMessageModel];
        }
            break;
        case MSG_LIVING_MESSAGE: //9：直播消息
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            break;
        case MSG_ANCHOR_LEAVE: //10：主播离开
        {
            _anchorLeaveTipLabel.hidden = NO;
            [_liveUIViewController.liveView.msgView insertMsg:msg];
        }
            break;
        case MSG_ANCHOR_BACK: //11：主播回来
        {
            _anchorLeaveTipLabel.hidden = YES;
            [_liveUIViewController.liveView.msgView insertMsg:msg];
        }
            break;
        case MSG_LIGHT: //12：点亮
        {
            if (customMessageModel.showMsg == 1)
            {
                [_liveUIViewController.liveView.msgView insertMsg:msg];
            }
            
            [_liveUIViewController.liveView onRecvLight:customMessageModel.imageName];
        }
            break;
      
      
    
        case MSG_PAY_SUCCESS : //29:支付成功
        {
            [_liveUIViewController.liveView.msgView insertMsg:msg];
//            [self.auctionTool paySuccessWithCustomModel:customMessageModel];
            
        }
            break;
       
        case  MSG_STARGOODS_SUCCESS: //31:主播发起商品推送成功
        {
            if ([_liveUIViewController.liveView.liveInputView isInputViewActive])
            {
                [_liveUIViewController.liveView.liveInputView resignFirstResponder];
            }
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            
        }
            break;
        case MSG_PAYMONEY_SUCCESS: //32:主播发起付费直播成功(按时间)
        {
            if (!_isHost)
            {
                [BGUtils closeKeyboard];
                [self.liveUIViewController getVedioViewWithType:1 closeBtn:_closeBtn];
            }
        }
            break;
        case  MSG_GAME_OVER: //34,//游戏结束推送
        {
            [_liveUIViewController.liveView gameOverWithCustomMessageModel:customMessageModel];
            _game_log_id = 0;
        }
            break;
        case MSG_BUYGOODS_SUCCESS : //37.购买商品成功推送
        {
            [_liveUIViewController.liveView.msgView insertMsg:msg];
//            [self.auctionTool buyGoodsSuccessWithCustomModel:customMessageModel];
        }
            break;
        case  MSG_GAME_ALL: //39.游戏总的推送
        {
            [_liveUIViewController.liveView gameAllMessageWithCustomMessageModel:customMessageModel];
        }
            break;
        case MSG_PAYMONEYSEASON_SUCCESS : //40.主播发起付费直播成功(按场次)
        {
            if (!_isHost)
            {
                [BGUtils closeKeyboard];
                [self.liveUIViewController getVedioViewWithType:40 closeBtn:_closeBtn];
            }
        }
            break;
        case MSG_REFRESH_AUDIENCE_LIST: // 42 刷新观众列表
        {
            [_liveUIViewController.liveView.topView refreshLiveAudienceList:customMessageModel];
        }
            break;
        case MSG_GAME_BANKER: // 43 游戏上庄相关推送
        {
            [_liveUIViewController.liveView gameBankerMessageWithCustomMessageModel:customMessageModel];
        }
            break;
        case MSG_BIG_GIFT_NOTICE_ALL: // 50 直播间飞屏模式(送大型礼物-全服飞屏通告)
        {
//            if (!_isHost)
//            {
                [_otherRoomBitGiftArray addObject:customMessageModel];
//            }
        }
            break;
            
        case MSG_WISH_UPDATE: // 71 更新直播间心愿列表.
        {
            [self.liveUIViewController.liveView.livewWishView requestModel:_roomIDStr];
//             showWishView];
        }
            break;
            
        case MSG_RECEIVE_BROADCAST: 
            {
                [self receiveGlobalMsgModel:customMessageModel];
            }
                break;
            
        case MSG_OPEN_VIP_TYPE: // 91 贵族开通消息
        {
            [self receiveGlobalMsgModel:customMessageModel];
        }
            break;
        default:
            break;
    }
}

-(void)receiveGlobalMsgModel:(CustomMessageModel *)customMessageModel{
   
    if (!self.globalView) {
         self.globalView = [[MGGlobalVipView alloc]initWithFrame:CGRectMake(kScreenW, kTopHeight + 120, kRealValue(230 + 40), 40)];
    }
    
    self.globalView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 判断是否有悬浮窗
        UIView *tmpView = [AppDelegate sharedAppDelegate].sus_window.rootViewController ? [AppDelegate sharedAppDelegate].sus_window : [AppDelegate sharedAppDelegate].window;

        UIView *inView = [AppDelegate sharedAppDelegate].sus_window.isSmallSusWindow ? [AppDelegate sharedAppDelegate].window : tmpView;
        
        self.globalView.model = customMessageModel;
        [inView addSubview:self.globalView];
        [inView bringSubviewToFront:self.globalView];
        
        FWWeakify(self)
        [UIView animateWithDuration:10.0f animations:^{
            FWStrongify(self)
            self.globalView.left = -kScreenW;
        } completion:^(BOOL finished) {
            FWStrongify(self)
            self.globalView.left = kScreenW;
            
        }];
    });
}

#pragma mark - ----------------------- 礼物处理 -----------------------

#pragma mark 开始循环小礼物队列
- (void)biginGiftLoop
{
    _giftLoopTimer = [NSTimer scheduledTimerWithTimeInterval:kLiveMessageRefreshTime target:self selector:@selector(looperWork) userInfo:nil repeats:YES];
}

#pragma mark 添加一条新的礼物信息
- (void)addGiftMessage:(CustomMessageModel *)newMsg
{
    @synchronized (_giftMessageMArray)
    {
        if (newMsg)
        {
            NSMutableDictionary *msgKey = [BGLiveServiceViewModel getGiftMsgKey:newMsg];
            CustomMessageModel *oldMsg = [_giftMessageMDict objectForKey:msgKey];
            
            int showNum = 1;
            if (oldMsg && newMsg.is_plus == 1)
            {
                showNum = oldMsg.showNum + oldMsg.num;
                if (oldMsg.isTaked)
                {
                    [_giftMessageMArray removeObject:oldMsg];
                }
            }
            newMsg.showNum = showNum;
            [_giftMessageMArray addObject:newMsg];
            [_giftMessageMDict setObject:newMsg forKey:msgKey];
        }
    }
}

#pragma mark 刷新IM消息
- (void)onUIRefreshIMMsg:(AVIMCache *)cache
{
    [_liveUIViewController.liveView.msgView insertCachedMsg:cache];
}

#pragma mark 刷新点赞消息
- (void)onUIRefreshPraise:(AVIMCache *)cache
{
    [_liveUIViewController.liveView onRecvPraise:cache];
}

- (void)refreshIMMsgTableView
{
    NSDictionary *dic = [_iMMsgHandler getMsgCache];
    AVIMCache *msgcache = dic[kRoomTableViewMsgKey];
    [self onUIRefreshIMMsg:msgcache];
    
    AVIMCache *praisecache = dic[@(MSG_LIGHT)];
    [self onUIRefreshPraise:praisecache];
}

#pragma mark 循环礼物队列
- (void)looperWork
{
    [_iMMsgHandler onHandleMyNewMessage:50];
    
    __weak typeof(self) ws = self;
    if (_refreshIMMsgCount % 2 == 0)
    {
        //在主线程播放送文字缩小动画
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws refreshIMMsgTableView];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_currentBigGiftState == 0 && [_gifAnimateArray count])
        {
            _currentBigGiftState = 1;
            [self playNextGiftAnimation];
        }
        
        if (_currentOtherRoomBigGiftState == 0 && [_otherRoomBitGiftArray count])
        {
            _currentOtherRoomBigGiftState = 1;
            [self playNextOhterRoomBigGiftAnimation];
        }
    });
    
    _refreshIMMsgCount ++;
    
    @synchronized (_giftMessageMArray)
    {
        for (SendGiftAnimateView *view in _giftMessageViewMArray)
        {
            if (!view.isPlaying || (view.isPlaying && view.isPlayingDeplay))
            {
                for (CustomMessageModel* giftElem in _giftMessageMArray)
                {
                    if (!giftElem.isTaked)
                    {
                        //如果本条msg还没有被播放过，遍历view列表，寻找是否已经有包含本条msg的view
                        SendGiftAnimateView *currentGiftMsgView;
                        for (SendGiftAnimateView *otherView in _giftMessageViewMArray)
                        {
                            if ([giftElem isEquals:otherView.customMessageModel])
                            {
                                currentGiftMsgView = otherView;
                                break;
                            }
                        }
                        
                        _sendGiftAnimateView1.frame = CGRectMake(kDefaultMargin, [self obtainGiftAnimateViewY:SmallGiftAnimateIndex_1], SEND_GIFT_ANIMATE_VIEW_WIDTH, SEND_GIFT_ANIMATE_VIEW_HEIGHT);
                        _sendGiftAnimateView2.frame = CGRectMake(kDefaultMargin, [self obtainGiftAnimateViewY:SmallGiftAnimateIndex_2], SEND_GIFT_ANIMATE_VIEW_WIDTH, SEND_GIFT_ANIMATE_VIEW_HEIGHT);
                        
                        if (currentGiftMsgView)
                        {
                            //如果找到包含本条msg的view
                            if (view != currentGiftMsgView)
                            {
                                //这个view不是自己，跳过此条信息
                                continue;
                            }
                            else
                            {
                                //如果这个view是自己
                                if (view.isPlaying && view.isPlayingDeplay)
                                {
                                    //在主线程播放送文字缩小动画
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (view == _sendGiftAnimateView1)
                                        {
                                            [_sendGiftAnimateView1 setContent:giftElem];
                                            BOOL canTxtFontChanging = [_sendGiftAnimateView1 txtFontAgain];
                                            if (canTxtFontChanging) {
                                                giftElem.isTaked = YES;
                                            }
                                        }
                                        else
                                        {
                                            [_sendGiftAnimateView2 setContent:giftElem];
                                            BOOL canTxtFontChanging = [_sendGiftAnimateView2 txtFontAgain];
                                            if (canTxtFontChanging)
                                            {
                                                giftElem.isTaked = YES;
                                            }
                                        }
                                        
                                    });
                                    break;
                                }
                                else
                                {
                                    //在主线程播放送礼物动画
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (view == _sendGiftAnimateView1)
                                        {
                                            [_sendGiftAnimateView1 setContent:giftElem];
                                            BOOL canshowGiftAnimate = [_sendGiftAnimateView1 showGiftAnimate];
                                            if (canshowGiftAnimate)
                                            {
                                                giftElem.isTaked = YES;
                                            }
                                        }
                                        else
                                        {
                                            [_sendGiftAnimateView2 setContent:giftElem];
                                            BOOL canshowGiftAnimate = [_sendGiftAnimateView2 showGiftAnimate];
                                            if (canshowGiftAnimate)
                                            {
                                                giftElem.isTaked = YES;
                                            }
                                        }
                                    });
                                    break;
                                }
                            }
                        }
                        else
                        {
                            //如果没找到包含本条msg的view
                            if (!view.isPlaying)
                            {
                                giftElem.isTaked = YES;
                                //在主线程播放送礼物动画
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (view == _sendGiftAnimateView1)
                                    {
                                        [_sendGiftAnimateView1 setContent:giftElem];
                                        [_sendGiftAnimateView1 showGiftAnimate];
                                    }
                                    else
                                    {
                                        [_sendGiftAnimateView2 setContent:giftElem];
                                        [_sendGiftAnimateView2 showGiftAnimate];
                                    }
                                });
                                break;
                            }
                        }
                    }
                    else
                    {
                        continue;
                    }
                }
            }
        }
    }
}


#pragma mark - ----------------------- 小礼物 -----------------------
#pragma mark 获取小礼物视图的Y值
- (CGFloat)obtainGiftAnimateViewY:(SmallGiftAnimateIndex)smallGiftAnimateindex
{
    if (smallGiftAnimateindex == SmallGiftAnimateIndex_1)
    {
        if (_liveUIViewController.liveView.goldFlowerView && _liveUIViewController.liveView.goldViewCanNotSee == NO)
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_1-_liveUIViewController.liveView.goldFlowerViewHeiht+20;
        }
        else if (_liveUIViewController.liveView.guessSizeView && _liveUIViewController.liveView.guessSizeViewCanNotSee == NO)
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_1-kGuessSizeViewHeight+20;
        }
        else
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_1;
        }
    }
    else
    {
        if (_liveUIViewController.liveView.goldFlowerView && _liveUIViewController.liveView.goldViewCanNotSee == NO)
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_2-_liveUIViewController.liveView.goldFlowerViewHeiht+20;
        }
        else if (_liveUIViewController.liveView.guessSizeView && _liveUIViewController.liveView.guessSizeViewCanNotSee == NO)
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_2-kGuessSizeViewHeight+20;
        }
        else
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_2;
        }
    }
}

#pragma mark 创建礼物视图及礼物动画视图
- (void)loadGiftView:(NSArray *)list
{
    _sendGiftAnimateView1 = [[SendGiftAnimateView alloc]initWithFrame:CGRectMake(kDefaultMargin, [self obtainGiftAnimateViewY:SmallGiftAnimateIndex_1], SEND_GIFT_ANIMATE_VIEW_WIDTH, SEND_GIFT_ANIMATE_VIEW_HEIGHT)];
    [_liveUIViewController.liveView addSubview:_sendGiftAnimateView1];
    
    __weak typeof(self) ws = self;
    [_sendGiftAnimateView1.headImgView setClickAction:^(id<MenuAbleItem> menu) {
        CustomMessageModel *customMessageModel = ws.sendGiftAnimateView1.customMessageModel;
        UserModel *userModel = [[UserModel alloc]init];
        if(customMessageModel.type==1)
        {
            userModel.user_id = customMessageModel.sender.user_id;
            userModel.nick_name = customMessageModel.sender.nick_name;
            userModel.head_image = customMessageModel.sender.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
        }
        else if (customMessageModel.type==28)
        {
            userModel.user_id = customMessageModel.user.user_id;
            userModel.nick_name = customMessageModel.user.nick_name;
            userModel.head_image = customMessageModel.user.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.user.user_level];
        }
        
        [ws getUserInfo:userModel];
    }];
    
    _sendGiftAnimateView2 = [[SendGiftAnimateView2 alloc]initWithFrame:CGRectMake(kDefaultMargin, [self obtainGiftAnimateViewY:SmallGiftAnimateIndex_2], SEND_GIFT_ANIMATE_VIEW_WIDTH, SEND_GIFT_ANIMATE_VIEW_HEIGHT)];
    [_liveUIViewController.liveView addSubview:_sendGiftAnimateView2];
    
    [_sendGiftAnimateView2.headImgView setClickAction:^(id<MenuAbleItem> menu) {
        CustomMessageModel *customMessageModel = ws.sendGiftAnimateView2.customMessageModel;
        UserModel *userModel = [[UserModel alloc]init];
        if(customMessageModel.type==1)
        {
            userModel.user_id = customMessageModel.sender.user_id;
            userModel.nick_name = customMessageModel.sender.nick_name;
            userModel.head_image = customMessageModel.sender.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
        }
        else if (customMessageModel.type==28)
        {
            userModel.user_id = customMessageModel.user.user_id;
            userModel.nick_name = customMessageModel.user.nick_name;
            userModel.head_image = customMessageModel.user.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.user.user_level];
        }
        
        [ws getUserInfo:userModel];
    }];
    
    [_giftMessageViewMArray addObject:_sendGiftAnimateView1];
    [_giftMessageViewMArray addObject:_sendGiftAnimateView2];
}

-(void)closeRechargeWithRechargeView:(RechargeView *)rechargeView{
    [UIView animateWithDuration:0.5 animations:^{
        rechargeView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        rechargeView.hidden = YES;
    }];
//    self.giftView.hidden = NO;
}


#pragma mark - ----------------------- 大型礼物动画、GIF动画 -----------------------

#pragma mark - svga动画
- (void)beginSVGAAnimate:(CustomMessageModel *)customMessageModel andSenderName:(NSString *)senderName
{
    if (customMessageModel)
    {
        SVGAAnimate *svgaAnmate = [[SVGAAnimate alloc] initWithModel:customMessageModel inView:_liveUIViewController.liveView andSenderName:senderName];
        svgaAnmate.delegate = self;
    }
    else
    {
        _currentBigGiftState = 0;
    }
}

#pragma mark - svga关闭动画
-(void)SVGAViewFinish:(CustomMessageModel *)animateConfigModel andSenderName:(NSString *)senderName
{
    if ([_gifAnimateArray count])
    {
        CustomMessageModel *customMessageModel = [_gifAnimateArray firstObject];
        NSArray *firstArray = customMessageModel.anim_cfg;
        NSInteger index = [firstArray count];
        //        for (int i=0; i<[firstArray count]; i++)
        //        {
        //            AnimateConfigModel *model = [firstArray objectAtIndex:i];
        //            if (model.Id == animateConfigModel.Id)
        //            {
        //                model.isFinishAnimate = YES;
        //            }
        //            if (model.isFinishAnimate)
        //            {
        //                index--;
        //            }
        //        }
        //        if (index == 0)
        //        {
        [_gifAnimateArray removeObjectAtIndex:0];
        _currentBigGiftState = 0;
        //        }
    }
}

#pragma mark 开始gif动画
- (void)beginGifAnimate:(CustomMessageModel *)customMessageModel andSenderName:(NSString *)senderName
{
    if (customMessageModel.anim_cfg)
    {
        if ([customMessageModel.anim_cfg count])
        {
            NSArray *gifArray = customMessageModel.anim_cfg;
            for (AnimateConfigModel *animateConfigModel in gifArray)
            {
                GifImageView *gifImageView = [[GifImageView alloc]initWithModel:animateConfigModel inView:_liveUIViewController.liveView andSenderName:senderName];
                gifImageView.delegate = self;
            }
        }
        else
        {
            [_gifAnimateArray removeObjectAtIndex:0];
            _currentBigGiftState = 0;
        }
    }
    else
    {
        _currentBigGiftState = 0;
    }
}

#pragma mark GifImageView代理（GifImageViewDelegate）
- (void)gifImageViewFinish:(AnimateConfigModel *)animateConfigModel andSenderName:(NSString *)senderName
{
    if ([_gifAnimateArray count])
    {
        CustomMessageModel *customMessageModel = [_gifAnimateArray firstObject];
        NSArray *firstArray = customMessageModel.anim_cfg;
        NSInteger index = [firstArray count];
        for (int i=0; i<[firstArray count]; i++)
        {
            AnimateConfigModel *model = [firstArray objectAtIndex:i];
            if (model.Id == animateConfigModel.Id)
            {
                model.isFinishAnimate = YES;
            }
            if (model.isFinishAnimate)
            {
                index--;
            }
        }
        if (index == 0)
        {
            [_gifAnimateArray removeObjectAtIndex:0];
            _currentBigGiftState = 0;
        }
    }
}

#pragma mark Plane1Controller代理（Plane1ControllerDelegate）
- (void)plane1AnimationFinished
{
    [self removePlayAnimate:kPlane1Tag];
}

#pragma mark Plane2Controller代理（Plane2ControllerDelegate）
- (void)plane2AnimationFinished
{
    [self removePlayAnimate:kPlane2Tag];
}

#pragma mark FerrariController代理（FerrariControllerDelegate）
- (void)ferrariAnimationFinished
{
    [self removePlayAnimate:kFerrariTag];
}

#pragma mark LambohiniViewController代理（LambohiniViewControllerDelegate）
- (void)lambohiniAnimationFinished
{
    [self removePlayAnimate:kLambohiniTag];
}

#pragma mark RocketViewController代理（RocketViewControllerDelegate）
- (void)rocketAnimationFinished
{
    [self removePlayAnimate:kRocket1Tag];
}

#pragma mark 移除当前播放动画视图，如果有下一条视图则对应继续播放
- (void)removePlayAnimate:(NSInteger)viewTag
{
    [_gifAnimateArray removeObjectAtIndex:0];
    _currentBigGiftState = 0;
}

#pragma mark 播放礼物下一个gif、真实动画
- (void)playNextGiftAnimation
{
    CustomMessageModel *customMessageModel = [_gifAnimateArray firstObject];
    //1：gif动画  2：真实动画
    if (customMessageModel.is_animated == 1)
    {
        [self beginGifAnimate:[_gifAnimateArray firstObject] andSenderName:customMessageModel.top_title];
    }
    else if (customMessageModel.is_animated == 2)
    {
        
        if ([BGUtils isBlankString:customMessageModel.animated_url]) {
//            [self playAnimationWithTagStr:customMessageModel superView:_liveUIViewController.liveView];
        }else{
            [self beginSVGAAnimate:customMessageModel andSenderName:customMessageModel.sender.nick_name];
        }
    }
}

#pragma mark 播放对应标签的动画
- (void)playAnimationWithTagStr:(CustomMessageModel *)customMessageModel superView:(UIView *)superView
{
    if ([customMessageModel.anim_type isEqualToString:kPlane1TypeStr])
    {
        Plane1Controller *tmpController = [[Plane1Controller alloc]init];
        tmpController.senderNameStr = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kPlane1Tag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
    else if ([customMessageModel.anim_type isEqualToString:kPlane2TypeStr])
    {
        Plane2Controller *tmpController = [[Plane2Controller alloc]init];
        tmpController.senderNameStr = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kPlane2Tag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
    else if ([customMessageModel.anim_type isEqualToString:kFerrariTypeStr])
    {
        FerrariController *tmpController = [[FerrariController alloc]init];
        tmpController.senderNameStr1 = customMessageModel.top_title;
        tmpController.senderNameStr2 = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kFerrariTag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
    else if ([customMessageModel.anim_type isEqualToString:kLambohiniTypeStr])
    {
        LambohiniViewController *tmpController = [[LambohiniViewController alloc]init];
        tmpController.senderNameStr = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kLambohiniTag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
    else if ([customMessageModel.anim_type isEqualToString:kRocket1TypeStr])
    {
        RocketViewController *tmpController = [[RocketViewController alloc]init];
        tmpController.senderNameStr = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kRocket1Tag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
}

#pragma mark - ----------------------- 飞屏模式 -----------------------
#pragma mark 播放下一个其他房间的大型礼物（飞屏模式）
- (void)playNextOhterRoomBigGiftAnimation
{
    _ohterRoomBitGiftModel = [_otherRoomBitGiftArray firstObject];
    [self.otherRoomBitGiftArray removeObjectAtIndex:0];
    
    if (![BGUtils isBlankString:_ohterRoomBitGiftModel.desc])
    {
        FWWeakify(self)
        [self.otherRoomBitGiftView judgeGiftViewWith:_ohterRoomBitGiftModel.desc finishBlock:^{
            
            FWStrongify(self)
            self.otherRoomBitGiftView.hidden = NO;
            self.currentOtherRoomBigGiftState = 0;
            
        }];
        _otherRoomBitGiftView.hidden = NO;
    }
}

- (OtherRoomBitGiftView *)otherRoomBitGiftView
{
    if (!_otherRoomBitGiftView)
    {
        _otherRoomBitGiftView = [[OtherRoomBitGiftView alloc] initWithFrame:CGRectMake(0, 100, kScreenW, 55)];
        [_liveUIViewController.liveView addSubview:_otherRoomBitGiftView];
        _otherRoomBitGiftView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOtherLiveRoom)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [_otherRoomBitGiftView addGestureRecognizer:tapRecognizer];
    }
    return _otherRoomBitGiftView;
}

- (void)goOtherLiveRoom
{

    
    if (!_isHost)
    {
        [FanweMessage alert:nil message:ASLocalizedString(@"您确定需要前往该直播间吗？")destructiveAction:^{
            
            SUS_WINDOW.switchedRoomId = _ohterRoomBitGiftModel.room_id;
            
            [self closeCurrentLive:YES isHostShowAlert:NO];
            [self releaseAll];
            
        } cancelAction:^{
            
        }];
        
        /**
         _roomIDStr = _ohterRoomBitGiftModel.room_id;
         if (_delegate && [_delegate respondsToSelector:@selector(switchLiveRoom)])
         {
         [_delegate switchLiveRoom];
         }
         */
    }
}


#pragma mark - ----------------------- 弹幕消息 -----------------------
- (void)addBarrageMessage:(CustomMessageModel *)customMessageModel
{
    if(customMessageModel.desc.length == 0)
    {
        return;
    }
    MessageView* messageView = [[MessageView alloc] initWithView:_liveUIViewController.liveView customMessageModel:customMessageModel];
    messageView.delegate = self;
    if ([_barrageViewArray count])
    { //弹幕消息视图队列中有正在等待展示的弹幕信息
        [_barrageViewArray addObject:messageView];
    }
    else
    {
        if (_barrageViewShowing1 && !_barrageViewShowing2)
        { //正在展示底下的弹幕，上面的弹幕空闲状态
            messageView.frame = CGRectMake(messageView.frame.origin.x, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_2], messageView.frame.size.width, messageView.frame.size.height);
            [self barrageViewAnimating2:messageView];
        }
        else if ((!_barrageViewShowing1 && _barrageViewShowing2) || (!_barrageViewShowing1 && !_barrageViewShowing2))
        { //正在展示上面的弹幕，底下的弹幕空闲状态 或者 两个弹幕都不在展示状态
            messageView.frame = CGRectMake(messageView.frame.origin.x, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_1], messageView.frame.size.width, messageView.frame.size.height);
            [self barrageViewAnimating1:messageView];
        }
        else if (_barrageViewShowing1 && _barrageViewShowing2)
        { //两个弹幕都正在展示状态
            [_barrageViewArray addObject:messageView];
        }
    }
}

- (CGFloat)showBarrageViewWithOriginY:(CGFloat)originY
{
    if (_liveUIViewController.liveView.goldFlowerView && _liveUIViewController.liveView.goldViewCanNotSee == NO)
    {
        return originY-_liveUIViewController.liveView.goldFlowerViewHeiht;
    }
    else if (_liveUIViewController.liveView.guessSizeView && _liveUIViewController.liveView.guessSizeViewCanNotSee == NO)
    {
        return originY-kGuessSizeViewHeight;
    }
    else
    {
        return originY;
    }
}

#pragma mark 获取弹幕视图队列中的弹幕视图
- (void)getBarrageViewFromArray:(int)tag
{
    MessageView* messageView;
    
    if ([_barrageViewArray count])
    { //获取弹幕消息视图队列中的第一个弹幕信息
        messageView = [_barrageViewArray firstObject];
        [_barrageViewArray removeObjectAtIndex:0];
        if (tag == 1)
        {
            messageView.frame = CGRectMake(messageView.frame.origin.x, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_1], messageView.frame.size.width, messageView.frame.size.height);
            [self barrageViewAnimating1:messageView];
        }
        else
        {
            messageView.frame = CGRectMake(messageView.frame.origin.x, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_2], messageView.frame.size.width, messageView.frame.size.height);
            [self barrageViewAnimating2:messageView];
        }
    }
}

- (void)barrageViewAnimating1:(MessageView *)messageView
{
    double needTime = 0;
    if (messageView.frame.size.width<kScreenW)
    {
        needTime = BARRAGE_VIEW_ANIMATE_TIME;
    }
    else
    {
        needTime = BARRAGE_VIEW_ANIMATE_TIME+(messageView.frame.size.width-kScreenW)/kScreenW*BARRAGE_VIEW_ANIMATE_TIME;
    }
    
    _barrageViewShowing1 = YES;
    
    __weak MessageView *mv = messageView;
    
    FWWeakify(self)
    [UIView animateWithDuration:needTime animations:^{
        
        FWStrongify(self)
        mv.frame = CGRectMake(-mv.frame.size.width, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_1], mv.frame.size.width, mv.frame.size.height);
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        self.barrageViewShowing1 = NO;
        [mv removeFromSuperview];
        if ([self.barrageViewArray count])
        {
            [self getBarrageViewFromArray:1];
        }
        
    }];
}

- (void)barrageViewAnimating2:(MessageView *)messageView
{
    double needTime = 0;
    if (messageView.frame.size.width<kScreenW)
    {
        needTime = BARRAGE_VIEW_ANIMATE_TIME;
    }
    else
    {
        needTime = BARRAGE_VIEW_ANIMATE_TIME+(messageView.frame.size.width-kScreenW)/kScreenW*BARRAGE_VIEW_ANIMATE_TIME;
    }
    
    _barrageViewShowing2 = YES;
    
    __weak MessageView *mv = messageView;
    
    FWWeakify(self)
    [UIView animateWithDuration:needTime animations:^{
        
        FWStrongify(self)
        mv.frame = CGRectMake(-mv.frame.size.width, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_2], mv.frame.size.width, mv.frame.size.height);
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        self.barrageViewShowing2 = NO;
        [mv removeFromSuperview];
        if ([self.barrageViewArray count])
        {
            [self getBarrageViewFromArray:2];
        }
    }];
}

#pragma mark 点击弹幕头像
- (void)tapLogo:(MessageView *)messageView customMessageModel:(CustomMessageModel *)customMessageModel
{
    
}
//#pragma mark 关闭每日任务
//- (void)closeEverydayTask
//{
//    self.liveUIViewController.liveView.closeLiveBtn.hidden = YES;
//}


#pragma mark - ----------------------- 高级别用户进入动画 -----------------------
#pragma mark 查看客户是否高级用户，如果是的显示对应的高级用户进入动画
- (void)showCurrUserJoinAnimate
{
    if (!_isHost)
    {
        UserModel *userModel = [[UserModel alloc]init];
        userModel.user_id = [IMAPlatform sharedInstance].host.imUserId;
        userModel.nick_name = [IMAPlatform sharedInstance].host.imUserName;
        userModel.head_image = [IMAPlatform sharedInstance].host.imUserIconUrl;
        userModel.user_level = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getUserRank]];
        
        [self audienceEnterAnimate:userModel];
    }
}

#pragma mark 判断是否播放高级别用户进入动画
- (void)audienceEnterAnimate:(UserModel *)userModel
{
    if (userModel.is_guardian == 1) {
        //是守护,展示守护样式
        [_aETViewArray addObject:userModel];
        if ([_aETViewArray count] == 1 && !_aETViewShowing)
        {
            _aETView.type = AudienceEnteringTipViewTypeGuard;
            [self playAETViewAnimate:userModel];
        }
    }else if ([userModel.user_level integerValue] >= self.BuguLive.appModel.jr_user_level){
        //高级别观众进入,展示高级别动画
            [_aETViewArray addObject:userModel];
            if ([_aETViewArray count] == 1 && !_aETViewShowing)
            {
                _aETView.type = AudienceEnteringTipViewTypeHighLevel;
                [self playAETViewAnimate:userModel];
            }
    }else{
        //不是守护也不是高级别
    }
    
    
    
}

#pragma mark 播放高级别观众进入的动画
- (void)playAETViewAnimate:(UserModel *) userModel
{
    
    _aETView = [[AudienceEnteringTipView alloc]initWithMyFrame:CGRectMake(-kScreenW, _liveUIViewController.liveView.msgView.top - 35, kRealValue(250), kRealValue(30))];
    [_liveUIViewController.liveView addSubview:_aETView];
    [_liveUIViewController.liveView bringSubviewToFront:_liveUIViewController.liveView.giftView];
    
    _aETViewShowing = YES;
    [_aETView setContent:userModel];
    
    FWWeakify(self)
    [UIView animateWithDuration:1.2 animations:^{
        
        FWStrongify(self)
        self.aETView.hidden = NO;
        self.aETView.frame = CGRectMake(0, _liveUIViewController.liveView.msgView.top - 35, kScreenW, 35);
        
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        [self performSelector:@selector(finishAETViewAnimate) withObject:nil afterDelay:2];
        
    }];
}

#pragma mark 结束高级用户进入动画
- (void)finishAETViewAnimate
{
    _aETView.hidden = YES;
    _aETViewShowing = NO;
    [_aETViewArray removeObjectAtIndex:0];
    _aETView.frame = CGRectMake(-kScreenW, _aETView.frame.origin.y, CGRectGetWidth(_aETView.frame), CGRectGetHeight(_aETView.frame));
    [_aETView removeAllSubViews];
    _aETView = nil;
    
    if ([_aETViewArray count])
    {
        UserModel *userModel = [_aETViewArray firstObject];
        
        [self playAETViewAnimate:userModel];
    }
}

#pragma mark - ======= 中奖全站播放通知动画 ======
- (void)confirmPlayWinNotificationAnimation:(CustomMessageModel *)model{
    [_winTipViewArray addObject:model];
    if ([_winTipViewArray count] == 1 && !_winTipViewShowing)
    {
        [self playWinNotificationAnimation:model];
    }
}

- (void)playWinNotificationAnimation:(CustomMessageModel *)model{
    _winTipViewShowing = YES;
    [_winTipView setModel:model];
    self.winTipView.hidden = NO;
    [UIView animateWithDuration:8 animations:^{
        self.winTipView.frame = CGRectMake(-kScreenW, kOpenTipViewHeight, kScreenW - 20, 44);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(finishWinNotificationAnimation) withObject:nil afterDelay:0];
    }];
}

- (void)finishWinNotificationAnimation{
    _winTipViewShowing = NO;
    [_winTipViewArray removeObjectAtIndex:0];
    self.winTipView.hidden = YES;
    self.winTipView.frame = CGRectMake(kScreenW, kOpenTipViewHeight, kScreenW - 20, 44);
    if ([_winTipViewArray count])
    {
        CustomMessageModel *model = [_winTipViewArray firstObject];
        [self playWinNotificationAnimation:model];
    }
}

#pragma mark - ----------------------- 红包 -----------------------
#pragma mark 展示红包
- (void)addRedBagView:(CustomMessageModel *) customMessageModel
{
    BGRedPackModel *user = [BGRedPackModel new];
    user.head_image = customMessageModel.dicData[@"head_image"];
    
    user.nick_name = customMessageModel.dicData[@"nick_name"];
    user.id = customMessageModel.dicData[@"surprise_id"];

    BGOpenRedPackView *readView = [[BGOpenRedPackView alloc] init];
//    readView.video_id = self.video_id;
    readView.userModel = user;
    readView.frame = CGRectMake(40, 0, kScreenW-40*2, kScreenH-140*2);
    readView.userModel = user;
//    readView.backgroundColor = kRedColor;
    [readView show:[self currentViewController].view type:FDPopTypeCenter];
    return;
    [customMessageModel startRedPackageTimer];
    
    SLiveRedBagView *redBagView = [[[NSBundle mainBundle]loadNibNamed:@"SLiveRedBagView" owner:self options:nil] objectAtIndex:0];
    redBagView.frame = CGRectMake(0,0,kScreenW,kScreenH);
    redBagView.rebBagDelegate = self;
    redBagView.video_id = self.currentLiveInfo.room_id;
    [redBagView creatRedWithModel:customMessageModel];
    [_liveUIViewController.liveView addSubview:redBagView];
}

- (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (true) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        } else if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else {
            break;
        }
    }
    return vc;
}
#pragma mark RedBagViewDelegate
#pragma mark 点击打开红包
- (void)openRedbag:(SLiveRedBagView *)redBagView
{
    [redBagView.customMessageModel stopRedPackageTimer];
    
    _liveUIViewController.liveView.currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
    [_liveUIViewController.liveView.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getDiamonds]]];
}

#pragma mark CustomMessageModelDelegate
#pragma mark 红包消失

- (void)redPackageDisappear:(CustomMessageModel *)customMessageModel
{
    for (UIView *subView in _liveUIViewController.liveView.subviews)
    {
        if ([subView isKindOfClass:[SLiveRedBagView class]])
        {
            SLiveRedBagView *redBagView = (SLiveRedBagView *)subView;
            if ([redBagView.customMessageModel isEqual:customMessageModel])
            {
                [redBagView removeFromSuperview];
            }
        }
    }
}


#pragma mark - ----------------------- 结束界面 -----------------------
#pragma mark 结束界面
- (void)setupFinishView:(CurrentLiveInfo *)liveInfo
{
    if (!_finishLiveView)
    {
        _finishLiveView = [[BGFinishLiveView alloc] init];
    }
    [BGUtils downloadImage:liveInfo.podcast.user.head_image place:kDefaultPreloadHeadImg imageView:_finishLiveView.userHeadImgView];
//    [BGUtils downloadImage:liveInfo.podcast.user.head_image place:kDefaultPreloadHeadImg imageView:_finishLiveView.bgImgView];
    
    _finishLiveView.userNameLabel.text = liveInfo.podcast.user.nick_name;
    
    

    if (_isHost)
    {
        _finishLiveView.shareFollowBtn.hidden = YES;
        
        _finishLiveView.screenshotShareBtn.hidden = YES;
        _finishLiveView.audienTicketContrainerView.hidden = YES;
        _finishLiveView.hostCostView.hidden = YES;
        _finishLiveView.hostTicketView.hidden = YES;
        
        //2021.05修改
        _finishLiveView.shareFollowBtn.hidden = YES;
        _finishLiveView.backHomeBtn.hidden = NO;
        _finishLiveView.backTopConstraint.constant = 60;
        _finishLiveView.userIDLabel.text =ASLocalizedString( @"直播已结束");
    }
    else
    {
//        _finishLiveView.screenshotShareBtn.hidden = YES;
//        _finishLiveView.hostContrainerView.hidden = YES;
        _finishLiveView.shareFollowBtn.hidden = NO;
        _finishLiveView.delLiveVideoBtn.hidden = YES;
        _finishLiveView.backTopConstraint.constant = 120;
        _finishLiveView.userIDLabel.text = [NSString stringWithFormat:@"ID %@",liveInfo.podcast.user.user_id];
    }
    
    FWWeakify(self)
    _finishLiveView.shareFollowBlock = ^(){
        
        FWStrongify(self)
        // 主播此时是“分享”按钮，观众此时是“关注”按钮
        if (self.isHost)
        {
            
            FWStrongify(self)
            [self clickedFinishLiveViewBackHomeBtn];
            //分享
//            [self shareWithModel:self.currentLiveInfo.share];
        }
        else
        {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            [mDict setObject:@"user" forKey:@"ctl"];
            [mDict setObject:@"follow" forKey:@"act"];
            if (![BGUtils isBlankString:self.currentLiveInfo.user_id])
            {
                [mDict setObject:self.currentLiveInfo.user_id forKey:@"to_user_id"];
                [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
                    
                    if ([responseJson toInt:@"status"] == 1)
                    {
                        if ([responseJson toInt:@"has_focus"] == 1)
                        {
                            [self.finishLiveView.shareFollowBtn setTitle:ASLocalizedString(@"已关注")forState:UIControlStateNormal];
                        }
                        else
                        {
                            [self.finishLiveView.shareFollowBtn setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
                        }
                    }
                    
                } FailureBlock:^(NSError *error) {
                    
                }];
            }
        }
        
    };
    
    _finishLiveView.backHomeBlock = ^(){
        
        FWStrongify(self)
        [self clickedFinishLiveViewBackHomeBtn];
        
    };
    
    _finishLiveView.screenshotShareBlock = ^{
        FWStrongify(self)
        [self shareWithModel:self.currentLiveInfo.share];

    };
    
    /*
    _finishLiveView.delLiveBlock = ^(){
        
        FWStrongify(self)
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"video" forKey:@"ctl"];
        [mDict setObject:@"del_video" forKey:@"act"];
        [mDict setObject:self.roomIDStr forKey:@"room_id"];
        
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
            
            FWStrongify(self)
            [self clickedFinishLiveViewBackHomeBtn];
            
        } FailureBlock:^(NSError *error) {
            
            FWStrongify(self)
            [self clickedFinishLiveViewBackHomeBtn];
            
        }];
        
    };
     */
}

- (void)clickedFinishLiveViewBackHomeBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishViewClose:)])
    {
        [self.delegate finishViewClose:self];
    }
}

#pragma mark 显示主播结束界面
- (void)showHostFinishView:(NSString *)audience andVote:(NSString *)vote andHasDel:(BOOL)hasDel
{
    if (_isHost)
    {
        [BGUtils closeKeyboard];
        
        _finishLiveView.delLiveVideoBtn.hidden = !hasDel;
        
        [self.view addSubview:_finishLiveView];
        [self.view bringSubviewToFront:_finishLiveView];
        
        if ([BGUtils isBlankString:audience] && [BGUtils isBlankString:vote])
        {
            [_finishLiveView.acIndicator startAnimating];
        }
        else
        {
            [_finishLiveView.acIndicator stopAnimating];
            _finishLiveView.acIndicator.hidden = YES;
            
            _finishLiveView.audienceNumLabel.text = audience;
            _finishLiveView.hostLight.text = vote;
        }
    }
}

#pragma mark 显示观众结束界面
- (void)showAudienceFinishView:(CustomMessageModel *)customMessageModel
{
    if (!_isHost)
    {
        
        [BGUtils closeKeyboard];
        
        NSString *audienceTotalStr = customMessageModel.show_num;
        if ([BGUtils isBlankString:audienceTotalStr])
        {
            [_finishLiveView.acIndicator startAnimating];
        }
        else
        {
            [_finishLiveView.acIndicator stopAnimating];
            _finishLiveView.acIndicator.hidden = YES;
            _finishLiveView.audienceNumLabel.text = audienceTotalStr;
        }
        
        //现在观众端无法记录
        self.finishLiveView.liveTimeL.hidden = YES;
        self.finishLiveView.liveTimeStrLabel.hidden = YES;
        self.finishLiveView.viewToTopConstraint.constant = 119 / 2;
        self.finishLiveView.consumStrLabel.text =ASLocalizedString( @"消费数");
        
        self.finishLiveView.audienceBGView.hidden = NO;
        self.finishLiveView.hostContrainerView.backgroundColor = kClearColor;
        
        //_isFollowAnchor 是否已关注主播
        if (_isFollowAnchor)
        {
            self.finishLiveView.shareFollowBtn.hidden = YES;
            self.finishLiveView.backTopConstraint.constant = 119;
        }
        else
        {
            self.finishLiveView.backTopConstraint.constant = 119;
            [self.finishLiveView.shareFollowBtn setTitle:ASLocalizedString(@"关注主播")forState:UIControlStateNormal];
        }
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"video" forKey:@"ctl"];
        [mDict setObject:@"user_consumption_sum" forKey:@"act"];
        [mDict setObject:_roomIDStr forKey:@"room_id"];
        NSLog(@"%@",_roomIDStr);

        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            NSLog(@"%@",responseJson);
            
            _finishLiveView.hostLight.text = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"total_diamonds"]];
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
        
        [self.view addSubview:_finishLiveView];
        [self.view bringSubviewToFront:_finishLiveView];
    }
}


#pragma mark - ----------------------- 其他代理方法 -----------------------

#pragma mark ========== FWLiveUIViewControllerServeiceDelegate ==========
- (void)showRechargeView:(BGLiveUIViewController *)liveUIViewController
{
    [self rechargeView:_liveUIViewController.liveView];
}

#pragma mark ========== TCShowLiveViewServiceDelegate ==========
#pragma mark 显示充值
- (void)rechargeView:(TCShowLiveView *)showLiveView
{
    [self.rechargePopView show:self.view type:FDPopTypeBottom];
//    if (!self.mgRechargeView) {
//        self.mgRechargeView = [[MGLiveRechargeView alloc]initWithFrame:CGRectMake(0, kScreenH - kRealValue(485), kScreenW, kRealValue(485))];
//    }
//    [self.mgRechargeView show:self.view];
    
//    self.rechargeView.hidden = NO;
//    SUS_WINDOW.window_Tap_Ges.enabled = NO;
//    SUS_WINDOW.window_Pan_Ges.enabled = NO;
//    [self.rechargeView loadRechargeData];
//
//    FWWeakify(self)
//    [UIView animateWithDuration:0.5 animations:^{
//
//        FWStrongify(self)
//        self.rechargeView.transform = CGAffineTransformMakeTranslation(0, (kScreenH-kRechargeViewHeight)/2-kScreenH);
//
//    } completion:^(BOOL finished) {
//
//    }];
}

#pragma mark 连麦、关闭连麦
- (void)clickMikeBtn:(TCShowLiveView *)showLiveView
{
    [self canMike];
}

- (void)canMike
{
    if ([GlobalVariables sharedInstance].isBeingPK) {
        [FanweMessage alertHUD:ASLocalizedString(@"pk中不可以连麦")];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(openOrCloseMike:)])
    {
        [_delegate openOrCloseMike:self];
    }
}

#pragma mark IM私聊
- (void)clickIM:(TCShowLiveView *)showLiveView
{
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    
    // 加载半VC;
    [_liveUIViewController addTwoSubVC];
}

- (void)clickFace:(TCShowLiveView *)showLiveView
{
    [_liveUIViewController showFace];
}

-(void)clickMusic:(TCShowLiveView *)showLiveView
{
    BOOL isInMike = NO;
    for(int i = 0;i < self.currentLiveInfo.wheat_type_list.count; i++)
    {
        Wheat_Type_List *model = self.currentLiveInfo.wheat_type_list[i];
        if(model.even_wheat.user_id == [IMAPlatform sharedInstance].host.userId.intValue)
        {
            isInMike = YES;
            break;
        }
        
    }
    if(isInMike)
    {
        [_liveUIViewController showMusic];

    }
    else
    {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"上麦后才能播放音乐")];
    }
    
}
#pragma mark 点击liveView的空白
- (void)clickBlank:(TCShowLiveView *)showLiveView
{
    
    [_liveUIViewController hiddenPKlist];
    // 后期通知要废掉
    self.liveUIViewController.panGestureRec.enabled = YES;
    for (UIViewController *one_VC in self.liveUIViewController.childViewControllers)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imRemoveNeedUpdate" object:nil];
        
        FWWeakify(self)
        // chatVC存在
        if ([one_VC isKindOfClass:[BGConversationSegmentController class]])
        {
            BGConversationSegmentController *imChat_VC = (BGConversationSegmentController *)one_VC;
            __weak BGConversationSegmentController *imchat = imChat_VC;
            
            [UIView animateWithDuration:kHalfVCViewanimation animations:^{
                
                imchat.view.y = kScreenH;
                
            } completion:^(BOOL finished) {
                
                FWStrongify(self)
                if(finished)
                {
                    [imChat_VC.view removeFromSuperview];
                    [self.liveUIViewController removeChild:imChat_VC];
                    
                    self.liveUIViewController.isHaveHalfIMChatVC = NO;
                    self.liveUIViewController.isKeyboardTypeNum = 0;
                }
            }];
        }
        // 聊天退出
        if ([one_VC isKindOfClass:[BGConversationServiceController class]])
        {
            BGConversationSegmentController *imMsgChat_VC = (BGConversationSegmentController *)one_VC;
            __weak BGConversationSegmentController *imchat = imMsgChat_VC;
            
            [UIView animateWithDuration:kHalfVCViewanimation animations:^{
                
                imchat.view.y = kScreenH;
                
            } completion:^(BOOL finished) {
                
                FWStrongify(self)
                [imMsgChat_VC.view removeFromSuperview];
                [self.liveUIViewController removeChild:imMsgChat_VC];
                self.liveUIViewController.isHaveHalfIMMsgVC = NO;
                self.liveUIViewController.isKeyboardTypeNum = 0;
                
            }];
        }
    }
}


#pragma mark ========== TCShowLiveMessageViewDelegate ==========
- (void)getUserInfo:(UserModel *)userModel
{
    // 关闭键盘
    [BGUtils closeKeyboard];
    if (!_informationView)
    {
        _informationView = [[[NSBundle mainBundle]loadNibNamed:@"SLiveHeadInfoView" owner:self options:nil] objectAtIndex:0];
        _informationView.infoDelegate = self;
        _informationView.frame = CGRectMake(0,kScreenH,kScreenW, kScreenH);
        [_informationView updateUIWithModel:userModel withRoom:_liveItem];
        [_liveUIViewController.view addSubview:_informationView];
        
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            CGRect rect = _informationView.frame;
            rect.origin.y = 0;
            _informationView.frame = rect;
            
        } completion:^(BOOL finished) {
            
        }];
        
        [self setUpLocalizationStringForView:_informationView];
        
//        _informationView loc

        
    }else
    {
        [self removeInformationView];
    }
}



#pragma mark 点击消息列表中的用户名称
- (void)clickNameRange:(CustomMessageModel *) customMessageModel
{
    UserModel *userModel = [[UserModel alloc]init];
    userModel.user_id = customMessageModel.sender.user_id;
    userModel.nick_name = customMessageModel.sender.nick_name;
    userModel.head_image = customMessageModel.sender.head_image;
    userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
    
    [self getUserInfo:userModel];
}

- (void)clickUserInfo:(cuserModel *)cuser
{
    UserModel *userModel = [[UserModel alloc]init];
    userModel.user_id = cuser.user_id;
    userModel.nick_name = cuser.nick_name;
    userModel.head_image = cuser.head_image;
    userModel.user_level = [NSString stringWithFormat:@"%ld",(long)cuser.user_level];
    
    [self getUserInfo:userModel];
}

#pragma mark 点击消息列表中的具体消息内容（目前会响应点击事件的是：红包）
- (void)clickMessageRange:(CustomMessageModel *) customMessageModel
{
    
    BGRedPackModel *user = [BGRedPackModel new];
    user.head_image = customMessageModel.dicData[@"head_image"];
    
    user.nick_name = customMessageModel.dicData[@"nick_name"];
    user.id = customMessageModel.dicData[@"surprise_id"];

    BGOpenRedPackView *readView = [[BGOpenRedPackView alloc] init];
//    readView.video_id = self.video_id;
    readView.userModel = user;
    readView.frame = CGRectMake(40, 0, kScreenW-40*2, kScreenH-140*2);
    readView.userModel = user;
//    readView.backgroundColor = kRedColor;
    [readView show:[AppDelegate sharedAppDelegate].topViewController.view type:FDPopTypeCenter];
    
    return;
    //防止当前页面中正在展示该红包
    for (UIView *view in _liveUIViewController.liveView.subviews)
    {
        if ([view isKindOfClass:[SLiveRedBagView class]])
        {
            SLiveRedBagView *redBagView = (SLiveRedBagView *)view;
            if ([redBagView.customMessageModel isEquals:customMessageModel])
            {
                return;
            }
        }
    }
    
    [self clickNameRange:customMessageModel];
    
    if (customMessageModel.type == MSG_RED_PACKET)
    {
        SLiveRedBagView *redBagView = [[[NSBundle mainBundle]loadNibNamed:@"SLiveRedBagView" owner:self options:nil] objectAtIndex:0];
        redBagView.frame = CGRectMake(0,0,kScreenW,kScreenH);
        redBagView.video_id = self.currentLiveInfo.room_id;
        redBagView.rebBagDelegate = self;
        [redBagView creatRedWithModel:customMessageModel];
        if (customMessageModel.isRedPackageTaked)
        {
            [redBagView changeRedPackageView];
        }
        [_liveUIViewController.liveView addSubview:redBagView];
    }
}

#pragma mark 点击消息列表中的商品推送信息
- (void)clickGoodsMessage:(CustomMessageModel *) customMessageModel
{
    if (customMessageModel.goods.url.length>0 && customMessageModel.goods.type == 1)
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:customMessageModel.goods.url isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
        [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:ASLocalizedString(@"直播")];
        
        //        if (kSupportH5Shopping || self.BuguLive.appModel.open_podcast_goods == 1)
        //        {
        //            tmpController.isSmallScreen = NO;
        //        }
        //        else
        //        {
        //            tmpController.isSmallScreen = YES;
        //        }
        tmpController.isSmallScreen = NO;
        tmpController.httpMethodStr = @"GET";
        [self toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
    }
    else
    {
        GoodsModel * model = [[GoodsModel alloc] init];
        model = customMessageModel.goods;
        NSString * hostId = [[_liveItem liveHost] imUserId];
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"pai_user" forKey:@"ctl"];
        [mDict setObject:@"open_goods_detail" forKey:@"act"];
        [mDict setObject:hostId forKey:@"podcast_id"];
        [mDict setObject:@"shop" forKey:@"itype"];
        if(model.goods_id>0)
        {
            [mDict setObject:model.goods_id forKey:@"goods_id"];
        }
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:[responseJson toString:@"url"] isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
                [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:ASLocalizedString(@"直播")];
                
                //                if (kSupportH5Shopping || self.BuguLive.appModel.open_podcast_goods == 1)
                //                {
                //                    tmpController.isSmallScreen = NO;
                //                }
                //                else
                //                {
                //                    tmpController.isSmallScreen = YES;
                //                }
                tmpController.isSmallScreen = NO;
                tmpController.httpMethodStr = @"GET";
                [self toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    if ([_liveUIViewController.liveView.liveInputView isInputViewActive])
    {
        [_liveUIViewController.liveView.liveInputView resignFirstResponder];
    }
}

#pragma mark ========== SLiveHeadInfoViewDelegate ==========

- (void)operationHeadView:(SLiveHeadInfoView *)headView andUserId:(NSString *)userId andNameStr:(NSString *)nameStr andUserImgUrl:(NSString *)userImgUrl andIs_robot:(BOOL)is_robot andViewType:(int)viewType
{
    [self removeInformationView];
    switch (viewType)
    {
        case 1:  //删除_informationView
        {
            //[self removeInformationView];
        }
            break;
        case 2:  //进入用户主页
        {
            
//            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
//            [mDict setObject:@"pk_tencent" forKey:@"ctl"];
//            [mDict setObject:@"get_pk_lists" forKey:@"act"];
//            [mDict setObject:@"1"  forKey:@"page"];
//            [mDict setObject:@"164741"  forKey:@"user_id"];
//
//
//
//            [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
//
//            } FailureBlock:^(NSError *error) {
//
//            }];
                    
            SHomePageVC *tmpController= [[SHomePageVC alloc]init];
            tmpController.user_id = userId;
            tmpController.type = 0;
            WeakSelf
            tmpController.clickHomePageBlock = ^(BOOL isFocus) {
                
                if ([userId isEqualToString:[[_liveItem liveHost] imUserId]]) {
                    if (isFocus) {
                        self.liveUIViewController.liveView.topView.isShowFollowBtn = NO;
                        self.isFollowAnchor = YES;
                        [self.liveUIViewController.liveView.topView relayoutFrameOfSubViews];
                    }else{
                        self.liveUIViewController.liveView.topView.isShowFollowBtn = YES;
                        self.isFollowAnchor = NO;
                        [self.liveUIViewController.liveView.topView relayoutFrameOfSubViews];
                    }
                }
                
                
                
            };
            BGNavigationController *nav = [[BGNavigationController alloc] initWithRootViewController:tmpController];
            
            [self presentViewController:nav animated:YES completion:nil];

        }
            break;
        case 3:  //进入管理员列表
        {
            ManagerViewController *tmpController = [[ManagerViewController alloc]init];
//            [[AppDelegate sharedAppDelegate]pushViewController:tmpController];
            [self.navigationController pushViewController:tmpController animated:YES];
        }
            break;
        case 4:  //@某个用户
        {
            if (_liveUIViewController.liveView.giftView.hidden == NO)
            {
                [_liveUIViewController.liveView hiddenGiftView];
            }
            
            [_liveUIViewController.liveView.liveInputView.textField becomeFirstResponder];
            _liveUIViewController.liveView.liveInputView.hidden = NO;
            _liveUIViewController.liveView.bottomView.hidden = YES;
            _liveUIViewController.liveView.liveInputView.textField.text = [NSString stringWithFormat:@"%@%@ ",@"@",nameStr];
            
        }
            break;
        case 5:  //举报
        {
            _tipoffUserId = userId;
            _liveReportV = [[SLiveReportView alloc]initWithFrame:CGRectMake(0,0,kScreenW,kScreenH)];
            _liveReportV.reportDelegate = self;
            [_liveUIViewController.liveView addSubview:_liveReportV];
        }
            break;
        case 6:  //进入IM消息
        {
            SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:[userId intValue]];
            
            chattag.mNick_name = nameStr;
            chattag.mHead_image = userImgUrl;
            chattag.is_robot = is_robot;
            
            BGConversationServiceController* chatvc = [BGConversationServiceController makeChatVCWith:chattag];
            chatvc.mtoptitle.text = nameStr;
            BGNavigationController *nav = [[BGNavigationController alloc] initWithRootViewController:chatvc];
            nav.navigationBarHidden = YES;
            [self presentViewController:nav animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)clickHeadViewRefresh{
    [_liveUIViewController.liveView.topView refreshTicketCount:[NSString stringWithFormat:@"%ld",(long)_voteNumber]];
}

- (void)removeInformationView
{
    [_informationView removeFromSuperview];
    _informationView = nil;
}

//- (void)IMchatMsg:(int)userid userimgurl:(NSString*)userimgurl username:(NSString*)username is_robot:(BOOL)is_robot
//{
//    SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:userid];
//
//    chattag.mNick_name = username;
//    chattag.mHead_image = userimgurl;
//    chattag.is_robot = is_robot;
//
//    BGConversationServiceController* chatvc = [BGConversationServiceController makeChatVCWith:chattag];
//    chatvc.mtoptitle.text = username;
//    BGNavigationController *nav = [[BGNavigationController alloc] initWithRootViewController:chatvc];
//    nav.navigationBarHidden = YES;
//    [self presentViewController:nav animated:YES completion:nil];
//}

#pragma mark ========== ReportViewDelegate ==========
- (void)clickWithReportId:(NSString *)reportId andBtnIndex:(int)btnIndex andView:(SLiveReportView *)reportView
{
    if (btnIndex == 1)
    {
        if (reportId.length < 1)
        {
            [FanweMessage alert:ASLocalizedString(@"请选择举报类型")];
            return;
        }
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"user" forKey:@"ctl"];
        [mDict setObject:@"tipoff" forKey:@"act"];
        if (_tipoffUserId) {
            [mDict setObject:_tipoffUserId forKey:@"to_user_id"];
        }
        [mDict setObject:_roomIDStr forKey:@"room_id"];
        [mDict setObject:reportId forKey:@"type"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            [self.liveReportV removeFromSuperview];
            self.liveReportV = nil;
            if ([responseJson toInt:@"status"] == 1)
            {
                [FanweMessage alertHUD:ASLocalizedString(@"已收到举报消息,我们将尽快落实处理")];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    else
    {
        [_liveReportV removeFromSuperview];
        _liveReportV = nil;
    }
}

#pragma mark ========== TCShowLiveTopViewDelegate ==========
#pragma mark 点击用户头像
- (void)onTopView:(TCShowLiveTopView *)topView userModel:(UserModel *)userModel
{
    [self getUserInfo:userModel];
}

#pragma mark 点击关注按钮
- (void)followAchor:(TCShowLiveTopView *)topView
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"follow" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    if ([[_liveItem liveHost] imUserId])
    {
        [mDict setObject:[[_liveItem liveHost] imUserId] forKey:@"to_user_id"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
            
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                if ([responseJson toInt:@"has_focus"] == 1)
                {
                    self.liveUIViewController.liveView.topView.isShowFollowBtn = NO;
                    self.isFollowAnchor = YES;
                    [self.liveUIViewController.liveView.topView relayoutFrameOfSubViews];
                    
                    NSString *follow_msg = [responseJson toString:@"follow_msg"];
                    
                    if (![BGUtils isBlankString:[[IMAPlatform sharedInstance].host imUserName]] && ![BGUtils isBlankString:follow_msg])
                    {
                        [self sentMessageWithStr:follow_msg];
                    }
                }
                else
                {
                    self.isFollowAnchor = NO;
                }
            }
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}

#pragma mark 点击关注按钮发送IM通知
- (void)sentMessageWithStr:(NSString *)msgStr
{
    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
    sendCustomMsgModel.msgType = MSG_LIVING_MESSAGE;
    sendCustomMsgModel.msg = msgStr;
    sendCustomMsgModel.chatGroupID = [_liveItem liveIMChatRoomId];
    [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
}

#pragma mark 进入印票排行榜
- (void)goToContributionList:(TCShowLiveTopView *)topView
{
    ContributionListViewController *VC = [[ContributionListViewController alloc]init];
    VC.user_id = [[_liveItem liveHost] imUserId];
    VC.liveHost_id = [[_liveItem liveHost] imUserId];
    VC.type = @"1";
    //    VC.fromType = @"1";
    VC.liveAVRoomId = _roomIDStr;
    [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController pushViewController:VC animated:YES];
}



     
#pragma mark - 进入守护排行榜
- (void)goToWardPopView:(TCShowLiveTopView *)topView{
    
    [self.liveUIViewController.liveView hiddenGiftView];
    _wardPopView = [[WardPopView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kRealValue(416)) UserId:self.currentLiveInfo.user_id ResponseJson:topView.wardJson];
    [_wardPopView show:self.view];
    __weak typeof(self) weakSelf = self;
    [_wardPopView setClickOpenBtnBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //点击了开通守护
        NSLog(ASLocalizedString(@"点击了开通守护功能"));
        BogoWardOpenView *openView = [[BogoWardOpenView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kRealValue(569)) UserId:self.currentLiveInfo.user_id];
        [openView setClickOpenViewBtnBlock:^(NSString *currentId){
           //开通守护
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:@"guardians" forKey:@"ctl"];
            [dict setValue:@"guardian_buy" forKey:@"act"];
            [dict setValue:self.currentLiveInfo.user_id forKey:@"host_id"];
            [dict setValue:currentId forKey:@"id"];
            [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                if ([responseJson toInt:@"status"] == 1) {
                    NSLog(ASLocalizedString(@"开通守护成功"));
                    
                    if ([[GlobalVariables sharedInstance].is_guartian isEqualToString:@"1"]) {
                        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"守护续费成功")];
                    }else{
                        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"开通守护成功")];
                    }
                    
                    [_liveUIViewController.liveView.topView requestWardData];
                    [_wardPopView show:[UIApplication sharedApplication].keyWindow];
                    self.currentLiveInfo.is_guardian = 1;
                    [GlobalVariables sharedInstance].is_guartian = @"1";
                    [self getGuardianInfo];
//                    //发送群组消息
//                    SendCustomMsgModel *scmm = [[SendCustomMsgModel alloc] init];
//                    scmm.msgType = MSG_OPEN_GUARD_SUCCESS;
//                    scmm.chatGroupID = [_liveItem liveIMChatRoomId];
//                    [[BGIMMsgHandler sharedInstance] sendCustomGroupMsg:scmm succ:^{
//                        NSLog(ASLocalizedString(@"开通守护之后发送群组消息成功"));
//                    } fail:^(int code, NSString *msg) {
//                        NSLog(ASLocalizedString(@"开通守护之后发送群组消息失败:code:%d msg:%@"),code,msg);
//                    }];
                }else{
                    NSLog(ASLocalizedString(@"开通守护失败responseJson:%@"),responseJson);
                }
            } FailureBlock:^(NSError *error) {
                NSLog(ASLocalizedString(@"开通守护失败error:%@"),error);
            }];
        }];

        __block BGLiveServiceController *blockSelf = weakSelf;
        [openView setClickWardListBtnBlock:^{
            [blockSelf->_wardPopView show:[UIApplication sharedApplication].keyWindow];
        }];
        [openView setClickFAQBtnBlock:^{
            //去到网页
            BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.guartian_details isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
            [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
        }];
        __weak typeof(openView) weakOpenView = openView;
        [openView setClickPrivilegeBtnBlock:^(NSString *htmlString, WardPrivilegeButton *button, BOOL isLast) {
            __strong typeof(weakOpenView) strongOpenView = weakOpenView;
            if ([strongOpenView.subviews containsObject:strongSelf.tipView]) {
                [strongSelf.tipView removeFromSuperview];
            }
            strongSelf.tipView = [[WardTipView alloc]initWithFrame:CGRectMake(80, kScreenH, kScreenW - 160, kScreenH / 2)];
            [strongSelf.tipView setURL:htmlString];
            [strongSelf.tipView show:[UIApplication sharedApplication].keyWindow];
            [strongSelf.tipView setTipWebViewDidFinishLoadBlock:^{
                
            }];
        }];
        [openView show:[UIApplication sharedApplication].keyWindow];
    }];
    [_wardPopView setClickWardPopViewCellBlock:^(WardPopViewModel * _Nonnull model) {
        SHomePageVC *tmpController= [[SHomePageVC alloc]init];
        tmpController.user_id = model.uid;
        tmpController.type = 0;
        [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
    }];
}



#pragma mark 移除添加好友的View
- (void)removeAddFriendView
{
    [_addFView removeFromSuperview];
    _addFView = nil;
}

#pragma mark  PasteViewDelegate 微信qq添加好友跳转
- (void)sentPasteWithIndex:(int)index withShareIndex:(int)shareIndex
{
    UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
    pasteboard.string = _privateShareString;
    if (index == 0 || index == 1)
    {
        [_PView removeFromSuperview];
        _PView = nil;
    }
    else
    {
        if (shareIndex == 0)
        {
            NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [_PView removeFromSuperview];
            _PView = nil;
        }
        else
        {
            NSString *str =@"mqq://";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [_PView removeFromSuperview];
            _PView = nil;
        }
    }
}

#pragma mark PasteViewDelegate
- (void)deletePasteView
{
    if (_PView)
    {
        [_PView removeFromSuperview];
        _PView = nil;
    }
}

#pragma mark 添加好友跳转
- (void)addFriendWithIndex:(int)index
{
    if (index == 0 || index == 1)
    {
        [self removeAddFriendView];
        if (!_PView)
        {
            _PView = [[[NSBundle mainBundle]loadNibNamed:@"PasteView" owner:self options:nil] lastObject];
            _PView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
            _PView.shareIndex = index;
            _PView.delegate = self;
            [self.view addSubview:_PView];
        }
    }
    else // 添加好友
    {
        [_addFView removeFromSuperview];
        _addFView = nil;
        SManageFriendVC *manageVC = [[SManageFriendVC alloc]init];
        manageVC.liveAVRoomId = _roomIDStr;
        manageVC.type         = 1;
        [self presentViewController:manageVC animated:YES completion:nil];
    }
}
#pragma mark 最新点击+ -跳转
- (void)onTopView:(TCShowLiveTopView *)topView andCount:(int)count
{
    if (count == 0)
    {
        if (!_addFView)
        {
            _addFView = [[[NSBundle mainBundle]loadNibNamed:@"AddFriendView" owner:self options:nil] lastObject];
            _addFView.delegate = self;
            _addFView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
            [self.view addSubview:_addFView];
        }
        else
        {
            [self removeAddFriendView];
        }
    }
    else if (count == 1)
    {
        if (_addFView)
        {
            [self removeAddFriendView];
        }
        else
        {
            SManageFriendVC *manageVC = [[SManageFriendVC alloc]init];
            manageVC.liveAVRoomId = _roomIDStr;
            manageVC.chatAVRoomId = [_liveItem liveIMChatRoomId];
            manageVC.type         = 0;
            [self presentViewController:manageVC animated:YES completion:nil];
        }
    }
}

#pragma mark - 通知接受到结束惩罚
- (void)endPunish{
    [_liveUIViewController pkVivewHidden];
}

#pragma mark - 点击好友pk
-(void)clickPkList:(TCShowLiveView *)showLiveView
{
    [_liveUIViewController showPKlist];
}

-(void)clickShowShopView:(TCShowLiveView *)showLiveView{
//    _shopView = [[MGShopView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kRealValue(416)) UserId:self.currentLiveInfo.user_id ResponseJson:nil];
//    [_shopView show:self.view];
    
    BogoLiveStartGoodListCellType type = BogoLiveStartGoodListCellTypeList;
    if (!_isHost) {
        type = BogoLiveStartGoodListCellTypeForUser;
    }
    
    self.cartPopView.type = type;
    self.cartPopView.lid = self.currentLiveInfo.room_id;
    [self.cartPopView show:self.liveUIViewController.view type:FDPopTypeBottom];
    NSLog(@"");
    
    [_liveUIViewController.liveView bringSubviewToFront:_liveUIViewController.liveView.giftView];
}

-(void)clickWishView:(TCShowLiveView *)showLiveView{
    _liveUIViewController.wishView = nil;
    [_liveUIViewController showWishView];
}

- (void)clickRoomManage:(TCShowLiveView *)showLiveView
{
    if([self.delegate respondsToSelector:@selector(clickRoomManage)])
    {
        [self.delegate clickRoomManage];
    }

    
}
#pragma mark 添加好友点击空白的地方
- (void)deleteFriendView
{
    [self removeAddFriendView];
}

#pragma mark 控制半VC退出
- (void)clickTopViewUserHeaderMustQuitAllHalfVC:(TCShowLiveTopView*)topView
{
    if (_liveUIViewController.liveView)
    {
        [self clickBlank:_liveUIViewController.liveView];
    }
}


#pragma mark - ----------------------- 分享 -----------------------
#pragma mark 主播开始直播时点击的分享
- (void)hostShareLive
{
    if (![BGUtils isBlankString:_liveUIViewController.liveView.share_type] && _isHost)
    {
        [BGLiveServiceViewModel hostShareCurrentLive:_currentLiveInfo.share shareType:_liveUIViewController.liveView.share_type vc:self block:nil];
    }
}

#pragma mark 观众在直播间点击分享按钮
- (void)clickShareBtn:(TCShowLiveView *)showLiveView
{
    [self shareWithModel:_currentLiveInfo.share];
}

#pragma mark 分享
- (void)shareWithModel:(ShareModel *)model
{
    NSString *share_content;
    if (![model.share_content isEqualToString:@""])
    {
        share_content = model.share_content;
    }
    else
    {
        share_content = model.share_title;
    }
    
    model.isNotifiService = YES;
    model.roomIDStr = _roomIDStr;
    model.imChatIDStr = [_liveItem liveIMChatRoomId];
    [[BGUMengShareManager sharedInstance] showShareViewInControllr:self shareModel:model succ:nil failed:nil];
}

#pragma mark 是否显示关注通知的实现
- (void)isShowFollow:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.object;
    if ([interuptionDict toString:@"userId"])
    {
        if ([[interuptionDict toString:@"userId"] isEqualToString:[[_liveItem liveHost] imUserId]])
        {
            if ([[interuptionDict objectForKey:@"isShowFollow"] intValue] == 0)
            {
                _liveUIViewController.liveView.topView.isShowFollowBtn = NO;
                if ([interuptionDict objectForKey:@"follow_msg"])
                {
//                    [self sentMessageWithStr:[interuptionDict objectForKey:@"follow_msg"]];
                }
            }
            else
            {
                _liveUIViewController.liveView.topView.isShowFollowBtn = YES;
            }
            [_liveUIViewController.liveView.topView relayoutFrameOfSubViews];
        }
    }
}


#pragma mark - ----------------------- 插件中心 -----------------------
#pragma mark 创建插件中心
- (void)creatPluginCenter
{
    if (!_pluginCenterView)
    {
        _pluginCenterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _pluginCenterBgView.backgroundColor = [UIColor clearColor];
        _pluginCenterBgView.hidden = YES;
        [_liveUIViewController.liveView addSubview:_pluginCenterBgView];
        UITapGestureRecognizer *pluginBgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pluginBgViewClick)];
        [_pluginCenterBgView addGestureRecognizer:pluginBgTap];
        
        _pluginCenterView = [[PluginCenterView alloc]initWithFrame:CGRectMake(0, kScreenH , kScreenW, kPluginCenterHeight)];
        _pluginCenterView.delegate = self;
        _pluginCenterView.layer.masksToBounds = YES;
        _pluginCenterView.backgroundColor = [UIColor colorWithHexString:@"#221336"];
        [_liveUIViewController.view addSubview:_pluginCenterView];
    }
}

#pragma mark 收起插件中心
- (void)closeGameList
{
    [self closeGameListView];
}

#pragma mark 点击空白关闭插件中心
- (void)closeGamesView:(TCShowLiveView *)showLiveView
{
    [self closeGameListView];
}

- (void)pluginBgViewClick
{
    [self closeGameListView];
}

- (void)closeGameListView
{
    FWWeakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        FWStrongify(self)
        self.pluginCenterBgView.hidden = YES;
        self.pluginCenterView.frame = CGRectMake(0, kScreenH, kScreenW, kPluginCenterHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 点击插件中心列表
- (void)loadGoldFlowerView:(GameModel *)model withGameID:(NSString *)gameID
{
    if (_isHost)
    {
        if ([model.class_name isEqualToString:@"live_pay"]) // 按时付费
        {
            [self.liveUIViewController clickPluginPayItem:model closeBtn:_closeBtn];
        }
        else if ([model.class_name isEqualToString:@"live_pay_scene"]) // 按场付费
        {
            [self.liveUIViewController clickPluginPayItem:model closeBtn:_closeBtn];
        }
        else if ([model.class_name isEqualToString:@"pai"])
        {
            if ([model.is_active intValue] == 0)
            {
//                [self.auctionTool addView]; // 点击竞拍按钮后出现实物竞拍和虚拟竞拍
            }
            else
            {
                [FanweMessage alert:ASLocalizedString(@"直播间已处于竞拍中")];
            }
        }
        else if ([model.class_name isEqualToString:@"shop"])
        {
            if ([model.is_active intValue] == 0)
            {
//                [self.auctionTool clickStarShopWithIsOTOShop:NO];   // 主播点击星店后
            }
        }
        else if ([model.class_name isEqualToString:@"podcast_goods"])
        {
            if ([model.is_active intValue] == 0)
            {
//                [self.auctionTool clickStarShopWithIsOTOShop:YES];  // 主播点击星店后
            }
        }
        else
        {
            if (self.pluginCenterView.game_id)
            {
                _liveUIViewController.liveView.gameId = [self.pluginCenterView.game_id integerValue];
                [_liveUIViewController.liveView beginGame];
            }
            [_liveUIViewController.liveView addGameView];
        }
    }
}

#pragma mark 获取功能插件个数
- (void)getCount:(NSMutableArray *)array
{
    self.gameOrFeatures = array.count;
}

- (void)clickGameBtn:(TCShowLiveView *)showLiveView
{
    // 进一步控制悬浮手势
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    self.pluginCenterView.hidden = NO;
    [_liveUIViewController.view bringSubviewToFront:self.pluginCenterView];
    [self.pluginCenterView initGamesForNetWorking];
    
    FWWeakify(self)
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options: UIViewAnimationOptionCurveLinear  animations:^{
        
        FWStrongify(self)
        self.pluginCenterBgView.hidden = NO;
        if (self.gameOrFeatures != 0)
        {
            self.pluginCenterView.frame = CGRectMake(0, kPluginCenterY , kScreenW, kPluginCenterHeight);
        }
        else
        {
            self.pluginCenterView.frame = CGRectMake(0, kScreenH - 250, kScreenW, 250);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}



- (void)toGoH5With:(UIViewController *)tmpController andShowSmallWindow:(BOOL)smallWindow
{
    if (smallWindow == YES)
    {
        [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:YES nextViewController:tmpController delegateWindowRCNameStr:nil complete:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self.navigationController pushViewController:tmpController animated:YES];
    }
}


- (void)changePayView:(TCShowLiveView *)showLiveView
{
//    [self.liveUIViewController.livePay changeLeftViewFrameWithIsHost:_isHost andAuctionView:showLiveView.topView.priceView];
    [self.liveUIViewController.livePay changeLeftViewFrameWithIsHost:_isHost andAuctionView:showLiveView.topView.priceView andBankerView:showLiveView.gameBankerView];
}


#pragma mark - ----------------------- 游戏相关 -----------------------
#pragma mark 重新开始直播时判断之前是否有游戏视图
- (void)reloadGameData
{
    if (_liveUIViewController.liveView.goldFlowerView || _liveUIViewController.liveView.guessSizeView)
    {
        if (_liveUIViewController.liveView.goldFlowerView)
        {
            [_liveUIViewController.liveView disAboutClick];
            [_liveUIViewController.liveView.goldFlowerView removeFromSuperview];
            _liveUIViewController.liveView.goldFlowerView = nil;
        }
        else if(_liveUIViewController.liveView.guessSizeView)
        {
            [_liveUIViewController.liveView.guessSizeView disClockTime];
            [_liveUIViewController.liveView.guessSizeView removeFromSuperview];
            _liveUIViewController.liveView.guessSizeView = nil;
        }
        [_liveUIViewController.liveView relayoutFrameOfSubViews];
        _liveUIViewController.liveView.bottomView.hidden = YES;
        [_liveUIViewController.liveView.gameArray removeAllObjects];
        [_liveUIViewController.liveView.gameDataArray removeAllObjects];
        [_liveUIViewController.liveView.bankerDataArr removeAllObjects];
        [_liveUIViewController.liveView.bankerListArr removeAllObjects];
        
        // 如果是主播调用该方法获取到本局游戏的状态
        if (_isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            [_liveUIViewController.liveView loadGameData];
        }
    }
    else
    {
        // 如果前后台切换时直播间不存在游戏
        _liveUIViewController.liveView.shouldReloadGame = NO;
    }
    // 如果是观众
    if (!_isHost)
    {
        [self getVideo:^(CurrentLiveInfo *liveInfo) {
            
        } roomID:_roomIDStr failed:^(int errId, NSString *errMsg) {
            
        }];
    }
}

- (void)exchangeCoin:(NSString *)diamond
{
    ConverDiamondsViewController *ConverDiamondsVC =[[ConverDiamondsViewController alloc]init];
    ConverDiamondsVC.whetherGame = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        ConverDiamondsVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    else
    {
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    [self presentViewController:ConverDiamondsVC animated:YES completion:nil];
}


#pragma mark - ----------------------- 充值兑换界面相关 -----------------------
- (RechargeView *)rechargeView
{
    if (_rechargeView == nil)
    {
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, kRechargeViewHeight) andUIViewController:self];
        _rechargeView.hidden = YES;
        _rechargeView.delegate = self;
        [self.view addSubview:_rechargeView];
    }
    return _rechargeView;
}

- (OtherChangeView *)otherChangeView
{
    if (_otherChangeView == nil)
    {
        _otherChangeView = [[OtherChangeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, 300) andUIViewController:self];
        _otherChangeView.hidden = YES;
        _otherChangeView.delegate = self;
        [self.view addSubview:_otherChangeView];
    }
    return _otherChangeView;
}

- (ExchangeView *)exchangeView
{
    if (_exchangeView == nil)
    {
        _exchangeView = [[ExchangeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, 260)];
        _exchangeView.hidden = YES;
        _exchangeView.delegate = self;
        [self.view addSubview:_exchangeView];
    }
    return _exchangeView;
}

- (void)choseRecharge:(BOOL)recharge orExchange:(BOOL)exchange
{
    [self.liveUIViewController.liveView closeGitfView];
    FWWeakify(self)
    if (recharge)
    {
        self.rechargeView.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            FWStrongify(self)
            self.rechargeView.transform = CGAffineTransformMakeTranslation(0, (kScreenH-kRechargeViewHeight)/2-kScreenH);
//            self.rechargeView.frame = CGRectMake(10, (kScreenH-kRechargeViewHeight)/2, kScreenW-20, kRechargeViewHeight);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else if(exchange)
    {
        self.exchangeView.hidden = NO;
        self.exchangeView.model = self.rechargeView.model;
        [UIView animateWithDuration:0.5 animations:^{
            
            FWStrongify(self)
            //self.exchangeView.frame = CGRectMake(10,  kScreenH-230-kNumberBoardHeight, kScreenW-20, 230);
            self.exchangeView.transform = CGAffineTransformMakeTranslation(0, -260-kNumberBoardHeight);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)choseOtherRechargeWithRechargeView:(RechargeView *)rechargeView
{
    self.otherChangeView.hidden = NO;
    self.otherChangeView.selectIndex = rechargeView.indexPayWay;
    self.otherChangeView.model = rechargeView.model;
    self.otherChangeView.otherPayArr = rechargeView.model.pay_list;
    [self.liveUIViewController.liveView closeGitfView];
    
    FWWeakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        
        FWStrongify(self)
        //self.otherChangeView.frame = CGRectMake(10, kScreenH-260-kNumberBoardHeight, kScreenW-20, 260);
        self.otherChangeView.transform = CGAffineTransformMakeTranslation(0, -300-kNumberBoardHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 点击其它支付的确定按钮
- (void)clickOtherRechergeWithView:(OtherChangeView *)otherView
{
    PayMoneyModel * model = [[PayMoneyModel alloc] init];
    model.hasOtherPay = YES;
    self.rechargeView.money = otherView.textField.text;
    [self.rechargeView payRequestWithModel:model withPayWayIndex:otherView.selectIndex];
}

#pragma mark 点击其它支付的兑换按钮
- (void)clickExchangeWithView:(OtherChangeView *)otherView
{
    [self choseRecharge:NO orExchange:YES];
}

#pragma mark 充值成功后调用
- (void)rechargeSuccessWithRechargeView:(RechargeView *)rechargeView
{
    if (self.liveUIViewController.livePay)//通过这个判断充钱后是否可以看看付费直播的视频
    {
        if (self.liveUIViewController.livePay.isEnterPayLive == 1)
        {
            [self.liveUIViewController.livePay enterMoneyMode];
        }
    }
    
    FWWeakify(self)
    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
        
        FWStrongify(self)
        
        self.liveUIViewController.liveView.currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        
        // 更新游戏余额
        if (self.liveUIViewController.liveView.goldFlowerView)
        {
            if (self.BuguLive.appModel.open_diamond_game_module == 1)
            {
                self.liveUIViewController.liveView.goldFlowerView.coinView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getDiamonds]];
                self.liveUIViewController.liveView.guessSizeView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getDiamonds]];
            }
            else
            {
                self.liveUIViewController.liveView.goldFlowerView.coinView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getUserCoin]];
                self.liveUIViewController.liveView.guessSizeView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getUserCoin]];
            }
        }
        
        [self.liveUIViewController.liveView.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getDiamonds]]];
        self.rechargeView.model.diamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        
        if (self.otherChangeView.hidden == NO)
        {
            [self.otherChangeView disChangeText];
        }
        
    }];
}

- (void)closeRechargeView:(TCShowLiveView *)showLiveView
{
    [self.view endEditing:YES];
    if (self.rechargeView.hidden == NO)
    {
        FWWeakify(self)
        [UIView animateWithDuration:0.5 animations:^{
            
            FWStrongify(self)
            //self.rechargeView.frame = CGRectMake(10, kScreenH, kScreenW-20, kRechargeViewHeight);
            self.rechargeView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            FWStrongify(self)
            self.exchangeView.hidden = YES;
            
        }];
    }
    if (self.exchangeView.hidden == NO)
    {
        [self.exchangeView cancleExchange];
    }
    if (self.otherChangeView.hidden == NO)
    {
        [self.otherChangeView disChangeText];
    }
}

#pragma mark - ----------------------- CY座驾进入动画 -----------------------

#pragma mark 判断是否播放高级别用户进入动画
- (void)CarAnimate:(UserModel *)userModel
{
    //if (userModel.has_car > 0)
    if (userModel.noble_car_url.length > 0 && ![BGUtils isBlankString:userModel.noble_car_url])
    {
        [_aCYCarViewwArray addObject:userModel];
        if ([_aCYCarViewwArray count] == 1 && !_aCYCarViewwShowing)
        {
            [self playCarViewAnimate:userModel];
        }
    }
}

-(void)CarAnimationHiddenPlayerDelegate
{
    [self finishCarViewAnimate];
}

#pragma mark 播放高级别观众进入的动画
- (void)playCarViewAnimate:(UserModel *) userModel
{
    _aCYCarViewwShowing = YES;
    [_aCYCarView setContent:userModel];
    
    //    _aCYCarView.backgroundColor = randomColor;
    _aCYCarView.hidden = NO;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //    [self performSelector:@selector(finishCarViewAnimate) withObject:nil afterDelay:3.5];
    //    });
    
    //    [UIView animateWithDuration:1.2 animations:^{
    //        _aETView.frame = CGRectMake(0,kCYCarViewY, kCYCarViewWidth, kCYCarViewHeight);
    //    } completion:^(BOOL finished) {
    //    }];
}

#pragma mark 结束高级用户进入动画
- (void)finishCarViewAnimate
{
    _aCYCarView.hidden = YES;
    _aCYCarViewwShowing = NO;
    [_aCYCarViewwArray removeObjectAtIndex:0];
    if ([_aCYCarViewwArray count])
    {
        UserModel *userModel = [_aCYCarViewwArray firstObject];
        [self playCarViewAnimate:userModel];
    }
}

- (WardTipView *)tipView{
    if (!_tipView) {
        _tipView = [[WardTipView alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 2, 1)];
    }
    return _tipView;
}

- (void)hideTipView{
    [self.tipView hide];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)protocolDidScrollView:(BGTLiveScrollView *)scrollView isRefreshLive:(BOOL)isRefresh{
    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolDidScrollView:isRefreshLive:)]) {
        [self.delegate protocolDidScrollView:scrollView isRefreshLive:isRefresh];
    }
}



#pragma mark - BogoLiveCartPopViewDelegate
- (void)popView:(BogoLiveCartPopView *)popView didClickGood:(BogoCommodityDetailModel *)model{
    
//    BogoCartModel *model = self.dataArray[indexPath.section];
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
        detailVC.distribution_id = model.distribution_uid;
    //    detailVC.uid = model.share_uid;
        detailVC.source = BogoShopBuySourceLive;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)popView:(BogoLiveCartPopView *)popView didClickAddBtn:(UIButton *)sender{
    
    BogoLiveGoodAddViewController *addVC = [[BogoLiveGoodAddViewController alloc]init];
    addVC.lid = self.currentLiveInfo.room_id;
    BGNavigationController *nav = [[BGNavigationController alloc]initWithRootViewController:addVC];
    [self presentViewController:nav animated:YES completion:nil];
    popView.bottom = 0;
}

-(void)popView:(BogoLiveCartPopView *)popView didRemoveGood:(BogoCommodityDetailModel *)model{
    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
    sendCustomMsgModel.msgType = MSG_SHOP_SAY_CANCLE_TYPE;
    sendCustomMsgModel.msg = @"";
    sendCustomMsgModel.chatGroupID = [_liveItem liveIMChatRoomId];
    sendCustomMsgModel.shopModel = model;
    [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
}

- (void)popView:(BogoLiveCartPopView *)popView didClickSayBtn:(BogoCommodityDetailModel *)model{
    
    
    if (!model.is_live) {
        //取消讲解
        [[BogoNetwork shareInstance] GET:@"api/inExplanation" param:@{@"token":[BogoNetwork shareInstance].token,@"lid":self.currentLiveInfo.room_id,@"gid":model.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
            
            if (result.status.integerValue == 200) {
                
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_SHOP_SAY_TYPE;
                sendCustomMsgModel.msg = @"";
                sendCustomMsgModel.chatGroupID = [_liveItem liveIMChatRoomId];
                sendCustomMsgModel.shopModel = model;
                [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
//                [self.cartPopView hide];
            }
            
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:[UIApplication sharedApplication].keyWindow];
        }];
        
    }else{
        
        [[BogoNetwork shareInstance] GET:@"api/endExplanation" param:@{@"token":[BogoNetwork shareInstance].token,@"lid":self.currentLiveInfo.room_id,@"gid":model.gid} success:^(BogoNetworkResponseModel * _Nonnull result) {
            
            if (result.status.integerValue == 200) {
                
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_SHOP_SAY_CANCLE_TYPE;
                sendCustomMsgModel.msg = @"";
                sendCustomMsgModel.chatGroupID = [_liveItem liveIMChatRoomId];
                sendCustomMsgModel.shopModel = model;
                [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
               
            }
            
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:[UIApplication sharedApplication].keyWindow];
        }];
        
    }
    
    
    
}

- (BogoLiveCartPopView *)cartPopView{
    if (!_cartPopView) {
        _cartPopView = [kShopKitBundle loadNibNamed:@"BogoLiveCartPopView" owner:nil options:nil].lastObject;
        _cartPopView.delegate = self;
    }
    return _cartPopView;
}

- (BogoRechargePopView *)rechargePopView{
    if (!_rechargePopView) {
        _rechargePopView = [[BogoRechargePopView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH - kRealValue(180))];
    }
    return _rechargePopView;
}

//发送表情
-(void)protocolDidClickEmoji:(NSString *)emoji
{
    //判断我在没在麦位
    BOOL isInMike = NO;
    for(int i = 0;i < self.currentLiveInfo.wheat_type_list.count; i++)
    {
        Wheat_Type_List *model = self.currentLiveInfo.wheat_type_list[i];
        if(model.even_wheat.user_id == [IMAPlatform sharedInstance].host.userId.intValue)
        {
            isInMike = YES;
            break;
        }
        
    }
    if(isInMike)
    {
        NSLog(@"发送表情 %@",emoji);
        SendCustomMsgModel *scmm = [[SendCustomMsgModel alloc] init];
        scmm.msgType = MSG_SEND_EMOTION;
        scmm.faceUrl = emoji;
        scmm.chatGroupID = [_liveItem liveIMChatRoomId];
        [[BGIMMsgHandler sharedInstance] sendCustomGroupMsg:scmm succ:nil fail:nil];
    }
    else
    {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"上麦后才能发送表情")];
    }

    
}

@end
