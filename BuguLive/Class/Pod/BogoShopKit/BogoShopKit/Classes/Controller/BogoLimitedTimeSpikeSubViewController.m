//
//  BogoLimitedTimeSpikeSubViewController.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/8.
//

#import "BogoLimitedTimeSpikeSubViewController.h"
#import "BogoLimitedTimeSpikeCell.h"
#import <YYKit/YYKit.h>
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import <Masonry/Masonry.h>
#import "BogoShopKit.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface BogoLimitedTimeSpikeSubViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BogoLimitedTimeSpikeSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
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
//    /shopapi/shop/seckillIndexUrl?uid=200676&token=dbb5e1a7327a551baaffac3d83c75775&time=1626163200
    [[BogoNetwork shareInstance] POST:@"shop/seckillIndexUrl" param:@{@"time":self.time.length ? self.time : @"",@"page":@(self.page)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in result.data[@"goods"]) {
            BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        NSArray *array = result.data[@"goods"];
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

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoLimitedTimeSpikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoLimitedTimeSpikeCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
        
        cell.clickBuyBtnBlock = ^(BogoCommodityDetailModel * _Nonnull model) {
            [self pushBuyShopModel:model];
        };
    }
    return cell;
}

-(void)pushBuyShopModel:(BogoCommodityDetailModel *)model{
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
        detailVC.distribution_id = model.distribution_uid;
    //    detailVC.uid = model.share_uid;
        detailVC.source = BogoShopBuySourceShop;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(FD_ScreenWidth - 20, 120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoCommodityDetailModel *model = self.dataArray[indexPath.item];
    [self pushBuyShopModel:model];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 62 - FD_Top_Height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoLimitedTimeSpikeCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoLimitedTimeSpikeCell class])];
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
