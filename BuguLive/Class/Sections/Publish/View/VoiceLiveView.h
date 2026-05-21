//
//  PublishLiveView.h
//  BuguLive
//
//  Created by xgh on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseView.h"
#import "PublishLiveTopView.h"
#import "PublishLiveShareView.h"
#import "PublishLiveView.h"
///////////////////// TiFaceSDK 添加 开始 ///////////////////
//#import "TiSDKInterface.h"
//#import "TiUIView.h"
///////////////////// TiFaceSDK 添加 结束 ///////////////////

//todo --- tillusory start ---
#import "TiSDKInterface.h" // TiSDK接口头文件
#import "TiUIManager.h" // TiSDK开源UI接口文件
//todo --- tillusory end ---


#import "BeautySettingPanel.h"
#import "VoiceLiveTopView.h"
//#import "PushSettingViewController.h"
//#import "PushMoreSettingViewController.h"


//@protocol publishViewDelegate <NSObject>
//- (void)selectedTheImageDelegate;
//
//- (void)closeThestartLiveViewDelegate;
//
//- (void)startThePublishLiveDelegate;
//
//- (void)selectedTheClassifyDelegate;
//
//- (void)selectedTheBeautyDelegate;
//
//
//- (void)clickPasswordActionDelegate:(BOOL)password;
//
//- (void)clickShopActionDelegate:(BOOL)shop;
//
//@end





@interface VoiceLiveView : UIScrollView<PublishLiveTopDelegate,BeautySettingPanelDelegate,BeautyLoadPituDelegate>{
    BeautySettingPanel            *_beautyPanel;    // 美颜控件
//    PushMoreSettingViewController *_moreSettingVC;  // 更多设置
//    PushBgmControl                *_bgmControl;     // BGM控制面板
//    PushLogView                   *_logView;        // 显示app日志
}

@property (nonatomic, strong)VoiceLiveTopView *topView;
@property(nonatomic, strong) UIView *middleView;
@property (nonatomic, strong)QMUITextView *textView;
@property (nonatomic, strong) UIImageView *backGroundImageview;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, weak) id<publishViewDelegate>delegate;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, weak)PublishLiveShareView *shareView;

@property(nonatomic, strong) QMUIButton *beautyBtn;


///////////// TiSDK 添加 开始 /////////////
@property(nonatomic, strong) TiSDKManager *tiSDKManager;
//@property(nonatomic, strong) TiUIView *tiUIView;
///////////// TiSDK 添加 结束 /////////////

@property(nonatomic, strong) UIButton *videoPushBtn;
@property(nonatomic, strong) UIButton *otherPushBtn;
@property(nonatomic, strong) NSString *cid;
@property(nonatomic, strong) NSString *people_count;


@property(nonatomic, strong) QMUIButton *liveBtn;
@property(nonatomic, strong) QMUIButton *voiceBtn;

@end
