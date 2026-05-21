//
//  ContributionViewController.m
//  BuguLive
//
//  Created by yy on 16/10/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ContributionViewController.h"


NS_ENUM(NSInteger, ContriClassColl)
{
    EClassColl_ContriDay,     //日榜
    EClassColl_ContriMonth,   //月榜
    EClassColl_ContriTotal,   //总榜
    EClass_Count,
};
@interface ContributionViewController ()<UIScrollViewDelegate,SegmentViewDelegate,MLMSegmentHeadDelegate,ListDayViewControllerDelegate>
{
    CGRect          _segmentFrame;
    UIScrollView    *_bScrollView;
    NSInteger       _startPage;
    NSArray *list;
}

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;



@property(nonatomic, strong) QMUIButton *listInfoBtn;//榜单介绍

@end

@implementation ContributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kAppSpaceColor3;
    [self segmentStyle1];
    self.title  = ASLocalizedString(@"贡献榜");
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
//    [UIColor colorWithHexString:@"#999999"];
    _segHead.fontSize = 15;
    _segHead.moreButton_width = 50;//
    _segHead.fontScale = 1;//点击后的缩放比例
    _segHead.lineHeight = 2;
    _segHead.delegate = self;
    _segHead.slideHeight = 22;
    _segHead.lineScale = .9;
    _segHead.headColor = kClearColor;
    _segHead.btnBgImg = @"bogo_contributeList_rankImgView";
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

-(void)changeBtnFrom:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"mg_new_list_concert"] forState:UIControlStateNormal];
}

-(void)handleSearchEvent{
    
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    //日榜
    if (!_ContriDayViewController) {
        _ContriDayViewController = [[ListDayViewController alloc]init];
        _ContriDayViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriDayViewController.type = 1;
        _ContriDayViewController.delegate = self;
        _ContriDayViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriDay, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriDayViewController.view.backgroundColor = kClearColor;
    }
    [arr addObject:_ContriDayViewController];
    //月榜
    if (!_ContriMonthViewController) {
        _ContriMonthViewController = [[ListDayViewController alloc]init];
        _ContriMonthViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriMonthViewController.type = 2;
        _ContriMonthViewController.delegate = self;
        _ContriMonthViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriMonth, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriMonthViewController.view.backgroundColor = kClearColor;
    }
    [arr addObject:_ContriMonthViewController];
    //总榜
    if (!_ContriTotalViewController) {
        _ContriTotalViewController = [[ListDayViewController alloc]init];
        _ContriTotalViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriTotalViewController.type = 3;
        _ContriTotalViewController.delegate = self;
        _ContriTotalViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriTotal, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriTotalViewController.view.backgroundColor = kClearColor;
    }
    [arr addObject:_ContriTotalViewController];
    
    return arr;
}


- (void)createScroll
{
    //分段视图
    NSArray* items = [NSArray arrayWithObjects:ASLocalizedString(@"日榜"), ASLocalizedString(@"月榜"), ASLocalizedString(@"总榜"), nil];
    _segmentFrame = CGRectMake(kScreenW/8, 20,  kScreenW - 40, 44);
    _contriSegmentView = [[SegmentView alloc]initWithFrame:_segmentFrame andItems:items andSize:12 border:NO  isrankingRist:YES];
    _contriSegmentView.backgroundColor = kWhiteColor;
    _contriSegmentView.frame = CGRectMake(20, 20, kScreenW - 40, 44);
    _contriSegmentView.delegate = self;
    [self.view addSubview:_contriSegmentView];
    
    
    if (self.isHiddenTabbar)
    {
        _bScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenH-64 - 44)];
    }else
    {
        _bScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenH-64-49-44)];
    }
    _bScrollView.backgroundColor = kClearColor;
    _bScrollView.contentSize = CGSizeMake(EClass_Count*kScreenW, 0);
    _bScrollView.pagingEnabled = YES;
    _bScrollView.bounces = NO;
    _bScrollView.showsHorizontalScrollIndicator = NO;
    _bScrollView.delegate = self;
    [self.view addSubview:_bScrollView];
    _bScrollView.contentOffset = CGPointMake(0, 0);
    [_contriSegmentView setSelectIndex:0];
    //日榜
    if (!_ContriDayViewController) {
        _ContriDayViewController = [[ListDayViewController alloc]init];
        _ContriDayViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriDayViewController.type = 1;
        _ContriDayViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriDay, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriDayViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_bScrollView addSubview:_ContriDayViewController.view];
    //月榜
    if (!_ContriMonthViewController) {
        _ContriMonthViewController = [[ListDayViewController alloc]init];
        _ContriMonthViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriMonthViewController.type = 2;
        _ContriMonthViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriMonth, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriMonthViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_bScrollView addSubview:_ContriMonthViewController.view];
    //总榜
    if (!_ContriTotalViewController) {
        _ContriTotalViewController = [[ListDayViewController alloc]init];
        _ContriTotalViewController.isHiddenTabbar = self.isHiddenTabbar;
        _ContriTotalViewController.type = 3;
        _ContriTotalViewController.view.frame = CGRectMake(kScreenW * EClassColl_ContriTotal, 0, kScreenW, _bScrollView.bounds.size.height);
        _ContriTotalViewController.view.backgroundColor = kAppSpaceColor3;
    }
    [_bScrollView addSubview:_ContriTotalViewController.view];
}

#pragma mark --SegmentView代理方法
- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2f animations:^{
        _bScrollView.contentOffset = CGPointMake(_bScrollView.frame.size.width*index, 20);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _bScrollView.contentOffset;
    NSInteger page = (offset.x + _bScrollView.frame.size.width/2) / _bScrollView.frame.size.width;
//    self.contriSegmentView.indicatorView.hidden = NO;
    [_contriSegmentView setSelectIndex:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
    float tmpPage2    = scrollView.contentOffset.x / pageWidth;
    NSInteger page    = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
    
    if (_startPage != page)
    {
        [_contriSegmentView setSelectIndex:page];
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




