//
//  BogoOtherShopDetailViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/8/29.
//

#import "BogoOtherShopDetailViewController.h"
#import "BogoShopKit.h"
#import "BogoOtherShopDetailSubViewController.h"
#import "MLMSegmentManager.h"
#import <YYKit/YYKit.h>
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import <SDWebImage/SDWebImage.h>
#import <ZLCollectionViewFlowLayout/ZLCollectionViewVerticalLayout.h>
#import "BogoShopSelectedGoodCell.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface BogoOtherShopDetailViewController ()<BogoOtherShopDetailSubViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZLCollectionViewBaseFlowLayoutDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, copy) NSString *key;

@property(nonatomic, strong) MLMSegmentHead *segHead;
@property(nonatomic, strong) MLMSegmentScroll *segScroll;

@property(nonatomic, strong) NSMutableArray <BogoOtherShopDetailSubViewController *>*vcArray;

@property(nonatomic, strong) NSMutableDictionary *param;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *saleBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;

@property(nonatomic, strong) NSMutableArray *heightArray;

@end

@implementation BogoOtherShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"店铺";
    [self.view addSubview:self.collectionView];
    self.saleBtn.imagePosition = QMUIButtonImagePositionRight;
    self.saleBtn.spacingBetweenImageAndTitle = 3;
    self.priceBtn.imagePosition = QMUIButtonImagePositionRight;
    self.priceBtn.spacingBetweenImageAndTitle = 3;

    self.defaultBtn.selected = YES;
    
    [self.param setObject:@"0" forKey:@"type"];
    [self.param setObject:@"1" forKey:@"desc"];

    [self headerRefresh];
    
    [self.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toUserVC)]];
    [self.titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toUserVC)]];
}

- (void)toUserVC{
    [[NSNotificationCenter defaultCenter] postNotificationName:GoToUserPageFromShopKit object:self.user_id];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)defaultBtnAction:(UIButton *)sender {
//    self.lineView.centerX = sender.centerX;
    
    
    
    sender.selected = YES;
    
    [self.param setObject:@"0" forKey:@"type"];
    [self.param setObject:@"1" forKey:@"desc"];
    [self headerRefresh];
    
    self.saleBtn.selected = NO;
    self.priceBtn.selected = NO;
    
    
    [self.saleBtn setImage:imageNamed(@"shop_排序") forState:UIControlStateNormal];
    [self.priceBtn setImage:imageNamed(@"shop_排序") forState:UIControlStateNormal];
    
    [self.priceBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    
    [self.saleBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
}

- (IBAction)saleBtnAction:(QMUIButton *)sender {
    
//    self.saleBtn.selected = NO;
    self.defaultBtn.selected = NO;
    self.priceBtn.selected = NO;
    [self.priceBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    
    sender.selected = !sender.isSelected;
    
    [sender setTitleColor:[UIColor colorWithHexString:@"F42416"] forState:UIControlStateNormal];
    
    self.lineView.centerX = sender.centerX;
    [self.param setObject:@"1" forKey:@"type"];
    if (sender.isSelected) {
        [sender setImage:imageNamed(@"shop_排序- 2") forState:UIControlStateNormal];
        [self.param setObject:@"0" forKey:@"desc"];
    }else{
        [sender setImage:imageNamed(@"shop_排序-1") forState:UIControlStateNormal];
        [self.param setObject:@"1" forKey:@"desc"];
    }
    
    [self headerRefresh];
    
}

- (IBAction)priceBtnAction:(QMUIButton *)sender {
    
    self.saleBtn.selected = NO;
    self.defaultBtn.selected = NO;
    [self.saleBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    
    sender.selected = !sender.isSelected;
    
    [sender setTitleColor:[UIColor colorWithHexString:@"F42416"] forState:UIControlStateNormal];
    self.lineView.centerX = sender.centerX;
    
    [self.param setObject:@"2" forKey:@"type"];
    if (sender.isSelected) {
        [sender setImage:imageNamed(@"shop_排序- 2") forState:UIControlStateNormal];
        [self.param setObject:@"0" forKey:@"desc"];
    }else{
        [sender setImage:imageNamed(@"shop_排序-1") forState:UIControlStateNormal];
        [self.param setObject:@"1" forKey:@"desc"];
    }
    [self headerRefresh];
}

- (void)setUser_id:(NSString *)user_id{
    _user_id = user_id;
//    [self addSubController];
//    [self headerRefresh];
}

- (void)headerRefresh{
    _page = 1;
    [self requestData];
}

- (void)footerRefresh{
    _page ++;
    [self requestData];
}

- (void)addSubController{
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(15, 80, self.view.fd_width - 15, 40) titles:@[@"平台商品",@"个人商品"] headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutLeft];
    //tab颜色
    _segHead.selectColor = [UIColor colorWithHexString:@"#F46628"];
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#333333"];
    _segHead.lineColor = [UIColor colorWithHexString:@"#F46628"];
    _segHead.lineHeight = 3;
    _segHead.fontSize = 14;
    _segHead.fontScale = 1;
    _segHead.lineScale = .5;
    _segHead.headColor = FD_WhiteColor;
    _segHead.bottomLineHeight = 0;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), FD_ScreenWidth, FD_ScreenHeight -  - CGRectGetMaxY(_segHead.frame)) vcOrViews:self.vcArray];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    __weak __typeof(self)weakSelf = self;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll contentChangeAni:YES completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view addSubview:strongSelf.segHead];
        [strongSelf.view addSubview:strongSelf.segScroll];
    } selectEnd:^(NSInteger index) {
        NSLog(@"当前滚动到:%ld",index);
        if (!self.vcArray[index].dataArray.count) {
            [self.vcArray[index] headerRefresh];
        }
    }];
}

- (void)requestData{
    [self.param setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [self.param setObject:self.user_id forKey:@"to_user_id"];
    [self.param setObject:@(self.page) forKey:@"page"];
//    [self.param setObject:self.key.length ? self.key : @"" forKey:@"key"];
//    http://xx.com/api/Shopmanage/get_other_shop_info
    [[BogoNetwork shareInstance] GET:@"shop/shopGoodsUrl" param:self.param success:^(BogoNetworkResponseModel * _Nonnull result) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in result.data[@"lists"]) {
            BogoCommodityDetailModel *model = [BogoCommodityDetailModel mj_objectWithKeyValues:dict];
            [self.dataArray addObject:model];
            [self.heightArray addObject:@(250)];
        }
        [self.collectionView reloadData];
        NSDictionary *userinfo = result.data[@"user"];
        NSString *nick_name = [NSString stringWithFormat:@"%@",userinfo[@"shop_name"]];
        NSString *head_image = [NSString stringWithFormat:@"%@",userinfo[@"head_image"]];

        NSString *shop_image = [NSString stringWithFormat:@"%@",userinfo[@"shop_logo"]];
        [self.titleLabel setText:[NSString stringWithFormat:@"%@",nick_name]];
        self.title = [NSString stringWithFormat:@"%@的店铺",userinfo[@"nick_name"]];
        if (shop_image.length > 10) {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shop_image]];
        }else{
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_image]];
        }
        
        [self.collectionView.mj_header endRefreshing];
        NSArray *array = result.data[@"lists"];
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
    BogoShopSelectedGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BogoShopSelectedGoodCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        [cell setModel:self.dataArray[indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BogoCommodityDetailModel *model = self.dataArray[indexPath.item];
    if (model.model_id.integerValue == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
    }else{
        BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc]init];
        detailVC.gid = model.gid;
    //            detailVC.distribution_id = model.distribution_uid;
        detailVC.uid = model.uid;
        detailVC.source = BogoShopBuySourceShop;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
}

- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section{
    return ClosedLayout;
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
//            [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:model.icon] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
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



- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}


#pragma mark - BogoOtherShopDetailSubViewControllerDelegate
- (void)shopDetailVC:(BogoOtherShopDetailSubViewController *)shopDetailVC didHeaderRefresh:(NSDictionary *)param{
    [self.param setValuesForKeysWithDictionary:param];
    [self requestData];
}

- (void)shopDetailVC:(BogoOtherShopDetailSubViewController *)shopDetailVC didFooterRefresh:(NSDictionary *)param{
    [self.param setValuesForKeysWithDictionary:param];
    [self requestData];
}

- (NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        BogoOtherShopDetailSubViewController *platformVC = [[BogoOtherShopDetailSubViewController alloc]initWithNibName:NSStringFromClass([BogoOtherShopDetailSubViewController class]) bundle:kShopKitBundle];
        platformVC.user_id = self.user_id;
        platformVC.type = 2;
        platformVC.delegate = self;
        [_vcArray addObject:platformVC];
        BogoOtherShopDetailSubViewController *personalVC = [[BogoOtherShopDetailSubViewController alloc]initWithNibName:NSStringFromClass([BogoOtherShopDetailSubViewController class]) bundle:kShopKitBundle];
        platformVC.user_id = self.user_id;
        personalVC.type = 1;
        personalVC.delegate = self;
        [_vcArray addObject:personalVC];
    }
    return _vcArray;
}

- (NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.canDrag = NO;
        flowLayout.isFloor = NO;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 120, FD_ScreenWidth, FD_ScreenHeight - 120 - FD_Top_Height) collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, FD_Bottom_SafeArea_Height, 0);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BogoShopSelectedGoodCell class]) bundle:kShopKitBundle] forCellWithReuseIdentifier:NSStringFromClass([BogoShopSelectedGoodCell class])];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _collectionView;
}

- (NSMutableArray *)heightArray{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

@end
