//
//  GKBasePageViewController.m
//  GKPageScrollViewDemo
//
//  Created by QuintGao on 2018/12/11.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKBasePageViewController.h"

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
#import "BogoJXCategoryView.h"
#import "CountryView.h"
static float const bannerAutoScrollTimeInterval = 7;
static NSString *firstHeaderViewIdentifier = @"firstHederview";
static NSString *secondHeaderViewIdentifier = @"secondHederview";

@interface GKBasePageViewController()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,PushToLiveControllerDelegate>

@property (nonatomic, strong) UIView           *headerView;

@property (nonatomic, strong) UIView                *pageView;

@property (nonatomic, strong) JXCategoryTitleView   *segmentedView;

@property (nonatomic, strong) BGNoContentView *noContentViews;


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

@property(nonatomic, strong) NSArray <UIViewController *>*vcArray;
@property (nonatomic, strong) NetHttpsManager *httpsManager;
@property(nonatomic, strong) CountryView *countryView;
@end

@implementation GKBasePageViewController



-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, kScreenW - 20, kRealValue(94)) delegate:self placeholderImage:nil];
        self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView.currentPageDotColor = [UIColor colorWithHexString:@"#666666"]; // 自定义分页控件小圆标颜色
        self.cycleScrollView.pageDotColor = [UIColor colorWithHexString:@"#ffffff"]; // 自定义分页控件小圆标颜色

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


/////////////////
- (void)viewDidLoad {
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
    

    //价格背景避免下拉是白色
    
    
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44 + kStatusBarHeight)];
//    navView.backgroundColor = [UIColor colorWithHexString:@"#FBE2FF"];
    navView.userInteractionEnabled = YES;
    navView.image = [UIImage imageNamed:@"顶部渐变"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, navView.height + 105)];
    bgView.backgroundColor = navView.backgroundColor;
    [self.view addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"Voice room";
    titleLab.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    [navView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navView).offset(8);
        make.left.equalTo(@(10));
        make.height.mas_equalTo(44 + kStatusBarHeight);
    }];
    
    
    /*搜索栏*/
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setImage:[UIImage imageNamed:@"habibi_sousuo"] forState:UIControlStateNormal];
    [navView addSubview:searchBtn];
    
    
    UIButton *startLive = [[UIButton alloc] init];
    [startLive setImage:[UIImage imageNamed:@"开播"] forState:UIControlStateNormal];
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
    [self.view addSubview:navView];
    
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(@(44 + kStatusBarHeight));
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    [self initFWData];
}

- (void)initFWUI
{

}

- (void)initFWData
{
    [self loadDataWithPage:1];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect frame = self.headerView.frame;
    frame.size.width = self.view.frame.size.width;
    self.headerView.frame = frame;
    
    frame = self.segmentView.frame;
    if (frame.size.width != self.view.frame.size.width) {
        frame.size.width = self.view.frame.size.width;
        [self.segmentView reloadData];
    }
    
    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(self.view.frame.size.width * idx, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    self.scrollView.contentSize = CGSizeMake(self.childVCs.count * self.view.frame.size.width, 0);
}

#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.headerView;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.pageView;
}

- (NSArray<id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.childVCs;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

#pragma mark - 懒加载
- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.showInFooter = YES;
    }
    return _pageScrollView;
}

- (UIView *)headerView {
    if (!_headerView) {
       
        
        //添加一个从上到下的渐变视图 #FBE2FF - #DFFFF9、
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, kScreenW,  kRealValue(108));
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FBE2FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#DFFFF9"].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        //把gradientLayer加到_collectionView最底部

    //    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 250)];
        UIView *view = [[UIView alloc] initWithFrame:self.collectionView.bounds];
    //    view.backgroundColor = kYellowColor;
        [view addSubview:self.collectionView];
//        [view.layer insertSublayer:gradientLayer atIndex:0];
        _headerView = view;
        
    }
    return _headerView;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [UIView new];
        
        [_pageView addSubview:self.segmentView];
        [_pageView addSubview:self.scrollView];
        
        [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self->_pageView);
            make.height.mas_equalTo(44);
        }];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_pageView);
            make.top.equalTo(self.segmentView.mas_bottom);
        }];
    }
    return _pageView;
}

- (BogoJXCategoryView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[BogoJXCategoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _segmentView.titles = self.itemTitleMutableArray;
        _segmentView.titleFont = [UIFont systemFontOfSize:14];
        _segmentView.titleSelectedFont = [UIFont systemFontOfSize:14];
        _segmentView.titleColor = [UIColor colorWithHexString:@"#808080"];
        _segmentView.titleSelectedColor = [UIColor colorWithHexString:@"#ffffff"];
        
        JXCategoryIndicatorLineView *lineView = [JXCategoryIndicatorLineView new];
        lineView.indicatorColor = kClearColor;
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
        lineView.indicatorHeight = 4.0f;
        lineView.verticalMargin = 2;
        _segmentView.indicators = @[lineView];
        
        _segmentView.contentScrollView = self.scrollView;
        
        UIView  *btmLineView = [UIView new];
        btmLineView.backgroundColor = RGB(110, 110, 110);
        btmLineView.hidden = YES;
        [_segmentView addSubview:btmLineView];
        [btmLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_segmentView);
            make.height.mas_equalTo(1);
        }];
    }
    return _segmentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat scrollW = self.view.frame.size.width;
        CGFloat scrollH = self.view.frame.size.height - 44 - 44;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, scrollW, scrollH)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.gk_openGestureHandle = YES;
        
        [self.childVCs enumerateObjectsUsingBlock:^(GKBaseListViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:vc];
            [self->_scrollView addSubview:vc.view];
            
            vc.view.frame = CGRectMake(idx * scrollW, 0, scrollW, scrollH);
            
            __weak __typeof(self) weakSelf = self;
            vc.listItemClick = ^(GKBaseListViewController * _Nonnull listVC, NSIndexPath * _Nonnull indexPath) {
                __strong __typeof(weakSelf) self = weakSelf;
                [self.pageScrollView scrollToCriticalPoint];
            };
        }];
        _scrollView.contentSize = CGSizeMake(scrollW * self.childVCs.count, 0);
    }
    return _scrollView;
}

- (NSArray *)childVCs {
    
    return self.vcArray;
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
//    [self.view addSubview:_collectionView];
//    [_collectionView setBackgroundView:gradientView];

    //刷新该页面（主要为了删除最新页已经退出的直播间）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome:) name:@"refreshHome" object:nil];
//    [BGMJRefreshManager refresh:_collectionView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerReresh)];
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
            
            [self.collectionView reloadData];
            
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
            
            [header removeAllSubviews];

//            [self.view addSubview:baseView];
            self.cycleScrollView.top = 10;
            //头视图添加view
//            if (!_firstL) {
//                self.firstBtn.frame = CGRectMake(kRealValue(15), self.headView.bottom, kScreenW * 0.5, kRealValue(55));
            
            self.secondBtn.top = self.cycleScrollView.bottom;
            
            NSArray *countries = @[
                @{@"image": @"新加坡", @"name": @"USA"},
                @{@"image": @"新加坡", @"name": @"Canada"},
                @{@"image": @"新加坡", @"name": @"UK"},
                @{@"image": @"新加坡", @"name": @"Germany"},
                @{@"image": @"新加坡", @"name": @"France"},
                @{@"image": @"新加坡", @"name": @"Japan"},
                @{@"image": @"新加坡", @"name": @"China"},
                @{@"image": @"新加坡", @"name": @"India"},
                @{@"image": @"新加坡", @"name": @"Brazil"},
                @{@"image": @"新加坡", @"name": @"Russia"}
            ];

            CountryView *countryView = [[CountryView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 200) countries:countries];
            
            [header addSubview:countryView];
            
            self.firstBtn.top =  countryView.bottom + kRealValue(10);

            self.countryView = countryView;
            
//                [header addSubview:self.cycleScrollView];
            

                [header addSubview:self.firstBtn];
            if(self.view.isRTL)
            {
                [_firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.cycleScrollView.mas_bottom).offset(kRealValue(15));
                    make.leading.equalTo(header).offset(15);
                    make.width.equalTo(@(kScreenW * 0.5));
//                    _firstBtn.frame = CGRectMake(kRealValue(15), self.cycleScrollView.bottom + kRealValue(10), kScreenW * 0.8, kRealValue(55));

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

- (NetHttpsManager *)httpsManager
{
    if (!_httpsManager)
    {
        _httpsManager = [NetHttpsManager manager];
    }
    return _httpsManager;
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
