//
//  BogoCategoryDetailViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/14.
//

#import "BogoCategoryDetailViewController.h"
#import "MLMSegmentScroll.h"
#import "MLMSegmentHead.h"
#import "MLMSegmentManager.h"
#import "BogoCategoryDetailSubViewController.h"
#import "FDUIKitObjC.h"
#import "UIColor+YYAdd.h"
#import "BogoCategoryModel.h"
#import "BogoShopKit.h"

@interface BogoCategoryDetailViewController ()

@property(nonatomic, strong) NSMutableArray *vcArray;

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;

@end

@implementation BogoCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageNamed(@"new返回") style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setModel:(BogoCategoryModel *)model{
    _model = model;
    [self addSubController];
    self.title = model.title;
}

- (void)addSubController {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (BogoCategoryModel *model in _model.children) {
        [tempArray addObject:model.title];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, self.view.fd_width, 40) titles:tempArray headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutLeft];
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
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
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
        for (NSInteger i = 0; i < _model.children.count; i++) {
            BogoCategoryModel *model = _model.children[i];
            BogoCategoryDetailSubViewController *listVC = [[BogoCategoryDetailSubViewController alloc]init];
            listVC.pid = model.pid;
            [_vcArray addObject:listVC];
        }
    }
    return _vcArray;
}

@end
