//
//  BGTPublishController.m
//  BuguLive
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BGTPublishController.h"
#import <Foundation/Foundation.h>
#import <TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>
#import <TXLiteAVSDK_Professional/TXLiveBase.h>
//#import <TXLiteAVSDK_Professional/COSClient.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>
#import <mach/mach.h>

/////////////////// TiFaceSDK 添加 开始 ///////////////////
#import "TiSDKInterface.h"
//#import "TiUIView.h"
#import "BeautySettingPanel.h"
/////////////////// TiFaceSDK 添加 结束 ///////////////////

//声网dev
#import "AgoraPushUtils.h"
#import "UIView+CustomAutoLayout.h"
// 清晰度定义
#define    HD_LEVEL_720P       1  //  1280 * 720
#define    HD_LEVEL_540P       2  //  960 * 540
#define    HD_LEVEL_360P       3  //  640 * 360
#define    HD_LEVEL_360_PLUS   4  //  640 * 360 且开启码率自适应

#define kRePublishTime 3        // 断开后重新尝试的次数

@interface BGTPublishController ()<TXLivePushListener,TXLivePlayListener,TXVideoCustomProcessDelegate,TiUIManagerDelegate,BeautySettingPanelDelegate,AgoraRtcEngineDelegate>{
    BeautySettingPanel            *_beautyPanel;    // 美颜控件
}

/////////////// TiSDK 添加 开始 /////////////
//@property(nonatomic, strong) TiSDKManager *tiSDKManager;
//@property(nonatomic, strong) TiUIView *tiUIView;
/////////////// TiSDK 添加 结束 /////////////

@end

@implementation BGTPublishController
{
    //声网dev
    BOOL unpublishing;
    UIView *userListView;
    UIView *userView1;
    UIView *userView2;
    UIView *userView3;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)endLive
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRtmp) object:nil];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    if (self.tiSDKManager) {
//        [self.tiSDKManager destroy];
//        self.tiSDKManager = nil;
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    unpublishing = NO;
    
    ///////////// TiSDK 添加 开始 ////////////

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMainSwitchButtonClick:) name:@"onMainSwitchButtonClick" object:nil];
    
    //#error TiSDK Key, 与包名对应，请联系商务获取
    NSString* key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;
    if([BGUtils isBlankString:key])
    {
        //这里写上那个key
        key = @"517a990947274dd8b51e1525feb0fb79";
        //        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"美颜key为空，请尝试重新打开app获取！")];
    }
    else
    {
//        NSString* key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;
//            
//        //    NSString* key = @"";
//        
////        [[TiSDKManager shareManager] destroy];
////        [[TiUIManager shareManager] destroy]; // TiSDK开源UI窗口对象资源释放
//        [TiSDK init:key CallBack:^(InitStatus initStatus) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"TiSDKInitStatusNotification" object:nil];
//        }];
//            
//        //    [[TiUIManager shareManager] loadToSuperview:self.view];
//        [TiUIManager shareManager].showsDefaultUI = YES;
//        [[TiUIManager shareManager]loadToWindowDelegate:self];
    }
    
    [self initConfig];

    ///////////// TiSDK 添加 结束 /////////////
    //loading imageview
    float width = 34;
    float height = 34;
    float offsetX = (self.view.frame.size.width - width) / 2;
    float offsetY = (self.view.frame.size.height - height) / 2;
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"loading_image0.png"],[UIImage imageNamed:@"loading_image1.png"],[UIImage imageNamed:@"loading_image2.png"],[UIImage imageNamed:@"loading_image3.png"],[UIImage imageNamed:@"loading_image4.png"],[UIImage imageNamed:@"loading_image5.png"],[UIImage imageNamed:@"loading_image6.png"],[UIImage imageNamed:@"loading_image7.png"], nil];
    _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, height)];
    _loadingImageView.animationImages = array;
    _loadingImageView.animationDuration = 1;
    _loadingImageView.hidden = YES;
    [self.view addSubview:_loadingImageView];
}



-(void)onMainSwitchButtonClick:(NSNotificationCenter *)sender{
    
    [[TiUIManager shareManager]showMainMenuView];
    
    _beautyPanel.hidden = NO;
//    [self.tiUIView onMainSwitchButtonClick:nil];
}

//声网dev
- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[GlobalVariables sharedInstance].appModel.agora_app_id delegate:self];
}
- (void)setChannelProfile {
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
}

- (void)setClientRole {

    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
}

- (void)setupLocalVideo {
    // 启用视频模块
    [self.agoraKit enableVideo];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    videoCanvas.view = _preViewContainer;
    // 设置本地视图
    [self.agoraKit setupLocalVideo:videoCanvas];
}

- (void)joinChannel {
    // 频道内每个用户的 uid 必须是唯一的
    int status =  [self.agoraKit joinChannelByToken:self.agora_token channelId:self.roomIDStr info:nil uid:[IMAPlatform sharedInstance].host.userId.intValue joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        [self startRtmpStreaming:self.pushUrlStr];
        NSLog(@"加入声网房间成功");
    }];
    
    NSLog(@"声网 status %d",status);
}

-(void)startRtmpStreaming:(NSString *)rtmp
{
    [self.agoraKit startRtmpStreamWithTranscoding:rtmp transcoding:[AgoraPushUtils getLiveHostTranscoding:[IMAPlatform sharedInstance].host.userId]];
}


// 远端用户加入频道时，会触发该回调
//- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
//
//    userView1.hidden = NO;
//    userView2.hidden = YES;
//    userView3.hidden = YES;
//    [self reloduserListView];
//
////    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
////    videoCanvas.uid = uid;
////    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
////    videoCanvas.view = userView1;
////    // 设置远端视图
////    [self.agoraKit setupRemoteVideo:videoCanvas];
//
//
//
//}
//
//- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason NS_SWIFT_NAME(rtcEngine(_:didOfflineOfUid:reason:))
//{
//    NSLog(@"用户离开");
//}

//重连操作
- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine rtmpStreamingChangedToState:(NSString* _Nonnull)url state:(AgoraRtmpStreamingState)state errorCode:(AgoraRtmpStreamingErrorCode)errorCode NS_SWIFT_NAME(rtcEngine(_:rtmpStreamingChangedToState:state:errorCode:)){
    NSLog(@"rtmpStreamingChangedToState %lu errorCode %lu",(unsigned long)state,(unsigned long)errorCode);
   
//    if(state == AgoraRtmpStreamingStateFailure)
//    {
//        if(errorCode != AgoraRtmpStreamingErrorCodeInternalServerError)
//        {
//            unpublishing = YES;
//            [self.agoraKit stopRtmpStream:self.pushUrlStr];
//        }
//    }
//    else if(state == AgoraRtmpStreamingStateIdle)
//    {
//        if(unpublishing == YES)
//        {
//            unpublishing = NO;
//            [self startRtmpStreaming:self.pushUrlStr];
//        }
//    }
}

- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine rtmpStreamingEventWithUrl:(NSString* _Nonnull)url eventCode:(AgoraRtmpStreamingEvent)eventCode NS_SWIFT_NAME(rtcEngine(_:rtmpStreamingEventWithUrl:eventCode:));
{
    
    NSLog(@"rtmpStreamingEventWithUrl %@ eventCode %lu",url,(unsigned long)eventCode);

}
//===
#pragma mark 初始化配置
- (void)initConfig
{
    [self.view setBackgroundColor:kBlackColor];
    
    //声网dev
    if([GlobalVariables sharedInstance].openAgora == YES)
    {
        [self initializeAgoraEngine];
        [self setChannelProfile];
        [self setClientRole];
//        [self setupLocalVideo];
    }
    else
    {
        _txLivePushonfig = [[TXLivePushConfig alloc] init];
        _txLivePushonfig.frontCamera                = YES;
        _txLivePushonfig.enableAEC                  = YES;
        _txLivePushonfig.enableHWAcceleration       = YES;
        _txLivePushonfig.enableAutoBitrate          = NO;
        _txLivePushonfig.audioChannels              = 1; // 单声道
        
        GlobalVariables *BuguLive = [GlobalVariables sharedInstance];
        // 0：标清(360*640) 1：高清(540*960) 2：超清(720*1280)
        if (BuguLive.appModel.video_resolution_type == 0)
        {
            _txLivePushonfig.videoResolution            = VIDEO_RESOLUTION_TYPE_360_640;
            _txLivePushonfig.videoBitratePIN            = 700;
        }
        else if (BuguLive.appModel.video_resolution_type == 1)
        {
            _txLivePushonfig.videoResolution            = VIDEO_RESOLUTION_TYPE_540_960;
            _txLivePushonfig.videoBitratePIN            = 1000;
        }
        else if (BuguLive.appModel.video_resolution_type == 2)
        {
            _txLivePushonfig.videoResolution            = VIDEO_RESOLUTION_TYPE_720_1280;
            _txLivePushonfig.videoBitratePIN            = 1500;
        }
        _txLivePushonfig.autoAdjustStrategy         = NO;
        
        _txLivePushonfig.videoFPS                   = 20;
        _txLivePushonfig.audioSampleRate            = AUDIO_SAMPLE_RATE_48000;  // 不要用其它的
        _txLivePushonfig.pauseFps                   = 10;
        _txLivePushonfig.pauseTime                  = 300;
        _txLivePushonfig.pauseImg                   = [UIImage imageNamed:@"lr_bg_leave.png"];
        _txLivePublisher = [[TXLivePush alloc] initWithConfig:_txLivePushonfig];
        _txLivePublisher.delegate = self;
        // 设置日志级别
        [TXLiveBase setLogLevel:LOGLEVEL_NULL];
    }

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPKViewChange:) name:@"onPKViewChange" object:nil];
    // 初始化视频父视图
    _preViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_preViewContainer atIndex:0];
    _preViewContainer.center = self.view.center;
    _preViewContainer.backgroundColor = kBlackColor;
    
    //声网dev
    if([GlobalVariables sharedInstance].openAgora == YES)
    {
        [self setupLocalVideo];
        int userViewWidth = 80;
        int userViewHeight = userViewWidth * 1.5;
        userListView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW - userViewWidth - 10, kScreenH - userViewHeight*3 - 60, userViewWidth, userViewHeight*3 + 30)];


        [self.view addSubview:userListView];
        
        
        userView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userViewWidth, userViewHeight)];
        userView1.backgroundColor = kRedColor;
        [userListView addSubview:userView1];
        
        userView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userViewWidth, userViewHeight)];
        userView2.backgroundColor = kYellowColor;
        [userListView addSubview:userView2];
        
        userView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userViewWidth, userViewHeight)];
        userView3.backgroundColor = kBlueColor;
        [userListView addSubview:userView3];
        
//        userView1.hidden = YES;
        userView2.hidden = YES;
        userView3.hidden = YES;
        [self reloduserListView];
//        [userListView alignSubviewsVerticallyWithPadding:0 margin:0];
//        [userListView gridViews:userListView.subviews inColumn:1 size:CGSizeMake(userViewWidth, userViewHeight) margin:CGSizeMake(0, 0) inRect:CGRectMake(0, 0, userViewWidth, userViewHeight)];
        
        if (_delegate && [_delegate respondsToSelector:@selector(firstIFrame:)])
        {
            [_delegate firstIFrame:self];
            _rePublishTime = 0;
        }
    }
    
    
#if TARGET_IPHONE_SIMULATOR
    [self toastTip:ASLocalizedString(@"iOS模拟器不支持推流和播放，请使用真机体验")];
#endif
    
    NSLog(ASLocalizedString(@"==========腾讯SDK版本号：%@"),[TXLiveBase getSDKVersionStr]);
}


-(void)reloduserListView
{
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
    int userViewHeight = userViewWidth * 1.5;
    
    [userListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(userViewWidth));
        make.height.equalTo(@(userViewHeight * realViewArr.count));
        make.bottom.equalTo(self.view).offset(-80);
        make.right.equalTo(self.view).offset(-20);
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
            make.bottom.equalTo(userListView);
            make.height.equalTo(@(userViewHeight));
            make.width.equalTo(@(userViewWidth));
        }];
    }
    
}

- (void)initRightVideoContainerView{
    if (!_rightVideoContrainerView) {
        _rightVideoContrainerView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW / 2, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3)];
        _rightVideoContrainerView.backgroundColor = kClearColor;
    }
    [self.view addSubview:_rightVideoContrainerView];
}

- (void)initTXLivePlayerWithUrl:(NSString *)playUrl playType:(NSInteger)playType{
    if (!_txLivePlayer) {
        _txLivePlayer = [[TXLivePlayer alloc] init];//初始化
    }
    if (!_txLivePlayConfig) {
        _txLivePlayConfig = [[TXLivePlayConfig alloc]init];
        _txLivePlayConfig.enableAEC = YES;
    }
    [_txLivePlayer setConfig:_txLivePlayConfig];
    _txLivePlayer.delegate = self; //如果您需要处理播放的事件
    [_txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:_rightVideoContrainerView insertIndex:0];
    //4-16 2.苹果连麦无法与安卓和苹果之间连麦，对方是没有影子。
    int result = [_txLivePlayer startPlay:[NSString stringWithFormat:@"%@%@",playUrl,@""] type:playType];
    if (result == -1)
    {
        [self toastTip:ASLocalizedString(@"非腾讯云链接，若要放开限制请联系腾讯云商务团队")];
    }
    if( result != 0)
    {
        NSLog(ASLocalizedString(@"播放器启动失败"));
    }
}

//该参数就是发送过来的通知,接到通知后执行的方法
- (void)onPKViewChange:(NSNotification *)notify
{
    int isFull = [[notify.userInfo valueForKey:@"isFull"] intValue];
    NSString *playUrl = [notify.userInfo valueForKey:@"playUrl"];
    
    TX_Enum_PlayType _playType = PLAY_TYPE_LIVE_RTMP;
    if ([playUrl hasPrefix:@"rtmp:"])
    {
        _playType = PLAY_TYPE_LIVE_RTMP;
    }
    else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".flv"].length > 0)
    {
        _playType = PLAY_TYPE_LIVE_FLV;
    }
    
    if(isFull == 1)
    {
        //模拟动态修改
        _preViewContainer.frame = self.view.bounds;
//        [redBgView removeFromSuperview];
//        [blueBgView removeFromSuperview];
        [pkBgView removeFromSuperview];
        _txLivePlayer.delegate = nil;
        [_txLivePlayer stopPlay];
        [_txLivePlayer removeVideoWidget];
        _txLivePlayer = nil;
        [_rightVideoContrainerView removeFromSuperview];
        _rightVideoContrainerView = nil;
        float width = 34;
        float height = 34;
        float offsetX = (self.view.frame.size.width - width) / 2;
        float offsetY = (self.view.frame.size.height - height) / 2;
        _loadingImageView.frame = CGRectMake(offsetX, offsetY, width, height);
        [_txLivePublisher setVideoQuality:VIDEO_QUALITY_HIGH_DEFINITION adjustBitrate:YES adjustResolution:YES];
        [self stopLoadingAnimation];
    }
    else if(isFull == 3)
    {
        //        _preViewContainer.frame = CGRectMake(0, 0, kScreenW/2, kScreenH/);
        
        _preViewContainer.frame = CGRectMake(0, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3);
        [self addPkBgView];
        [self initRightVideoContainerView];
        [self initTXLivePlayerWithUrl:[self changeRTMPToFlv:playUrl] playType:_playType];
        _loadingImageView.centerX = _rightVideoContrainerView.centerX;
        _loadingImageView.centerY = _rightVideoContrainerView.centerY;
        [_txLivePublisher setVideoQuality:VIDEO_QUALITY_STANDARD_DEFINITION adjustBitrate:YES adjustResolution:YES];
        
    }
    else if(isFull == 0)
    {
        _preViewContainer.frame = CGRectMake(0, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3);
        //        _preViewContainer.frame = CGRectMake(kScreenW/2, 0, kScreenW/2, kScreenH/2);
        [self addPkBgView];
        [self initRightVideoContainerView];
        [self initTXLivePlayerWithUrl:[self changeRTMPToFlv:playUrl] playType:_playType];
        _loadingImageView.centerX = _rightVideoContrainerView.centerX;
        _loadingImageView.centerY = _rightVideoContrainerView.centerY;
        [_txLivePublisher setVideoQuality:VIDEO_QUALITY_STANDARD_DEFINITION adjustBitrate:YES adjustResolution:YES];
    }
}

- (void)addVSView{
    //红蓝双方
    if (!redBgView) {
        redBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 2, kScreenH)];
        redBgView.backgroundColor = [UIColor colorWithHexString:@"#731a5a"];
        [self.view addSubview:redBgView];
        [self.view sendSubviewToBack:redBgView];
    }else{
        [self.view addSubview:redBgView];
        [self.view sendSubviewToBack:redBgView];
    }
    if (!blueBgView) {
        blueBgView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW / 2, 0, kScreenW / 2, kScreenH)];
        blueBgView.backgroundColor = [UIColor colorWithHexString:@"#012e89"];
        [self.view addSubview:blueBgView];
        [self.view sendSubviewToBack:blueBgView];
    }else{
        [self.view addSubview:blueBgView];
        [self.view sendSubviewToBack:blueBgView];
    }
}

- (void)addPkBgView{
    if (!pkBgView) {
        pkBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        pkBgView.image = [UIImage imageNamed:@"pk_bg"];
    }
    [self.view addSubview:pkBgView];
    [self.view sendSubviewToBack:pkBgView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.txLivePublisher.isPublishing) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"onPKViewChange" object:nil];
        [GlobalVariables sharedInstance].appModel.spear_live = @"0";
//        if (self.tiSDKManager) {
//            [self.tiSDKManager destroy];
//            self.tiSDKManager = nil;
//            if(_tiUIView.viewArr != nil)
//                for (UIView *sview in _tiUIView.viewArr) {
//                    [sview removeFromSuperview];
//                }
//        }
    }
}
//6-19 修改-onPKViewChange
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPKViewChange:) name:@"onPKViewChange" object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#if !TARGET_IPHONE_SIMULATOR
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied)
    {
        [FanweMessage alert:ASLocalizedString(@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限")];
        return;
    }
#endif
    
}

#pragma mark - ----------------------- 开始、停止推流 -----------------------
#pragma mark 开始推流
- (BOOL)startRtmp
{

    
    _startTime = [[NSDate date]timeIntervalSince1970]*1000;
    _lastTime = _startTime;
    
    NSString* rtmpUrl = self.pushUrlStr;
    
    //声网dev
    if([GlobalVariables sharedInstance].openAgora == YES)
    {
        [self joinChannel];
        
        //是否有摄像头权限
        AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (statusVideo == AVAuthorizationStatusDenied)
        {
            [FanweMessage alert:ASLocalizedString(@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限")];
            return NO;
        }
        
        //是否有麦克风权限
        AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (statusAudio == AVAuthorizationStatusDenied)
        {
            [FanweMessage alert:ASLocalizedString(@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限")];
            return NO;
        }
        
        return YES;
    }
    //===
    
    if (rtmpUrl.length == 0)
    {
        rtmpUrl = ASLocalizedString(@"获取推流地址失败");
    }
    
    if (!([rtmpUrl hasPrefix:@"rtmp://"] ))
    {
        [FanweMessage alert:ASLocalizedString(@"推流地址不合法，目前支持rtmp推流!")];
        return NO;
    }
    
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied)
    {
        [FanweMessage alert:ASLocalizedString(@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限")];
        return NO;
    }
    
    //是否有麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied)
    {
        [FanweMessage alert:ASLocalizedString(@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限")];
        return NO;
    }
    
    if(_txLivePublisher != nil)
    {
        _txLivePublisher.delegate = self;
        if (!_isPreviewing)
        {
            [_txLivePublisher startPreview:_preViewContainer];
            _isPreviewing = YES;
        }
        
        if ([_txLivePublisher startPush:rtmpUrl] != 0)
        {
            NSLog(ASLocalizedString(@"推流器启动失败:%d"),[_txLivePublisher startPush:rtmpUrl]);
            return NO;
        }
    }
    _txLivePublisher.videoProcessDelegate = self;
    
    return YES;
}

#pragma mark 停止推流
- (void)stopRtmp
{
    //声网dev
    [self.agoraKit leaveChannel:nil];
//===
    
    if(_txLivePublisher != nil)
    {
        _txLivePublisher.delegate = nil;
        [_txLivePublisher stopPreview];
        _isPreviewing = NO;
        [_txLivePublisher stopPush];
    }
    if (_txLivePlayer != nil)
    {
        _txLivePlayer.delegate = nil;
        [_txLivePlayer stopPlay];
        [_txLivePlayer removeVideoWidget];
    }
}


#pragma mark - ----------------------- TXLivePushListener代理事件 -----------------------
- (void)onPushEvent:(int)EvtID withParam:(NSDictionary*)param;
{
    //    NSLog(@"==========PushEvtID1:%d",EvtID);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PUSH_EVT_PUSH_BEGIN)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(firstIFrame:)])
            {
                [_delegate firstIFrame:self];
                _rePublishTime = 0;
            }
        }
        else if (EvtID == PUSH_ERR_NET_DISCONNECT)
        {
            [self stopRtmp];
            
            _rePublishTime ++;
            [self performSelector:@selector(startRtmp) withObject:nil afterDelay:3];
        }
        else if(EvtID == PUSH_WARNING_HW_ACCELERATION_FAIL)
        {
            _txLivePublisher.config.enableHWAcceleration = false;
        }else if (EvtID == PUSH_WARNING_NET_BUSY){
            NSLog(ASLocalizedString(@"网络状况不佳：上行带宽太小，上传数据受阻"));
        }
    });
}

- (void)onNetStatus:(NSDictionary*)param
{
    NSDictionary* dict = param;
    _qualityDict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int vbitrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_BITRATE] intValue];
//        int settrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_SET_VIDEO_BITRATE] intValue];
        
        _kbpsRecvStr = StringFromInt(vbitrate);
//        _kbpsSendStr = StringFromInt(settrate);
    });
}

#pragma mark - BeautySettingPanelDelegate

- (void)onSetBeautyStyle:(NSUInteger)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel {
    [_txLivePublisher setBeautyStyle:beautyStyle beautyLevel:beautyLevel whitenessLevel:whitenessLevel ruddinessLevel:ruddinessLevel];
}

- (void)onSetMixLevel:(float)mixLevel {
    [_txLivePublisher setSpecialRatio:mixLevel / 10.0];
}

- (void)onSetEyeScaleLevel:(float)eyeScaleLevel {
    [_txLivePublisher setEyeScaleLevel:eyeScaleLevel];
}

- (void)onSetFaceScaleLevel:(float)faceScaleLevel {
    [_txLivePublisher setFaceScaleLevel:faceScaleLevel];
}

- (void)onSetFaceBeautyLevel:(float)beautyLevel {
}

- (void)onSetFaceVLevel:(float)vLevel {
    [_txLivePublisher setFaceVLevel:vLevel];
}

- (void)onSetChinLevel:(float)chinLevel {
    [_txLivePublisher setChinLevel:chinLevel];
}

- (void)onSetFaceShortLevel:(float)shortLevel {
    [_txLivePublisher setFaceShortLevel:shortLevel];
}

- (void)onSetNoseSlimLevel:(float)slimLevel {
    [_txLivePublisher setNoseSlimLevel:slimLevel];
}

- (void)onSetFilter:(UIImage*)filterImage {
    [_txLivePublisher setFilter:filterImage];
}

- (void)onSetGreenScreenFile:(NSURL *)file {
    [_txLivePublisher setGreenScreenFile:file];
}

- (void)onSelectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir {
    [_txLivePublisher selectMotionTmpl:tmplName inDir:tmplDir];
}

#pragma mark ------------TXLivePlayListener----------

-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param{
    switch (EvtID) {
        case PLAY_EVT_PLAY_BEGIN:
            [self stopLoadingAnimation];
            break;
        case PLAY_EVT_PLAY_LOADING:
            [self startLoadingAnimation];
            break;
        default:
            break;
    }
}

- (void)startLoadingAnimation
{
    if (_loadingImageView != nil)
    {
        _loadingImageView.hidden = NO;
        [_loadingImageView startAnimating];
    }
}

- (void)stopLoadingAnimation
{
    if (_loadingImageView != nil)
    {
        _loadingImageView.hidden = YES;
        [_loadingImageView stopAnimating];
    }
}

#pragma mark - ----------------------- 摄像头、闪光灯 -----------------------
#pragma mark 开、关闪光灯
- (void)clickTorch:(BOOL)isOpen
{
    if (_txLivePublisher)
    {
        if (![_txLivePublisher toggleTorch:isOpen])
        {
            [self toastTip:ASLocalizedString(@"闪光灯启动失败")];
        }
    }
}

#pragma mark 前置后置摄像头切换
- (void)clickCamera:(UIButton*)btn
{
    [_txLivePublisher switchCamera];
}


#pragma mark - ----------------------- 定义清晰度 -----------------------
- (void)changeHD:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"720p"] && NO == [self isSuitableMachine:7])
    {
        [FanweMessage alert:ASLocalizedString(@"直播推流")message:ASLocalizedString(@"iphone 6 及以上机型适合开启720p!")isHideTitle:NO destructiveAction:nil];
        return;
    }
    
    if ([btn.titleLabel.text isEqualToString:@"540p"] && NO == [self isSuitableMachine:5])
    {
        [FanweMessage alert:ASLocalizedString(@"直播推流")message:ASLocalizedString(@"iphone 5 及以上机型适合开启540p!")isHideTitle:NO destructiveAction:nil];
        return;
    }
    
    if (_txLivePublisher == nil) return;
    
    if ([btn.titleLabel.text isEqualToString:@"720p"])
    {
        TXLivePushConfig* _config = _txLivePublisher.config;
        _config.videoBitratePIN   = 1500;
        _config.videoResolution   = [self isSuitableMachine:7 ] ? VIDEO_RESOLUTION_TYPE_720_1280 : VIDEO_RESOLUTION_TYPE_540_960;
        _config.enableAutoBitrate = NO;
        [_txLivePublisher setConfig:_config];
    }
    else if ([btn.titleLabel.text isEqualToString:@"540p"])
    {
        TXLivePushConfig* _config = _txLivePublisher.config;
        _config.videoBitratePIN   = 1000;
        _config.videoResolution   = [self isSuitableMachine:5 ] ? VIDEO_RESOLUTION_TYPE_540_960 : VIDEO_RESOLUTION_TYPE_360_640;
        _config.enableAutoBitrate = NO;
        [_txLivePublisher setConfig:_config];
    }
    else if ([btn.titleLabel.text isEqualToString:@"360p"])
    {
        TXLivePushConfig* _config = _txLivePublisher.config;
        _config.videoBitratePIN   = 700;
        _config.videoResolution   = VIDEO_RESOLUTION_TYPE_360_640;
        _config.enableAutoBitrate = NO;
        [_txLivePublisher setConfig:_config];
        
    }
    else if ([btn.titleLabel.text isEqualToString:@"360+"])
    {
        TXLivePushConfig* _config = _txLivePublisher.config;
        _config.videoBitrateMin   = 500;
        _config.videoBitrateMax   = 1200;
        _config.enableAutoBitrate = YES;
        _config.videoResolution   = VIDEO_RESOLUTION_TYPE_360_640;
        [_txLivePublisher setConfig:_config]; // 此模式下设置bitrate无效
    }
}

// iphone 6 及以上机型适合开启720p, 否则20帧的帧率可能无法达到, 这种"流畅不足,清晰有余"的效果并不好
- (BOOL)isSuitableMachine:(int)targetPlatNum
{
    int mib[2] = {CTL_HW, HW_MACHINE};
    size_t len = 0;
    char* machine;
    
    sysctl(mib, 2, NULL, &len, NULL, 0);
    
    machine = (char*)malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString* platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform length] > 6)
    {
        NSString * platNum = [NSString stringWithFormat:@"%C", [platform characterAtIndex: 6 ]];
        return ([platNum intValue] >= targetPlatNum);
    }
    else
    {
        return NO;
    }
}

#pragma mark - ----------------------- 自定义Toast -----------------------
/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float)heightForString:(UITextView *)textView andWidth:(float)width
{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)toastTip:(NSString*)toastInfo
{
    NSLog(@"======publishtoastInfo:%@",toastInfo);
    
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 110;
    frameRC.size.height -= 110;
    __block UITextView * toastView = [[UITextView alloc] init];
    
    toastView.editable = NO;
    toastView.selectable = NO;
    
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    
    toastView.frame = frameRC;
    
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;
    
    [self.view addSubview:toastView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(){
        [toastView removeFromSuperview];
        toastView = nil;
    });
}


#pragma mark ---------美颜增加-------------
- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height{
    return [[TiSDKManager shareManager] renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:_txLivePublisher.config.frontCamera];
//    if (self.tiSDKManager && [self.tiSDKManager renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:NO]) {
//        /////////////////// TiFaceSDK 添加 开始 ///////////////////
//        return [self.tiSDKManager renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:NO];
//        /////////////////// TiFaceSDK 添加 结束 ///////////////////
//    }
//    return texture;
}

//#pragma mark ---------美颜增加-------------
//- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height{
//    if (self.tiSDKManager && [self.tiSDKManager renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:NO]) {
//        /////////////////// TiFaceSDK 添加 开始 ///////////////////
//        return [self.tiSDKManager renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:NO];
//        /////////////////// TiFaceSDK 添加 结束 ///////////////////
//    }
//    return texture;
//}

//可以在这里释放创建的OpenGL资源
- (void)onTextureDestoryed{
//    [self.tiSDKManager destroy];
}

- (NSString *)changeRTMPToFlv:(NSString *)originalString{
    NSMutableString *mStr = [NSMutableString stringWithString:originalString];
//    [mStr replaceCharactersInRange:NSMakeRange(0, 4) withString:@"http"];
//    [mStr appendString:@".flv"];
    return mStr;
}

@end
