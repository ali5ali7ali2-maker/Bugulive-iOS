//
//  BogoLiveGoodThingsViewController.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import "BogoLiveGoodThingsViewController.h"
#import <YYKit/YYKit.h>
#import "FDUIKitObjC.h"
#import "BogoLiveGoodThingsCell.h"
#import "BogoShopKit.h"
#import <Masonry/Masonry.h>
#import "BogoShopKit.h"
#import "BogoLiveGoodThingItemModel.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface BogoLiveGoodThingsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BogoLiveGoodThingsCellDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSString *password;

@end

@implementation BogoLiveGoodThingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"直播好物";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self headerRefresh];
}

- (void)headerRefresh{
    _page = 1;
    [self requestData];
}

- (void)footerRefresh{
    _page ++;
    [self requestData];
}

- (void)requestData{
//    /shopapi/shop/liveGoodsUrl?uid=164755&token=11111&page=1
    [[BogoNetwork shareInstance] POST:@"shop/liveGoodsUrl" param:@{@"page":@(self.page)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in result.data) {
            BogoLiveGoodThingItemModel *model = [BogoLiveGoodThingItemModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        NSArray *array = result.data;
        if (array.count < 20) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - BogoLiveGoodThingsCellDelegate
- (void)goodThingsCell:(BogoLiveGoodThingsCell *)goodThingsCell didClickGood:(BogoLiveGoodThingItemModelGoods *)good{
    if (good.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:good.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = good.gid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (void)goodThingsCell:(BogoLiveGoodThingsCell *)goodThingsCell didClickUser:(NSString *)uid{
    [[NSNotificationCenter defaultCenter] postNotificationName:GoToUserPageFromShopKit object:uid];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoLiveGoodThingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoLiveGoodThingsCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        [cell setModel:self.dataArray[indexPath.item]];
    }
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(FD_ScreenWidth - 20, 227);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoLiveGoodThingItemModel *itemModel = self.dataArray[indexPath.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:GoToLiveFromShopKit object:itemModel.mj_keyValues];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 40 - FD_Top_Height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoLiveGoodThingsCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoLiveGoodThingsCell class])];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
