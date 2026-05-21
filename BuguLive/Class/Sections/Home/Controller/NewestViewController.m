
//
//  NewestViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "NewestViewController.h"
#import "cuserModel.h"
#import "LivingModel.h"
#import "HMHotModel.h"
#import "OneSectionCell.h"
#import "WebModels.h"
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#import "DistanceModel.h"
#import "NewestItemCell.h"

#import "SDCycleScrollView.h"
#import "AdJumpViewModel.h"
//富豪榜
//#import "MGRecommdHeadView.h"
#import "BogoHomeSubTitleView.h"

NS_ENUM(NSInteger ,NewEstiewTableView)
{
    FWNewEstFirstSection,                //直播间的画面
    FWNewEstTab_Count,
};

// 广告图默认滚动时间
static float const bannerAutoScrollTimeInterval = 7;
static NSString *firstHeaderViewIdentifier = @"firstHederview";
static NSString *secondHeaderViewIdentifier = @"secondHederview";

@interface NewestViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

@property ( nonatomic,strong) UICollectionView                *collectionView;      //CollectionView
@property ( nonatomic,strong) UICollectionViewFlowLayout      *layout;
@property ( nonatomic,assign) int                             page;
@property ( nonatomic,assign) int                             has_next;
@property ( nonatomic,strong) NSMutableArray                  *dataArray;           //数据源
@property ( nonatomic,strong) NSMutableArray                  *recommandArr;           //数据源
@property ( nonatomic,strong) NSMutableArray                  *titleArray;
//@property ( nonatomic,strong) UIView                          *NoThingView;
@property (nonatomic, strong) SDCycleScrollView         *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *bannArr;

@property(nonatomic, strong) BogoHomeSubTitleView *headView;

@property(nonatomic, strong) QMUIButton *firstBtn;
@property(nonatomic, strong) QMUIButton *secondBtn;
//@property(nonatomic, strong) UILabel *secondL;
@property(nonatomic, assign) BOOL isClicking;
@end

@implementation NewestViewController


-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, kScreenW - 20, kRealValue(97)) delegate:self placeholderImage:nil];
        self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView.currentPageDotColor = kAppMainColor; // 自定义分页控件小圆标颜色
        self.cycleScrollView.autoScrollTimeInterval = bannerAutoScrollTimeInterval;
        self.cycleScrollView.backgroundColor = kWhiteColor;
        self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        self.cycleScrollView.layer.cornerRadius = 10;
        self.cycleScrollView.clipsToBounds = YES;
    }
    return _cycleScrollView;
}

-(QMUIButton *)firstBtn{
    if (!_firstBtn) {
        _firstBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _firstBtn.frame = CGRectMake(kRealValue(15), self.headView.bottom, kScreenW * 0.8, kRealValue(55));
        [_firstBtn setTitle:ASLocalizedString(@"推荐主播") forState:UIControlStateNormal];
        [_firstBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_firstBtn setImage:[UIImage imageNamed:@"bogo_home_top_recommand"] forState:UIControlStateNormal];
        _firstBtn.spacingBetweenImageAndTitle = 2;
        if(self.view.isRTL)
        {
            _firstBtn.imagePosition = QMUIButtonImagePositionRight;
            _firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;


        }
        else
        {
            _firstBtn.imagePosition = QMUIButtonImagePositionLeft;
            _firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        }
//        _firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _firstBtn;
}

-(QMUIButton *)secondBtn{
    if (!_secondBtn) {
        _secondBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _secondBtn.frame = CGRectMake(kRealValue(15), 0, kScreenW * 0.5, kRealValue(55));
        _secondBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_secondBtn setTitle:ASLocalizedString(@"热门主播") forState:UIControlStateNormal];
        [_secondBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_secondBtn setImage:[UIImage imageNamed:@"bogo_home_top_recommand"] forState:UIControlStateNormal];
        _secondBtn.spacingBetweenImageAndTitle = 2;
        _secondBtn.imagePosition = QMUIButtonImagePositionLeft;
        _secondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        UIControlContentHorizontalAlignmentLeft;
    }
    return _secondBtn;
}

-(BogoHomeSubTitleView *)headView{
    if (!_headView) {
        _headView = [[BogoHomeSubTitleView alloc]initWithFrame:CGRectMake(0, self.cycleScrollView.bottom + 5, kScreenW, kRealValue(56))];
    }
    return _headView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [GlobalVariables sharedInstance].appModel.open_noble = @"1";
}

- (void)initFWUI
{
    [super initFWUI];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _dataArray = [[NSMutableArray alloc]init];
    _recommandArr = [[NSMutableArray alloc]init];
    _titleArray = [[NSMutableArray alloc]init];
    [self creatView];
    
    _isClicking = NO;
}

- (void)initFWData
{
    [super initFWData];
    [self loadDataWithPage:1];
}

#pragma mark 创建UICollectionView

- (void)creatView
{
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    if ([self.types isEqualToString:@"1"]) { _layout.headerReferenceSize=CGSizeMake(self.view.frame.size.width,self.cycleScrollView.height + 10); //设置collectionView头视图的大小
        _layout.itemSize = CGSizeMake((kScreenW-30)/2.0f,(kScreenW-30)/2.0f);
    }else{
        _layout.minimumInteritemSpacing = 3;
        _layout.minimumLineSpacing = 3;
        _layout.itemSize = CGSizeMake((kScreenW-3)/2,(kScreenW-3)/2);
    }
    
    
    CGRect tmpFrame;
    if (_collectionViewFrame.size.height)
    {
//        tmpFrame = _collectionViewFrame;
        tmpFrame = CGRectMake(0, 0, kScreenW, _collectionViewFrame.size.height - self.headView.height);
    }
    else
    {
        tmpFrame = CGRectMake(0, 0, kScreenW, kScreenH - kRealValue(120) - kTabBarHeight - MG_BOTTOM_MARGIN);
//                              kStatusBarHeight-kTabBarHeight - 22 - 50 + MG_BOTTOM_MARGIN);
    }
    _collectionView = [[UICollectionView alloc]initWithFrame:tmpFrame collectionViewLayout:_layout];
    //    [_collectionView registerClass:[OneSectionCell class] forCellWithReuseIdentifier:@"OneSectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"NewestItemCell" bundle:nil] forCellWithReuseIdentifier:@"NewestItemCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:firstHeaderViewIdentifier];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:secondHeaderViewIdentifier];
    _collectionView.backgroundColor = kClearColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    //刷新该页面（主要为了删除最新页已经退出的直播间）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome:) name:@"refreshHome" object:nil];
    [BGMJRefreshManager refresh:_collectionView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerReresh)];
}

#pragma mark ==========================通知==========================
- (void)refreshHome:(NSNotification *)noti
{
    if (noti)
    {
        NSDictionary *tmpDict = (NSDictionary *)noti.object;
        NSString *room_id = [tmpDict toString:@"room_id"];
        @synchronized (_dataArray)
        {
            NSMutableArray *tmpArray = _dataArray;
            for (LivingModel *model in tmpArray)
            {
                if (model.room_id == [room_id intValue])
                {
                    [tmpArray removeObject:model];
                    _dataArray = tmpArray;
                    [_collectionView reloadData];
                    return;
                }
            }
        }
    }
}

#pragma mark 头部刷新
- (void)headerReresh
{
    [self loadDataWithPage:1];
}

#pragma mark 尾部刷新
- (void)footerReresh
{
    if (_has_next == 1)
    {
        _page ++;
        [self loadDataWithPage:_page];
    }
    else
    {
        [BGMJRefreshManager endRefresh:_collectionView];
    }
}

#pragma mark 网络加载
- (void)loadDataFromNet:(int)page{
    [self loadDataWithPage:page];
}

- (void)loadDataWithPage:(int)page
{
    
    
    
    //全部主播
    self.bannArr = @[];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    if ([self.types isEqualToString:@"1"]){
//        || [self.types isEqualToString:@"2"]) {
        [parmDict setObject:@"index" forKey:@"ctl"];
        [parmDict setObject:@"index" forKey:@"act"];
        
        if (![BGUtils isBlankString:_sexString])
        {
            [parmDict setObject:_sexString forKey:@"sex"];
        }
        if (![BGUtils isBlankString:_areaString])
        {
            [parmDict setObject:_areaString forKey:@"city"];
        }
        if (![BGUtils isBlankString:self.cate_id])
        {
            [parmDict setObject:self.cate_id forKey:@"cate_id"];
        }
    }else if ([self.types isEqualToString:@"2"]){
        [parmDict setObject:@"index" forKey:@"ctl"];
        [parmDict setObject:@"new_video" forKey:@"act"];
    }
    else{
        
    }
    
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             _has_next = [responseJson toInt:@"has_next"];
             _page = [responseJson toInt:@"page"];
             if (_page == 1)
             {
                 [_dataArray removeAllObjects];
                 [_titleArray removeAllObjects];
                 [_recommandArr removeAllObjects];
             }
             //直播数组
             NSArray *listArray = [responseJson objectForKey:@"list"];
             NSArray *bannArr  = [responseJson objectForKey:@"banner"];
             NSArray *recommandArr = [responseJson objectForKey:@"recommend_list"];
             NSMutableArray *tmpMArray = [NSMutableArray array];
             self.bannArr = [NSMutableArray array];
             for (NSDictionary *dic in bannArr)
             {
                 HMHotBannerModel *bannerModel = [HMHotBannerModel mj_objectWithKeyValues:dic];
                 [self.bannArr addObject:bannerModel];
                 [tmpMArray addObject:bannerModel.image];
//                 [tmpMArray addObject:[dic valueForKey:@"image"]];
             }
             
             // 加载延迟
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 
                 self.cycleScrollView.imageURLStringsGroup = tmpMArray;
                 
             });
             //推荐主播
//             NSMutableArray *recommadList = [[NSMutableArray alloc]init];
             if (recommandArr && [recommandArr isKindOfClass:[NSArray class]])
             {
                 if (recommandArr.count > 0)
                 {
                     for (NSDictionary *dict in recommandArr)
                     {
                         LivingModel *model = [LivingModel mj_objectWithKeyValues:dict];
                         model.xponit = [dict toFloat:@"xpoint"];
                         model.yponit = [dict toFloat:@"ypoint"];
                         [self.recommandArr addObject:model];
                     }
                 }
             }
             //全部主播
             NSMutableArray *listMArray = [[NSMutableArray alloc]init];
             if (listArray && [listArray isKindOfClass:[NSArray class]])
             {
                 if (listArray.count > 0)
                 {
                     for (NSDictionary *dict in listArray)
                     {
                         LivingModel *model = [LivingModel mj_objectWithKeyValues:dict];
                         
                         
                         model.xponit = [dict toFloat:@"xpoint"];
                         model.yponit = [dict toFloat:@"ypoint"];
                         [listMArray addObject:model];
                     }
                 }
             }
             
             
             
             QMapPoint point1 = QMapPointForCoordinate(CLLocationCoordinate2DMake(self.BuguLive.longitude,self.BuguLive.latitude));
             DistanceModel *distanceModel = [[DistanceModel alloc]init];
             if([self.types isEqualToString:@"1"])
             {
                 _dataArray = listMArray;
             }
             else
             {
                 if (listMArray.count)
                 {
                     _dataArray = [distanceModel CalculateDistanceWithArray:listMArray andPoint:point1];
                 }
             }
             [_collectionView reloadData];
             
//             if (!_dataArray.count)
//             {
//                 [self showNoContentView];
//                 //                 self.NoThingView.hidden = NO;
//             }else
//             {
                 [self hideNoContentView];
                 //                   self.NoThingView.hidden = YES;
//             }
         }
         [BGMJRefreshManager endRefresh:_collectionView];
         
     } FailureBlock:^(NSError *error)
     {
         [BGMJRefreshManager endRefresh:_collectionView];
     }];
}



//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        if (indexPath.section == 0) {
            UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:firstHeaderViewIdentifier forIndexPath:indexPath];
            
            //头视图添加view
//            if (!_firstL) {
//                self.firstBtn.frame = CGRectMake(kRealValue(15), self.headView.bottom, kScreenW * 0.5, kRealValue(55));
            self.firstBtn.top =  self.headView.bottom;
            
            self.secondBtn.top = self.cycleScrollView.bottom;
            
                [header addSubview:self.cycleScrollView];
            
            [header addSubview:self.headView];

                [header addSubview:self.firstBtn];
            //        _firstBtn.frame = CGRectMake(kRealValue(15), self.headView.bottom, kScreenW * 0.8, kRealValue(55));

            //使用Masonry适配RTL
            [_firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headView.mas_bottom).offset(15);
                make.leading.equalTo(self.headView).offset(15);
                make.width.equalTo(@(kScreenW * 0.8));
                make.height.equalTo(@55);
            }];
            if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version] || ![self.types isEqualToString:@"1"]) {
                self.headView.hidden = self.firstBtn.hidden = YES;
            }
            return header;
        }
        else if (indexPath.section == 1) {
            UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:secondHeaderViewIdentifier forIndexPath:indexPath];
            header.hidden = YES;
            //头视图添加view
//            if (!_secondL) {
         
//                [header addSubview:self.secondBtn];
//            if (![self.types isEqualToString:@"1"]) {
//                self.secondBtn.hidden = YES;
//                self.cycleScrollView.hidden = YES;
//            }
            
//            }
            return header;
        }
    }
    return nil;
}

#pragma mark UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
//    FWNewEstTab_Count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (![self.types isEqualToString:@"1"]) {
            return CGSizeMake(0, 0);;
    //       return CGSizeMake(kScreenW, kRealValue(120));
    }
    
    if (section == 0) {
        
        if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version] || ![self.types isEqualToString:@"1"]) {
            return CGSizeMake(0, 0);
        }
        return CGSizeMake(kScreenW, self.firstBtn.bottom - 10);
    }
    
    return CGSizeMake(kScreenW, 1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (![self.types isEqualToString:@"1"]) {
            return 0;
        }
        return self.recommandArr.count;
    }else{
        return _dataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        NewestItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewestItemCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        if (_recommandArr.count > 0) {
            LivingModel *LModel = _recommandArr[indexPath.row];
            [cell setCellContent:LModel Type:[self.types intValue]];
        }
        return cell;
    }else{
        NewestItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewestItemCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        if (_dataArray.count > 0) {
            LivingModel *LModel = _dataArray[indexPath.row];
            [cell setCellContent:LModel Type:[self.types intValue]];
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if ([_types isEqualToString:@"1"] || [_types isEqualToString:@"2"]) {
        return CGSizeMake((kScreenW-30)/2.0f, (kScreenW-30) / 2.0f + kRealValue(32));
//    }
//    return CGSizeMake((kScreenW-3)/2, (kScreenW-3)/2 + kRealValue(32));
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([_types isEqualToString:@"1"] ) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    if ( [_types isEqualToString:@"2"]) {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark  跳转到在线直播
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isClicking) {
      return;
    }
    _isClicking = YES;
    
    // 1 秒后将 _isClicking 置为 NO
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_isClicking = NO;
    });
    
    LivingModel *model;
    if (indexPath.section == 0) {
        model = _recommandArr[indexPath.row];
    }else{
        model = _dataArray[indexPath.row];
    }
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(pushToLiveController:modelArr:isFirstJump:)])
        {
            [self.delegate pushToLiveController:model modelArr:self.dataArray isFirstJump:YES];
        }
    }
}


#pragma mark 跳转到直播的tableView
- (void)GotoNextViewWithBlockTag:(int)tag
{
    cuserModel *model = _titleArray[tag];
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(pushToNextControllerWithModel:)])
        {
            [self.delegate pushToNextControllerWithModel:model];
        }
    }
}


-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    HMHotBannerModel *hotBannerModel = [self.bannArr objectAtIndex:index];
    if ([AdJumpViewModel adToOthersWith:hotBannerModel])
    {
        [[AppDelegate sharedAppDelegate]pushViewController:[AdJumpViewModel adToOthersWith:hotBannerModel] animated:YES];
    }
}




@end
