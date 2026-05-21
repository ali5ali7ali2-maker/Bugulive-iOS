//
//  BGTVoiceController.h
//  BuguLive
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//  腾讯云直播，只处理与SDK有关的业务

#import "STSuspensionWindow.h"
#import "BGLiveServiceController.h"
#import "BGTLiveBeautyView.h"
#import "WMDragView.h"

#import "BuguLive-Swift.h"

#import "LivingModel.h"
#import "RoomMicUserListView.h"

@interface BGVoiceController : BGLiveBaseController<FWLiveControllerAble,FWLiveServiceControllerDelegate,ToolsViewDelegate,TCShowLiveTopViewToSDKDelegate,FWTPlayControllerDelegate,FWTPublishControllerDelegate,livePayDelegate,FWTLinkMicPlayControllerDelegate,FWTLinkMicPublishControllerDelegate,FWTLiveBeautyViewDelegate,TCShowLiveViewForSDKDelegate,STSuspensionWindowDelegate,UIGestureRecognizerDelegate>
{

@private
    UISlider            *_playProgress;
    UILabel             *_playStart;
    UIButton            *_btnPlay;

    NSInteger           _micMaxNum;

    MMAlertView         *_applyMickingAlert;
    MMAlertView         *_hostMickingAlert;

    BGTLiveBeautyView   *_beautyView;
    ToolsView           *_toolsView;

    BOOL                _isMickAudiencePushing;
    BOOL                _isMuted;
}

@property (nonatomic, strong) UIView                            *reLiveProgressView;
@property (nonatomic, strong) BGLiveServiceController           *liveServiceController;
@property (nonatomic, strong) BGTLinkMicPublishController       *publishController;
@property (nonatomic, strong) BGTLinkMicPlayController          *linkMicPlayController;
@property (nonatomic, strong) BGTLinkMicPlayController          *linkSecondMicPlayController;

@property (nonatomic, strong) UIImageView                       *firstImgView;
@property (nonatomic, strong) UIImageView                       *secondImgView;
@property (nonatomic, strong) UIImageView                       *thirdImgView;
@property (nonatomic, strong) UIViewController                  *currentVC;
@property (nonatomic, strong) BGTPlayController                 *playController;
@property (nonatomic, assign) BOOL                              isApplyMicking;
@property (nonatomic, assign) BOOL                              isResponseMicking;
@property (nonatomic, strong) UIButton                          *backVerticalBtn;
@property (nonatomic, copy)   NSString                          *agora_token;
@property (nonatomic, strong) UIScrollView                      *liveScrollView;
@property (nonatomic, assign) NSInteger                         now_LiveIndex;
@property (nonatomic, strong) LivingModel                       *nowModel;
@property (nonatomic, strong) WMDragView                        *hoverView;
@property (nonatomic, assign) CGPoint                           startPoint;
@property (nonatomic, strong) UIPanGestureRecognizer            *panGestureRecognizer;
@property (nonatomic, assign) CGFloat                           previousScale;
@property (nonatomic, assign) BOOL                              mg_isHost;
@property (nonatomic, strong) UIImageView                       *voiceBackgroundImage;

- (void)startLiveRtmp:(NSString *)playUrlStr;
- (void)stopLiveRtmp;
- (NSString *)getLiveQuality;
- (UIView *)getPlayViewBottomView;
- (void)setSDKMute:(BOOL)bEnable;

@end