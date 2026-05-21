//
//  BGTPublishController.h
//  BuguLive
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//  腾讯云直播的主播控制类

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <TXLiteAVSDK_Professional/TXLivePush.h>

#import "UserView.h"
//声网dev
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "TLiveMickListModel.h"

@class BGTPublishController;

@protocol FWTPublishControllerDelegate <NSObject>
@required

// 首帧回调
- (void)firstIFrame:(BGTPublishController*)publishVC;

// 网络断连,且经多次重连抢救无效后退出app
- (void)exitPublishAndApp:(BGTPublishController*)publishVC;

@end

@interface BGTPublishController : UIViewController
{
    BOOL            _appIsInterrupt;
    UIView          *_preViewContainer;
    UIView          *_rightVideoContrainerView;   // 放置右视频的view
    
    BOOL            _hardware_switch;
    int             _whitening_level;
    
    unsigned long long  _startTime;
    unsigned long long  _lastTime;
    
    NSString        *_testPath;
    BOOL            _isPreviewing;
    
    NSInteger       _rePublishTime;
    
    UIView *blueBgView;
    UIView *redBgView;
    UIImageView *pkBgView;
    UIImageView             *_loadingImageView;
}

@property (nonatomic, weak) id<FWTPublishControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableSet          *linkMemeberSet;    // 连麦观众列表

@property (nonatomic, strong) TXLivePush        *txLivePublisher;
@property (nonatomic, strong) TXLivePushConfig  *txLivePushonfig;
@property (nonatomic, strong)TXLivePlayer   *txLivePlayer;
@property (nonatomic, strong) TXLivePlayConfig  *txLivePlayConfig;


//声网dev
// 定义 agoraKit 变量
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property(nonatomic, strong) NSString *agora_token;
- (void)adjustPlayItemAgora:(TLiveMickListModel *)mickListModel;


@property (nonatomic, copy) NSString        *pushUrlStr;        // 推流地址

@property (nonatomic, copy) NSString        *kbpsSendStr;       // 发送码率
@property (nonatomic, copy) NSString        *kbpsRecvStr;       // 接收码率
@property (nonatomic, strong) NSDictionary  *qualityDict;       // 直播质量相关参数
@property (nonatomic, copy) NSString                *roomIDStr;         // 房间ID
// 开始推流
- (BOOL)startRtmp;
// 停止推流
- (void)stopRtmp;
// 前置后置摄像头切换
- (void)clickCamera:(UIButton*) btn;
// 开、关闪光灯
- (void)clickTorch:(BOOL) isOpen;

- (void)toastTip:(NSString*)toastInfo;

// 结束直播
- (void)endLive;
- (void)adjustPlayItemVoiceUserList:(NSArray *)userlist;
-(void)updateLianMaiCoin;
- (void)clickCloseBtn:(UserView *)view;
@end
