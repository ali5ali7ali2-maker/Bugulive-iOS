//
//  YHPlayerViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/8/29.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "YHPlayerViewController.h"
#import <CLPlayer/CLPlayerView.h>


@interface YHPlayerViewController ()

@property (nonatomic, strong) CLPlayerView *playerView;

@property(nonatomic, assign) BOOL isDisappear;
@property(nonatomic, assign) BOOL isPlaying;

@end

@implementation YHPlayerViewController

- (instancetype)initWithPlayerURL:(NSString *)url{
    YHPlayerViewController *vc = [YHPlayerViewController new];
    vc.url = url;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

-(void)setUpView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    bgView.backgroundColor = kBlackColor;
    [self.view addSubview:bgView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, kTopHeight - 20, 40, 30);
    [backBtn setImage:[UIImage imageNamed:@"ac_auction_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _playerView.backgroundColor = kClearColor;
    if ([_playerView.maskView respondsToSelector:NSSelectorFromString(@"playButton")]) {
        UIButton *playButton = [_playerView.maskView valueForKey:@"playButton"];
        playButton.alpha = 0;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPlayerView:)];
    [_playerView.maskView addGestureRecognizer:tap];
//    [_playerView.maskView.playButton addTarget:self action:@selector(clickPlayerView:) forControlEvents:UIControlEventTouchUpInside];

    
    __weak __typeof(self)weakSelf = self;
    
    [_playerView updateWithConfigure:^(CLPlayerViewConfigure *configure) {
        configure.repeatPlay = YES;
        configure.mute = NO;
        configure.isLandscape = YES;

        _playerView.url = [NSURL URLWithString:self.url];
        //播放
        [_playerView playVideo];
        self.isPlaying = YES;
    }];
    
    
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(ASLocalizedString(@"返回按钮被点击"));
    }];
    
    //播放完成回调
    [_playerView endPlay:^{

    }];
    
    [bgView addSubview:_playerView];
    [bgView addSubview:backBtn];
}

-(void)clickPlayerView:(id)sender{
    
    if (self.isPlaying) {
        [_playerView pausePlay];
    }else{
        [_playerView playVideo];
    }
    self.isPlaying = !self.isPlaying;

    UIButton *playButton = nil;
    if ([_playerView.maskView respondsToSelector:NSSelectorFromString(@"playButton")]) {
        playButton = [_playerView.maskView valueForKey:@"playButton"];
        playButton.selected = self.isPlaying;
    }
    
    if (_isDisappear){
        [UIView animateWithDuration:0.5 animations:^{
            playButton.alpha = 0;
        }];
    }else{
        //重置定时消失
        [UIView animateWithDuration:0.5 animations:^{
            playButton.alpha = 1;
        }];
    }
    _isDisappear = !_isDisappear;
}

-(void)clickBack:(UIButton *)sender{
    [_playerView destroyPlayer];
    _playerView = nil;
    [[AppDelegate sharedAppDelegate].navigationViewController popViewControllerAnimated:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
