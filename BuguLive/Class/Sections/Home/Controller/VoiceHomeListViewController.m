
//
//  NewestViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "VoiceHomeListViewController.h"
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
#import "MLMSegmentManager.h"
#import "MLMSegmentScroll.h"
#import "MLMSegmentHead.h"
#import "VideoViewController.h"
#import "VoiceListViewController.h"
// 广告图默认滚动时间
#import "BogoSearchViewController.h"

//新的滑动页面
#import <GKPageSmoothView/GKPageSmoothView.h>
#import "GKPageSmoothView.h"
#import "GKDBListView.h"

#import <JXCategoryViewExt/JXCategoryView.h>
#import "BogoJXCategoryView.h"
static float const bannerAutoScrollTimeInterval = 7;
static NSString *firstHeaderViewIdentifier = @"firstHederview";
static NSString *secondHeaderViewIdentifier = @"secondHederview";

@interface VoiceHomeListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,PushToLiveControllerDelegate,GKPageSmoothViewDataSource, GKPageSmoothViewDelegate, JXCategoryViewDelegate>

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

//分类导航
@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle mlmLayout;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic, strong) NSMutableArray                            *itemTitleMutableArray;         // 完整的分类标题容器
@property (nonatomic, strong) NSMutableArray    *classifiedModelMutableArray;   //
@property(nonatomic, strong) NSArray *listArr;


//新滚动
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) GKPageSmoothView *smoothView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIView    *segmentedView;

@property (nonatomic, strong) BogoJXCategoryView *categoryView;

@property (nonatomic, strong) JXCategoryIndicatorAlignmentLineView *lineView;
@property(nonatomic, strong) NSArray <UIViewController *>*vcArray;
@end

@implementation VoiceHomeListViewController


-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, kScreenW - 20, kRealValue(94)) delegate:self placeholderImage:nil];
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
        _firstBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _firstBtn.frame = CGRectMake(kRealValue(15), self.cycleScrollView.bottom + kRealValue(10), kScreenW * 0.8, kRealValue(55));
        [_firstBtn setTitle:ASLocalizedString(@"Popular recommendation") forState:UIControlStateNormal];
        [_firstBtn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
        [_firstBtn setImage:[UIImage imageNamed:@"推荐"] forState:UIControlStateNormal];
        _firstBtn.spacingBetweenImageAndTitle = 6;
        _firstBtn.imagePosition = QMUIButtonImagePositionLeft;
        _firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if(self.view.isRTL)
        {
            _firstBtn.imagePosition = QMUIButtonImagePositionRight;
            _firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
    }
    return _firstBtn;
}

-(QMUIButton *)secondBtn{
    if (!_secondBtn) {
        _secondBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _secondBtn.frame = CGRectMake(kRealValue(16), 0, kScreenW * 0.5, kRealValue(55));
        _secondBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_secondBtn setTitle:ASLocalizedString(@"热门主播") forState:UIControlStateNormal];
        [_secondBtn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
        [_secondBtn setImage:[UIImage imageNamed:@"推荐"] forState:UIControlStateNormal];
        _secondBtn.spacingBetweenImageAndTitle = 2;
        _secondBtn.imagePosition = QMUIButtonImagePositionLeft;
//        _secondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
    
    
    //左上角添加标题
    //Voice room
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kStatusBarHeight + 15, 200, 44)];
    titleLabel.text = @"Voice room";
    titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];

   
    _dataArray = [[NSMutableArray alloc]init];
    _recommandArr = [[NSMutableArray alloc]init];
    _titleArray = [[NSMutableArray alloc]init];
    [self creatView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initFWUI
{
    [super initFWUI];

}

- (void)initFWData
{
    [super initFWData];
    [self loadDataWithPage:1];
}

#pragma mark 创建UICollectionView

- (void)creatView
{
    self.view.backgroundColor = kWhiteColor;
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    if ([self.types isEqualToString:@"1"]) { _layout.headerReferenceSize=CGSizeMake(self.view.frame.size.width,self.cycleScrollView.height + 10); //设置collectionView头视图的大小
        _layout.itemSize = CGSizeMake((kScreenW-30)/2.0f,(kScreenW-30)/2.0f);
    }else{
        _layout.minimumInteritemSpacing = 3;
        _layout.minimumLineSpacing = 3;
        _layout.itemSize = CGSizeMake((kScreenW-30)/2,(kScreenW-3)/2);
    }

    
    CGRect tmpFrame;
    if (_collectionViewFrame.size.height)
    {
//        tmpFrame = _collectionViewFrame;
        tmpFrame = CGRectMake(0, 0, kScreenW, _collectionViewFrame.size.height - self.headView.height);
    }
    else
    {
        tmpFrame = CGRectMake(0, 0, kScreenW,self.cycleScrollView.height + (kScreenW-30) / 3.0f + kRealValue(100) + kStatusBarHeight + 44);
//                              kStatusBarHeight-kTabBarHeight - 22 - 50 + MG_BOTTOM_MARGIN);
    }
    
    

    _collectionView = [[UICollectionView alloc]initWithFrame:tmpFrame collectionViewLayout:_layout];
    


    
//    [_collectionView.layer insertSublayer:gradientLayer atIndex:0];
    
    //    [_collectionView registerClass:[OneSectionCell class] forCellWithReuseIdentifier:@"OneSectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"NewestItemCell" bundle:nil] forCellWithReuseIdentifier:@"NewestItemCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:firstHeaderViewIdentifier];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:secondHeaderViewIdentifier];
    _collectionView.backgroundColor = kClearColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
//    [_collectionView setBackgroundView:gradientView];

    //刷新该页面（主要为了删除最新页已经退出的直播间）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome:) name:@"refreshHome" object:nil];
    [BGMJRefreshManager refresh:_collectionView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerReresh)];
//
    self.itemTitleMutableArray = [NSMutableArray array];
//
    _listArr = @[ASLocalizedString(@"推荐"),ASLocalizedString(@"关注")];
//
    [self.itemTitleMutableArray addObjectsFromArray:_listArr];
    // 动态添加视频分类
    for (VideoClassifiedModel *model in [GlobalVariables sharedInstance].appModel.video_classified)
    {
        [self.itemTitleMutableArray addObject:model.title];
    }
    self.vcArray = [self vcArr:0];
//    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(kRealValue(9.5), _collectionView.bottom + kRealValue(15), kScreenW - kRealValue(100), kRealValue(46)) titles:self.itemTitleMutableArray headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutLeft];
//        //tab颜色
//        _segHead.lineScale = 0.3;
//
//        _segHead.selectColor = [UIColor colorWithHexString:@"#1A1A1A"];;
//        _segHead.delegate = self;
//
//        _segHead.fontScale = 1.1;
//    //    _segHead.lineHeight = 0;
//    //    _segHead.lineColor = kClearColor;
//        _segHead.fontSize = 15;
//        _segHead.lineColor = kClearColor;
//        _segHead.lineHeight = kRealValue(3);
//        _segHead.lineScale = 0.3;
//        //滑块设置
//    //    _segHead.slideHeight = kRealValue(32);
//    //    _segHead.slideCorner = 4;
//    //    _segHead.moreButton_width = kRealValue(64);
//    //    _segHead.singleW_Add = kRealValue(64);
//    //    _segHead.slideColor = nil;
//    //    _segHead.slideScale = 1.5;
//        _segHead.deSelectColor = [UIColor colorWithHexString:@"#808080"];
//    //    _segHead.btnBgImg = @"bogo_home_top_bgSelectImg";
//    //    _segHead.btnBeforeBgImg = @"bogo_home_top_bgBeforeImg";
//
//        _segHead.bottomLineHeight = 0;
//
//        _segHead.headColor = kClearColor;
//        _segHead.deSelectColor = [UIColor colorWithHexString:@"#808080"];
//
//        self.view.backgroundColor = kClearColor;
//        _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segHead.frame)  + 10, SCREEN_WIDTH,CGRectGetMaxY(_segHead.frame) - kTabBarHeight) vcOrViews:[self vcArr:_listArr.count]];
//        _segScroll.loadAll = NO;
//        _segScroll.showIndex = 1;
//
//        [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
//            [self.view addSubview:_segHead];
//            [self.view addSubview:_segScroll];
//        }];
    

    [self viewDidLoad2];
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray array];
 
    VoiceListViewController *focusVC = [[VoiceListViewController alloc] init];
//    focusVC.viewFrame = CGRectMake(0, 0, kScreenW, kScreenH  - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
//    focusVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
    focusVC.types = @"0";


    VoiceListViewController *recommandVC = [[VoiceListViewController alloc] init];
//    recommandVC.viewFrame = CGRectMake(0, 0, kScreenW, kScreenH  - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
//    recommandVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
    recommandVC.types = @"1";
    
    
    
    [arr addObject:recommandVC];

    
    [arr addObject:focusVC];
    
    if (self.classifiedModelMutableArray.count > 0)
    {
        
    }
    
    
    
    self.classifiedModelMutableArray = [GlobalVariables sharedInstance].appModel.video_classified;
    
    
    

    for (NSInteger i = 0; i < self.classifiedModelMutableArray.count; ++i)
    {
        // 服务端下发的分类的在完整的分类容器中的起点

        VoiceListViewController *videoVC = [[VoiceListViewController alloc] init];
        VideoClassifiedModel * model = [[GlobalVariables sharedInstance].appModel.video_classified objectAtIndex:i];
//        videoVC.viewFrame = CGRectMake(0, 0, kScreenW, kScreenH  - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
//        videoVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
        videoVC.classified_id = model.classified_id;
        
        [arr addObject:videoVC];
    }
    
    return arr;
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
    
    //加载轮播
    NSMutableDictionary *parmDict1 = [NSMutableDictionary dictionary];
    [parmDict1 setObject:@"index" forKey:@"ctl"];
    [parmDict1 setObject:@"get_voice_banner_list" forKey:@"act"];    [self.httpsManager POSTWithParameters:parmDict1 SuccessBlock:^(NSDictionary *responseJson) {
       
        if ([responseJson toInt:@"status"] == 1)
        {
        
            NSArray *bannArr  = [responseJson objectForKey:@"data"];
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
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.cycleScrollView.imageURLStringsGroup = tmpMArray;
                
//            });
            
        }
    } FailureBlock:^(NSError *error) {
        
    }];
    
    //全部主播
    self.bannArr = @[];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    if ([self.types isEqualToString:@"1"]){
//        || [self.types isEqualToString:@"2"]) {
        [parmDict setObject:@"index" forKey:@"ctl"];
        [parmDict setObject:@"voice_popularity" forKey:@"act"];
        
  
    }
    
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             _has_next = [responseJson toInt:@"has_next"];
             _page = [responseJson toInt:@"page"];
  
            [_recommandArr removeAllObjects];
     
             //直播数组
             NSArray *recommandArr = [responseJson objectForKey:@"data"];
           
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
            
             
             
           
             [_collectionView reloadData];
             

            [self hideNoContentView];
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
            
            UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44+StatusBarHeight)];
            navView.backgroundColor = kClearColor;
            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.text = @"Voice room";
            titleLab.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
            titleLab.font = [UIFont boldSystemFontOfSize:20];
            [navView addSubview:titleLab];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(navView).offset(5);
                make.left.equalTo(@(10));
                make.height.mas_equalTo(44+StatusBarHeight);
            }];
            
            
            /*搜索栏*/
            
            UIButton *searchBtn = [[UIButton alloc] init];
            [searchBtn setImage:[UIImage imageNamed:@"habibi_sousuo"] forState:UIControlStateNormal];
            [navView addSubview:searchBtn];
            
            
            UIButton *startLive = [[UIButton alloc] init];
            [startLive setImage:[UIImage imageNamed:@"进入房间"] forState:UIControlStateNormal];
            [startLive addTarget:self action:@selector(handleLiveEvent) forControlEvents:UIControlEventTouchUpInside];
            [navView addSubview:startLive];
            
            UIButton *paihangBtn = [[UIButton alloc] init];
            [paihangBtn setImage:[UIImage imageNamed:@"hbibi_paihagnbang"] forState:UIControlStateNormal];
            [navView addSubview:paihangBtn];
            
            [paihangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(startLive.mas_left).offset(kRealValue(-10));
                make.size.height.equalTo(@kRealValue(30));
                make.size.width.equalTo(@kRealValue(30));
                make.centerY.equalTo(startLive);
            }];
            
            [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(paihangBtn.mas_left).offset(kRealValue(-10));
                make.size.height.equalTo(@kRealValue(30));
                make.size.width.equalTo(@kRealValue(30));
                make.centerY.equalTo(startLive);
            }];
            
            [startLive mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(navView).offset(kRealValue(-10));
                make.size.height.equalTo(@kRealValue(30));
                make.size.width.equalTo(@kRealValue(30));
                make.centerY.equalTo(titleLab);
            }];
            
            
            [searchBtn addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
            [paihangBtn addTarget:self action:@selector(clickPaihang) forControlEvents:UIControlEventTouchUpInside];
            
            /*搜索栏结束*/
            [navView addSubview:titleLab];
            [header addSubview:navView];

//            [self.view addSubview:baseView];
            self.cycleScrollView.top = 44+StatusBarHeight;
            //头视图添加view
//            if (!_firstL) {
//                self.firstBtn.frame = CGRectMake(kRealValue(15), self.headView.bottom, kScreenW * 0.5, kRealValue(55));
            self.firstBtn.top =  self.cycleScrollView.bottom + kRealValue(10);
            
            self.secondBtn.top = self.cycleScrollView.bottom;
            
                [header addSubview:self.cycleScrollView];
            

                [header addSubview:self.firstBtn];
            if(self.view.isRTL)
            {
                [_firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.mas_bottom).offset(kRealValue(44));
                    make.leading.equalTo(self.headView).offset(kRealValue(-15));
                }];
            }
            if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version] || ![self.types isEqualToString:@"1"]) {
                self.headView.hidden = self.firstBtn.hidden = YES;
            }
            return header;
        }
        else if (indexPath.section == 1) {
            UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:secondHeaderViewIdentifier forIndexPath:indexPath];
            //头视图添加view
//            if (!_secondL) {
         
                [header addSubview:self.secondBtn];
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
    return 1;
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
    
    return CGSizeMake(kScreenW, self.secondBtn.bottom - 10);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (![self.types isEqualToString:@"1"]) {
            return 0;
        }
        if(self.recommandArr.count > 3)
        {
            return 3;
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
        return CGSizeMake((kScreenW-50)/3.0f, (kScreenW-30) / 3.0f + kRealValue(32));
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


- (void)viewDidLoad2 {
    
   
    
    [self.view addSubview:self.smoothView];
    [self.smoothView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    self.smoothView.listCollectionView.backgroundColor = kClearColor;
    self.categoryView.contentScrollView = self.smoothView.listCollectionView;
    [self.smoothView reloadData];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    _smoothView.listCollectionView.mj_header = header;
    
//    [self.smoothView setCurrentIndex:1]
}

#pragma mark - GKPageSmoothViewDataSource
- (UIView *)headerViewInSmoothView:(GKPageSmoothView *)smoothView {
//    self.collectionView.backgroundColor = kRedColor;
    
    //添加一个从上到下的渐变视图 #FBE2FF - #DFFFF9、
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, kScreenW, 250);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FBE2FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#DFFFF9"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //把gradientLayer加到_collectionView最底部

//    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 250)];
    UIView *view = [[UIView alloc] initWithFrame:self.collectionView.bounds];
//    view.backgroundColor = kYellowColor;
    [view addSubview:self.collectionView];
    [view.layer insertSublayer:gradientLayer atIndex:0];

    return view;
}

- (UIView *)segmentedViewInSmoothView:(GKPageSmoothView *)smoothView {
    return self.segmentedView;
}

- (NSInteger)numberOfListsInSmoothView:(GKPageSmoothView *)smoothView {
    return self.categoryView.titles.count;
}

- (id<GKPageSmoothListViewDelegate>)smoothView:(GKPageSmoothView *)smoothView initListAtIndex:(NSInteger)index {
    return self.vcArray[index];
    GKDBListView *listView = [GKDBListView new];
    return listView;
//    GKBaseListViewController *listVC = [[GKBaseListViewController alloc] initWithListType:index];
//    listVC.shouldLoadData = YES;
//    return listVC;
}

#pragma mark - GKPageSmoothViewDelegate
- (void)smoothView:(GKPageSmoothView *)smoothView listScrollViewDidScroll:(UIScrollView *)scrollView contentOffset:(CGPoint)contentOffset {
    if (smoothView.isOnTop) return;
    
    // 导航栏显隐
    CGFloat offsetY = contentOffset.y;
    CGFloat alpha = 0;
    if (offsetY <= 0) {
        alpha = 0;
    }else if (offsetY > 60) {
        alpha = 1;
        [self changeTitle:YES];
    }else {
        alpha = offsetY / 60;
        [self changeTitle:NO];
    }
}

- (void)smoothViewDragBegan:(GKPageSmoothView *)smoothView {
    if (smoothView.isOnTop) return;
 
}

- (void)smoothViewDragEnded:(GKPageSmoothView *)smoothView isOnTop:(BOOL)isOnTop {
    // titleView已经显示，不作处理
    
    
   
}

- (void)changeTitle:(BOOL)isShow {
   
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
//    [self.smoothView showingOnTop];
}

#pragma mark - 懒加载
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 44.0f)];
        
        UIImage *image = [UIImage imageNamed:@"db_title"];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = CGRectMake(0, 0, 44.0f * image.size.width / image.size.height, 44.0f);
        [_titleView addSubview:imgView];
    }
    return _titleView;
}

- (GKPageSmoothView *)smoothView {
    if (!_smoothView) {
        _smoothView = [[GKPageSmoothView alloc] initWithDataSource:self];
//        _smoothView.defaultSelectedIndex = 1;
//        _smoothView.currentIndex = 1;
        _smoothView.backgroundColor = kClearColor;
        _smoothView.delegate = self;
        _smoothView.ceilPointHeight = 0;
//        _smoothView.bottomHover = YES;
//        _smoothView.allowDragBottom = YES;
//        _smoothView.allowDragScroll = YES;
        // 解决与返回手势滑动冲突
//        _smoothView.listCollectionView.gk_openGestureHandle = YES;
        _smoothView.holdUpScrollView = YES;

    }
    return _smoothView;
}

- (void)pullDownToRefresh
{

}

- (UIImageView *)headerView {
    if (!_headerView) {
        UIImage *image = [UIImage imageNamed:@"douban"];
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _headerView.image = image;
    }
    return _headerView;
}

- (UIView *)segmentedView {
    if (!_segmentedView) {
        _segmentedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        _segmentedView.backgroundColor = [UIColor whiteColor];
        [_segmentedView addSubview:self.categoryView];
        
//        UIView *topView = [UIView new];
//        topView.backgroundColor = [UIColor lightGrayColor];
//        topView.layer.cornerRadius = 3;
//        topView.layer.masksToBounds = YES;
//        [_segmentedView addSubview:topView];
//        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self->_segmentedView).offset(5);
//            make.centerX.equalTo(self->_segmentedView);
//            make.width.mas_equalTo(60);
//            make.height.mas_equalTo(6);
//        }];
    }
    return _segmentedView;
}

- (BogoJXCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[BogoJXCategoryView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
        _categoryView.backgroundColor = UIColor.whiteColor;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.contentEdgeInsetLeft = 16;
        _categoryView.delegate = self;
        _categoryView.titles = self.itemTitleMutableArray;
        _categoryView.titleFont = [UIFont systemFontOfSize:16];
        _categoryView.titleColor = UIColor.grayColor;
        _categoryView.titleSelectedColor = UIColor.blackColor;
        _categoryView.subTitleFont = [UIFont systemFontOfSize:11];
        _categoryView.subTitleColor = UIColor.grayColor;
        _categoryView.subTitleSelectedColor = UIColor.grayColor;
        _categoryView.positionStyle = JXCategorySubTitlePositionStyle_Right;
        _categoryView.alignStyle = JXCategorySubTitleAlignStyle_Top;
        _categoryView.cellSpacing = 30;
        _categoryView.cellWidthIncrement = 0;
        _categoryView.ignoreSubTitleWidth = YES;
        
        JXCategoryIndicatorLineView *lineView = [JXCategoryIndicatorLineView new];
        lineView.indicatorColor = UIColor.blackColor;
        _categoryView.indicators = @[self.lineView];
        
//        _categoryView.contentScrollView = self.smoothView.listCollectionView;
    }
    return _categoryView;
}

-  (JXCategoryIndicatorAlignmentLineView *)lineView {
    if (!_lineView) {
        _lineView = [JXCategoryIndicatorAlignmentLineView new];
        _lineView.indicatorColor = UIColor.blackColor;
    }
    return _lineView;
}

-(void)clickSearch:(UITapGestureRecognizer *)sender{
//    SSearchVC *searchVC = [[SSearchVC alloc]init];
//    searchVC.searchType = @"0";
//    [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
    BogoSearchViewController *searchVC = [[BogoSearchViewController alloc]initWithNibName:@"BogoSearchViewController" bundle:[NSBundle mainBundle]];
    [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
}

- (void)clickPaihang {
    
    LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
    lbVCtr.isHiddenTabbar = YES;
    [[AppDelegate sharedAppDelegate]pushViewController:lbVCtr animated:YES];
    

}

- (void)handleLiveEvent {
    if(self.topViewdelegate && [self.topViewdelegate respondsToSelector:@selector(clickLiveBtn)]) {
        [self.topViewdelegate clickLiveBtn];
    }
}

@end
