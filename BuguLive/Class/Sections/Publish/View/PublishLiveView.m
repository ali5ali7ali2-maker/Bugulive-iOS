//
//  PublishLiveView.m
//  BuguLive
//
//  Created by xgh on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "PublishLiveView.h"
#import "StartLiveTitleBottomView.h"
#import "BGTLiveBeautyView.h"
#import "JCTagListView.h"



@interface PublishLiveView()<AVCaptureVideoDataOutputSampleBufferDelegate, UITextViewDelegate,FWTLiveBeautyViewDelegate,TXVideoCustomProcessDelegate,UIGestureRecognizerDelegate,BeautySettingPanelDelegate>
{
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_customLayer;//自定义layer展示层
    
}

@property (nonatomic, retain) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *customLayer;


@property (nonatomic, strong) TXLivePush        *pusher;
//@property (nonatomic, strong) TXLivePush        *pusher;
@property (nonatomic, strong) UIView          *preViewContainer;
@property (nonatomic, strong) TXLivePushConfig  *txLivePushonfig;
@property (nonatomic, strong) TXLivePlayer   *txLivePlayer;
@property (nonatomic, strong) TXLivePlayConfig  *txLivePlayConfig;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UIView *buttonLineView;

@property(nonatomic, strong) JCTagListView *tagListView;
@property(nonatomic, strong) UIView *s2;
@end

@implementation PublishLiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.topView = [[PublishLiveTopView alloc]initWithFrame:CGRectMake(0, 10, self.width, 120)];
//        self.topView.delegate = self;
//        //        [self initCapture];
////        [self backGroundImageview];
//        [self addSubview:self.topView];
        
        
        UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, kRealValue(55) + kStatusBarHeight, kScreenW, kScreenH - self.topView.height)];
//        middleView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.15];
        self.middleView = middleView;
    
        [self addSubview:middleView];
        
        UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 10 - kRealValue(35),kStatusBarHeight +  kRealValue(10), kRealValue(35), kRealValue(35))];
        [back setImage:[UIImage imageNamed:@"pl_publishlive_close"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(handleBackEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:back];

        UIView *s1 = [[UIView alloc] initWithFrame:CGRectMake(kRealValue(10), kRealValue(10), self.width-kRealValue(20), kRealValue(120))];
        [middleView addSubview:s1];
        ViewRadius(s1, kRealValue(5));
        
        s1.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.15];

        self.selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(10), kRealValue(10), kRealValue(100), kRealValue(100))];
        ViewRadius(self.selectedImageView, kRealValue(5));
//        self.selectedImageView.centerX = kScreenW / 2;
        self.selectedImageView.image = [UIImage imageNamed:@"pl_publishlive_cover"];
        [s1 addSubview:self.selectedImageView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.selectedImageView.bounds;
        [button addTarget:self action:@selector(selectedImageViewAction:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedImageView.userInteractionEnabled = YES;
        [self.selectedImageView addSubview:button];
        
        
        //直播分类
        
        self.s2 = [[UIView alloc] initWithFrame:CGRectMake(s1.left, s1.bottom + kRealValue(10), self.width-kRealValue(20), kRealValue(120))];
        [middleView addSubview:self.s2];
        ViewRadius(self.s2, kRealValue(5));
        
        self.s2.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.15];
        
        UILabel *labRoomTag = [[UILabel alloc] initWithFrame:CGRectMake(kRealValue(15), kRealValue(20.5), 100, kRealValue(16))];
        labRoomTag.text  = ASLocalizedString(@"直播分类");
        labRoomTag.font = [UIFont systemFontOfSize:15];
        labRoomTag.textColor = kWhiteColor;
        [self.s2 addSubview:labRoomTag];
        
        self.tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(kRealValue(20), kRealValue(40), self.width - kRealValue(20), 100)];
        [self.s2 addSubview:self.tagListView];
        
        self.tagListView.supportSelected = YES;
        self.tagListView.supportMultipleSelected = NO;
        self.tagListView.tagSelectedBackgroundColor = [UIColor colorWithHexString:@"#AE2CF1"];
        self.tagListView.tagBackgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.2];
        
        self.tagListView.tagSelectedTextColor = [UIColor qmui_colorWithHexString:@"#FFFFFF"];
        self.tagListView.tagTextColor = kWhiteColor;
        self.tagListView.tagCornerRadius = kRealValue(4);
        self.tagListView.tagSelectedBorderColor = kClearColor;
        self.tagListView.tagBorderColor = kClearColor;
        
        NSMutableArray *video_classified = [NSMutableArray array];
        for (int i = 0; i < self.BuguLive.appModel.video_classified.count; i++)
        {
            VideoClassifiedModel * model = self.BuguLive.appModel.video_classified[i];
            [video_classified addObject:model.title];
         
        }
        
        self.tagListView.tags = video_classified;
        
        self.cid = [NSString stringWithFormat:@"%ld",(long)((VideoClassifiedModel *)self.BuguLive.appModel.video_classified.firstObject).classified_id];

        self.tagListView.selectedTags = @[video_classified.firstObject];
        
        [self.tagListView didSelectItem:^(NSInteger index) {
            VideoClassifiedModel * model = self.BuguLive.appModel.video_classified[index];

            self.cid = [NSString stringWithFormat:@"%ld",(long)model.classified_id];
            NSLog(@"%@", @(index));
        }];
        
        [self.tagListView reloadData];
        self.tagListView.height = self.tagListView.contentHeight;
        self.s2.height = CGRectGetMaxY(self.tagListView.frame) + kRealValue(10);
        if(self.s2.height < kRealValue(173))
        {
            self.s2.height = kRealValue(173);
        }
//        StartLiveTitleBottomView *livebottom = [StartLiveTitleBottomView getView];
//        [self addSubview:livebottom];
//        livebottom.hidden = YES;
//        [livebottom mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(s1);
//            make.right.equalTo(s1);
//            make.top.equalTo(s1.mas_bottom);
//            make.height.equalTo(@kRealValue(75));
//        }];
        self.textView =[[QMUITextView alloc] initWithFrame:CGRectMake(self.selectedImageView.right + kRealValue(10.5), self.selectedImageView.top, self.width - self.selectedImageView.width - kRealValue(40),self.selectedImageView.height)];
        self.textView.backgroundColor =[UIColor clearColor];
        self.textView.keyboardType =UIKeyboardTypeDefault;
        self.textView.layoutManager.allowsNonContiguousLayout =NO;
        self.textView.textAlignment =NSTextAlignmentLeft;
        self.textView.textColor = RGBA(255, 255, 255, 1);
        self.textView.placeholderColor = RGBA(255, 255, 255, 1);
        self.textView.placeholder = ASLocalizedString(@"请输入直播标题");
        self.textView.font =[UIFont systemFontOfSize:15];
//        self.textView.text = ASLocalizedString(@"请输入直播标题");
    
//        self.textView.qmui_borderPosition = QMUIViewBorderPositionBottom;
//        self.textView.qmui_borderWidth = kRealValue(0.5);
//        self.textView.qmui_borderColor = RGBA(255, 255, 255, 0.4);
//        self.textView.hidden = YES;
        
        self.textView.delegate = self;
        self.autoresizingMask =UIViewAutoresizingFlexibleHeight;
        [s1 addSubview:self.textView];
        
        
        self.beautyBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [self.beautyBtn setImage:[UIImage imageNamed:@"ic_live_beauty"] forState:UIControlStateNormal];
        [self.beautyBtn setTitle:ASLocalizedString(@"美颜")forState:UIControlStateNormal];
        [self.beautyBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.beautyBtn.imagePosition = QMUIButtonImagePositionTop;
        self.beautyBtn.spacingBetweenImageAndTitle = 2;
        self.beautyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.beautyBtn.frame = CGRectMake(kRealValue(40) , self.height - kRealValue(120), kRealValue(40), kRealValue(50));
        [self.beautyBtn addTarget:self action:@selector(clickBeauty:) forControlEvents:UIControlEventTouchUpInside];
        
        

        
        NSString* key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;
//        self.beautyBtn.hidden = [BGUtils isBlankString:key];
        [self addSubview:self.beautyBtn];
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.beautyBtn.hidden = YES;
        self.startButton.frame = CGRectMake(SCREEN_WIDTH/2 - kRealValue(260)/2, self.height - 200, kRealValue(260), kRealValue(45));

        

//        self.startButton.centerY = self.beautyBtn.centerY;
//        self.startButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self.startButton addTarget:self action:@selector(startbuttonAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.startButton setTitle:ASLocalizedString(@"开始直播")forState:UIControlStateNormal];
//        [self.startButton setBackgroundImage:[UIImage imageWithColor:[UIColor qmui_colorWithHexString:@"#FF1979"]] forState:UIControlStateNormal];
//        [self.startButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
//        self.startButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        self.startButton.layer.masksToBounds = YES;
//        self.startButton.layer.cornerRadius = kRealValue(22.5);
//        [self addSubview:self.startButton];
        
        
        self.startButton.frame = CGRectMake(10, self.height - 200, SCREEN_WIDTH - 20, kRealValue(44));

//        self.startButton.centerY = self.beautyBtn.centerY;
        self.startButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.startButton addTarget:self action:@selector(startbuttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.startButton setTitle:ASLocalizedString(@"Go live")forState:UIControlStateNormal];
        [self.startButton setBackgroundImage:[UIImage imageWithColor:[UIColor qmui_colorWithHexString:@"#AE2CF1"]] forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.startButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.startButton.layer.masksToBounds = YES;
        self.startButton.layer.cornerRadius = kRealValue(22.5);
        [self addSubview:self.startButton];
        
        
        [self.beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.startButton.mas_top).offset(kRealValue(-15));
            make.centerX.equalTo(self.startButton);
        }];
        
        [self setUpBeautyView];
        [self setTxPreview];
        [self resetViewWithTitleTop:kRealValue(120)];
        
        
        _liveBtn = [[QMUIButton alloc] init];
        _liveBtn.spacingBetweenImageAndTitle = kRealValue(5);

//        [_liveBtn setImage:[UIImage imageNamed:@"habibi_live2"] forState:UIControlStateNormal];
        [_liveBtn setTitle:@"Live" forState:UIControlStateNormal];
        _liveBtn.imagePosition = QMUIButtonImagePositionTop;
        _liveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_liveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self addSubview:_liveBtn];
        
        [_liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startButton.mas_bottom).offset(kRealValue(20));
            make.height.equalTo(@(33+10));
            make.width.equalTo(@(80));
            make.centerX.equalTo(self.startButton).offset(-kRealValue(50));
        }];
        
        _voiceBtn = [[QMUIButton alloc] init];
        _voiceBtn.spacingBetweenImageAndTitle = kRealValue(5);
        
        _voiceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_voiceBtn setImage:[UIImage imageNamed:@"chatparty222"] forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"Voice room" forState:UIControlStateNormal];
        _voiceBtn.imagePosition = QMUIButtonImagePositionTop;
        [_voiceBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self addSubview:_voiceBtn];
        
        [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startButton.mas_bottom).offset(kRealValue(20));
            make.height.equalTo(@(33+10));
            make.width.equalTo(@(120));
            make.centerX.equalTo(self.startButton).offset(kRealValue(50));
        }];
        

        [self setNeedsLayout];
        [self layoutIfNeeded];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubview:self.lineView];
        });
        
        
        
        if (0) {
            [self addSubview:self.videoPushBtn];
            [self addSubview:self.otherPushBtn];
            [self addSubview:self.lineView];
        }
        
//        _liveBtn = [[QMUIButton alloc] init];
//        _liveBtn.spacingBetweenImageAndTitle = kRealValue(5);
//
//        [_liveBtn setImage:[UIImage imageNamed:@"habibi_start_live"] forState:UIControlStateNormal];
//        [_liveBtn setTitle:@"Live" forState:UIControlStateNormal];
//        _liveBtn.imagePosition = QMUIButtonImagePositionTop;
//        _liveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_liveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [self addSubview:_liveBtn];
//
//        [_liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.startButton.mas_bottom).offset(kRealValue(20));
//            make.height.equalTo(@(33+20));
//            make.width.equalTo(@(80));
//            make.centerX.equalTo(self.startButton).offset(-kRealValue(50));
//        }];
//
//        _voiceBtn = [[QMUIButton alloc] init];
//        _voiceBtn.spacingBetweenImageAndTitle = kRealValue(5);
//
//        _voiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_voiceBtn setImage:[UIImage imageNamed:@"chatparty"] forState:UIControlStateNormal];
//        [_voiceBtn setTitle:@"Chat party" forState:UIControlStateNormal];
//        _voiceBtn.imagePosition = QMUIButtonImagePositionTop;
//        [_voiceBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [self addSubview:_voiceBtn];
//
//        [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.startButton.mas_bottom).offset(kRealValue(20));
//            make.height.equalTo(@(33+20));
//            make.width.equalTo(@(80));
//            make.centerX.equalTo(self.startButton).offset(kRealValue(50));
//        }];
//
//        if (1) {
//            [self addSubview:self.videoPushBtn];
//            [self addSubview:self.otherPushBtn];
//            [self addSubview:self.lineView];
//        }
        
    }
    return self;
}


- (void)handleBackEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeThestartLiveViewDelegate)]) {
        [self.delegate closeThestartLiveViewDelegate];
    }
}

-(void)resetViewWithTitleTop:(CGFloat)top{
    
    top = kRealValue(55) + kStatusBarHeight;
    
    self.middleView.top = top;
//    self.selectedImageView.top = top;
    self.titleL.top = self.selectedImageView.bottom + kRealValue(15);
}

-(void)setUpBeautyView{

//    ///////////// TiSDK 添加 开始 ////////////
//    self.tiSDKManager = [[TiSDKManager alloc]init];
    NSString* key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;

//    NSString* key = @"";
    
    //隐藏美颜
    /*
    [TiSDK init:key CallBack:^(InitStatus initStatus) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TiSDKInitStatusNotification" object:nil];
    }];
//    [TiSDKManager shareManager]

    //    [[TiUIManager shareManager] loadToSuperview:self.view];
    [TiUIManager shareManager].showsDefaultUI = YES;
    [[TiUIManager shareManager]loadToWindowDelegate:nil];
     
     */
}

-(void)setTxPreview{

    [self setBackgroundColor:kBlackColor];
    
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
    _pusher = [[TXLivePush alloc] initWithConfig:_txLivePushonfig];
    
    // 设置日志级别
    [TXLiveBase setLogLevel:LOGLEVEL_NULL];
    // 初始化视频父视图
    _preViewContainer = [[UIView alloc] initWithFrame:self.bounds];
    [self insertSubview:_preViewContainer atIndex:0];
    _preViewContainer.center = self.center;
    [[BGHUDHelper sharedInstance] syncLoading];
    [_pusher startPreview:_preViewContainer];
    _pusher.videoProcessDelegate = self;
    [[BGHUDHelper sharedInstance] syncStopLoading];
    
//    UITapGestureRecognizer *tapBgView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBgView:)];
//    tapBgView.delegate = self;
//    [_preViewContainer addGestureRecognizer:tapBgView];
//    [self addGestureRecognizer:tapBgView];
    
}

-(void)stopPush
{
    [_pusher stopPreview];
}

#pragma mark ---------美颜增加-------------
//隐藏美颜
//- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height{
//    return [[TiSDKManager shareManager] renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:_pusher.config.frontCamera];
//}

-(void)clickBgView:(UITapGestureRecognizer *)sender{
    [self.textView resignFirstResponder];
    _beautyPanel.hidden = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    [self.textView resignFirstResponder];
    return YES;
}

- (void)selectedTheClassirmAction
{
    //选择分类
}

- (void)startbuttonAction
{
    if (self.otherPushBtn.isSelected) {
        [_pusher stopPreview];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(startThePublishLiveDelegate)]) {
        [self.delegate startThePublishLiveDelegate];
    }
}

-(void)clickPasswordActionDelegate:(BOOL)password{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPasswordActionDelegate:)]) {
        [self.delegate clickPasswordActionDelegate:password];
    }
}

-(void)clickShopActionDelegate:(BOOL)shop{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShopActionDelegate:)]) {
        [self.delegate clickShopActionDelegate:shop];
    }
}

- (void)closeThePublishLive:(PublishLiveTopView *)topView
{
    //关闭开始直播界面
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeThestartLiveViewDelegate)]) {
        [self.delegate closeThestartLiveViewDelegate];
    }
}

- (void)ispracychangeActionDelegate:(BOOL)ispraicy
{
    self.shareView.hidden = ispraicy;
}

- (UIImageView *)backGroundImageview {
    if (_backGroundImageview == nil) {
        _backGroundImageview = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_backGroundImageview];
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
        view.frame = _backGroundImageview.bounds;
        [_backGroundImageview addSubview:view];
        [_backGroundImageview sd_setImageWithURL:[NSURL URLWithString:[[IMAPlatform sharedInstance].host imUserIconUrl]]];
    }
    return _backGroundImageview;
}

/**
 初始化摄像头
 */
- (void) initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == AVCaptureDevicePositionFront) {
            [self.captureSession beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.captureSession.inputs) {
                [self.captureSession removeInput:oldInput];
            }
            [self.captureSession addInput:input];
            [self.captureSession commitConfiguration];
            break;
        }
    }
    
    [self.captureSession startRunning];
    self.customLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];;
    CGRect frame = self.bounds;
    
    self.customLayer.frame = frame;
    
    self.customLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.customLayer];
    
}

- (void)selectedImageViewAction:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectedTheImageDelegate)]) {
        [self.delegate selectedTheImageDelegate];
    }
}

-(void)clickBeauty:(UIButton *)sender{

    [[TiUIManager shareManager]showMainMenuView];
}


#pragma mark - BeautySettingPanelDelegate

- (void)onSetBeautyStyle:(NSUInteger)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel {
    [_pusher setBeautyStyle:beautyStyle beautyLevel:beautyLevel whitenessLevel:whitenessLevel ruddinessLevel:ruddinessLevel];
}

- (void)onSetMixLevel:(float)mixLevel {
    [_pusher setSpecialRatio:mixLevel / 10.0];
}

- (void)onSetEyeScaleLevel:(float)eyeScaleLevel {
    [_pusher setEyeScaleLevel:eyeScaleLevel];
}

- (void)onSetFaceScaleLevel:(float)faceScaleLevel {
    [_pusher setFaceScaleLevel:faceScaleLevel];
}

- (void)onSetFaceBeautyLevel:(float)beautyLevel {
}

- (void)onSetFaceVLevel:(float)vLevel {
    [_pusher setFaceVLevel:vLevel];
}

- (void)onSetChinLevel:(float)chinLevel {
    [_pusher setChinLevel:chinLevel];
}

- (void)onSetFaceShortLevel:(float)shortLevel {
    [_pusher setFaceShortLevel:shortLevel];
}

- (void)onSetNoseSlimLevel:(float)slimLevel {
    [_pusher setNoseSlimLevel:slimLevel];
}

- (void)onSetFilter:(UIImage*)filterImage {
    [_pusher setFilter:filterImage];
}

- (void)onSetGreenScreenFile:(NSURL *)file {
    [_pusher setGreenScreenFile:file];
}

- (void)onSelectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir {
    [_pusher selectMotionTmpl:tmplName inDir:tmplDir];
}


- (void)classifyButtonActionDelegate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedTheClassifyDelegate)]) {
        [self.delegate selectedTheClassifyDelegate];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:ASLocalizedString(@"#添加标题上热门更轻松")]) {
        self.textView.text = @"";
        [self resetViewWithTitleTop:kRealValue(50)];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = ASLocalizedString(@"#添加标题上热门更轻松");
    }

    [self resetViewWithTitleTop:kRealValue(120)];
    return YES;
}

- (UIButton *)videoPushBtn{
    if (!_videoPushBtn){
        _videoPushBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.startButton.bottom + 10, (self.width - 40 ) / 2, 35)];
        [_videoPushBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _videoPushBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_videoPushBtn setTitleColor:[kWhiteColor colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_videoPushBtn setTitle:ASLocalizedString(@"视频直播") forState:UIControlStateNormal];
        [_videoPushBtn addTarget:self action:@selector(videoPushBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _videoPushBtn.selected = YES;
        _videoPushBtn.hidden = YES;

    }
    return _videoPushBtn;
}

- (UIButton *)otherPushBtn{
    if (!_otherPushBtn){
        _otherPushBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width / 2, self.startButton.bottom + 10, (self.width - 40 ) / 2, 35)];
        _otherPushBtn.hidden = YES;

        [_otherPushBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _otherPushBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_otherPushBtn setTitleColor:[kWhiteColor colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_otherPushBtn setTitle:ASLocalizedString(@"外设直播") forState:UIControlStateNormal];
        [_otherPushBtn addTarget:self action:@selector(otherPushBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherPushBtn;
}

- (void)videoPushBtnAction:(UIButton *)sender{
    [self.pusher startPreview:_preViewContainer];
    sender.selected = YES;
    self.otherPushBtn.selected = NO;
    self.lineView.centerX = sender.centerX;
    self.beautyBtn.hidden = NO;
    self.startButton.frame = CGRectMake(self.beautyBtn.right + kRealValue(25), self.height - 120, kRealValue(220), kRealValue(45));
    [self.startButton setTitle:ASLocalizedString(@"开始直播") forState:UIControlStateNormal];
}

- (void)otherPushBtnAction:(UIButton *)sender{
    [self.pusher stopPreview];
    sender.selected = YES;
    self.videoPushBtn.selected = NO;
    self.lineView.centerX = sender.centerX;
    self.beautyBtn.hidden = YES;
    self.startButton.frame = CGRectMake(kRealValue(50), self.height - 120, kScreenW - kRealValue(100), kRealValue(45));
    [self.startButton setTitle:ASLocalizedString(@"创建外设直播") forState:UIControlStateNormal];
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 4)];
        _lineView.backgroundColor = kWhiteColor;
        _lineView.layer.cornerRadius = 2;
        _lineView.clipsToBounds = YES;
        _lineView.top = self.liveBtn.bottom;
        _lineView.centerX = self.liveBtn.centerX;
    }
    return _lineView;
}

//// 创建推流器，并使用本地配置初始化它
//- (TXLivePush *)createPusher {
//    // config初始化
//    TXLivePushConfig *config = [[TXLivePushConfig alloc] init];
//    config.pauseFps = 10;
//    config.pauseTime = 300;
//    config.pauseImg = [UIImage imageNamed:@"pause_publish"];
////    config.touchFocus = [PushMoreSettingViewController isEnableTouchFocus];
////    config.enableZoom = [PushMoreSettingViewController isEnableVideoZoom];
////    config.enableAudioPreview = [PushSettingViewController getEnableAudioPreview];
////    config.frontCamera = _btnCamera.tag == 0 ? YES : NO;
//    if ([PushMoreSettingViewController isEnableWaterMark]) {
//        config.watermark = [UIImage imageNamed:@"watermark"];
//        config.watermarkPos = CGPointMake(10, 10);
//    }
//
//    // 推流器初始化
//    TXLivePush *pusher = [[TXLivePush alloc] initWithConfig:config];
////    [pusher setReverbType:[PushSettingViewController getReverbType]];
////    [pusher setVoiceChangerType:[PushSettingViewController getVoiceChangerType]];
////    [pusher toggleTorch:[PushMoreSettingViewController isOpenTorch]];
////    [pusher setMirror:[PushMoreSettingViewController isMirrorVideo]];
////    [pusher setMute:[PushMoreSettingViewController isMuteAudio]];
////    [pusher setVideoQuality:[PushSettingViewController getVideoQuality] adjustBitrate:[PushSettingViewController getBandWidthAdjust] adjustResolution:NO];
//    
//    // 修改软硬编需要在setVideoQuality之后设置config.enableHWAcceleration
//    config.enableHWAcceleration = [PushSettingViewController getEnableHWAcceleration];
//    
//    // 横屏推流需要先设置config.homeOrientation = HOME_ORIENTATION_RIGHT，然后再[pusher setRenderRotation:90]
//    config.homeOrientation = ([PushMoreSettingViewController isHorizontalPush] ? HOME_ORIENTATION_RIGHT : HOME_ORIENTATION_DOWN);
//    if ([PushMoreSettingViewController isHorizontalPush]) {
//        [pusher setRenderRotation:90];
//    } else {
//        [pusher setRenderRotation:0];
//    }
//    
//    [pusher setLogViewMargin:UIEdgeInsetsMake(120, 10, 60, 10)];
//    [pusher showVideoDebugLog:[PushMoreSettingViewController isShowDebugLog]];
//    [pusher setEnableClockOverlay:[PushMoreSettingViewController isEnableDelayCheck]];
//    
//    [pusher setVideoProcessDelegate:self];
//    
//    [pusher setConfig:config];
//    
//    return pusher;
//}

//lineView 懒加载
- (UIView *)buttonLineView{
    if (!_buttonLineView) {
        _buttonLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 4)];
        _buttonLineView.backgroundColor = kWhiteColor;
        _buttonLineView.layer.cornerRadius = 1.5;
        _buttonLineView.clipsToBounds = YES;
//        _buttonLineView.top = self.videoPushBtn.bottom - 4;
        _buttonLineView.centerX = self.videoPushBtn.centerX;
        _buttonLineView.top = self.videoPushBtn.bottom + 4;
    }
    return _buttonLineView;
}


@end
