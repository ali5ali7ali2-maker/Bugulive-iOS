//
//  HMRecomendViewController.m
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//

#import "HMVideoPlayerViewController.h"
#import "SmallVideoListModel.h"
#import "RechargeView.h"
#import "BogoRechargePopView.h"

@interface HMVideoPlayerViewController ()<UIGestureRecognizerDelegate,HMVideoViewDelegate,RechargeViewDelegate>

@property (nonatomic, strong) SmallVideoListModel    *model;
@property (nonatomic, strong) NSArray           *videos;
@property (nonatomic, assign) NSInteger         playIndex;
@property (nonatomic, assign) BOOL isPushed;
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UIButton *moreBtn;
@property(nonatomic, strong) RechargeView *rechargeView;
@property(nonatomic, strong) BogoRechargePopView *rechargePopView;


@end

@implementation HMVideoPlayerViewController

- (instancetype)initWithVideoModel:(SmallVideoListModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index IsPushed:(BOOL)isPushed requestDict:(nonnull NSDictionary *)dict{
    if (self = [super init]) {
        self.videos = videos;
        self.playIndex = index;
        self.isPushed = isPushed;
        self.dict = dict;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (self.isPushed) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    }
    
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    
    
    if (self.videoView.player) {
        [self.videoView.player resumePlay];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.isViewAppear = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}

- (void)setIsViewAppear:(BOOL)isViewAppear{
    _isViewAppear = isViewAppear;
    if (isViewAppear) {
        if (self.videoView.player) {
            [self.videoView.player resumePlay];
        }
    }else{
        if (self.videoView.player) {
            [self.videoView.player pausePlay];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.videoView.player) {
        [self.videoView.player pausePlay];
    }
    self.isViewAppear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBlackColor;
    [self.view addSubview:self.videoView];
    self.videoView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.videoView.backgroundColor = kClearColor;
    self.videoView.delegate = self;
    if (self.videos.count) {
        [self.videoView setModels:self.videos index:self.playIndex];
    }else{
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"svideo" forKey:@"ctl"];
        
        [parmDict setObject:@"recommit_list" forKey:@"act"];
//        [parmDict setObject:@"video" forKey:@"act"];
        
        [parmDict setObject:[NSNumber numberWithInt:1] forKey:@"page"];
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                NSArray *list = responseJson[@"data"];
                NSMutableArray *tempArray = [NSMutableArray array];
                for ( NSDictionary *dict in list)
                {
                    SmallVideoListModel *model = [SmallVideoListModel mj_objectWithKeyValues:dict];
                    [tempArray addObject:model];
                }
                self.videos = tempArray;
                [self.videoView setModels:self.videos index:self.playIndex];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (self.isPushed) {
        // 添加返回按钮
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(kStatusBarHeight / 2, kStatusBarHeight, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"ac_auction_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popToRootViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlay) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumePlay) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlay) name:@"MSG_VIDEO_LINE_CALL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay) name:KLOGIN_OUT_Notification object:nil];
    
    [self.view addSubview:self.rechargeView];
    
    
    
    
}

-(void)endPlay{
    [self.videoView destoryPlayer];
}

- (void)pausePlay{
    [self.videoView pause];
}

- (void)resumePlay{
    if (self.videoView.player.status == HMVideoPlayerStatusPaused) {
        [self.videoView resume];
    }else{
        [self.videoView playVideoFrom:self.videoView.currentPlayView];
    }
}

- (void)videoViewDidClickOneOnOne:(HMVideoView *)videoView{
    //点击了一对一按钮
}

- (void)videoViewDidClickRecharge:(HMVideoView *)videoView{
    [self.rechargePopView show:[UIApplication sharedApplication].keyWindow type:FDPopTypeBottom];
//    if (!self.mgRechargeView) {
//        self.mgRechargeView = [[MGLiveRechargeView alloc]initWithFrame:CGRectMake(0, kScreenH - kRealValue(485), kScreenW, kRealValue(485))];
//    }
//    [self.mgRechargeView show:self.view];
//    NSLog(@"%s",__func__);
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

- (void)videoViewDidClickReport:(HMVideoView *)videoView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"举报") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [videoView clickShareViewReportBtn];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//点击视频view
-(void)controlViewDidClickSelf:(HMVideoView *)videoView{
    
//    if (videoView.giftView.hidden == NO) {
//        self.rechargeView.hidden = YES;
//        return;
//    }
    
    if (self.rechargeView.hidden == NO) {
        self.rechargeView.hidden = YES;
        videoView.giftView.hidden = NO;
        return;
    }
    videoView.giftView.hidden = YES;
}

-(void)deleteVideoWithView:(HMVideoView *)videoView{
    [self.videoView destoryPlayer];
    if (self.isRefreshVideoBlock) {
        self.isRefreshVideoBlock(YES);
        [[AppDelegate sharedAppDelegate]popViewController];
    }
}

//关闭
-(void)closeRechargeWithRechargeView:(RechargeView *)rechargeView{
    self.rechargeView.hidden = YES;
//    [[AppDelegate sharedAppDelegate]popViewController];
}

- (void)pushToNextViewController:(NSString *)user_id {
//    NSString *user_id = noti.object;
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = user_id;
    tmpController.type = 0;
    [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
    
    [self.videoView.player pausePlay];
}



- (void)popToRootViewController{
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self.videoView destoryPlayer];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    
    
    [self.videoView destoryPlayer];
    
    NSLog(@"playerVC dealloc");
}



#pragma mark ------------- Lazy Load --------------
- (HMVideoView *)videoView{
    if (!_videoView) {
        _videoView = [[HMVideoView alloc]initWithVC:self isPushed:self.isPushed requestDict:self.dict];
        _videoView.delegate = self;
        _videoView.isRecommend = YES;
        _videoView.clickHeadBlock = ^(NSString * _Nonnull userID) {
            [self pushToNextViewController:userID];
        };
    }
    return _videoView;
}

- (RechargeView *)rechargeView
{
    if (_rechargeView == nil)
    {
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, kRechargeViewHeight) andUIViewController:self];
        _rechargeView.hidden = YES;
        _rechargeView.delegate = self;
    }
    return _rechargeView;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BogoRechargePopView *)rechargePopView{
    if (!_rechargePopView) {
        _rechargePopView = [[BogoRechargePopView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH - kRealValue(180))];
    }
    return _rechargePopView;
}

@end
