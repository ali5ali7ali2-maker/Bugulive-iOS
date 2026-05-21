//
//  BogoShopViewController.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import "BogoShopViewController.h"
#import "MLMSegmentManager.h"
#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>
#import "BogoShopSelectedViewController.h"
#import "BogoShopKit.h"
#import <QMUIKit/QMUIKit.h>
#import "WMDragView.h"
#import "BogoCategoryModel.h"
#import "BogoShopKit.h"
#import <MJExtension/MJExtension.h>
#import "BogoGoodSearchViewController.h"
#import "BogoCategoryGoodViewController.h"
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"

@interface BogoShopViewController ()

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;

@property(nonatomic, strong) NSMutableArray *vcArray;

@property(nonatomic, strong) QMUIButton *searchBtn;
@property(nonatomic, strong) UIButton *cateBtn;

@property(nonatomic, strong) WMDragView *cartBtn;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BogoShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.searchBtn];
//    [self addSubController];
    [self.view addSubview:self.cartBtn];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)requestData{
    __weak __typeof(self)weakSelf = self;
    [[BogoNetwork shareInstance] GET:@"api/catListUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (NSDictionary *dict in result.data[@"list"]) {
            BogoCategoryModel *model = [BogoCategoryModel mj_objectWithKeyValues:dict];
            [strongSelf.dataArray addObject:model];
        }
        [strongSelf addSubController];
        [strongSelf.view bringSubviewToFront:strongSelf.cartBtn];
        [strongSelf.view addSubview:strongSelf.cateBtn];
    } failure:^(NSString * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[FDHUDManager defaultManager] show:error ToView:strongSelf.view];
    }];
}

- (void)cateBtnAction{
    BogoCategoryViewController *categoryVC = [[BogoCategoryViewController alloc]initWithNibName:NSStringFromClass([BogoCategoryViewController class]) bundle:kShopKitBundle];
    categoryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:categoryVC animated:YES];
}

- (void)searchBtnAction{
    BogoGoodSearchViewController *searchVC = [[BogoGoodSearchViewController alloc]initWithNibName:NSStringFromClass([BogoGoodSearchViewController class]) bundle:kShopKitBundle];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)addSubController {
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:@"精选"];
    for (BogoCategoryModel *model in self.dataArray) {
        [tempArray addObject:model.title];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(10, FD_Top_Height, self.view.fd_width - 42 - 20, 40) titles:tempArray headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutLeft];
    _segHead.tag = 1101;
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#333333"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#777777"];
    _segHead.lineColor = [UIColor colorWithHexString:@"#F34115"];
    _segHead.lineHeight = 3;
    _segHead.selectFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _segHead.deSelectFont = [UIFont systemFontOfSize:16];
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
        for (NSInteger i = 0; i < self.dataArray.count + 1; i++) {
            if (i == 0) {
                BogoShopSelectedViewController *selectVC = [[BogoShopSelectedViewController alloc]init];
                [_vcArray addObject:selectVC];
            }else{
                BogoCategoryGoodViewController *subVC = [[BogoCategoryGoodViewController alloc]init];
                BogoCategoryModel *model = self.dataArray[i - 1];
                subVC.model = model;
                [_vcArray addObject:subVC];
            }
        }
    }
    return _vcArray;
}

- (QMUIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(12, 11 + FD_StatusBar_Height, FD_ScreenWidth - 24, 32)];
        [_searchBtn setTitle:@"输入关键词搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#AAAAAA"] forState:UIControlStateNormal];
        [_searchBtn setImage:imageNamed(@"shop_搜索") forState:UIControlStateNormal];
        [_searchBtn setBackgroundColor:[UIColor colorWithHexString:@"#F4F4F4"]];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _searchBtn.imagePosition = QMUIButtonImagePositionLeft;
        _searchBtn.spacingBetweenImageAndTitle = 5;
        _searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _searchBtn.layer.cornerRadius = 16;
        _searchBtn.clipsToBounds = YES;
        [_searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIButton *)cateBtn{
    if (!_cateBtn) {
        _cateBtn = [[UIButton alloc]initWithFrame:CGRectMake(_segHead.right, FD_Top_Height, 42, 40)];
        [_cateBtn setImage:imageNamed(@"shop_分类") forState:UIControlStateNormal];
        [_cateBtn addTarget:self action:@selector(cateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cateBtn;
}

- (WMDragView *)cartBtn{
    if (!_cartBtn) {
        _cartBtn = [[WMDragView alloc] initWithFrame:CGRectMake(FD_ScreenWidth - 62 - 7, 0 , 60, 62)];
        _cartBtn.backgroundColor = FD_ClearColor;
        _cartBtn.isKeepBounds = NO;
            //设置网络图片
            [_cartBtn.imageView setImage:imageNamed(@"shop_购物车-悬浮按钮")];
            //限定logoView的活动范围
        _cartBtn.freeRect = CGRectMake(0, FD_Top_Height + 40, self.view.frame.size.width, self.view.frame.size.height-FD_Top_Height - FD_Bottom_Height - 62);
        _cartBtn.bottom = self.view.bottom - 40 - FD_Bottom_Height;

            ///点击block
        __weak __typeof(self)weakSelf = self;
        _cartBtn.clickDragViewBlock = ^(WMDragView *dragView){
                
                NSLog(@"点击block");
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            BogoCartViewController *cartVC = [[BogoCartViewController alloc]init];
            cartVC.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:cartVC animated:YES];
                
            };
            ///开始拖曳block
        _cartBtn.beginDragBlock = ^(WMDragView *dragView){
                NSLog(@"开始拖曳");
            };

            ///结束拖曳block
        _cartBtn.endDragBlock = ^(WMDragView *dragView){
                NSLog(@"结束拖曳");

            };
    }
    return _cartBtn;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
