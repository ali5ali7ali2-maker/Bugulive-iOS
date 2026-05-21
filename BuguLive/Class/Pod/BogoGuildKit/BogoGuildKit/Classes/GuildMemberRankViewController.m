//
//  GuildMemberRankViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/26.
//

#import "GuildMemberRankViewController.h"
#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>
#import "GuildRankSubViewController.h"

@interface GuildMemberRankViewController ()

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;
@property(nonatomic, strong) NSMutableArray *vcArray;

@end

@implementation GuildMemberRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ASLocalizedString(@"公会贡献榜") ;
    [self addSubController];
}

- (void)addSubController {
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, self.view.fd_width, 40) titles:@[ASLocalizedString(@"总榜"),ASLocalizedString(@"日榜")] headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    _segHead.tag = 1101;
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#9152F8"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#777777"];
    _segHead.lineColor = [UIColor colorWithHexString:@"#9E64FF"];
    _segHead.lineHeight = 4;
    _segHead.deSelectFont = [UIFont systemFontOfSize:14];
    _segHead.selectFont = [UIFont systemFontOfSize:14];
    _segHead.lineScale = .125;
    _segHead.headColor = FD_WhiteColor;
    _segHead.bottomLineHeight = 0;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), FD_ScreenWidth, FD_ScreenHeight - CGRectGetMaxY(_segHead.frame) - FD_Top_Height) vcOrViews:self.vcArray];
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
}

-(NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        GuildRankSubViewController *allVC = [[GuildRankSubViewController alloc]initWithNibName:@"GuildRankSubViewController" bundle:kBogoGuildKitBundle];
        allVC.type = GuildRankSubViewControllerTypeMemberAll;
        allVC.family_id = self.family_id;
        allVC.isFromDetailVC = self.isFromDetailVC;
        [_vcArray addObject:allVC];
        GuildRankSubViewController *dayVC = [[GuildRankSubViewController alloc]initWithNibName:@"GuildRankSubViewController" bundle:kBogoGuildKitBundle];
        dayVC.family_id = self.family_id;
        dayVC.type = GuildRankSubViewControllerTypeMemberDay;
        dayVC.isFromDetailVC = self.isFromDetailVC;
        [_vcArray addObject:dayVC];
    }
    return _vcArray;
}

@end
