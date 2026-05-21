//
//  MSmallVideoVC.m
//  BuguLive
//
//  Created by 丁凯 on 2017/8/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MSmallVideoVC.h"
#import "SSearchVC.h"
#import "SmallVideoCell.h"
#import "SmallVideoListModel.h"
#import "BGVideoDetailController.h"
#import "HMVideoPlayerViewController.h"
#import "BogoVideoPlayViewController.h"

#import "XRWaterfallLayout.h"
#import "XRImage.h"

@interface MSmallVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,XRWaterfallLayoutDelegate>


@property ( nonatomic,strong) XRWaterfallLayout       *myCollectionLayout;
@property ( nonatomic,strong) NSMutableArray                   *dataArray;
@property ( nonatomic,assign) int                              currentPage;
@property ( nonatomic,assign) int                              has_next;

@property (nonatomic, strong) NSMutableArray<XRImage *> *images;

@property(nonatomic, assign) NSInteger page;

@end

@implementation MSmallVideoVC

-(NSMutableArray<XRImage *> *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isHaveNavBar) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.navigationController.navigationBar.hidden = NO;
    }
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    
    
    
}

- (void)initFWUI
{
    [super initFWUI];
    
    [self setupBackBtnWithBlock:nil];
    self.title = ASLocalizedString(@"小视频");
    
//    self.view.backgroundColor = kGreenColor;
    
    self.myCollectionLayout  = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    //或者一次性设置
    [self.myCollectionLayout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    self.myCollectionLayout.delegate = self;
//    self.myCollectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    self.myCollectionLayout.minimumInteritemSpacing = 5;
//    self.myCollectionLayout.itemSize = );
    if (!self.notHaveTabbar)
    {
        self.videoCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-FD_Top_Height-FD_Bottom_Height) collectionViewLayout:self.myCollectionLayout];
    }else
    {
        self.videoCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-FD_Top_Height) collectionViewLayout:self.myCollectionLayout];
    }
    
    self.videoCollectionV.delegate = self;
    self.videoCollectionV.dataSource = self;
    self.videoCollectionV.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self.videoCollectionV registerNib:[UINib nibWithNibName:@"SmallVideoCell" bundle:nil] forCellWithReuseIdentifier:@"SmallVideoCell"];
    [self.view addSubview:self.videoCollectionV];
    [self.videoCollectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    [BGMJRefreshManager refresh:self.videoCollectionV target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
}

- (void)returnCenterVC
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

- (void)refreshHeader
{
    [self requestNetDataWithPage:1];
}

- (void)refreshFooter
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self requestNetDataWithPage:_currentPage];
    }
    else
    {
        [self.videoCollectionV.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestNetDataWithPage:(int)Page
{
    
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        [self.dataArray removeAllObjects];
        [self.images removeAllObjects];
        
        [self.videoCollectionV reloadData];
        [BGMJRefreshManager endRefresh:self.videoCollectionV];
        return;
    }
    
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"svideo" forKey:@"ctl"];
    if (!self.notHaveTabbar)
    {
        [parmDict setObject:@"index" forKey:@"act"];
    }else
    {
        [parmDict setObject:@"video" forKey:@"act"];
    }
    [parmDict setObject:[NSNumber numberWithInt:Page] forKey:@"page"];
    if (self.paramDict) {
        [parmDict setValuesForKeysWithDictionary:self.paramDict];
    }
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (Page == 1)
            { 
                [self.dataArray removeAllObjects];
                [self.images removeAllObjects];
            }
            _has_next = [responseJson toInt:@"has_next"];
            _currentPage = [responseJson toInt:@"page"];
            
            NSString *focus = [responseJson toString:@"is_focus"];
            
            NSArray *list = responseJson[@"data"];
            for ( NSDictionary *dict in list)
            {
                SmallVideoListModel *model = [SmallVideoListModel mj_objectWithKeyValues:dict];
                XRImage *image = [XRImage new];
                image.imageURL = [NSURL URLWithString:model.photo_image];
                model.has_focus = focus;
                [self.images addObject:image];
                [self.dataArray addObject:model];
            }
            [self.videoCollectionV reloadData];
        }
        
        [BGMJRefreshManager endRefresh:self.videoCollectionV];
        
        if (!self.dataArray.count)
        {
            [self showNoContentView];
        }
        else
        {
            [self hideNoContentView];
        }
    } FailureBlock:^(NSError *error) {
        FWStrongify(self)
        [BGMJRefreshManager endRefresh:self.videoCollectionV];
    }];
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallVideoCell" forIndexPath:indexPath];
    SmallVideoListModel *model = self.dataArray[indexPath.row];
    [cell creatCellWithModel:model andRow:(int)indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count)
    {
        //        SmallVideoListModel *model = _dataArray[indexPath.row];
        //        BGVideoDetailController *VideoVC = [[BGVideoDetailController alloc]init];
        //        VideoVC.weibo_id = model.weibo_id;
        //        [[AppDelegate sharedAppDelegate] pushViewController:VideoVC];
//        BogoVideoPlayViewController *vc = [[BogoVideoPlayViewController alloc]initWithModelArr:_dataArray];
        HMVideoPlayerViewController *vc = [[HMVideoPlayerViewController alloc]initWithVideos:_dataArray index:indexPath.item IsPushed:YES requestDict:nil];
        WeakSelf
        vc.isRefreshVideoBlock = ^(BOOL isRefresh) {
            [weakSelf refreshHeader];
        };
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }
}

////每个item之间的横间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//
//    return 10;
//}

////每个item之间的纵间距
// - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    if (section == 0 || section % 3 == 0) {
//        return 10;
//    }
//    return 0;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    if (section == 1) {
//        return UIEdgeInsetsMake(0, 10, 0, 10);
//    }
//    return UIEdgeInsetsMake(-10, 10, 0, 10);
//}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    XRImage *image = self.images[indexPath.item];
    
    if (indexPath.row % 2 == 0) {
        return (kScreenW-30)/2.0f * 1.8;
    }
    
    return (kScreenW-30)/2.0f * 1.4;
//    image.imageH / image.imageW * itemWidth;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.row == 1) {
//        return CGSizeMake((kScreenW-30)/2.0f,(kScreenW-30)/2.0f * 1.5);
//    }
//
//    return CGSizeMake((kScreenW-30)/2.0f,(kScreenW-30)/2.0f * 1.2);
//}

#pragma mark - ----------------------- scrollViewDelegate -----------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


@end
