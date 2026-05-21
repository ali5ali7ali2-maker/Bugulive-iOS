//
//  BogoShopDetailViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/7.
//

#import "BogoShopDetailViewController.h"
#import "BogoShopDetailHeaderView.h"
#import "BogoShopDetailTopCell.h"
#import "BogoShopDetailGoodCell.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoShopDetailModel.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "BogoNetworkKit.h"
#import "BogoNetworkResponseModel.h"
@interface BogoShopDetailViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) BogoShopDetailModel *model;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BogoShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageNamed(@"分享-shop") style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnAction)];
}

- (void)setSid:(NSString *)sid{
    _sid = sid;
    [self headerRefresh];
}

- (void)shareBtnAction{
    
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
//    http://xx.com/api/Shopmanage/get_other_shop_info
    [[BogoNetwork shareInstance] GET:@"api/getOtherShopInfoUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"sid":self.sid,@"page":@(_page)} success:^(BogoNetworkResponseModel * _Nonnull result) {
        BogoShopDetailModel *model = [BogoShopDetailModel mj_objectWithKeyValues:result.data];
        NSMutableArray *array = [NSMutableArray arrayWithArray:model.list.data];
        if (self->_page == 1) {
            model.list.data = array;
        }else{
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.model.list.data];
            [tempArray addObjectsFromArray:array];
            model.list.data = tempArray;
        }
        self.model = model;
        self.title = self.model.shop_info.title;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.model.list.data.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BogoShopDetailTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoShopDetailTopCell class]) forIndexPath:indexPath];
        [cell setModel:self.model];
        return cell;
    }
    BogoShopDetailGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoShopDetailGoodCell class]) forIndexPath:indexPath];
    [cell setModel:self.model.list.data[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(FD_ScreenWidth, 195);
    }
    return CGSizeMake((FD_ScreenWidth - 30) / 2, (FD_ScreenWidth - 30) / 2 + 55);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 1) {
            BogoShopDetailHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([BogoShopDetailHeaderView class]) forIndexPath:indexPath];
            [header setNumber:self.model.shop_info.goods_num];
            return header;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return CGSizeMake(FD_ScreenWidth, 45);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return;
    }
    
    
    BogoCommodityDetailModel *model = self.model.list.data[indexPath.item];
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = FD_WhiteColor;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopDetailTopCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoShopDetailTopCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopDetailGoodCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoShopDetailGoodCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopDetailHeaderView class]) bundle:kShopKitBundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([BogoShopDetailHeaderView class])];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _collectionView;
}

@end
