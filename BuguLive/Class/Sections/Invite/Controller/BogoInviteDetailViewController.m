//
//  BogoInviteDetailViewController.m
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteDetailViewController.h"
#import "BogoInviteDetailSubViewController.h"
#import "BogoInviteDetailTopView.h"
#import "BogoInviteWithDrawViewController.h"
#import "BogoInviteWithDrawLogViewController.h"

@interface BogoInviteDetailViewController ()<BogoInviteDetailTopViewDelegate>{
    NSArray *list;
}

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;

@property(nonatomic, strong) NSMutableArray *vcArray;

@property(nonatomic, strong) BogoInviteDetailTopView *topView;

@end

@implementation BogoInviteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =ASLocalizedString( @"我的邀请详情");
    [self.view addSubview:self.topView];
    [self addSubController];
    [self performSelector:@selector(updateLayout) afterDelay:0.25];
}

- (void)updateLayout{
    self.topView.height = 98;
}

- (void)addSubController {
    list = @[
             ASLocalizedString(@"一级邀请"),
             ASLocalizedString(@"二级邀请")];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(15, 98 + 15, SCREEN_WIDTH, 52) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutLeft];
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#333333"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#777777"];
    _segHead.lineColor = [UIColor colorWithHexString:@"#FD4161"];
    _segHead.deSelectFont = [UIFont systemFontOfSize:16];
    _segHead.selectFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _segHead.lineHeight = 4;
    _segHead.headColor = kWhiteColor;
    _segHead.lineScale = 0.25;
    _segHead.bottomLineHeight = 0;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, kScreenH - FD_Top_Height - 52 - 98 - 15) vcOrViews:self.vcArray];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
    
    UIView *line = [_segHead getScrollLineView];
    line.layer.cornerRadius = 2;
    line.layer.masksToBounds = YES;
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = line.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#F4491F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FF9D45"].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [line.layer insertSublayer:gl atIndex:0];
}

#pragma mark - BogoInviteDetailTopViewDelegate
- (void)topView:(BogoInviteDetailTopView *)topView didClickLogBtn:(UIButton *)sender{
    BogoInviteWithDrawLogViewController *detailVC = [[BogoInviteWithDrawLogViewController alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)topView:(BogoInviteDetailTopView *)topView didClickWithDrawBtn:(UIButton *)sender{
    BogoInviteWithDrawViewController *withDrawVC = [[BogoInviteWithDrawViewController alloc]init];
    [self.navigationController pushViewController:withDrawVC animated:YES];
}

- (NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        BogoInviteDetailSubViewController *subVC = [[BogoInviteDetailSubViewController alloc]init];
        subVC.type = BogoInviteDetailSubViewControllerTypeDirect;
        BogoInviteDetailSubViewController *subVC2 = [[BogoInviteDetailSubViewController alloc]init];
        subVC2.type = BogoInviteDetailSubViewControllerTypeDirectIndirect;
        [_vcArray addObject:subVC];
        [_vcArray addObject:subVC2];
    }
    return _vcArray;
}

- (BogoInviteDetailTopView *)topView{
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"BogoInviteDetailTopView" owner:nil options:nil].firstObject;
        _topView.delegate = self;
    }
    return _topView;
}

@end
