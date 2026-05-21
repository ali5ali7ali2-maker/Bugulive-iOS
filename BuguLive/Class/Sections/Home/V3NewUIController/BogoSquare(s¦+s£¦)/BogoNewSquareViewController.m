//
//  BogoNewSquareViewController.m
//  BuguLive
//
//  Created by Mac on 2021/9/28.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNewSquareViewController.h"
#import "YHTimeLineViewController.h"
#import "HMVideoPlayerViewController.h"
#import "ReleaseDynamicVC.h"

@interface BogoNewSquareViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIButton *videoBtn;
@property(nonatomic, strong) UIButton *dynamicBtn;
@property(nonatomic, strong) UIImageView *lineView;
@property(nonatomic, strong) UIButton *publishBtn;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) HMVideoPlayerViewController *videoVC;
@property(nonatomic, strong) YHTimeLineViewController *timelineVC;
@property(nonatomic, strong) QMUIPopupMenuView *popView;

@end

@implementation BogoNewSquareViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //添加一个从上到下的渐变视图 #FBE2FF - #DFFFF9、
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, kScreenW, 250);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FBE2FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#DFFFF9"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);

    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view.layer insertSublayer:gradientLayer atIndex:0];
    [self.view addSubview:view];
    
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.videoBtn];
    [self.view addSubview:self.dynamicBtn];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.publishBtn];
    [self dynamicBtnAction];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.scrollView.contentOffset.x == 0) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)videoBtnAction{
    [self setNeedsStatusBarAppearanceUpdate];
    [self.videoVC setIsViewAppear:YES];
    [self.scrollView scrollToLeftAnimated:NO];
    self.lineView.centerX = self.videoBtn.centerX;
    self.videoBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.dynamicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.videoBtn setTitleColor:FD_WhiteColor forState:UIControlStateNormal];
    [self.dynamicBtn setTitleColor:FD_WhiteColor forState:UIControlStateNormal];
}

- (void)dynamicBtnAction{
    [self setNeedsStatusBarAppearanceUpdate];
    [self.videoVC setIsViewAppear:NO];
//    [self.scrollView scrollToRight];
    [self.scrollView scrollToRightAnimated:NO];

    self.lineView.centerX = self.dynamicBtn.centerX;
    self.dynamicBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.videoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.videoBtn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
    [self.dynamicBtn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
}

- (void)publishBtnAction{
    [self.popView showWithAnimated:YES];
}

- (QMUIPopupMenuView *)popView{
    if (!_popView) {
        _popView = [[QMUIPopupMenuView alloc] init];
        _popView.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
        _popView.shouldShowItemSeparator = YES;
        _popView.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            [aItem.button setTitleColor:[UIColor qmui_colorWithHexString:@"333333"] forState:UIControlStateNormal];
            aItem.button.titleLabel.font = [UIFont systemFontOfSize:14];
        };
        _popView.items = @[[QMUIPopupMenuButtonItem itemWithImage:nil title:ASLocalizedString(@"短视频") handler:^(QMUIPopupMenuButtonItem *aItem) {
            [aItem.menuView hideWithAnimated:YES];
            if (self.clickSquareBtnBlock) {
                self.clickSquareBtnBlock(0);
            }
        }],
                                     [QMUIPopupMenuButtonItem itemWithImage:nil title:ASLocalizedString(@"动态") handler:^(QMUIPopupMenuButtonItem *aItem) {
                                         [aItem.menuView hideWithAnimated:YES];
                                         ReleaseDynamicVC *pushVC = [ReleaseDynamicVC new];

                                         __weak __typeof(self)weakSelf = self;
                                         pushVC.postFinishBlock = ^(BOOL isFinish) {
                                             if (isFinish) {
                                                 [[NSNotificationCenter defaultCenter]postNotificationName:KBogoTimeReloadList object:nil];
                                             }
                                         };
                                         [[AppDelegate sharedAppDelegate]presentViewController:pushVC animated:YES completion:nil];
                                     }]];
        _popView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
        _popView.sourceView = self.publishBtn;// 相对于 button4 布局
    }
    return _popView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight)];
        _scrollView.contentSize = CGSizeMake(kScreenW * 2, 0);
//        _scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        
        HMVideoPlayerViewController *videoVC = [[HMVideoPlayerViewController alloc]initWithVideos:nil index:0 IsPushed:NO requestDict:nil];
        videoVC.view.frame = CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - FD_Bottom_Height);
        [self addChildViewController:videoVC];
        [_scrollView addSubview:videoVC.view];
        [videoVC didMoveToParentViewController:self];
        self.videoVC = videoVC;
        
        
        
        YHTimeLineViewController *timelineVC = [YHTimeLineViewController new];
        timelineVC.view.frame = CGRectMake(FD_ScreenWidth, FD_Top_Height, FD_ScreenWidth, FD_ScreenHeight - FD_Bottom_Height - FD_Top_Height);
        [self addChildViewController:timelineVC];
        [_scrollView addSubview:timelineVC.view];
        [timelineVC didMoveToParentViewController:self];
        self.timelineVC = timelineVC;
        
        self.scrollView.backgroundColor = kClearColor;
    }
    return _scrollView;
}

- (UIButton *)videoBtn{
    if (!_videoBtn) {
        _videoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, FD_StatusBar_Height, 84, FD_Navigation_Height)];
//        _videoBtn.right = FD_ScreenWidth / 2 - 15;
        
        _videoBtn.left = kScreenW / 2 + 15;

        
        [_videoBtn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
        [_videoBtn setTitle:ASLocalizedString(@"短视频") forState:UIControlStateNormal];
        _videoBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [_videoBtn addTarget:self action:@selector(videoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoBtn;
}

- (UIButton *)dynamicBtn{
    if (!_dynamicBtn) {
        _dynamicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, FD_StatusBar_Height, 80, FD_Navigation_Height)];
        
        _dynamicBtn.right = FD_ScreenWidth / 2 - 15;

        
//        _dynamicBtn.left = kScreenW / 2 + 15;
        _dynamicBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_dynamicBtn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
        [_dynamicBtn setTitle:ASLocalizedString(@"动态") forState:UIControlStateNormal];
        [_dynamicBtn addTarget:self action:@selector(dynamicBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dynamicBtn;
}

- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 4)];
        _lineView.centerX = self.videoBtn.centerX;
        _lineView.bottom = self.videoBtn.bottom;
        _lineView.image = [UIImage imageNamed:@"选中条"];
        _lineView.layer.cornerRadius = 2;
        _lineView.clipsToBounds = YES;
    }
    return _lineView;
}

- (UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(FD_ScreenWidth - 60, FD_StatusBar_Height, 50, FD_Navigation_Height)];
        [_publishBtn setImage:[UIImage imageNamed:ASLocalizedString(@"bogo_publish_btn")] forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(publishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

@end
