//
//  BogoCategoryGoodViewController.m
//  BogoShopKit
//
//  Created by Mac on 2021/8/28.
//

#import "BogoCategoryGoodViewController.h"
#import "BogoShopKit.h"
#import "BogoShopBannerModel.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import "BogoShopSelectedHeaderView.h"
#import <ZLCollectionViewFlowLayout/ZLCollectionViewVerticalLayout.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/SDWebImage.h>
#import "BogoCategoryModel.h"
#import "BogoShopSelectedGoodCell.h"

@interface BogoCategoryGoodViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZLCollectionViewBaseFlowLayoutDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *bannerArray;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *heightArray;

@end

@implementation BogoCategoryGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
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
//    /shopapi/shop/shopIndexUrl?uid=165999&token=dbb5e1a7327a551baaffac3d83c75775
    [[BogoNetwork shareInstance] GET:@"api/platformChildrenGoodsUrl" param:@{@"page":@(_page),@"pid":self.model.sc_id} success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
            [self.heightArray removeAllObjects];
        }
        NSArray *array = result.data[@"data"];
        for (NSDictionary *dict in array) {
            BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
            [self.heightArray addObject:@(250)];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
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
    BogoShopSelectedGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoShopSelectedGoodCell class])
                                                                               forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    __block BogoCommodityDetailModel *model = self.dataArray[indexPath.item];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.icon];
    if (!cacheImage) {
        cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:model.icon];
    }
    if (!cacheImage) {
        cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:model.icon];
    }
    if (cacheImage) {
        CGFloat imageHeight = cacheImage.size.height * (FD_ScreenWidth - 40) / (2 * cacheImage.size.width);
        NSLog(@"第%ld个Cell的高度为%.2f",indexPath.item,imageHeight + 110);
        self.heightArray[indexPath.item] = @(110 + imageHeight);
        return CGSizeMake((FD_ScreenWidth - 40) / 2, 110 + imageHeight);
    }else{
        if ([self.heightArray[indexPath.item] integerValue] != 250) {
            return CGSizeMake((FD_ScreenWidth - 40) / 2, [self.heightArray[indexPath.item] floatValue]);
        }
        //            [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:model.icon]    completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        //                if (image) {
        //                    CGFloat newImageHeight = image.size.height * (FD_ScreenWidth - 40) / (2 * image.size.width);
        //                    self.heightArray[indexPath.item] = @(newImageHeight + 87);
        //                    NSInteger index = [self.dataArray indexOfObject:model];
        //                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:2]]];
        //                }
        //            }];
        return CGSizeMake((FD_ScreenWidth - 40) / 2, [self.heightArray[indexPath.item] floatValue]);
    }
}

- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section{
    return ClosedLayout;
}

- (CGRect)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout rectOfItem:(NSIndexPath*)indexPath{
    return CGRectZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoCommodityDetailModel *model = self.dataArray[indexPath.item];
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.canDrag = NO;
        flowLayout.isFloor = NO;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight - 40 - FD_Top_Height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopSelectedGoodCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoShopSelectedGoodCell class])];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _collectionView;
}

- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)heightArray{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

@end
