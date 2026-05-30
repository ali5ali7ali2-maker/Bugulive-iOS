//
//  BogoSquareViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/10.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSquareViewController.h"

#import "YHTimeLineViewController.h"
#import "NewSmallVideoViewController.h"

#import "BogoSquarePopView.h"

#import "ReleaseDynamicVC.h"
#import "HMVideoPlayerViewController.h"
#import "MSmallVideoVC.h"

@interface BogoSquareViewController ()

@property(nonatomic, strong) NSArray *listArr;

@property(nonatomic, strong) UIButton *publishBtn;

@property(nonatomic, strong) BogoSquarePopView *popView;

@property(nonatomic, strong) YHTimeLineViewController *dynamicVC;

@property(nonatomic, strong) HMVideoPlayerViewController *videoVC;

@end

@implementation BogoSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //顶部渐变

    UIImageView *topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64+kStatusBarHeight)];
    topImgView.image = [UIImage imageNamed:@"顶部渐变"];
    [self.view addSubview:topImgView];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    
    self.dynamicVC = [YHTimeLineViewController new];
    [self setUpSegView];
    
//    self.publishBtn.hidden = YES;
    [self.view addSubview:self.publishBtn];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)setUpSegView{
    _listArr = @[ASLocalizedString(@"动态"),ASLocalizedString(@"短视频")];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW *0.7, kRealValue(40)) titles:_listArr headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutCenter];
    _segHead.centerX = kScreenW / 2;
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#1A1A1A"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#333333"];
    _segHead.delegate = self;
    
    _segHead.fontScale = 1.57;
    _segHead.fontSize = 14;
    //滑块设置
    _segHead.slideHeight = kRealValue(32);
    _segHead.slideCorner = 4;
//    _segHead.moreButton_width = kRealValue(140);
    _segHead.singleW_Add = kRealValue(50);
    _segHead.slideColor = nil;
    
    _segHead.lineScale = 0.3;
    _segHead.lineHeight = 3.5;
    _segHead.lineColor = [UIColor clearColor];
    _segHead.bottomLineHeight = 0;

//    UIView *line = [_segHead getLineView];
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = line.bounds;
//    gl.startPoint = CGPointMake(0, 0.5);
//    gl.endPoint = CGPointMake(1, 0.5);
//    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#9E64FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#EF60F6"].CGColor];
//    gl.locations = @[@(0), @(1.0f)];
//    [line.layer insertSublayer:gl atIndex:0];
//    line.backgroundColor = kRedColor;

    _segHead.headColor = kClearColor;
    self.view.backgroundColor = kClearColor;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame)+30, SCREEN_WIDTH, SCREEN_HEIGHT - self.segHead.bottom - kTabBarHeight - 30) vcOrViews:[self vcArr:_listArr.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll contentChangeAni:YES completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
        [self setHeadBottomLineView];
    } selectEnd:^(NSInteger index) {
        if (self.videoVC) {
            self.videoVC.isViewAppear = index == 0;
        }
    }];
    
    self.publishBtn.bottom = SCREEN_HEIGHT - 32 - kTabBarHeight;
}

-(void)setHeadBottomLineView{
//    UIView *line = [_segHead getScrollLineView];
//    
//    line.layer.cornerRadius = 2;
//    line.layer.masksToBounds = YES;
//    
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = line.bounds;
//    gl.startPoint = CGPointMake(0, 0.5);
//    gl.endPoint = CGPointMake(1, 0.5);
//    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#9E64FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#EF60F6"].CGColor];
//    gl.locations = @[@(0), @(1.0f)];
//    [line.layer insertSublayer:gl atIndex:0];
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray array];
    
    
    
    NSMutableDictionary *hotDic = [NSMutableDictionary dictionary];
    
    [hotDic setObject:@"1" forKey:@"order"];
    [hotDic setObject:@"0" forKey:@"cate"];
    
    
    
    MSmallVideoVC *hotVC = [[MSmallVideoVC alloc]init];
    hotVC.isHaveNavBar = NO;
    hotVC.paramDict = hotDic;
//        NewSmallVideoViewController *videoVC = [NewSmallVideoViewController new];
    [arr addObject:self.dynamicVC];

    [arr addObject:hotVC];
    
    return arr;
}


#pragma mark - 点击事件

-(void)clickPublish:(UIButton *)sender{
    
    self.popView.listArr = @[ASLocalizedString(@"短视频"),ASLocalizedString(@"动态")];
    
//    self.popView.frame = CGRectMake(kScreenW - kRealValue(98 + 22), self.publishBtn.bottom, kRealValue(90), kRealValue(98));
    
    [self.popView show:[UIApplication sharedApplication].keyWindow frame:CGRectMake(kScreenW - kRealValue(98), self.publishBtn.bottom, kRealValue(90), kRealValue(40 * self.popView.listArr.count) + kRealValue(10))];

    self.popView.clickIndexBlock = ^(NSInteger index) {
        if (index == 0) {
            if (self.clickSquareBtnBlock) {
                self.clickSquareBtnBlock(index);
            }
        }else{
            [self popDynamicView];
//            [self.dynamicVC handleSearchEvent];
        }
    };
}



-(void)popDynamicView{
    ReleaseDynamicVC *pushVC = [ReleaseDynamicVC new];

    __weak __typeof(self)weakSelf = self;
    pushVC.postFinishBlock = ^(BOOL isFinish) {
        if (isFinish) {
            [[NSNotificationCenter defaultCenter]postNotificationName:KBogoTimeReloadList object:nil];
        }
    };
    [[AppDelegate sharedAppDelegate]presentViewController:pushVC animated:YES completion:nil];
}



-(UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBtn.frame = CGRectMake(kScreenW - kRealValue(60) - kRealValue(5), 0, kRealValue(44), kRealValue(44));
        [_publishBtn setImage:[UIImage imageNamed:ASLocalizedString(@"mg_dy_publish")] forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(clickPublish:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _publishBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BogoSquarePopView *)popView{
    if (!_popView) {
        _popView = [[BogoSquarePopView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(90), kRealValue(98))];
    }
    return _popView;
}

@end
