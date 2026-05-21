//
//  MGAdvertViewController.m
//  BuGuDY
//
//  Created by 宋晨光 on 2019/12/9.
//  Copyright © 2019 宋晨光. All rights reserved.
//

#import "MGAdvertViewController.h"

#import "BGTabBarController.h"
#import "MGAdvertModel.h"

#import "BogoJHLogin.h"

#import <XHLaunchAdButton.h>


@interface MGAdvertViewController ()<GGBannerViewDelegate>

@property(nonatomic, strong) GGBannerView *bannerView;
@property(nonatomic, strong) UIButton *jumpOverBut;

@property(nonatomic,strong)XHLaunchAdButton * skipButton;

@end

@implementation MGAdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.navigationController.navigationBar.hidden = YES;
    
    self.bannerView = [[GGBannerView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.bannerView.interval = 3;
//    [[GlobalData sharedInstance].start_figure_switch integerValue] / 1000;
    
//    NSLog(@"%ld",[[GlobalData sharedInstance].start_figure_switch integerValue] / 1000);
//    NSLog(@"%@",[GlobalData sharedInstance].start_figure_switch);
//    NSLog(@"%ld",[[GlobalData sharedInstance].start_figure_switch integerValue]);
    self.bannerView.delegate = self;
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *dic in [GlobalVariables sharedInstance].guardImgArr) {
        [arr addObject:[dic valueForKey:@"image"]];
//        [arr addObject:[dic valueForKey:@"plug_ad_pic"]];
//        [arr addObject:@""];
//        [arr addObject:[dic valueForKey:@"plug_ad_pic"]];
    }
    
    [self.bannerView configBanner:arr];
    self.bannerView.backgroundColor = kRedColor;
    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.jumpOverBut];
    [self.view addSubview:self.skipButton];
    
    self.jumpOverBut.frame = CGRectMake(kScreenW - kRealValue(42) - 10, 30, kRealValue(42), kRealValue(42));
    self.skipButton.frame = CGRectMake(kScreenW - kRealValue(42) - 10, 30, kRealValue(42), kRealValue(42));
    if([GlobalVariables sharedInstance].guardImgArr.count == 0)
    {
        [self btnClick:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - delegate
- (void)imageView:(UIImageView *)imageView loadImageForUrl:(NSString *)url{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

-(void)bannerView:(GGBannerView *)bannerView didSelectAtIndex:(NSUInteger)index{
   
}

-(void)bannerViewFinsh{
    [self btnClick:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIButton *)jumpOverBut{
    if (_jumpOverBut == nil) {
        _jumpOverBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpOverBut addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_jumpOverBut setBackgroundImage:[UIImage imageNamed:@"mg_advert_jump"] forState:UIControlStateNormal];
        _jumpOverBut.hidden = YES;
//        _jumpOverBut.backgroundColor = [UIColor colorWithHex:@"#E5E5E5"];
        _jumpOverBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_jumpOverBut setTitle:NSLocalizedString(ASLocalizedString(@"跳过"), nil) forState:(UIControlStateNormal)];
    }
    return _jumpOverBut;
}

-(XHLaunchAdButton *)skipButton{
    if(_skipButton == nil){
       _skipButton = [[XHLaunchAdButton alloc] initWithSkipType:SkipTypeRoundProgressText];
//       _skipButton.hidden = YES;
       [_skipButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_skipButton setTitleWithSkipType:SkipTypeRoundProgressText duration:9];
        [_skipButton startRoundDispathTimerWithDuration:9];
   }
    return _skipButton;
}

-(void)btnClick:(UIButton *)sender{
    
    [self.bannerView removeTimer];
    
    
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    
    if (isAutoLogin) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        BGTabBarController *mainViewController = [[BGTabBarController alloc] init];
//        MGNavigationController *nav = [[MGNavigationController alloc]initWithRootViewController:mainViewController];
//        GB_Nav = nav;
        window.rootViewController = [BGTabBarController sharedInstance];;
        [window makeKeyAndVisible];
    }else{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        BogoJHLogin *login = [[BogoJHLogin alloc]initWithNibName:NSStringFromClass([BogoJHLogin class]) bundle:[NSBundle mainBundle]];
        BGNavigationController *nav = [[BGNavigationController alloc]initWithRootViewController:login];
        window.rootViewController = nav;
        [window makeKeyAndVisible];
    }
}

@end
