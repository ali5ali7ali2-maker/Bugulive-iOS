//
//  BogoOrderManageViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoOrderManageViewController.h"
#import "MLMSegmentScroll.h"
#import "MLMSegmentHead.h"
#import "MLMSegmentManager.h"
#import "BogoOrderManageListViewController.h"
#import "FDUIKitObjC.h"
#import "UIColor+YYAdd.h"

@interface BogoOrderManageViewController (){
    NSArray *_titleArray;
}

@property(nonatomic, strong) NSMutableArray *vcArray;

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;

@end

@implementation BogoOrderManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_listType == BogoOrderManageViewControllerTypeShop) {
        self.title = @"售卖订单管理";
    }else{
        self.title = @"购买订单管理";
    }
    [self addSubController];
}

- (void)addSubController {
    if (_listType == BogoOrderManageViewControllerTypeShop) {
        _titleArray = @[@"全部订单",@"待付款",@"待发货",@"已发货",@"已完成",@"退款"];
    }else{
        _titleArray = @[@"全部订单",@"待付款",@"待发货",@"待收货",@"退款",@"已完成"];
    }


    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(10, 0, self.view.fd_width - 20, 40) titles:_titleArray headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    _segHead.tag = 1101;

    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#F46628"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#333333"];
    _segHead.lineColor = [UIColor colorWithHexString:@"#F46628"];
    _segHead.lineHeight = 3;
    _segHead.fontSize = 13;
    _segHead.fontScale = 1;
    _segHead.lineScale = .5;
    _segHead.headColor = FD_WhiteColor;
    _segHead.bottomLineHeight = 0;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), FD_ScreenWidth, FD_ScreenHeight -  - CGRectGetMaxY(_segHead.frame)) vcOrViews:self.vcArray];
    if (@available(iOS 11.0, *)) {
        _segScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _segScroll.loadAll = NO;
    _segScroll.showIndex = self.index;
    __weak __typeof(self)weakSelf = self;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view addSubview:strongSelf.segHead];
        [strongSelf.view addSubview:strongSelf.segScroll];
    }];
}

-(NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        NSArray *statusArray = @[];
        if (_listType == BogoOrderManageViewControllerTypeShop) {
            statusArray = @[@(BogoOrderManageListViewControllerTypeAll),@(BogoOrderManageListViewControllerTypeWaitPurchase),@(BogoOrderManageListViewControllerTypeWaitTransfer),@(BogoOrderManageListViewControllerTypeTransfered),@(BogoOrderManageListViewControllerTypeWaitEvaluate),@(BogoOrderManageListViewControllerTypeRefund)];
        }else{
            statusArray = @[@(BogoOrderManageListViewControllerTypeAll),@(BogoOrderManageListViewControllerTypeWaitPurchase),@(BogoOrderManageListViewControllerTypeWaitTransfer),@(BogoOrderManageListViewControllerTypeTransfered),@(BogoOrderManageListViewControllerTypeRefund),@(BogoOrderManageListViewControllerTypeWaitEvaluate)];
        }
        for (NSInteger i = 0; i < statusArray.count; i++) {
            BogoOrderManageListViewController *listVC = [[BogoOrderManageListViewController alloc]init];
            listVC.type = [statusArray[i] integerValue];
            listVC.listType = _listType;
            [_vcArray addObject:listVC];
        }
    }
    return _vcArray;
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
