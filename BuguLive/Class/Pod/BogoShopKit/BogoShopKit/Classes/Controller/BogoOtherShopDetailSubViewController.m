//
//  BogoOtherShopDetailSubViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/8/29.
//

#import "BogoOtherShopDetailSubViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <QMUIKit/QMUIKit.h>
#import "BogoShopKit.h"
#import "BogoShopDetailGoodCell.h"
#import "FDUIKitObjC.h"

@interface BogoOtherShopDetailSubViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (unsafe_unretained, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableDictionary *param;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *defaultBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *saleBtn;
@property (unsafe_unretained, nonatomic) IBOutlet QMUIButton *priceBtn;
@property(nonatomic, assign) NSInteger orderno;

@end

@implementation BogoOtherShopDetailSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopDetailGoodCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoShopDetailGoodCell class])];
}

- (void)reloadData:(NSArray *)dataArray{
    if (_page == 1) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:dataArray];
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
    if (dataArray.count < 20) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.collectionView.mj_footer endRefreshing];
    }
}

- (void)setType:(NSInteger)type{
    _page = 1;
    _type = type;
    [self.param setObject:@(_page) forKey:@"page"];
    [self.param setObject:@(_type) forKey:@"type"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopDetailVC:didHeaderRefresh:)]) {
        [self.delegate shopDetailVC:self didHeaderRefresh:self.param];
    }
}

- (void)headerRefresh{
    _page = 1;
    [self.param setObject:@(_page) forKey:@"page"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopDetailVC:didHeaderRefresh:)]) {
        [self.delegate shopDetailVC:self didHeaderRefresh:self.param];
    }
}

- (void)footerRefresh{
    _page ++;
    [self.param setObject:@(_page) forKey:@"page"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopDetailVC:didHeaderRefresh:)]) {
        [self.delegate shopDetailVC:self didHeaderRefresh:self.param];
    }
}

- (IBAction)defaultBtnAction:(UIButton *)sender {
    sender.selected = YES;
    self.saleBtn.selected = NO;
    self.priceBtn.selected = NO;
    _orderno = 0;
    [self.param setObject:@(_orderno) forKey:@"orderno"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopDetailVC:didHeaderRefresh:)]) {
        [self.delegate shopDetailVC:self didHeaderRefresh:self.param];
    }
}

- (IBAction)saleBtnAction:(UIButton *)sender {
    sender.selected = YES;
    self.defaultBtn.selected = NO;
    self.priceBtn.selected = NO;
    _orderno = 3;
    [self.param setObject:@(_orderno) forKey:@"orderno"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopDetailVC:didHeaderRefresh:)]) {
        [self.delegate shopDetailVC:self didHeaderRefresh:self.param];
    }
}

- (IBAction)priceBtnAction:(UIButton *)sender {
    sender.selected = YES;
    self.defaultBtn.selected = NO;
    self.saleBtn.selected = NO;
    if (_orderno == 0 || _orderno == 3) {
        _orderno = 2;
        [sender setImage:imageNamed(@"排序Up") forState:UIControlStateSelected];
    }else{
        _orderno = 1;
        [sender setImage:imageNamed(@"排序Down") forState:UIControlStateSelected];
    }
    [self.param setObject:@(_orderno) forKey:@"orderno"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopDetailVC:didHeaderRefresh:)]) {
        [self.delegate shopDetailVC:self didHeaderRefresh:self.param];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoShopDetailGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoShopDetailGoodCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((FD_ScreenWidth - 30) / 2, (FD_ScreenWidth - 30) / 2 + 55);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BogoCommodityDetailModel *model = self.dataArray[indexPath.item];
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

@end
