//
//  BogoCommodityManagementViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/13.
//

#import "BogoCommodityManagementViewController.h"
#import "MLMSegmentScroll.h"
#import "MLMSegmentHead.h"
#import "MLMSegmentManager.h"
#import "BogoCommodityManagementListViewController.h"
#import "FDUIKitObjC.h"
#import "UIColor+YYAdd.h"
#import "BogoCommodityManagementSearchBar.h"
#import "BogoShopKit.h"
#import "BogoCommodityAddViewController.h"
#import "BogoNetwork.h"
#import <Masonry/Masonry.h>

#import "BogoShopKit.h"
#import "BogoCommodityPlatformAddViewController.h"

@interface BogoCommodityManagementViewController ()<BogoCommodityManagementSearchBarDelegate>{
    NSArray *_titleArray;
}

@property(nonatomic, strong) NSMutableArray *vcArray;

@property(nonatomic, strong) BogoCommodityManagementSearchBar *searchBar;

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;

@property(nonatomic, assign) NSInteger currentIndex;

@end

@implementation BogoCommodityManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"商品管理";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加商品" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@70);
    }];
    [self addSubController];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    for (BogoCommodityManagementListViewController *vc in self.vcArray) {
        [vc headerRefresh];
    }
}

- (void)add{
    //自己添加商品
//    BogoCommodityAddViewController *addVC = [[BogoCommodityAddViewController alloc]init];
//    addVC.gid = @"";
//    [self.navigationController pushViewController:addVC animated:YES];
    //添加平台商品
    BogoCommodityPlatformAddViewController *addVC = [[BogoCommodityPlatformAddViewController alloc]initWithNibName:NSStringFromClass([BogoCommodityPlatformAddViewController class]) bundle:kShopKitBundle];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)addSubController {
    
    self.currentIndex = 0;
    _titleArray = @[@"全部",@"售卖中",@"已下架",@"已售空"];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, self.searchBar.fd_bottom, self.view.fd_width, 40) titles:_titleArray headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
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
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), FD_ScreenWidth, FD_ScreenHeight - CGRectGetMaxY(_segHead.frame)) vcOrViews:self.vcArray];
    if (@available(iOS 11.0, *)) {
        _segScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _segScroll.loadAll = NO;
    _segScroll.showIndex = self.currentIndex;;
    __weak __typeof(self)weakSelf = self;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll contentChangeAni:YES completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view addSubview:strongSelf.segHead];
        [strongSelf.view addSubview:strongSelf.segScroll];
    } selectEnd:^(NSInteger index) {
        NSLog(@"滑动到%ld",index);
        BogoCommodityManagementListViewController *vc = self.vcArray[index];
        [vc headerRefresh];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.currentIndex = index;
    }];
}

#pragma mark - BogoCommodityManagementSearchBarDelegate
- (void)searchBar:(BogoCommodityManagementSearchBar *)searchBar didClickSearchBtn:(UIButton *)sender{
    BogoCommodityManagementListViewController *vc = self.vcArray[self.currentIndex];
    [[BogoNetwork shareInstance]GET:@"shop/goodsIndexUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"keyword":self.searchBar.textField.text,@"status":@(vc.type)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        BogoCommodityManagementListViewController *vc = self.vcArray[self.currentIndex];
        [vc headerRefreshWithModelArr:result.data];
        
    } failure:^(NSString * _Nonnull error) {
        BogoCommodityManagementListViewController *vc = self.vcArray[self.currentIndex];
        [vc headerRefreshWithModelArr:nil];
    }];
}



-(NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        NSArray *typeArray = @[@(BogoCommodityManagementViewControllerTypeAll),@(BogoCommodityManagementViewControllerTypeAuthSuccess),@(BogoCommodityManagementViewControllerTypeOffSale),@(BogoCommodityManagementViewControllerTypeEmpty)];
        for (NSInteger i = 0; i < typeArray.count; i++) {
            BogoCommodityManagementListViewController *listVC = [[BogoCommodityManagementListViewController alloc]init];
            listVC.type = [typeArray[i] integerValue];
            [_vcArray addObject:listVC];
        }
    }
    return _vcArray;
}

- (BogoCommodityManagementSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoCommodityManagementSearchBar class]) owner:nil options:nil].lastObject;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

@end
