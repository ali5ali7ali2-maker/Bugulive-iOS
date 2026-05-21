//
//  SHomeSVideoV.m
//  BuguLive
//
//  Created by 丁凯 on 2017/8/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SHomeSVideoV.h"
#import "SmallVideoCell.h"
#import "SmallVideoListModel.h"
#import "BGVideoDetailController.h"


#import "HMVideoPlayerViewController.h"



@implementation SHomeSVideoV

-(NSMutableArray<XRImage *> *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (instancetype)initWithFrame:(CGRect)frame andUserId:(NSString *)userId
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kBackGroundColor;
        self.user_id = userId;
        [self creatMainView];
        [self requestNetDataWithPage:1];
    }
    return self;
}

- (void)creatMainView
{
//    self.myCollectionLayout = [[UICollectionViewFlowLayout alloc]init];
//    self.myCollectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    self.myCollectionLayout.minimumInteritemSpacing = 5;
//    self.myCollectionLayout.itemSize = CGSizeMake((kScreenW-5*kScaleWidth)/2,(kScreenW-5*kScaleWidth)/2);
    
    self.myCollectionLayout  = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    //或者一次性设置
    [self.myCollectionLayout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.myCollectionLayout.delegate = self;
    
    self.videoCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.height) collectionViewLayout:self.myCollectionLayout];
    self.videoCollectionV.delegate = self;
    self.videoCollectionV.dataSource = self;
    self.videoCollectionV.backgroundColor = kBackGroundColor;
    self.videoCollectionV.pagingEnabled = YES;
    [self.videoCollectionV registerNib:[UINib nibWithNibName:@"SmallVideoCell" bundle:nil] forCellWithReuseIdentifier:@"SmallVideoCell"];
    [self addSubview:self.videoCollectionV];
    [self.videoCollectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
//    [BGMJRefreshManager refresh:self.videoCollectionV target:self headerRereshAction:nil footerRereshAction:@selector(refreshFooter)];
    [BGMJRefreshManager refresh:self.videoCollectionV target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
}

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

-(void)refreshHeader{
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

- (void)requestNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"svideo" forKey:@"ctl"];
    if (self.user_id)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [parmDict setObject:@"video" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (page == 1)
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
            if (self.dataArray.count)
            {
                [self hideNoContentViewOnView:self.videoCollectionV];
            }else
            {
                [self showNoContentViewOnView:self.videoCollectionV];
            }
            [self.videoCollectionV reloadData];
            if (list.count < 20) {
                [self.videoCollectionV.mj_header endRefreshing];
                [self.videoCollectionV.mj_footer endRefreshingWithNoMoreData];
            }else{
                [BGMJRefreshManager endRefresh:self.videoCollectionV];
            }
        }
        else
        {
            [[BGHUDHelper sharedInstance] tipMessage:responseJson[@"error"]];
            [BGMJRefreshManager endRefresh:self.videoCollectionV];
        }
        
    } FailureBlock:^(NSError *error)
     {
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0*kScaleWidth;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row < self.dataArray.count)
    {
//        HMVideoPlayerViewController *vc = [[HMVideoPlayerViewController alloc]initWithVideos:_dataArray index:indexPath.row IsPushed:YES requestDict:nil];
//        vc.isRefreshVideoBlock = ^(BOOL isRefresh) {
//            [self refreshHeader];
//        };
        
        NSLog(@"navigationController%@",[AppDelegate sharedAppDelegate].topViewController.navigationController);
        
 
        
//        [self presentViewController:nav animated:YES completion:nil];
        
//        [[AppDelegate sharedAppDelegate] pushViewController:nav animated:YES];
//        [[AppDelegate sharedAppDelegate].topViewController.navigationController pushViewController:vc animated:YES];
//        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
        
//        SmallVideoListModel *model = _dataArray[indexPath.row];
        if (self.VDelegate)
        {
            [self.VDelegate pushToVideoDetailWithArr:_dataArray index:indexPath.row IsPushed:YES requestDict:nil];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.VDelegate && [self.VDelegate respondsToSelector:@selector(didVideoCollectionViewScrollView:)]) {
        [self.VDelegate didVideoCollectionViewScrollView:scrollView];
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

@end
