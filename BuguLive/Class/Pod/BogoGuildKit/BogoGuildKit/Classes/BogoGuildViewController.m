//
//  BogoGuildViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/24.
//

#import "BogoGuildViewController.h"
#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>
#import "MineGuildViewController.h"
#import "GuildRankViewController.h"

@interface BogoGuildViewController ()

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;
@property(nonatomic, strong) NSMutableArray *vcArray;

@end

@implementation BogoGuildViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.view.backgroundColor = FD_WhiteColor;
    [self.view addSubview:self.backBtn];
    [self addSubController];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)addSubController {
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(44, FD_StatusBar_Height, self.view.fd_width - 88, 40) titles:@[ASLocalizedString(@"公会排行榜"),ASLocalizedString(@"我的公会")] headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutCenter];
    _segHead.tag = 1101;
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#333333"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#777777"];
    _segHead.lineColor = [UIColor colorWithHexString:@"#ffffff"];
    _segHead.lineHeight = 4;
    _segHead.deSelectFont = [UIFont systemFontOfSize:16];
    _segHead.selectFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _segHead.lineScale = .25;
    _segHead.headColor = FD_WhiteColor;
    _segHead.bottomLineHeight = 0;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), FD_ScreenWidth, FD_ScreenHeight - CGRectGetMaxY(_segHead.frame)) vcOrViews:self.vcArray];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    __weak __typeof(self)weakSelf = self;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view addSubview:strongSelf.segHead];
        [strongSelf.view addSubview:strongSelf.segScroll];
    }];
    UIView *line = [self.segHead getScrollLineView];
//    line.width = 20;
    line.layer.cornerRadius = 2;
    line.layer.masksToBounds = YES;
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = line.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#9E64FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#EF60F6"].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [line.layer insertSublayer:gl atIndex:0];
}

- (void)backBtnAction:(UIButton *)sender{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        GuildRankViewController *rankVC = [[GuildRankViewController alloc]init];
        [_vcArray addObject:rankVC];
        MineGuildViewController *mineVC = [[MineGuildViewController alloc]initWithNibName:@"MineGuildViewController" bundle:kBogoGuildKitBundle];
        mineVC.family_id = self.family_id;
        [_vcArray addObject:mineVC];
    }
    return _vcArray;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, FD_StatusBar_Height, 44, 44)];
        [_backBtn setImage:kBogoGuildKitBundleImageNamed(@"guild_back") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
