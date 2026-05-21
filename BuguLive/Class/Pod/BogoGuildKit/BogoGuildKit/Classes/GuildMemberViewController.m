//
//  GuildMemberViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "GuildMemberViewController.h"
#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>
#import "GuildMemberSubViewController.h"

@interface GuildMemberViewController ()

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;
@property(nonatomic, strong) NSMutableArray *vcArray;

@end

@implementation GuildMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ASLocalizedString(@"公会成员");
    [self addSubController];
}

- (void)addSubController {
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, self.view.fd_width, 40) titles:@[ASLocalizedString(@"公会成员"),ASLocalizedString(@"成员申请")] headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    _segHead.tag = 1101;
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#333333"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#777777"];
    _segHead.lineColor = [UIColor colorWithHexString:@"#9E64FF"];
    _segHead.lineHeight = 4;
    _segHead.deSelectFont = [UIFont systemFontOfSize:16];
    _segHead.selectFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _segHead.lineScale = .25;
    _segHead.headColor = FD_WhiteColor;
    _segHead.bottomLineHeight = 0;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), FD_ScreenWidth, FD_ScreenHeight - FD_Top_Height - 40) vcOrViews:self.vcArray];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = self.showIndex;
    __weak __typeof(self)weakSelf = self;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll contentChangeAni:YES completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view addSubview:strongSelf.segHead];
        [strongSelf.view addSubview:strongSelf.segScroll];
    } selectEnd:^(NSInteger index) {
        GuildMemberSubViewController *subVC = self.vcArray[index];
        [subVC headerRefresh];
    }];
    UIView *line = [self.segHead getScrollLineView];
//    line.width = 20;
    line.layer.cornerRadius = 2;
    line.layer.masksToBounds = YES;
}

-(NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        GuildMemberSubViewController *memberVC = [[GuildMemberSubViewController alloc]initWithNibName:@"GuildMemberSubViewController" bundle:kBogoGuildKitBundle];
        memberVC.type = GuildMemberSubViewControllerTypeMember;
        memberVC.family_id = self.family_id;
        memberVC.familyModel = self.familyModel;
        [_vcArray addObject:memberVC];
        GuildMemberSubViewController *applyVC = [[GuildMemberSubViewController alloc]initWithNibName:@"GuildMemberSubViewController" bundle:kBogoGuildKitBundle];
        applyVC.type = GuildMemberSubViewControllerTypeApply;
        applyVC.family_id = self.family_id;
        applyVC.familyModel = self.familyModel;
        [_vcArray addObject:applyVC];
    }
    return _vcArray;
}

@end
