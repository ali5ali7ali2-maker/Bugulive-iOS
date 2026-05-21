//
//  BogoCategoryViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/14.
//

#import "BogoCategoryViewController.h"
#import "BogoCategoryCell.h"
#import "BogoCategoryDetailViewController.h"
#import "BogoShopKit.h"
#import "BogoCategoryModel.h"
#import "FDUIKitObjC.h"
#import "BogoCategorySubCell.h"
#import "BogoShopKit.h"
#import "BogoCategoryHeaderView.h"
#import "BogoGoodSearchViewController.h"
#import "BogoGoodSearchResultViewController.h"
#import "UIImageView+WebCache.h"
#import <YYKit/YYKit.h>
#import <MJExtension/MJExtension.h>
#import "BogoShopCategoryGoodViewController.h"

@interface BogoCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray <BogoCategoryModel *>*dataArray;

@property(nonatomic, assign) NSInteger selectIndex;

@end

@implementation BogoCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"333333"];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCategoryCell class]) bundle:kShopKitBundle] forCellReuseIdentifier:NSStringFromClass([BogoCategoryCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoCategorySubCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoCategorySubCell class])];
    [self.collectionView registerClass:[BogoCategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([BogoCategoryHeaderView class])];
    _selectIndex = 0;
    [self requestData];
    self.title = @"分类";
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, FD_Bottom_SafeArea_Height, 0);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, FD_Bottom_SafeArea_Height, 0);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnAction:(id)sender {
    BogoGoodSearchViewController *searchVC = [[BogoGoodSearchViewController alloc]initWithNibName:NSStringFromClass([BogoGoodSearchViewController class]) bundle:kShopKitBundle];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)requestData{
//    http://xx.com/api/shop/platform_type_list
    __weak __typeof(self)weakSelf = self;
    [[BogoNetwork shareInstance] GET:@"api/platformTypeListUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.dataArray removeAllObjects];
        for (NSDictionary *dict in result.data[@"list"]) {
            BogoCategoryModel *model = [BogoCategoryModel mj_objectWithKeyValues:dict];
            [strongSelf.dataArray addObject:model];
        }
        [strongSelf.tableView reloadData];
        [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [strongSelf tableView:strongSelf.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } failure:^(NSString * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[FDHUDManager defaultManager] show:error ToView:strongSelf.view];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BogoCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BogoCategoryCell class]) forIndexPath:indexPath];
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //更新CollectionView
    _selectIndex = indexPath.row;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count) {
        NSArray *tempArray = self.dataArray[_selectIndex].children;
        return tempArray.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoCategorySubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoCategorySubCell class]) forIndexPath:indexPath];
    NSArray *tempArray = self.dataArray[_selectIndex].children;
    [cell setModel:tempArray[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = floor((FD_ScreenWidth - FD_ScreenWidth * 100/375 - 60) / 3);
    return CGSizeMake(width, width + 27);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        BogoCategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([BogoCategoryHeaderView class]) forIndexPath:indexPath];
//        if (self.dataArray.count) {
//            BogoCategoryModel *model = self.dataArray[_selectIndex];
//            [headerView.imageView sd_setImageWithURL:[NSURL URLWithString:model.banner] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
//        }
//        return headerView;
//    }
//    return nil;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(FD_ScreenWidth - FD_ScreenWidth * 100/375 - 30, 100);
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //进入分类商品列表
    BogoShopCategoryGoodViewController *detailVC = [[BogoShopCategoryGoodViewController alloc]initWithNibName:NSStringFromClass([BogoShopCategoryGoodViewController class]) bundle:kShopKitBundle];
    NSArray *tempArray = self.dataArray[_selectIndex].children;
    BogoCategoryModel *model = tempArray[indexPath.item];
    detailVC.cid = model.sc_id;
    
    BogoCategoryModel *pmodel = self.dataArray[_selectIndex];
    detailVC.pid = pmodel.sc_id;
    detailVC.key = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
