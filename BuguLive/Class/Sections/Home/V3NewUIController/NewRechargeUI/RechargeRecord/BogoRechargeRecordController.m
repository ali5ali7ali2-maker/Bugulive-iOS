//
//  BogoRechargeRecordController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargeRecordController.h"
#import "BogoRechargeRecordListController.h"

@interface BogoRechargeRecordController ()

@property(nonatomic, strong) NSArray *listArr;

@end

@implementation BogoRechargeRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSegView];
    
    self.title = ASLocalizedString(@"收支记录");
    [self setupBackBtnWithBlock:nil];
    
    self.view.backgroundColor = kWhiteColor;
}

-(void)setUpSegView{
    _listArr = @[ASLocalizedString(@"充值明细"),ASLocalizedString(@"消费明细")];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(40)) titles:_listArr headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#333333"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#777777"];
    _segHead.delegate = self;
    
    _segHead.fontScale = 1;
//    _segHead.lineHeight = 0;
//    _segHead.lineColor = kClearColor;
    _segHead.fontSize = 16;
    //滑块设置
    _segHead.slideHeight = kRealValue(32);
    _segHead.slideCorner = 4;
    _segHead.moreButton_width = kRealValue(20);
    _segHead.singleW_Add = kRealValue(20);
    _segHead.slideColor = nil;
    
    _segHead.lineScale = 0.15;
    _segHead.lineHeight = 3.5;
    _segHead.lineColor = [UIColor colorWithHexString:@"#9152F8"];
    _segHead.bottomLineHeight = 0;
//    bottomLineHeight
//    _segHead.slideScale = 1.5;

    _segHead.headColor = kClearColor;
    self.view.backgroundColor = kClearColor;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT - self.segHead.bottom - kTabBarHeight) vcOrViews:[self vcArr:_listArr.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
        
        [self setHeadBottomLineView];
        
    }];
    
}

-(void)setHeadBottomLineView{
    UIView *line = [_segHead getScrollLineView];
    line.bottom = line.bottom - 5;
    
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

- (NSArray *)vcArr:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray array];
    BogoRechargeRecordListController *vc1 = [[BogoRechargeRecordListController alloc]initRecordTypeWith:BOGO_RECORD_TYPE_RECHARGE];
    BogoRechargeRecordListController *vc2 = [[BogoRechargeRecordListController alloc]initRecordTypeWith:BOGO_RECORD_TYPE_CONSUMPTION];

    [arr addObject:vc1];
    [arr addObject:vc2];
    
    return arr;
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
