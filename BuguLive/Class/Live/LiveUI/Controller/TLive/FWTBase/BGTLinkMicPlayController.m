//
//  BGTLinkMicPlayController.m
//  BuguLive
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGTLinkMicPlayController.h"
#import <TXLiteAVSDK_Professional/TXLivePush.h>
#import "UserView.h"
#import "VoiceLianmaiUserModel.h"
//声网dev
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "VoiceLianmaiView.h"
@implementation TCLivePushListenerImpl
{
}
- (void)onPushEvent:(int)evtID withParam:(NSDictionary*)param
{
    if (self.delegate)
    {
        [self.delegate onLivePushEvent:self.pushUrl withEvtID:evtID andParam:param];
    }
}

- (void)onNetStatus:(NSDictionary*) param
{
    if (self.delegate)
    {
        [self.delegate onLivePushNetStatus:self.pushUrl withParam:param];
    }
}

@end


@interface BGTLinkMicPlayController()<ITCLivePushListener, ITCLivePlayListener,AgoraRtcEngineDelegate,UserViewDelegate>
{
    
    BOOL                    _isNeedLoading;         // 是否需要展示加载指示器
    
    UIView*                 _smallPlayVideoView;    // 小主播预览窗口
    UIView*                 _fullScreenVideoView;   // 大主播全屏窗口
    
    UIView*                 _loadingBackground;     // 加载中的背景
    UIImageView *           _loadingImageView;      // 加载中的背景图
    
    TCLivePushListenerImpl* _txLivePushListener;    // 小主播推流监听
    TXLivePushConfig *      _txLivePushConfig;      // 小主播推流配置
    TXLivePush *            _txLivePush;            // SDK推流类
    
    TCLivePlayListenerImpl* _txLivePlayListener;    // 拉流监听
    TXLivePlayConfig *      _txLivePlayConfig;      // 拉流配置
    TXLivePlayer *          _txLivePlayer;          // SDK拉流类
    NSMutableArray <NSString *> *lianMaiuser;
    UIView *userListView;
    UserView *userView1;
    UserView *userView2;
    UserView *userView3;

    
}
/////声网dev
//声网dev
// 定义 agoraKit 变量
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;

@end


@implementation BGTLinkMicPlayController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _lianmaiOpenSound = YES;
    
    //声网dev
    lianMaiuser = [NSMutableArray array];
    _isBeingLinkMic = false;
    [GlobalVariables sharedInstance].isBeingLinkMic = _isBeingLinkMic;
    _isWaitingResponse = false;
    _isNeedLoading = YES;
    

    
    if([[GlobalVariables sharedInstance] openAgora])
    {
        
    }
    else
    {
        _txLivePushListener = [[TCLivePushListenerImpl alloc] init];
        _txLivePushListener.delegate = self;
        _txLivePushConfig = [[TXLivePushConfig alloc] init];
        _txLivePushConfig.frontCamera = YES;
        _txLivePushConfig.enableAEC = YES;
        _txLivePushConfig.videoResolution       = VIDEO_RESOLUTION_TYPE_1280_720;
    //    VIDEO_RESOLUTION_TYPE_320_480;
        _txLivePushConfig.videoBitratePIN       = 240;
        _txLivePushConfig.enableAutoBitrate     = NO;
        _txLivePushConfig.enableHWAcceleration  = YES;
        _txLivePushConfig.pauseFps              = 10;
        _txLivePushConfig.pauseTime             = 150;
        _txLivePushConfig.pauseImg = [UIImage imageNamed:@"lr_bg_leave"];
        
        _txLivePush = [[TXLivePush alloc] initWithConfig:_txLivePushConfig];
        _txLivePush.delegate = _txLivePushListener;
    }

    
    _txLivePlayListener = [[TCLivePlayListenerImpl alloc] init];
    _txLivePlayListener.delegate = self;
    _txLivePlayConfig = [[TXLivePlayConfig alloc] init];
    _txLivePlayer = [[TXLivePlayer alloc] init];
    _txLivePlayer.delegate = _txLivePlayListener;
    [_txLivePlayer setConfig:_txLivePlayConfig];
    
    int userViewWidth = 80;
    int userViewHeight = userViewWidth * 1.5;
    
    if(userListView == nil)
    {
        userListView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW - userViewWidth - 10, kScreenH - userViewHeight*3 - 90, 0, 0)];
        userListView.backgroundColor = kClearColor;

    }
    [userListView removeFromSuperview];

    
    
    _playItemArray = [NSMutableArray array];
    _linkMemeberSet = [NSMutableSet set];

    [[GlobalVariables sharedInstance].tliveView addSubview:userListView];
    userView1 = [UserView getView];
    userView1.delegate = self;
    userView1.frame = CGRectMake(0, 0, userViewWidth, userViewHeight);
    userView1.backgroundColor = kRedColor;
    [userListView addSubview:userView1];
    
    userView2 = [UserView getView];
    userView2.delegate = self;
    userView2.frame = CGRectMake(0, 0, userViewWidth, userViewHeight);
    userView2.backgroundColor = kYellowColor;
    [userListView addSubview:userView2];
    
    userView3 = [UserView getView];
    userView3.delegate = self;
    userView3.frame = CGRectMake(0, 0, userViewWidth, userViewHeight);

    [userListView addSubview:userView3];
    
//    UITapGestureRecognizer * tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
//    [userView3 addGestureRecognizer:tapGesture3];
    
    userView1.hidden = YES;
    userView2.hidden = YES;
    userView3.hidden = YES;
    
    userView1.userInteractionEnabled = YES;
    userView2.userInteractionEnabled = YES;
    userView3.userInteractionEnabled = YES;
    
    [self reloduserListView];
    
    [self addLinkMicPlayItem];
}

//点击视频或者音频代理
- (void)clickVideoBtn:(UserView *)view
{
    //如果按钮当前select NO，则要下一步则要关闭视频
    if(view.videoBtn.selected == NO)
    {
        [self.agoraKit muteLocalVideoStream:YES];
    }
    else
    {
        [self.agoraKit muteLocalVideoStream:NO];
    }
    NSLog(@"点击了视频");
}

- (void)clickVoiceBtn:(UserView *)view
{
    //如果按钮当前select NO，则要下一步则要关闭音频
    if(view.voiceBtn.selected == NO)
    {
        [self.agoraKit muteLocalAudioStream:YES];
    }
    else
    {
        [self.agoraKit muteLocalAudioStream:NO];
    }
    
    NSLog(@"点击了音频");
}

- (void)clickUserView:(UserView *)view
{
    [userView1 setSelect:NO];
    [userView2 setSelect:NO];
    [userView3 setSelect:NO];
    
    

    // post notification
//    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:view.uid forKey:@"uid"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showGiftView" object:self userInfo:userInfo];
    
    
    [view setSelect:YES];
}

//声网dev
- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[GlobalVariables sharedInstance].appModel.agora_app_id delegate:self];
    [self.agoraKit enableVideo];

}
- (void)setChannelProfile {
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
}

- (void)setClientRole {

    
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
}


- (void)setClientRole2 {

    
    AgoraClientRoleOptions *option = [[AgoraClientRoleOptions alloc] init];
    option.audienceLatencyLevel = AgoraAudienceLatencyLevelLowLatency;

    [self.agoraKit setClientRole:AgoraClientRoleAudience options:option];
//    [self.agoraKit setClientRole:AgoraClientRoleAudience];
//    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
}


- (void)setupLocalVideo {

    [self.agoraKit enableVideo];
//    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
//    videoCanvas.uid = [IMAPlatform sharedInstance].host.userId.intValue;
//    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
//    userView1.hidden = NO;
//    videoCanvas.view = userView1.videoView;
//    [userView1 frontView];
//    // 设置本地视图
//    [self.agoraKit setupLocalVideo:videoCanvas];
//    [self.agoraKit enableAudio];

}

- (void)joinChannel2 {
    // 频道内每个用户的 uid 必须是唯一的
    [self.agoraKit enableVideo];
    [self.agoraKit enableAudio];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit setClientRole:AgoraClientRoleAudience];

    int status =  [self.agoraKit joinChannelByToken:self.agora_token channelId:self.liveInfo.room_id info:nil uid:[IMAPlatform sharedInstance].host.userId.intValue joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        
        NSLog(@"加入声网房间成功");
    }];
    
//    NSLog(@"声网 status %d",status);
}

// 远端用户加入频道时，会触发该回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if(self.isBeingLinkMic)
    {
        //先将主播加入
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = self.liveInfo.user_id.intValue;
        videoCanvas.renderMode = AgoraVideoRenderModeHidden;
        videoCanvas.view = self.videoContrainerViewAgora;
        // 设置远端视图
        [self.agoraKit setupRemoteVideo:videoCanvas];

        if(uid != self.liveInfo.user_id.intValue && uid != [IMAPlatform sharedInstance].host.userId.intValue && ![lianMaiuser containsObject:StringFromInt(uid)])
        {
            [lianMaiuser addObject:StringFromInt(uid)];
            [self reloduserListView];
        }
    }
    else
    {
        if(uid == self.liveInfo.user_id.intValue)
        {

//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 需要延迟执行的代码
                AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
                videoCanvas.uid = uid;
                self.videoContrainerView.backgroundColor = kGrayColor;
                videoCanvas.renderMode = AgoraVideoRenderModeHidden;
                videoCanvas.view = self.videoContrainerView;
                // 设置远端视图
                [self.agoraKit setupRemoteVideo:videoCanvas];
//            });

        }
        else
        {
            if([GlobalVariables sharedInstance].isBeingPK)
            {
                //如果正在pk把对方的也加进来
                AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
                videoCanvas.uid = uid;
                videoCanvas.renderMode = AgoraVideoRenderModeHidden;
                videoCanvas.view = self.rightVideoContrainerView;
                // 设置远端视图
                [self.agoraKit setupRemoteVideo:videoCanvas];
            }

        }
        

    }

    

    //用户加入
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"live_multi_room" forKey:@"ctl"];
    [parmDict setObject:@"api_mic_list" forKey:@"act"];
    [parmDict setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [parmDict setObject:[BogoNetwork shareInstance].uid forKey:@"uid"];
    [parmDict setObject:self.liveInfo.room_id forKey:@"video_id"];


    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWWeakify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             NSMutableArray *model_arr = [NSMutableArray array];
             
             NSArray *arr = [responseJson valueForKey:@"list"];
             if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic  in arr) {
                    VoiceLianmaiUserModel *model =[VoiceLianmaiUserModel mj_objectWithKeyValues: dic];
                    if(model.user_id.intValue == self.liveInfo.user_id.intValue)
                    {
                        continue;
                    }
                    [model_arr addObject:model];

                }
             }

             [self adjustPlayItemVoiceUserList:model_arr];
             
       
         }
     } FailureBlock:^(NSError *error)
     {

     }];
    
    [self updateLianMaiCoin];
    

//    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
//    videoCanvas.uid = uid;
//    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
//    videoCanvas.view = userView1;
//    // 设置远端视图
//    [self.agoraKit setupRemoteVideo:videoCanvas];
}
-(void)updateLianMaiCoin
{
    //用户加入
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"live_multi_room" forKey:@"ctl"];
    [parmDict setObject:@"api_mic_list" forKey:@"act"];
    [parmDict setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [parmDict setObject:[BogoNetwork shareInstance].uid forKey:@"uid"];
    [parmDict setObject:self.liveInfo.room_id forKey:@"video_id"];


    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWWeakify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             NSMutableArray *model_arr = [NSMutableArray array];
             
             NSArray *arr = [responseJson valueForKey:@"list"];
             if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic  in arr) {
                    VoiceLianmaiUserModel *model =[VoiceLianmaiUserModel mj_objectWithKeyValues: dic];
                    if(model.user_id.intValue == self.liveInfo.user_id.intValue)
                    {
                        continue;
                    }
                    
                    if(model.user_id.intValue == userView1.uid.intValue)
                    {
                        userView1.numberLab.text = model.coin;
                    }
                    
                    if(model.user_id.intValue == userView2.uid.intValue)
                    {
                        userView2.numberLab.text = model.coin;
                    }
                    
                    if(model.user_id.intValue == userView2.uid.intValue)
                    {
                        userView3.numberLab.text = model.coin;
                    }

                }
             }

    
             
       
         }
     } FailureBlock:^(NSError *error)
     {

     }];
}
- (void)joinChannel {
    // 频道内每个用户的 uid 必须是唯一的
    int uid = [IMAPlatform sharedInstance].host.userId.intValue;

    [self.agoraKit enableLocalAudio:NO];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit setClientRole:AgoraClientRoleAudience];
    int status =  [self.agoraKit joinChannelByToken:self.agora_token channelId:self.roomIDStr info:nil uid:[IMAPlatform sharedInstance].host.userId.intValue joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        [self.agoraKit setEnableSpeakerphone:YES];
//        [self startRtmpStreaming:self.pushUrlStr];
        NSLog(@"加入声网房间成功");

    }];
    
    NSLog(@"声网 status %d",status);
}
-(void)reloduserListView
{

//    userView1.hidden = NO;
//    userView2.hidden = YES;
//    userView3.hidden = YES;
    
//    NSMutableArray *needAddLianMaiUser = [NSMutableArray array];//需要连麦的列表
//    NSMutableArray *needDelLianMaiUser = [NSMutableArray array];//需要删除的列表
//
//
    return;
    
    for (int i=0; i<lianMaiuser.count; i++) {
      
        if(i == 0)
        {
            userView2.hidden = NO;
            
            AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
            
            
            videoCanvas.uid = lianMaiuser[i].intValue;
            videoCanvas.renderMode = AgoraVideoRenderModeHidden;
            videoCanvas.view = userView2.videoView;
            [userView2 frontView];
            // 设置远端视图
            [self.agoraKit setupRemoteVideo:videoCanvas];
            
            
        }
        else if(i == 1)
        {
            userView3.hidden = NO;

            AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
            
            
            videoCanvas.uid = lianMaiuser[i].intValue;
            videoCanvas.renderMode = AgoraVideoRenderModeHidden;
            videoCanvas.view = userView3.videoView;;
            [userView3 frontView];
            // 设置远端视图
            [self.agoraKit setupRemoteVideo:videoCanvas];
            
        }
        
  
        
    }
    
    NSArray *subView = userListView.subviews;
    
    for (int i=0; i<subView.count; i++) {
        UIView *itemView = subView[i];
        [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    
    NSMutableArray *realViewArr = [NSMutableArray array];
    for (int i=0; i<subView.count; i++) {
        UIView *itemView = subView[i];
        if(itemView.hidden == NO)
        {
            [realViewArr addObject:itemView];
        }
    }
    int userViewWidth = 120;
    int userViewHeight = userViewWidth * 1.6;
    
    [userListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(userViewWidth));
        make.height.equalTo(@(userViewHeight * realViewArr.count));
        make.bottom.equalTo([GlobalVariables sharedInstance].tliveView).offset(-80);
        make.right.equalTo([GlobalVariables sharedInstance].tliveView).offset(0);
        make.height.equalTo(@(realViewArr.count * userViewHeight));
    }];
    
    
    if(realViewArr.count > 1)
    {
        [realViewArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(userViewHeight));
            make.width.equalTo(@(userViewWidth));
        }];
        [realViewArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:userViewHeight leadSpacing:0 tailSpacing:0];
    }
    else if(realViewArr.count == 1)
    {
        [realViewArr[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(userListView).offset(-80);;
            make.height.equalTo(@(userViewHeight));
            make.width.equalTo(@(userViewWidth));
        }];
    }
    
}

//
- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason NS_SWIFT_NAME(rtcEngine(_:didOfflineOfUid:reason:))
{
//    NSLog(@"用户加入房间");
//    int removeIndex = 0;
//    BOOL isFind = NO;
//    for (int i = 0; i < lianMaiuser.count; i++) {
//        if(i == lianMaiuser[i].intValue)
//        {
//            removeIndex = i;
//            isFind = YES;
//        }
//    }
//    if(isFind)
//    {
//        [lianMaiuser removeObjectAtIndex:removeIndex];
//        [self reloduserListView];
//    }
    NSLog(@"用户离开");
}


//====
- (void)addLinkMicPlayItem
{
    for (int i = 0; i<2; i++)
    {
        BGTLinkMicPlayItem* playItem = [[BGTLinkMicPlayItem alloc] init];
        playItem.videoView = [[UIView alloc] init];
        [self.view addSubview:playItem.videoView];
        
        playItem.livePlayListener = [[TCLivePlayListenerImpl alloc] init];
        playItem.livePlayListener.delegate = self;
        TXLivePlayConfig * playConfig0 = [[TXLivePlayConfig alloc] init];
        playItem.livePlayer = [[TXLivePlayer alloc] init];
        playItem.livePlayer.delegate = playItem.livePlayListener;
        [playItem.livePlayer setConfig: playConfig0];
        [playItem.livePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        playItem.pending = false;
        playItem.itemIndex = i;
        [playItem emptyPlayInfo];
        
        [_playItemArray addObject:playItem];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_smallPlayVideoView == nil)
    {
        _smallPlayVideoView = [[UIView alloc] init];
        [self.view addSubview:_smallPlayVideoView];
    }
    
    if (_fullScreenVideoView == nil)
    {
        _fullScreenVideoView = self.videoContrainerView;
    }
}


#pragma mark - ----------------------- 开始、停止连麦 -----------------------
#pragma mark 开始连麦
- (void)startLinkMic
{
//    if (_isBeingLinkMic || _isWaitingResponse)
//    {
////        [self initializeAgoraEngine];
////        [self setChannelProfile];
//        [self setClientRole];
//        [self setupLocalVideo];
//        [self reloduserListView];;
//    }
    
    if (!_isBeingLinkMic)
    {
        _isBeingLinkMic = YES;
        
        [self authorizationCheck];
        
        //结束从CDN拉流
//        [self stopRtmp];
        
        //声网dev
        if([[GlobalVariables sharedInstance] openAgora])
        {
//            self.videoContrainerViewAgora.hidden = NO;
            //1.加入房
//            [self initializeAgoraEngine];
//            [self setChannelProfile];
//            [self setClientRole];
//            [self setupLocalVideo];
            [self reloduserListView];
            [self joinChannel2];
            //2.设置自己的预览图
            //3.加载主播视频
            //4.加载其他观众视图
        }
        else
        {
            //开始连麦，启动推流
            _txLivePushListener.pushUrl = _push_rtmp2;
            [_txLivePush startPreview:_smallPlayVideoView];
            int i = [_txLivePush startPush:_push_rtmp2];
            NSLog(@"[_txLivePush startPush:_push_rtmp2]%d",i);
            //开始loading
            [self startLoading];
        }
        
       
        

        [GlobalVariables sharedInstance].isBeingLinkMic = _isBeingLinkMic;
    }
}

#pragma mark 停止连麦
- (void)stopLinkMic
{
    _isNeedLoading = YES;
    [self.agoraKit setClientRole:AgoraClientRoleAudience];

    if (_isBeingLinkMic)
    {
        [self.agoraKit enableLocalAudio:NO];;
        [self setClientRole2];
//        self.videoContrainerViewAgora.hidden = YES;
//        [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
//
//        }];
        //结束推流
        [_txLivePush stopPreview];
        [_txLivePush stopPush];
        
        //结束拉流
        [_txLivePlayer removeVideoWidget];
        [_txLivePlayer stopPlay];
        
        //结束连麦加载动画
        [self stopLoading];
        
        _isBeingLinkMic = NO;
        _isWaitingResponse = NO;
        
        [GlobalVariables sharedInstance].isBeingLinkMic = _isBeingLinkMic;
        
        if (_linkMicPlayDelegate && [_linkMicPlayDelegate respondsToSelector:@selector(pushMickResult:userID:)])
        {
            [_linkMicPlayDelegate pushMickResult:NO userID:[[IMAPlatform sharedInstance].host imUserId]];
        }
        
        for (BGTLinkMicPlayItem *playItem in _playItemArray)
        {
            [playItem stopPlay];
            [playItem stopLoading];
            [playItem emptyPlayInfo];
        }
        
        [_linkMemeberSet removeAllObjects];
    }
}

- (void)startLinkMic:(TLiveMickModel *)mickModel
{
    if (!_isBeingLinkMic)
    {
        _push_rtmp2 = mickModel.push_rtmp2;
        _play_rtmp_acc = mickModel.play_rtmp_acc;
        [self startLinkMic];
    }
}
//语音连麦窗口
- (void)adjustPlayItemVoiceUserList:(NSArray <VoiceLianmaiUserModel * > *)userlist
{
    NSLog(@"刷新语音连麦视图");
    NSLog(@"%@",userlist);
    userView1.hidden = YES;
    userView2.hidden = YES;
    userView3.hidden = YES;
    
//    NSMutableArray *needAddLianMaiUser = [NSMutableArray array];//需要连麦的列表
//    NSMutableArray *needDelLianMaiUser = [NSMutableArray array];//需要删除的列表
//
//
    
    for (int i=0; i<userlist.count; i++) {
        if(i == 0)
        {
            userView1.hidden = NO;
            userView1.userName.text = userlist[i].nick_name;
            userView1.uid = userlist[i].user_id;
            
            if(userlist[i].user_id.intValue == [IMAPlatform sharedInstance].host.userId.intValue)
            {
                AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
                videoCanvas.uid = [IMAPlatform sharedInstance].host.userId.intValue;
                videoCanvas.renderMode = AgoraVideoRenderModeHidden;
                userView1.hidden = NO;
                videoCanvas.view = userView1.videoView;
                [self.agoraKit setupLocalVideo:videoCanvas];
                [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
                
                if(userView1.videoBtn.selected == YES)
                {
                    [self.agoraKit enableVideo];
                }
                else
                {
                    [self.agoraKit muteLocalVideoStream:YES];
                }
                
                if(userView1.voiceBtn.selected == YES)
                {
                    [self.agoraKit enableAudio];
                }
                else
                {
                    [self.agoraKit muteLocalAudioStream:YES];
                }
                
            }
            else
            {
                AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
                videoCanvas.uid = userlist[i].user_id.intValue;
                videoCanvas.renderMode = AgoraVideoRenderModeHidden;
                videoCanvas.view = userView1.videoView;
                [self.agoraKit setupRemoteVideo:videoCanvas];
            }
           

        }
        else if(i == 1)
        {
            userView2.hidden = NO;
            
            userView2.userName.text = userlist[i].nick_name;
            userView2.uid = userlist[i].user_id;

            if(userlist[i].user_id.intValue == [IMAPlatform sharedInstance].host.userId.intValue)
            {
                AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
                videoCanvas.uid = [IMAPlatform sharedInstance].host.userId.intValue;
                videoCanvas.renderMode = AgoraVideoRenderModeHidden;
                userView2.hidden = NO;
                videoCanvas.view = userView2.videoView;
                [self.agoraKit setupLocalVideo:videoCanvas];
                
                if(userView2.videoBtn.selected == YES)
                {
                    [self.agoraKit enableVideo];
                }
                else
                {
                    [self.agoraKit muteLocalVideoStream:YES];
                }
                
                if(userView2.voiceBtn.selected == YES)
                {
                    [self.agoraKit enableAudio];
                }
                else
                {
                    [self.agoraKit muteLocalAudioStream:YES];
                }
            }
            else
            {
                AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
                videoCanvas.uid = userlist[i].user_id.intValue;
                videoCanvas.renderMode = AgoraVideoRenderModeHidden;
                videoCanvas.view = userView2.videoView;
                [self.agoraKit setupRemoteVideo:videoCanvas];

            }
           
            
        }
        else if(i == 2)
        {
            userView3.hidden = NO;
            userView3.userName.text = userlist[i].nick_name;
            userView3.uid = userlist[i].user_id;

            
            if(userlist[i].user_id.intValue == [IMAPlatform sharedInstance].host.userId.intValue)
            {
                AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
                videoCanvas.uid = [IMAPlatform sharedInstance].host.userId.intValue;
                videoCanvas.renderMode = AgoraVideoRenderModeHidden;
                userView3.hidden = NO;
                videoCanvas.view = userView3.videoView;
                [self.agoraKit setupLocalVideo:videoCanvas];
                
                if(userView3.videoBtn.selected == YES)
                {
                    [self.agoraKit enableVideo];
                }
                else
                {
                    [self.agoraKit muteLocalVideoStream:YES];
                }
                
                if(userView3.voiceBtn.selected == YES)
                {
                    [self.agoraKit enableAudio];
                }
                else
                {
                    [self.agoraKit muteLocalAudioStream:YES];
                }
            }
            else
            {
                AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
                videoCanvas.uid = userlist[i].user_id.intValue;
                videoCanvas.renderMode = AgoraVideoRenderModeHidden;
                videoCanvas.view = userView3.videoView;
                [self.agoraKit setupRemoteVideo:videoCanvas];
            }
            

        }
        
  
        
    }
    
    NSArray *subView = userListView.subviews;
    
    for (int i=0; i<subView.count; i++) {
        UIView *itemView = subView[i];
        [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    
    NSMutableArray *realViewArr = [NSMutableArray array];
    for (int i=0; i<subView.count; i++) {
        UIView *itemView = subView[i];
        if(itemView.hidden == NO)
        {
            [realViewArr addObject:itemView];
        }
    }
    int userViewWidth = 80;
    int userViewHeight = userViewWidth * 1.6;
    int sp = kRealValue(3);
    [userListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(userViewWidth));
        make.height.equalTo(@((userViewHeight + sp) * realViewArr.count ));
        make.top.equalTo([GlobalVariables sharedInstance].tliveView).offset(160+kStatusBarHeight);
        make.right.equalTo([GlobalVariables sharedInstance].tliveView).offset(0);
//        make.height.equalTo(@(realViewArr.count * userViewHeight));
    }];
    
    
    if(realViewArr.count > 1)
    {
        [realViewArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(userViewHeight));
            make.width.equalTo(@(userViewWidth));
        }];
        [realViewArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:userViewHeight leadSpacing:0 tailSpacing:0];
    }
    else if(realViewArr.count == 1)
    {
        [realViewArr[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(userListView);
            make.height.equalTo(@(userViewHeight));
            make.width.equalTo(@(userViewWidth));
        }];
    }
}


#pragma mark 调整连麦窗口
- (void)adjustPlayItem:(TLiveMickListModel *)mickListModel
{
    if([[GlobalVariables sharedInstance] openAgora])
    {
        return;
    }
    @synchronized (_linkMemeberSet)
    {
        [_linkMemeberSet removeAllObjects];
        
        if (!_isBeingLinkMic)
        {
            for (BGTLinkMicPlayItem *playItem in _playItemArray)
            {
                [playItem stopPlay];
                [playItem stopLoading];
                [playItem emptyPlayInfo];
                
                return;
            }
        }
        
        for (TLiveMickModel *mickModel in mickListModel.list_lianmai)
        {
            //加入连麦成员列表
            [_linkMemeberSet addObject:mickModel.user_id];
            
            TLiveMickLayoutParamModel *paramModel = mickModel.layout_params;
            if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:mickModel.user_id])
            {
                if (!_isClickedMickBtn)
                {
                    mickModel.play_rtmp_acc = mickListModel.play_rtmp_acc;
                    [self startLinkMic:mickModel];
                }
                
                _smallPlayVideoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                
                if (_isNeedLoading)
                {
                    _isNeedLoading = NO;
                    [self initLoadingView:_fullScreenVideoView];
                }
            }
            else
            {
                BOOL isHasPlayItem = NO;
                BGTLinkMicPlayItem *tmpPlayItem;
                int i = 0;
                
                for (BGTLinkMicPlayItem *playItem in _playItemArray)
                {
                    i ++;
                    
                    if ([playItem.userID isEqualToString:mickModel.user_id])
                    {
                        isHasPlayItem = YES;
                        
                        playItem.videoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                        
                        break;
                    }
                    
                    if (([BGUtils isBlankString:playItem.userID] || i == [_playItemArray count]) && !tmpPlayItem)
                    {
                        tmpPlayItem = playItem;
                    }
                }
                
                if (!isHasPlayItem)
                {
                    TLiveMickLayoutParamModel *paramModel = mickModel.layout_params;
                    tmpPlayItem.videoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                    
                    [tmpPlayItem stopPlay];
                    [tmpPlayItem emptyPlayInfo];
                    
                    tmpPlayItem.pending = YES;
                    tmpPlayItem.isWorking = YES;
                    tmpPlayItem.userID = mickModel.user_id;
                    [tmpPlayItem setLoadingText:ASLocalizedString(@"等待观众推流···")];
                    [tmpPlayItem initLoadingView:tmpPlayItem.videoView];
                    [tmpPlayItem startLoading];
                    [tmpPlayItem startPlay:mickModel.play_rtmp2_acc];
                }
            }
        }
        
        for (BGTLinkMicPlayItem *playItem in _playItemArray)
        {
            if (!playItem.isWorking)
            {
                [playItem stopPlay];
                [playItem stopLoading];
                [playItem emptyPlayInfo];
            }
        }
    }
}

- (BGTLinkMicPlayItem*)getPlayItemByStreamUrl:(NSString*)streamUrl
{
    if (streamUrl)
    {
        for (BGTLinkMicPlayItem* playItem in _playItemArray)
        {
            if ([streamUrl isEqualToString:playItem.playUrl])
            {
                return playItem;
            }
        }
    }
    return nil;
}

#pragma mark 请求连麦超时
- (void)onWaitLinkMicResponseTimeOut
{
    if (_isWaitingResponse == YES)
    {
        _isWaitingResponse = NO;
        [self toastTip:ASLocalizedString(@"连麦请求超时，主播没有做出回应")];
    }
}

#pragma mark 连麦过程出错处理
- (void)handleLinkMicFailed:(NSString*)message
{
    [self toastTip:message];
    //结束连麦
    [self stopLinkMic];
    
    [self startRtmp:self.create_type];
}

- (BOOL)startRtmp:(NSInteger)create_type
{
    [super startRtmp:create_type];
    
    if([GlobalVariables sharedInstance].openAgora)
    {
        [self initializeAgoraEngine];
        [self setClientRole];
        [self setupLocalVideo];
        [self joinChannel];
    }
    return YES;
}

#pragma mark 权限检查
- (void)authorizationCheck
{
    //检查麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied)
    {
        [self toastTip:ASLocalizedString(@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限")];
        return;
    }
    
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied)
    {
        [self toastTip:ASLocalizedString(@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限")];
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        [self toastTip:ASLocalizedString(@"系统不支持硬编码， 启动连麦失败")];
        return;
    }
}


#pragma mark - ----------------------- 代理事件 -----------------------
- (void)onReceiveMemberJoinNotify:(NSString*)userID withStreamID:(NSString*)streamID
{
    
}

- (void)onReceiveMemberExitNotify:(NSString*)userID
{
    
}

- (void)onLivePushEvent:(NSString*) pushUrl withEvtID:(int)event andParam:(NSDictionary*)param
{
    NSLog(@"==========PushEvtID2:%d",event);
    
    if (event == PUSH_EVT_PUSH_BEGIN)   // 开始推流事件通知
    {
        _isClickedMickBtn = YES;
        
        if (_linkMicPlayDelegate && [_linkMicPlayDelegate respondsToSelector:@selector(pushMickResult:userID:)])
        {
            [_linkMicPlayDelegate pushMickResult:YES userID:[[IMAPlatform sharedInstance].host imUserId]];
        }
        
        //1.拉取主播的低时延流
        _txLivePlayListener.playUrl = _play_rtmp_acc;
        [_txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView: _fullScreenVideoView insertIndex:0];
        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        [_txLivePlayer startPlay:_play_rtmp_acc type:PLAY_TYPE_LIVE_RTMP_ACC];

        //2.通知主播拉取自己的流
        //        [_tcLinkMicMgr sendMemberJoinNotify:_liveInfo.userid withJoinerID:profile.identifier andJoinerPlayUrl:_playUrl];
    }
    else if (event == PUSH_ERR_NET_DISCONNECT)
    {    //推流失败事件通知
        [self handleLinkMicFailed:ASLocalizedString(@"推流失败，结束连麦")];
    }
    else if (event == PUSH_WARNING_HW_ACCELERATION_FAIL)
    {
        [self handleLinkMicFailed:ASLocalizedString(@"启动硬编码失败，结束连麦")];
    }
}

- (void)onLivePushNetStatus:(NSString*)pushUrl withParam:(NSDictionary*) param
{
    [super onNetStatus:param];
}

- (void)onLivePlayEvent:(NSString*)playUrl withEvtID:(int)event andParam:(NSDictionary*)param
{
    BGTLinkMicPlayItem *playItem = [self getPlayItemByStreamUrl:playUrl];
    
    if (event == PLAY_EVT_PLAY_BEGIN)
    {
        if (playItem)
        {
            [playItem stopLoading];
        }
        else
        {
            [self stopLoading];
        }
    }
    else if (event == PLAY_EVT_PLAY_END)
    {
        if (playItem)
        {
            [playItem stopLoading];
        }
    }
    else if (event == PLAY_ERR_NET_DISCONNECT)
    {
        if (playItem)
        {
            [playItem stopPlay];
            [playItem stopLoading];
            [playItem emptyPlayInfo];
        }
    }
    else if (event == PLAY_WARNING_HW_ACCELERATION_FAIL)
    {
        if (playItem)
        {
            [playItem stopLoading];
        }
    }
    else if (event == PLAY_ERR_GET_RTMP_ACC_URL_FAIL)
    {
        [playItem reStartPlay];
    }
    
    [super onPlayEvent:event withParam:param];
}

- (void)onLivePlayNetStatus:(NSString*)playUrl withParam:(NSDictionary*)param
{
    
}

#pragma mark - ----------------------- 结束视频 -----------------------
- (void)endVideo
{
    [self stopLinkMic];
    
    [super stopRtmp];
}


#pragma mark - ----------------------- 加载动画 -----------------------
- (void)startLoading
{
    if (_loadingBackground)
    {
        _loadingBackground.hidden = NO;
    }
    
    if (_loadingImageView)
    {
        _loadingImageView.hidden = NO;
        [_loadingImageView startAnimating];
    }
}

- (void)stopLoading
{
    if (_loadingBackground)
    {
        _loadingBackground.hidden = YES;
        _loadingBackground = nil;
    }
    
    if (_loadingImageView)
    {
        _loadingImageView.hidden = YES;
        [_loadingImageView stopAnimating];
        _loadingImageView = nil;
    }
}

- (void)initLoadingView:(UIView*)view
{
    CGRect rect = view.frame;
    
    if (_loadingBackground == nil)
    {
        _loadingBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
        _loadingBackground.hidden = YES;
        _loadingBackground.backgroundColor = [UIColor blackColor];
        _loadingBackground.alpha  = 0.5;
        [view addSubview:_loadingBackground];
        
        UITextView * textView = [[UITextView alloc]init];
        textView.bounds = CGRectMake(0, 0, CGRectGetWidth(rect), 30);
        textView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2 - 30);
        textView.textAlignment = NSTextAlignmentCenter;
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        textView.textColor = [UIColor blackColor];
        textView.text = ASLocalizedString(@"连麦中···");
        textView.hidden = YES;
        [_loadingBackground addSubview:textView];
    }
    
    if (_loadingImageView == nil)
    {
        float width = 50;
        float height = 50;
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"loading_image0.png"],
                                 [UIImage imageNamed:@"loading_image1.png"],
                                 [UIImage imageNamed:@"loading_image2.png"],
                                 [UIImage imageNamed:@"loading_image3.png"],
                                 [UIImage imageNamed:@"loading_image4.png"],
                                 [UIImage imageNamed:@"loading_image5.png"],
                                 [UIImage imageNamed:@"loading_image6.png"],
                                 [UIImage imageNamed:@"loading_image7.png"],
                                 [UIImage imageNamed:@"loading_image8.png"],
                                 [UIImage imageNamed:@"loading_image9.png"],
                                 [UIImage imageNamed:@"loading_image10.png"],
                                 [UIImage imageNamed:@"loading_image11.png"],
                                 [UIImage imageNamed:@"loading_image12.png"],
                                 [UIImage imageNamed:@"loading_image13.png"],
                                 [UIImage imageNamed:@"loading_image14.png"],
                                 nil];
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.bounds = CGRectMake(0, 0, width, height);
        _loadingImageView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2);
        _loadingImageView.animationImages = array;
        _loadingImageView.animationDuration = 1;
        _loadingImageView.hidden = YES;
        [view addSubview:_loadingImageView];
    }
}


#pragma mark - ----------------------- 进入前后台 -----------------------
#pragma mark app进入后台
- (void)onAppDidEnterBackGround
{
    [super onAppDidEnterBackGround];
    
    if (_isBeingLinkMic)
    {
        [_txLivePush pausePush];
    }
}

#pragma mark app将要进入前台
- (void)onAppWillEnterForeground
{
    [super onAppWillEnterForeground];
    
    if (_isBeingLinkMic)
    {
        [_txLivePush resumePush];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo *> *)speakers totalVolume:(NSInteger)totalVolume{
    
    //totalVolume
    
    NSLog(@"totalVolume");
    NSLog(@"%ld",totalVolume);
    /*bug：当a用户在麦上正在说话时，切换到无网状态，此时虽然还显示在麦上（im还没下线），
           但观众席听不到声音，光圈还在闪烁
     原因： 这时观众席speakers 里面找不到a，就不会进入for循环，就不会更新a的声音为0
     解决： 1先找到 麦上的用户 2去判断有无声音
     */
    for (AgoraRtcAudioVolumeInfo *speaker in speakers) {
        NSString *uid = @"";
        if (speaker.uid == 0) {
            uid = [IMAPlatform sharedInstance].host.userId;
          
        }else{
            uid = [NSString stringWithFormat:@"%ld",speaker.uid];
            
        }
        
        if([[userView1 uid] isEqualToString:uid])
        {
            userView1.totalVolume = speaker.volume;
        }
        
        if([[userView2 uid] isEqualToString:uid])
        {
            userView2.totalVolume = speaker.volume;
        }
        
        if([[userView3 uid] isEqualToString:uid])
        {
            userView3.totalVolume = speaker.volume;
        }
        
        
        //speaker.volume

    }
    
    if(speakers.count == 0)
    {
        userView1.totalVolume = 0;
        userView2.totalVolume = 0;
        userView3.totalVolume = 0;
    }
    

    
//    [self.uiController.micView setUsers:self.users];
}
- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    
}
@end
