//
//  ConsumptionViewController.m
//  BuguLive
//
//  Created by yy on 16/10/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ConsumptionViewController.h"


NS_ENUM(NSInteger, ListClassColl)
{
    EClassColl_ListDay,     //日榜
    EClassColl_ListMonth,   //月榜
    EClassColl_ListTotal,   //总榜
    EClassColl_Count,
};

@interface ConsumptionViewController ()<UIScrollViewDelegate,SegmentViewDelegate,MLMSegmentHeadDelegate,ListDayViewControllerDelegate>
{
    CGRect          _segmentFrame;
    UIScrollView    *_cScrollView;
    NSInteger       _startPage;
    NSArray *list;
}

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;



@property(nonatomic, strong) QMUIButton *listInfoBtn;//榜单介绍

@end

@implementation ConsumptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kAppSpaceColor3;
    [self segmentStyle1];
//    [self createScrollView];
    self.title = ASLocalizedString(@"魅力榜");
     [self setupBackBtnWithBlock:nil];
}



- (void)segmentStyle1 {
    
    list = @[
    ASLocalizedString(@"  日榜   "), ASLocalizedString(@"  月榜  "), ASLocalizedString(@"   总榜   "),
    ];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 60 , 45) titles:list headStyle:SegmentHeadStyleDefault layoutStyle:MLMSegmentLayoutLeft];
    //tab颜色
    _segHead.selectColor = kWhiteColor;
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#DFC0FD"];
    _segHead.btnBgImg = @"bogo_contributeList_rankImgView";
    _segHead.fontSize = 15;
    _segHead.moreButton_width = 50;//
    _segHead.slideHeight = 22;
    _segHead.fontScale = 1;//点击后的缩放比例
    _segHead.lineHeight = 2;
    _segHead.delegate = self;
    
    _segHead.lineScale = .9;
    _segHead.headColor = kClearColor;
    //    CF6;
    _segHead.bottomLineHeight = 0;
    
    //    _segHead.deSelectColor = [UIColor colorWithRed:0.91 green:0.47 blue:0.62 alpha:1.00];
    self.view.backgroundColor = kClearColor;
    //    CF6;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 2;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
    
    self.listInfoBtn.frame = CGRectMake(SCREEN_WIDTH - 70 - 15, kStatusBarHeight - 5, 70, 30);
    //    search.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    self.listInfoBtn.centerY = _segHead.centerY;
    
    [self.listInfoBtn addTarget:self action:@selector(handleSearchEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.listInfoBtn];

    
}

-(void)handleSearchEvent{
    
}


-(void)changeBtnFrom:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"mg_new_list_concert"] forState:UIControlStateNormal];
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    //日榜
    if (!_listDayViewController) {
        _listDayViewController = [[ListDayViewController alloc]init];
        _listDayViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listDayViewController.type = 4;
        _listDayViewController.delegate = self;
        _listDayViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListDay, 0, kScreenW, _cScrollView.bounds.size.height);
        _listDayViewController.view.backgroundColor = kClearColor;
    }
    [arr addObject:_listDayViewController];
    //月榜
    if (!_listMonthViewController) {
        _listMonthViewController = [[ListDayViewController alloc]init];
        _listMonthViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listMonthViewController.delegate = self;
        _listMonthViewController.type = 5;
        _listMonthViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListMonth, 0, kScreenW, _cScrollView.bounds.size.height);
        _listMonthViewController.view.backgroundColor = kClearColor;
    }
    [arr addObject:_listMonthViewController];
    
    //总榜
    if (!_listTotalViewController) {
        _listTotalViewController = [[ListDayViewController alloc]init];
        _listTotalViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listTotalViewController.delegate = self;
        _listTotalViewController.type = 6;
        _listTotalViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListTotal, 0, kScreenW, _cScrollView.bounds.size.height);
        _listTotalViewController.view.backgroundColor = kClearColor;
    }
    [arr addObject:_listTotalViewController];
    
    return arr;
}



- (void)createScrollView
{
    //分段视图
    NSArray* items = [NSArray arrayWithObjects:ASLocalizedString(@"日榜"), ASLocalizedString(@"月榜"), ASLocalizedString(@"总榜"), nil];
    _segmentFrame = CGRectMake(0, 20,  200, 44);
    _listSegmentView = [[SegmentView alloc]initWithFrame:_segmentFrame andItems:items andSize:12 border:NO isrankingRist:YES];
    _listSegmentView.backgroundColor = kWhiteColor;
    _listSegmentView.frame = CGRectMake(0, 0, 200, 44);
    _listSegmentView.delegate = self;
//    _listSegmentView.segmentControl.tintColor =
    
    
    [self.view addSubview:_listSegmentView];
    
    if (self.isHiddenTabbar)
    {
      _cScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenH-64 - 44)];
    }else
    {
      _cScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenH-64-49-44)];
    }
    _cScrollView.backgroundColor = kClearColor;
    _cScrollView.contentSize = CGSizeMake(EClassColl_Count*kScreenW, 0);
    _cScrollView.pagingEnabled = YES;
    _cScrollView.bounces = NO;
    _cScrollView.showsHorizontalScrollIndicator = NO;
    _cScrollView.delegate = self;
    [self.view addSubview:_cScrollView];
    _cScrollView.contentOffset = CGPointMake(0, 0);
    [_listSegmentView setSelectIndex:0];
    //日榜
    if (!_listDayViewController) {
        _listDayViewController = [[ListDayViewController alloc]init];
        _listDayViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listDayViewController.type = 1;
        _listDayViewController.delegate = self;
        _listDayViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListDay, 0, kScreenW, _cScrollView.bounds.size.height);
        _listDayViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_cScrollView addSubview:_listDayViewController.view];
    //月榜
    if (!_listMonthViewController) {
        _listMonthViewController = [[ListDayViewController alloc]init];
        _listMonthViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listMonthViewController.delegate = self;
        _listMonthViewController.type = 2;
        _listMonthViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListMonth, 0, kScreenW, _cScrollView.bounds.size.height);
        _listMonthViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_cScrollView addSubview:_listMonthViewController.view];
    //总榜
    if (!_listTotalViewController) {
        _listTotalViewController = [[ListDayViewController alloc]init];
        _listTotalViewController.isHiddenTabbar = self.isHiddenTabbar;
        _listTotalViewController.type = 3;
        _listTotalViewController.delegate = self;
        _listTotalViewController.view.frame = CGRectMake(kScreenW * EClassColl_ListTotal, 0, kScreenW, _cScrollView.bounds.size.height);
        _listTotalViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_cScrollView addSubview:_listTotalViewController.view];

    
    
    
    
}

#pragma mark --SegmentView代理方法
- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2f animations:^{
        _cScrollView.contentOffset = CGPointMake(_cScrollView.frame.size.width*index, 0);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _cScrollView.contentOffset;
    NSInteger page = (offset.x + _cScrollView.frame.size.width/2) / _cScrollView.frame.size.width;
//    self.listSegmentView.indicatorView.hidden = NO;
    [_listSegmentView setSelectIndex:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
    float tmpPage2 = scrollView.contentOffset.x / pageWidth;
    NSInteger page = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
    
    if (_startPage != page)
    {
        [_listSegmentView setSelectIndex:page];
        _startPage = page;
    }
}



-(QMUIButton *)listInfoBtn{
    if (!_listInfoBtn) {
        _listInfoBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_listInfoBtn setTitle:ASLocalizedString(@"榜单介绍") forState:UIControlStateNormal];
        _listInfoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_listInfoBtn setImage:[UIImage imageNamed:@"bogo_contribute_list_questionMark"] forState:UIControlStateNormal];
        _listInfoBtn.imagePosition = QMUIButtonImagePositionRight;
        _listInfoBtn.spacingBetweenImageAndTitle = 5;
        [_listInfoBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _listInfoBtn.alpha = 0.8;
        _listInfoBtn.hidden = YES;
    }
    return _listInfoBtn;
}


@end
