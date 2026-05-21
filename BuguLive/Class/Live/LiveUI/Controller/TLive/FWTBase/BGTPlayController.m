//
//  BGTPlayController.m
//  BuguLive
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BGTPlayController.h"
#import <TXLiteAVSDK_Professional/TXLivePlayListener.h>
#import <TXLiteAVSDK_Professional/TXLiveBase.h>
#import <mach/mach.h>
#import "BogoPkProgressModel.h"
#define TEST_MUTE   0

#define RTMP_URL    ASLocalizedString(@"请输入或扫二维码获取播放地址")
#define kRePlayTime 1 // 断开后重新尝试的次数

typedef NS_ENUM(NSInteger, ENUM_TYPE_CACHE_STRATEGY)
{
    CACHE_STRATEGY_FAST           = 1,  //极速
    CACHE_STRATEGY_SMOOTH         = 2,  //流畅
    CACHE_STRATEGY_AUTO           = 3,  //自动
};

#define CACHE_TIME_FAST             1
#define CACHE_TIME_SMOOTH           5

#define CACHE_TIME_AUTO_MIN         5
#define CACHE_TIME_AUTO_MAX         10

@interface BGTPlayController ()<UITextFieldDelegate, TXLivePlayListener,AgoraRtcEngineDelegate>

@end

@implementation BGTPlayController
{
    BOOL                    _bHWDec;
    UIButton                *_btnPlayMode;
    UIButton                *_btnHWDec;
    long long               _trackingTouchTS;
    BOOL                    _startSeek;
    BOOL                    _videoPause;
    CGRect                  _videoWidgetFrame;      // 改变videoWidget的frame时候记得对其重新进行赋值
    UIImageView             *_loadingImageView;
    BOOL                    _appIsInterrupt;
    float                   _sliderValue;
    TX_Enum_PlayType        _playType;
    long long               _startPlayTS;
    NSString                *_playDurationStr;      // 播放时长
    
    // 普通播放配置
    TXLivePlayConfig        *_txLivePlayConfig;
    TXLivePlayConfig        *_rightTxLivePlayConfig;
}

- (void)dealloc
{
    if (_play_switch == YES)
    {
        [self stopRtmp];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_liveType == FW_LIVE_TYPE_RELIVE)
    {
        _play_switch = NO;
        self.isLivePlay = NO;
    }
    else if (_liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        _play_switch = NO;
        self.isLivePlay = YES;
    }
    
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor blackColor];
    
    _playDurationStr = @"00:00";
    
    _videoWidgetFrame = [UIScreen mainScreen].bounds;
    
    // remove all subview
    for (UIView *view in [self.view subviews])
    {
        [view removeFromSuperview];
    }
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    int icon_size = size.width / 10;
    
    _cover = [[UIView alloc]init];
    _cover.frame  = CGRectMake(10.0f, 55 + 2*icon_size, size.width - 20, size.height - 75 - 3 * icon_size);
    _cover.backgroundColor = [UIColor grayColor];
    _cover.alpha  = 0.5;
    _cover.hidden = YES;
    [self.view addSubview:_cover];
    
    int logheadH = 65;
    _statusView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 55 + 2*icon_size, size.width - 20,  logheadH)];
    _statusView.backgroundColor = [UIColor clearColor];
    _statusView.alpha = 1;
    _statusView.textColor = [UIColor blackColor];
    _statusView.editable = NO;
    _statusView.hidden = YES;
    [self.view addSubview:_statusView];
    
    _logViewEvt = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 55 + 2*icon_size + logheadH, size.width - 20, size.height - 75 - 3 * icon_size - logheadH)];
    _logViewEvt.backgroundColor = [UIColor clearColor];
    _logViewEvt.alpha = 1;
    _logViewEvt.textColor = [UIColor blackColor];
    _logViewEvt.editable = NO;
    _logViewEvt.hidden = YES;
    [self.view addSubview:_logViewEvt];
    
    int icon_length = 8;
    if (!self.isLivePlay)
    {
        icon_length = 6;
    }
    else
    {
        icon_length = 7;
    }
    int icon_gap = (size.width - icon_size*(icon_length-1))/icon_length;
    
    int btn_index = 0;
    _play_switch = NO;
//    2019年08月24日
    _log_switch = YES;
//    [self createBottomBtnIndex:btn_index++ Icon:@"log" Action:@selector(clickLog:) Gap:icon_gap Size:icon_size];
    
    _bHWDec = NO;
    _btnHWDec = [self createBottomBtnIndex:btn_index++ Icon:@"quick2" Action:@selector(onClickHardware:) Gap:icon_gap Size:icon_size];
    
    _screenPortrait = NO;
    [self createBottomBtnIndex:btn_index++ Icon:@"portrait" Action:@selector(clickScreenOrientation:) Gap:icon_gap Size:icon_size];
    
    _renderFillScreen = YES;
    [self createBottomBtnIndex:btn_index++ Icon:@"adjust" Action:@selector(clickRenderMode:) Gap:icon_gap Size:icon_size];
    //极速直播
    if([self tentuCloudPlay])
    {
        _txLivePlayer = [[TXLivePlayer alloc] init];
    }

//    else
//    {
////        [self initializeAgoraEngine];
//
//
//    }
    [TXLiveBase setLogLevel:LOGLEVEL_NULL];
    
    if (!self.isLivePlay)
    {
        _btnCacheStrategy = nil;
    }
    else
    {
        _btnCacheStrategy = [self createBottomBtnIndex:btn_index++ Icon:@"cache_time" Action:@selector(onAdjustCacheStrategy:) Gap:icon_gap Size:icon_size];
    }
    [self setCacheStrategy:CACHE_STRATEGY_AUTO];
    
    _videoPause = NO;
    _trackingTouchTS = 0;
    
    if (!self.isLivePlay)
    {
        _playStart.hidden = NO;
        _playProgress.hidden = NO;
    }
    else
    {
        _playStart.hidden = YES;
        _playProgress.hidden = YES;
    }
    
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
    
    //给声网用的
    _videoContrainerViewAgora = [[UIView alloc] initWithFrame:self.view.bounds];
    _videoContrainerViewAgora.hidden = YES;
    //    _videoContrainerView.tag = 19967;//主播视图tag
    [self.view insertSubview:_videoContrainerViewAgora atIndex:0];
    
    _videoContrainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    //    _videoContrainerView.tag = 19967;//主播视图tag
    [self.view insertSubview:_videoContrainerView atIndex:0];
    if([GlobalVariables sharedInstance].openAgora)
    {
//        [self setupLocalVideo];
//        [self joinChannel];
    }
   
    _videoContrainerView.center = self.view.center;
}

//是否是腾讯云rtmp播放
- (BOOL)tentuCloudPlay
{
    return (![GlobalVariables sharedInstance].openAgora) || (_liveType == FW_LIVE_TYPE_RELIVE);
}

//- (void)initializeAgoraEngine {
//    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[GlobalVariables sharedInstance].appModel.agora_app_id delegate:self];
//    [self setChannelProfile];
//    [self setClientRole];
//    [self.agoraKit enableLocalAudio:NO];
//    [self.agoraKit enableLocalVideo:NO];
//
//}
//- (void)setChannelProfile {
//    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
//}
//
//- (void)setClientRole {
//
//    AgoraClientRoleOptions *option = [[AgoraClientRoleOptions alloc] init];
//    option.audienceLatencyLevel = AgoraAudienceLatencyLevelLowLatency;
//
//    [self.agoraKit setClientRole:AgoraClientRoleAudience options:option];
////    [self.agoraKit setClientRole:AgoraClientRoleAudience];
//}
//
//- (void)setupLocalVideo {
//    // 启用视频模块
//    [self.agoraKit muteLocalAudioStream:YES];
//    [self.agoraKit muteLocalVideoStream:YES];
////    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
////    videoCanvas.uid = 0;
////    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
////    videoCanvas.view = _preViewContainer;
//    // 设置本地视图
////    [self.agoraKit setupLocalVideo:videoCanvas];
//}

//- (void)joinChannel {
//    // 频道内每个用户的 uid 必须是唯一的
//    int uid = [IMAPlatform sharedInstance].host.userId.intValue;
//
//    [self.agoraKit enableLocalAudio:NO];
//
////    [self.agoraKit joinChannelByToken:self.agora_token channelId:self.roomIDStr info:nil uid:uid options:nil];
//    int status =  [self.agoraKit joinChannelByToken:self.agora_token channelId:self.roomIDStr info:nil uid:[IMAPlatform sharedInstance].host.userId.intValue joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
//        [self.agoraKit setEnableSpeakerphone:YES];
////        [self startRtmpStreaming:self.pushUrlStr];
//        NSLog(@"加入声网房间成功");
//
//
//
//    }];
//
//    NSLog(@"声网 status %d",status);
//}

//- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
//
////    if(uid == self.roomIDStr.intValue)
////    {
////        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
////        videoCanvas.uid = uid;
////        videoCanvas.view = self.videoContrainerView;
////        videoCanvas.renderMode = AgoraVideoRenderModeHidden;
////
////    //    VideoSession *userSession = [self videoSessionOfUid:uid];
////        [self.agoraKit setupRemoteVideo:videoCanvas];
////    }
//
//
//
//    NSLog(@"用户加入房间 %lu",(unsigned long)uid);
//
//
//}

- (void)setPlayUrlStr:(NSString *)playUrlStr
{
    _playUrlStr = playUrlStr;
}

#pragma -- example code bellow
- (void)clearLog
{
    _tipsMsg = @"";
    _logMsg = @"";
    [_statusView setText:@""];
    [_logViewEvt setText:@""];
    _startTime = [[NSDate date]timeIntervalSince1970]*1000;
    _lastTime = _startTime;
}

- (BOOL)checkPlayUrl:(NSString*)playUrl
{
    if (!([playUrl hasPrefix:@"http:"] || [playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"rtmp:"]))
    {
        [self toastTip:ASLocalizedString(@"播放地址不合法，目前仅支持rtmp,flv,hls,mp4播放方式!")];
        return NO;
    }
    if (self.isLivePlay)
    {
        if ([playUrl hasPrefix:@"rtmp:"])
        {
            _playType = PLAY_TYPE_LIVE_RTMP;
        }
        else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]))
        {
            if([playUrl containsString:@".flv"])
            {
                _playType = PLAY_TYPE_LIVE_FLV;
            }
            else if([playUrl containsString:@".mp4"])
            {
                _playType = PLAY_TYPE_VOD_MP4;
            }
            else if([playUrl containsString:@".m3u8"])
            {
                _playType = PLAY_TYPE_VOD_HLS;
            }
            else
            {
                [self toastTip:ASLocalizedString(@"播放地址不合法，直播目前仅支持flv,hls,mp4播放方式!")];
                return NO;
            }
        }
        else
        {
            [self toastTip:ASLocalizedString(@"播放地址不合法，直播目前仅支持rtmp,flv播放方式!")];
            return NO;
        }
    }
    else
    {
        if ([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"])
        {
            if ([playUrl rangeOfString:@".flv"].length > 0)
            {
                _playType = PLAY_TYPE_VOD_FLV;
            }
            else if ([playUrl rangeOfString:@".m3u8"].length > 0)
            {
                _playType= PLAY_TYPE_VOD_HLS;
            }
            else if ([playUrl rangeOfString:@".mp4"].length > 0)
            {
                _playType= PLAY_TYPE_VOD_MP4;
            }
            else
            {
                [self toastTip:ASLocalizedString(@"播放地址不合法，点播目前仅支持flv,hls,mp4播放方式!")];
                return NO;
            }
        }
        else
        {
            [self toastTip:ASLocalizedString(@"播放地址不合法，点播目前仅支持flv,hls,mp4播放方式!")];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)startRtmp:(NSInteger)create_type
{
    

    
//    [self joinChannel];
    _create_type = create_type;
    
    NSString* playUrl = _playUrlStr;
    if (playUrl.length == 0)
    {
        playUrl = RTMP_URL;
    }
    
    if (![self checkPlayUrl:playUrl])
    {
        return NO;
    }
    
    [self clearLog];
    
    if(_txLivePlayer != nil)
    {
        
        _txLivePlayer.delegate = self;
        [_txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:_videoContrainerView insertIndex:0];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPKViewChange:) name:@"onPKViewChange" object:nil];
        
        //设置播放器缓存策略
        //这里将播放器的策略设置为自动调整，调整的范围设定为1到4s，您也可以通过setCacheTime将播放器策略设置为采用
        //固定缓存时间。如果您什么都不调用，播放器将采用默认的策略（默认策略为自动调整，调整范围为1到4s）
//        [_txLivePlayer setCacheTime:5];
//        [_txLivePlayer setMinCacheTime:1];
//        [_txLivePlayer setMaxCacheTime:4];
        int result = [_txLivePlayer startPlay:playUrl type:_playType];
        NSLog(@"播流地址 %@",playUrl);
        if (result == -1)
        {
            [self toastTip:ASLocalizedString(@"非腾讯云链接，若要放开限制请联系腾讯云商务团队")];
            return NO;
        }
        if( result != 0)
        {
            NSLog(ASLocalizedString(@"播放器启动失败"));
            return NO;
        }
        
        if (_screenPortrait)
        {
            [_txLivePlayer setRenderRotation:HOME_ORIENTATION_RIGHT];
        }
        else
        {
            [_txLivePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        }
        if (_renderFillScreen)
        {
            [_txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        }
        else
        {
            [_txLivePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        }
        
        if (_create_type == 1)
        {
            [_txLivePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        }
        else
        {
            [_txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        }
        
//        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
//        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        
//        [self startLoadingAnimation];
        
        _videoPause = NO;
        [_btnPlay setImage:[UIImage imageNamed:@"fw_relive_suspend"] forState:UIControlStateNormal];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(firstFrame:)])
    {
        [_delegate firstFrame:self];
        _rePlayTime = 0;
    }
        _startPlayTS = [[NSDate date]timeIntervalSince1970]*1000;
    
        return YES;
}

- (void)initRightVideoContainerView{
    if (!_rightVideoContrainerView) {
        _rightVideoContrainerView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW / 2, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3)];
        _rightVideoContrainerView.backgroundColor = kBlackColor;
    }
    [self.view addSubview:_rightVideoContrainerView];
}

- (void)initTXLivePlayerWithUrl:(NSString *)playUrl playType:(NSInteger)playType{
 
    if (!_rightTxLivePlayer) {
        _rightTxLivePlayer = [[TXLivePlayer alloc] init];//初始化
    }
    if (!_rightTxLivePlayConfig) {
        _rightTxLivePlayConfig = [[TXLivePlayConfig alloc]init];
        _rightTxLivePlayConfig.enableAEC = YES;
        _rightTxLivePlayConfig.bAutoAdjustCacheTime = YES;
        _rightTxLivePlayConfig.minAutoAdjustCacheTime = CACHE_TIME_AUTO_MIN;
        _rightTxLivePlayConfig.maxAutoAdjustCacheTime = CACHE_TIME_AUTO_MAX;
    }
    [_rightTxLivePlayer setConfig:_rightTxLivePlayConfig];
    _rightTxLivePlayer.delegate = self; //如果您需要处理播放的事件
    [_rightTxLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:_rightVideoContrainerView insertIndex:0];
    int result = [_rightTxLivePlayer startPlay:[self changeRTMPToFlv:playUrl] type:playType];
    if (result == -1)
    {
        [self toastTip:ASLocalizedString(@"非腾讯云链接，若要放开限制请联系腾讯云商务团队")];
    }
    if( result != 0)
    {
        NSLog(ASLocalizedString(@"播放器启动失败"));
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
    if (!_pkBgView) {
        _pkBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _pkBgView.image = [UIImage imageNamed:@"pk_bg"];
    }
    [self.view addSubview:_pkBgView];
    [self.view sendSubviewToBack:_pkBgView];
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
//    _playType = PLAY_TYPE_LIVE_RTMP_ACC;
    
    if(isFull == 1)
    {
        //模拟动态修改
        _videoContrainerView.frame = self.view.bounds;
        [redBgView removeFromSuperview];
        [blueBgView removeFromSuperview];
        //        [pkBgView removeFromSuperview];
        _rightTxLivePlayer.delegate = nil;
        [_rightTxLivePlayer stopPlay];
        [_rightTxLivePlayer removeVideoWidget];
        _rightTxLivePlayer = nil;
        [_rightVideoContrainerView removeFromSuperview];
        _rightVideoContrainerView = nil;
        float width = 34;
        float height = 34;
        float offsetX = (self.view.frame.size.width - width) / 2;
        float offsetY = (self.view.frame.size.height - height) / 2;
        _loadingImageView.frame = CGRectMake(offsetX, offsetY, width, height);
        [self stopLoadingAnimation];
        [GlobalVariables sharedInstance].isBeingPK = NO;
        
        NSString* playUrl = _playUrlStr;
        
        if([playUrl isEqualToString:[_txLivePlayer valueForKey:@"_playUrl"]])
        {
            int result = [_txLivePlayer startPlay:playUrl type:_playType];
            NSLog(@"播流状态 %d",result);
        }
   
        [self.txLivePlayer stopPlay];
        self.videoContrainerViewAgora.hidden = YES;
        [self.agoraKit enableVideo];
        [self.agoraKit enableAudio];

    }
    
    else if(isFull == 3)
    {
        if(![GlobalVariables sharedInstance].openAgora)
        {
//            _videoContrainerView.frame = CGRectMake(0, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3);
//            //        _videoContrainerView.frame = CGRectMake(0, 0, kScreenW/2, kScreenH/2);
//            [self addPkBgView];
//            [self initRightVideoContainerView];
//            [self initTXLivePlayerWithUrl:playUrl playType:_playType];
//            _loadingImageView.centerX = _rightVideoContrainerView.centerX;
//            _loadingImageView.centerY = _rightVideoContrainerView.centerY;
//
//            [GlobalVariables sharedInstance].isBeingPK = YES;
//
//            _videoContrainerViewAgora.hidden = NO;
//            [_txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:_videoContrainerViewAgora insertIndex:0];
//
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPKViewChange:) name:@"onPKViewChange" object:nil];
//            [_txLivePlayer startPlay:_playUrlStr type:_playType];
                    //设置播放器缓存策略
                    //这里将播放器的策略设置为自动调整，调整的范围设定为1到4s，您也可以通过setCacheTime将播放器策略设置为采用
                    //固定缓存时间。如果您什么都不调用，播放器将采用默认的策略（默认策略为自动调整，调整范围为1到4s）
                    //[_txLivePlayer setCacheTime:5];
                    //[_txLivePlayer setMinCacheTime:1];
                    //[_txLivePlayer setMaxCacheTime:4];
            //        int result = [_txLivePlayer startPlay:playUrl type:_playType];
            
        }
      else
      {
          BogoPkProgressModel *model = [notify.userInfo valueForKey:@"model"];

          NSInteger imUserId = [IMAPlatform sharedInstance].host.imUserId.integerValue;
          NSString *playRtmp = @"";
          if(model.emcee_user_id1.intValue == imUserId)
          {
              playRtmp = model.play_url1;
          }
          else
          {
              playRtmp = model.play_url2;
          }
          
//          [_txLivePlayer startPlay:playRtmp type:_playType];
          
          _videoContrainerView.frame = CGRectMake(0, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3);
//                  _videoContrainerView.frame = CGRectMake(0, 0, kScreenW/2, kScreenH/2);
          [self addPkBgView];
          [self initRightVideoContainerView];
//          [self initTXLivePlayerWithUrl:playUrl playType:_playType];
//            [_txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:_videoContrainerViewAgora insertIndex:0];
          
          //关闭声网音视频
//          [self.agoraKit disableVideo];
//          [self.agoraKit disableAudio];
          _videoContrainerViewAgora.hidden = NO;
          _loadingImageView.centerX = _rightVideoContrainerView.centerX;
          _loadingImageView.centerY = _rightVideoContrainerView.centerY;
          
          [GlobalVariables sharedInstance].isBeingPK = YES;
      }
    }
    else if(isFull == 0)
    {
        //        _videoContrainerView.frame = CGRectMake(kScreenW/2, 0, kScreenW/2, kScreenH/2);
        _videoContrainerView.frame = CGRectMake(0, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3);
        [self addPkBgView];
        [self initRightVideoContainerView];
        [self initTXLivePlayerWithUrl:playUrl playType:_playType];
        _loadingImageView.centerX = _rightVideoContrainerView.centerX;
        _loadingImageView.centerY = _rightVideoContrainerView.centerY;
        
        [GlobalVariables sharedInstance].isBeingPK = YES;
    }
    else if(isFull == 4)
    {
        CGRect leftFrame = CGRectMake(0, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3);
        CGRect rightFrame = CGRectMake(kScreenW / 2, kStatusBarHeight + 53 + 55, kScreenW / 2, kScreenW * 2 / 3);
        if (_videoContrainerView && _rightVideoContrainerView) {
            _videoContrainerView.frame = rightFrame;
            _rightVideoContrainerView.frame = leftFrame;
            _loadingImageView.centerX = _rightVideoContrainerView.centerX;
            _loadingImageView.centerY = _rightVideoContrainerView.centerY;
        }
    }
}

- (void)stopRtmp
{
//    [self.agoraKit leaveChannel:nil];

    [self stopLoadingAnimation];
    if(_txLivePlayer != nil)
    {
        _txLivePlayer.delegate = nil;
        [_txLivePlayer stopPlay];
        [_txLivePlayer removeVideoWidget];
    }
    if (_rightTxLivePlayer != nil) {
        _rightTxLivePlayer.delegate = nil;
        [_rightTxLivePlayer stopPlay];
        [_rightTxLivePlayer removeVideoWidget];
    }
}

- (void)rePlay
{
    if (_delegate && [_delegate respondsToSelector:@selector(playAgain:isHideLeaveTip:)])
    {
        [_delegate playAgain:self isHideLeaveTip:NO];
    }
}

#pragma mark - ----------------------- TXLivePlayListener代理事件 -----------------------
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary*)param;
{
    if (EvtID != PLAY_EVT_PLAY_PROGRESS)
    {
        NSLog(@"==========playEvtID1:%d",EvtID);
    }
    
    NSDictionary* dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(firstFrame:)])
            {
                [_delegate firstFrame:self];
                _rePlayTime = 0;
            }
            [self stopLoadingAnimation];
        }
        else if (EvtID == PLAY_EVT_PLAY_BEGIN)
        {
            [self stopLoadingAnimation];
            long long playDelay = [[NSDate date]timeIntervalSince1970]*1000 - _startPlayTS;
            NSLog(@"AutoMonitor:PlayFirstRender,cost=%lld", playDelay);
        }
        else if (EvtID == PLAY_EVT_PLAY_PROGRESS && !_startSeek)
        {
            // 避免滑动进度条松开的瞬间可能出现滑动条瞬间跳到上一个位置
            long long curTs = [[NSDate date]timeIntervalSince1970]*1000;
            if (llabs(curTs - _trackingTouchTS) < 500) {
                return;
            }
            _trackingTouchTS = curTs;
            
            float progress = [dict[EVT_PLAY_PROGRESS] floatValue];
            int intProgress = progress + 0.5;
            _playStart.text = [[NSString stringWithFormat:@"%02d:%02d", (int)(intProgress / 60), (int)(intProgress % 60)] stringByAppendingString:[NSString stringWithFormat:@"/%@",_playDurationStr]];
            [_playProgress setValue:progress];
            
            float duration = [dict[EVT_PLAY_DURATION] floatValue];
            int intDuration = duration + 0.5;
            if (duration > 0 && _playProgress.maximumValue != duration) {
                [_playProgress setMaximumValue:duration];
                _playDurationStr = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
            }
            return ;
        }
        else if (EvtID == PLAY_ERR_NET_DISCONNECT)
        {
            [self stopRtmp];
            _play_switch = NO;
            [_btnPlay setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
            [_playProgress setValue:0];
            _playStart.text = @"00:00/00:00";
            _videoPause = NO;
            [self performSelector:@selector(rePlay) withObject:nil afterDelay:3];
        }
        else if (EvtID == PLAY_EVT_PLAY_END)
        {
            [_txLivePlayer pause];
            [_btnPlay setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
        }
        else if (EvtID == PLAY_EVT_PLAY_LOADING)
        {
//            [self startLoadingAnimation];
        }
        
        long long time = [(NSNumber*)[dict valueForKey:EVT_TIME] longLongValue];
        int mil = time % 1000;
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
        NSString* Msg = (NSString*)[dict valueForKey:EVT_MSG];
        [self appendLog:Msg time:date mills:mil];
    });
    
    
}

- (void)onNetStatus:(NSDictionary*) param
{
    NSDictionary* dict = param;
    _qualityDict = param;
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        int netspeed  = [(NSNumber*)[dict valueForKey:NET_STATUS_NET_SPEED] intValue];
        int vbitrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_BITRATE] intValue];
        int settrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_SET_VIDEO_BITRATE] intValue];
        
        _kbpsRecvStr = StringFromInt(vbitrate);
        _kbpsSendStr = StringFromInt(settrate);
        
        int abitrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_AUDIO_BITRATE] intValue];
        int cachesize = [(NSNumber*)[dict valueForKey:NET_STATUS_CACHE_SIZE] intValue];
        int dropsize  = [(NSNumber*)[dict valueForKey:NET_STATUS_DROP_SIZE] intValue];
        int jitter    = [(NSNumber*)[dict valueForKey:NET_STATUS_NET_JITTER] intValue];
        int fps       = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_FPS] intValue];
        int width     = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_WIDTH] intValue];
        int height    = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_HEIGHT] intValue];
        float cpu_usage = [(NSNumber*)[dict valueForKey:NET_STATUS_CPU_USAGE] floatValue];
        NSString *serverIP = [dict valueForKey:NET_STATUS_SERVER_IP];
        int codecCacheSize = [(NSNumber*)[dict valueForKey:NET_STATUS_CODEC_CACHE] intValue];
        int nCodecDropCnt = [(NSNumber*)[dict valueForKey:NET_STATUS_CODEC_DROP_CNT] intValue];
        
        NSString* log = [NSString stringWithFormat:@"CPU:%.1f%%\tRES:%d*%d\tSPD:%dkb/s\nJITT:%d\tFPS:%d\tARA:%dkb/s\nQUE:%d|%d\tDRP:%d|%d\tVRA:%dkb/s\nSVR:%@\t",
                         cpu_usage*100,
                         width,
                         height,
                         netspeed,
                         jitter,
                         fps,
                         abitrate,
                         codecCacheSize,
                         cachesize,
                         nCodecDropCnt,
                         dropsize,
                         vbitrate,
                         serverIP];
        [_statusView setText:log];
        
    });
     */
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

#pragma ###TXLivePlayListener
- (void)appendLog:(NSString*) evt time:(NSDate*) date mills:(int)mil
{
    if (evt == nil)
    {
        return;
    }
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"hh:mm:ss";
    NSString* time = [format stringFromDate:date];
    NSString* log = [NSString stringWithFormat:@"[%@.%-3.3d] %@", time, mil, evt];
    if (_logMsg == nil) {
        _logMsg = @"";
    }
    _logMsg = [NSString stringWithFormat:@"%@\n%@", _logMsg, log ];
    [_logViewEvt setText:_logMsg];
}


#pragma mark - ----------------------- 底部按钮事件 -----------------------
#pragma mark 点击播放按钮
- (void)clickPlay:(UIButton *)sender create_type:(NSInteger)create_type
{
    _create_type = create_type;
    
    if (_play_switch == YES)
    {
        if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4)
        {
            if (_videoPause)
            {
                [_txLivePlayer resume];
                [sender setImage:[UIImage imageNamed:@"fw_relive_suspend"] forState:UIControlStateNormal];
            }
            else
            {
                [_txLivePlayer pause];
                [sender setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
            }
            _videoPause = !_videoPause;
        }
        else
        {
            _play_switch = NO;
            [self stopRtmp];
            [sender setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if (![self startRtmp:create_type])
        {
            return;
        }
        
        [sender setImage:[UIImage imageNamed:@"fw_relive_suspend"] forState:UIControlStateNormal];
        _play_switch = YES;
    }
}

#pragma mark 点击日志按钮
- (void)clickLog:(UIButton*) sender
{
//    if (_log_switch == YES)
//    {
//        _statusView.hidden = YES;
//        _logViewEvt.hidden = YES;
//        [sender setImage:[UIImage imageNamed:@"log"] forState:UIControlStateNormal];
//        _cover.hidden = YES;
//        _log_switch = NO;
//    }
//    else
//    {
//        _statusView.hidden = NO;
//        _logViewEvt.hidden = NO;
//        [sender setImage:[UIImage imageNamed:@"log2"] forState:UIControlStateNormal];
//        _cover.hidden = NO;
//        _log_switch = YES;
//    }
////    2019年08月24日
//    sender.hidden = YES;
}

#pragma mark 点击横竖屏按钮
- (void) clickScreenOrientation:(UIButton*) sender
{
    _screenPortrait = !_screenPortrait;
    
    if (_screenPortrait)
    {
        [sender setImage:[UIImage imageNamed:@"landscape"] forState:UIControlStateNormal];
        [_txLivePlayer setRenderRotation:HOME_ORIENTATION_RIGHT];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"portrait"] forState:UIControlStateNormal];
        [_txLivePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
    }
}

#pragma mark 点击填充模式按钮
- (void) clickRenderMode:(UIButton*) sender
{
    _renderFillScreen = !_renderFillScreen;
    
    if (_renderFillScreen) {
        [sender setImage:[UIImage imageNamed:@"adjust"] forState:UIControlStateNormal];
        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
    } else {
        [sender setImage:[UIImage imageNamed:@"fill"] forState:UIControlStateNormal];
        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    }
}

#pragma mark 点击硬件加速按钮
- (void) onClickHardware:(UIButton*)sender
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self toastTip:ASLocalizedString(@"iOS 版本低于8.0，不支持硬件加速.")];
        return;
    }
    
    if (_play_switch == YES)
    {
        [self stopRtmp];
    }
    
    _txLivePlayer.enableHWAcceleration = !_bHWDec;
    
    _bHWDec = _txLivePlayer.enableHWAcceleration;
    
    if(_bHWDec)
    {
        [sender setImage:[UIImage imageNamed:@"quick"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"quick2"] forState:UIControlStateNormal];
    }
    
    if (_play_switch == YES) {
        if (_bHWDec) {
            
            [self toastTip:ASLocalizedString(@"切换为硬解码. 重启播放流程")];
        }
        else
        {
            [self toastTip:ASLocalizedString(@"切换为软解码. 重启播放流程")];
            
        }
        
        [self startRtmp:_create_type];
    }
}

#pragma mark UISlider代理方法
- (void)onSeek:(UISlider *)slider
{
    [_txLivePlayer seek:_sliderValue];
    _trackingTouchTS = [[NSDate date]timeIntervalSince1970]*1000;
    _startSeek = NO;
    NSLog(@"vod seek drag end");
}

- (void)onSeekBegin:(UISlider *)slider
{
    _startSeek = YES;
    NSLog(@"vod seek drag begin");
}

- (void)onDrag:(UISlider *)slider
{
    float progress = slider.value;
    int intProgress = progress + 0.5;
    _playStart.text = [[NSString stringWithFormat:@"%02d:%02d",(int)(intProgress / 60), (int)(intProgress % 60)] stringByAppendingString:[NSString stringWithFormat:@"/%@",_playDurationStr]];
    _sliderValue = slider.value;
}

- (void)dragSliderDidEnd:(UISlider *)slider
{
    _startSeek = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _vCacheStrategy.hidden = YES;
}


#pragma mark - ----------------------- 清晰度设置 -----------------------
- (void) setCacheStrategy:(NSInteger) nCacheStrategy
{
    if (_btnCacheStrategy == nil || _cacheStrategy == nCacheStrategy)    return;
    
    if (_txLivePlayConfig == nil)
    {
        _txLivePlayConfig = [[TXLivePlayConfig alloc] init];
        _txLivePlayConfig.enableAEC = YES;
    }
    
    _cacheStrategy = nCacheStrategy;
    switch (_cacheStrategy) {
        case CACHE_STRATEGY_FAST:
            _txLivePlayConfig.bAutoAdjustCacheTime = YES;
            _txLivePlayConfig.minAutoAdjustCacheTime = CACHE_TIME_FAST;
            _txLivePlayConfig.maxAutoAdjustCacheTime = CACHE_TIME_FAST;
            [_txLivePlayer setConfig:_txLivePlayConfig];
            break;
            
        case CACHE_STRATEGY_SMOOTH:
            _txLivePlayConfig.bAutoAdjustCacheTime = NO;
            _txLivePlayConfig.cacheTime = CACHE_TIME_SMOOTH;
            [_txLivePlayer setConfig:_txLivePlayConfig];
            break;
            
        case CACHE_STRATEGY_AUTO:
            _txLivePlayConfig.bAutoAdjustCacheTime = YES;
            _txLivePlayConfig.minAutoAdjustCacheTime = CACHE_TIME_AUTO_MIN;
            _txLivePlayConfig.maxAutoAdjustCacheTime = CACHE_TIME_AUTO_MAX;
            [_txLivePlayer setConfig:_txLivePlayConfig];
            break;
            
        default:
            break;
    }
}

- (void) onAdjustCacheStrategy:(UIButton*) sender
{
#if TEST_MUTE
    static BOOL flag = YES;
    [_txLivePlayer setMute:flag];
    flag = !flag;
#else
    if (_vCacheStrategy == nil)
    {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        _vCacheStrategy = [[UIControl alloc]init];
        _vCacheStrategy.frame = CGRectMake(0, size.height-120, size.width, 120);
        [_vCacheStrategy setBackgroundColor:[UIColor whiteColor]];
        
        UILabel* title= [[UILabel alloc]init];
        title.frame = CGRectMake(0, 0, size.width, 50);
        [title setText:ASLocalizedString(@"缓存策略")];
        title.textAlignment = NSTextAlignmentCenter;
        [title setFont:[UIFont fontWithName:@"" size:14]];
        
        [_vCacheStrategy addSubview:title];
        
        int gap = 30;
        int width = (size.width - gap*2 - 20) / 3;
        _radioBtnFast = [UIButton buttonWithType:UIButtonTypeCustom];
        _radioBtnFast.frame = CGRectMake(10, 60, width, 40);
        [_radioBtnFast setTitle:ASLocalizedString(@"极速")forState:UIControlStateNormal];
        [_radioBtnFast addTarget:self action:@selector(onAdjustFast:) forControlEvents:UIControlEventTouchUpInside];
        
        _radioBtnSmooth = [UIButton buttonWithType:UIButtonTypeCustom];
        _radioBtnSmooth.frame = CGRectMake(10 + gap + width, 60, width, 40);
        [_radioBtnSmooth setTitle:ASLocalizedString(@"流畅")forState:UIControlStateNormal];
        [_radioBtnSmooth addTarget:self action:@selector(onAdjustSmooth:) forControlEvents:UIControlEventTouchUpInside];
        
        _radioBtnAUTO = [UIButton buttonWithType:UIButtonTypeCustom];
        _radioBtnAUTO.frame = CGRectMake(size.width - 10 - width, 60, width, 40);
        [_radioBtnAUTO setTitle:ASLocalizedString(@"自动")forState:UIControlStateNormal];
        [_radioBtnAUTO addTarget:self action:@selector(onAdjustAuto:) forControlEvents:UIControlEventTouchUpInside];
        
        [_vCacheStrategy addSubview:_radioBtnFast];
        [_vCacheStrategy addSubview:_radioBtnSmooth];
        [_vCacheStrategy addSubview:_radioBtnAUTO];
        
        [self.view addSubview:_vCacheStrategy];
    }
    
    _vCacheStrategy.hidden = NO;
    switch (_cacheStrategy) {
        case CACHE_STRATEGY_FAST:
            [_radioBtnFast setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
            [_radioBtnFast setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_radioBtnSmooth setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
            [_radioBtnSmooth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_radioBtnAUTO setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
            [_radioBtnAUTO setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case CACHE_STRATEGY_SMOOTH:
            [_radioBtnFast setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
            [_radioBtnFast setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_radioBtnSmooth setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
            [_radioBtnSmooth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_radioBtnAUTO setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
            [_radioBtnAUTO setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case CACHE_STRATEGY_AUTO:
            [_radioBtnFast setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
            [_radioBtnFast setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_radioBtnSmooth setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
            [_radioBtnSmooth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_radioBtnAUTO setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
            [_radioBtnAUTO setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
#endif
}

- (void) onAdjustFast:(UIButton*) sender
{
    _vCacheStrategy.hidden = YES;
    [self setCacheStrategy:CACHE_STRATEGY_FAST];
}

- (void) onAdjustSmooth:(UIButton*) sender
{
    _vCacheStrategy.hidden = YES;
    [self setCacheStrategy:CACHE_STRATEGY_SMOOTH];
}

- (void) onAdjustAuto:(UIButton*) sender
{
    _vCacheStrategy.hidden = YES;
    [self setCacheStrategy:CACHE_STRATEGY_AUTO];
}


#pragma mark - ----------------------- 进入前后台 -----------------------
- (void)onAppDidEnterBackGround
{
    if (_play_switch == YES && _appIsInterrupt == NO)
    {
        if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4)
        {
            if (!_videoPause)
            {
                [_txLivePlayer pause];
            }
        }
        _appIsInterrupt = YES;
    }
}

- (void)onAppWillEnterForeground
{
    if (_play_switch == YES && _appIsInterrupt == YES)
    {
        if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4)
        {
            if (!_videoPause)
            {
                [_txLivePlayer resume];
            }
        }
        _appIsInterrupt = NO;
    }
}


#pragma mark - ----------------------- 声音打断监听 -----------------------
- (void)onAudioInterruption:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan)
    {
        if (_play_switch == YES && _appIsInterrupt == NO)
        {
            if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4)
            {
                if (!_videoPause)
                {
                    [_txLivePlayer pause];
                }
            }
            _appIsInterrupt = YES;
        }
    }
    else
    {
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume)
        {
            if (_play_switch == YES && _appIsInterrupt == YES)
            {
                if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4)
                {
                    if (!_videoPause)
                    {
                        [_txLivePlayer resume];
                    }
                }
                _appIsInterrupt = NO;
            }
        }
    }
}


#pragma mark - ----------------------- 自定义Toast -----------------------
/**
 获取指定宽度width的字符串在UITextView上的高度
 
 @param textView 待计算的UITextView
 @param width 限制字符串显示区域的宽度
 @return 返回的高度
 */
- (float)heightForString:(UITextView *)textView andWidth:(float)width
{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)toastTip:(NSString*)toastInfo
{
    NSLog(@"======playtoastInfo:%@",toastInfo);
    
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
//6-19 修改-onPKViewChange
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPKViewChange:) name:@"onPKViewChange" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"onPKViewChange" object:nil];
    
}

#pragma mark - ----------------------- 创建按钮 -----------------------
- (UIButton*)createBottomBtnIndex:(int)index Icon:(NSString*)icon Action:(SEL)action Gap:(int)gap Size:(int)size
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((index+1)*gap + index*size, [[UIScreen mainScreen] bounds].size.height - size - 10, size, size);
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

- (NSString *)changeRTMPToFlv:(NSString *)originalString{
    NSMutableString *mStr = [NSMutableString stringWithString:originalString];
//    [mStr replaceCharactersInRange:NSMakeRange(0, 4) withString:@"http"];
//    [mStr appendString:@".flv"];
    return mStr;
}


@end
