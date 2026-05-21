//
//  SmallVideoViewController.m
//  BuguLive
//
//  Created by 范东 on 2019/1/21.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "SmallVideoViewController.h"
#import "MSmallVideoVC.h"
#import "SSearchVC.h"
#import "SegmentView.h"

@interface SmallVideoViewController ()<UIScrollViewDelegate,SegmentViewDelegate>{
    UITableView     *_listTableView;
    
    int             _buttonCount;            //button个数
    
    UIButton        *_dayBoardBtn;          //日榜
    UIButton        *_monthBoardBtn;        //月榜
    UIButton        *_totalBoardbtn;        //总榜
    UIButton        *_meritBtn;             //功德榜
    UIButton        *_contriBtn;            //贡献榜
    UIView          *_topicView;
    UIView          *_headView;
    NSArray         *_listItems;
    UIScrollView    *_tScrollView;
    CGRect          _listSegmentFrame;
    
    MSmallVideoVC   *_hotVC;  //热门
    MSmallVideoVC  *_latestVC; //最新
    MSmallVideoVC  *_nearVC; //附近
    NSInteger                   _startPage;                   // 起始页
}

@property ( nonatomic, strong) JSBadgeView                     *badge;

@end

@implementation SmallVideoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    _headView.hidden = NO;
    [self loadBtnBadageData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    _startPage = 1;
    
    self.view.backgroundColor = kNavBarThemeColor;
    //分段视图
    _listItems =[NSArray arrayWithObjects:ASLocalizedString(@"热门"),ASLocalizedString(@"最新"),ASLocalizedString(@"附近"), nil];
    self.navigationItem.title = @"";
    
    [self createHeadView];
    [self leftOrRightNavItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iMChatHaveNotification:) name:g_notif_chatmsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTableViewStatus) name:@"changeTableViewStatus" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _headView.hidden = YES;
}

- (void)changeTableViewStatus{
    [_hotVC refreshHeader];
    [_latestVC refreshHeader];
    [_nearVC refreshHeader];
}

#pragma mark    导航栏部分
//搜索
- (void)searchClick
{
    
    if (self.isHiddenTabbar)
    {
        [[AppDelegate sharedAppDelegate]popViewController];
    }else
    {
        SSearchVC *searchVC = [[SSearchVC alloc]init];
        searchVC.searchType = @"0";
        [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
    }
}

- (void)createHeadView
{
    _headView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-200)/2.0, 0, 200, 44)];
    _headView.backgroundColor = kClearColor;
    [self.navigationController.navigationBar addSubview:_headView];
    _listSegmentFrame = CGRectMake(0, 0, 200, 44);
    _listSegmentView = [[SegmentView alloc]initWithFrame:_listSegmentFrame andItems:_listItems andSize:16 border:NO  isrankingRist:NO];
    _listSegmentView.backgroundColor = kClearColor;
    _listSegmentView.delegate = self;
    [_listSegmentView setSelectIndex:0];
    [_headView addSubview:_listSegmentView];
    
    if (self.isHiddenTabbar)
    {
        _tScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kNavigationBarHeight-kStatusBarHeight)];
    }else
    {
        _tScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kNavigationBarHeight-kStatusBarHeight-kTabBarHeight)];
    }
    _tScrollView.backgroundColor = kClearColor;
    _tScrollView.contentSize = CGSizeMake(3*kScreenW, 0);
    _tScrollView.pagingEnabled = YES;
    _tScrollView.bounces = NO;
    _tScrollView.showsHorizontalScrollIndicator = NO;
    _tScrollView.delegate = self;
    [self.view addSubview:_tScrollView];
    _tScrollView.contentOffset = CGPointMake(0, 0);
    
    //热门
    if (!_hotVC)
    {
        _hotVC = [[MSmallVideoVC alloc]init];
        _hotVC.view.frame = CGRectMake(0, 0, kScreenW, _hotVC.view.height);
        _hotVC.paramDict = [NSDictionary dictionaryWithObject:@"1" forKey:@"order"];
    }
    [_tScrollView addSubview:_hotVC.view];
    //最新
    if (!_latestVC){
        _latestVC = [[MSmallVideoVC alloc]init];
        _latestVC.view.frame = CGRectMake(kScreenW, 0, kScreenW, _hotVC.view.height);
        _latestVC.paramDict = [NSDictionary dictionaryWithObject:@"2" forKey:@"order"];
    }
    [_tScrollView addSubview:_latestVC.view];
    //附近
    if (!_nearVC) {
        _nearVC = [[MSmallVideoVC alloc]init];
        _nearVC.view.frame = CGRectMake(kScreenW*2, 0, kScreenW, _hotVC.view.height);
        _nearVC.paramDict = [NSDictionary dictionaryWithObject:@"3" forKey:@"order"];
    }
    [_tScrollView addSubview:_nearVC.view];
}

- (void)leftOrRightNavItem
{
    // 左上角按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, kNavigationBarHeight)];
    if (self.isHiddenTabbar)
    {
        [leftButton setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
    }
    else
    {
        [leftButton setImage:[UIImage imageNamed:@"hm_search"] forState:UIControlStateNormal];
    }
    [leftButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // 右上角按钮
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, kNavigationBarHeight)];
    [rightButton setImage:[UIImage imageNamed:@"hm_private_message"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickedIMChat) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    // 设置角标
    [self initBadgeBtn:rightButton];
    [self loadBtnBadageData];
}

#pragma mark --SegmentView代理方法
- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2f animations:^{
        _tScrollView.contentOffset = CGPointMake(_tScrollView.frame.size.width*index, 0);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    CGPoint offset = _tScrollView.contentOffset;
    NSInteger page = (offset.x + _tScrollView.frame.size.width/2) / _tScrollView.frame.size.width;
//    self.segmentView.indicatorView.hidden = NO;
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

- (void)pushToHomePage:(UserModel *)model
{
    SHomePageVC *homeVC = [[SHomePageVC alloc]init];
    homeVC.user_id = model.user_id;
//    homeVC.user_nickname =model.nick_name;
    homeVC.type = 0;
    [[AppDelegate sharedAppDelegate]pushViewController:homeVC animated:YES];
}

#pragma mark - ----------------------- 私信消息、角标 -----------------------
#pragma mark IM
- (void)clickedIMChat
{
    BGConversationSegmentController *chatListVC = [[BGConversationSegmentController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:chatListVC animated:YES];
}

- (void)iMChatHaveNotification:(NSNotification*)notification
{
    //all 角标数据
    [self loadBtnBadageData];
}

/**
 设置 角标
 
 @param sender 对应的控件
 */
- (void)initBadgeBtn:(UIButton *)sender
{
    //-好友
    _badge = [[JSBadgeView alloc]initWithParentView:sender alignment:JSBadgeViewAlignmentTopRight];
    _badge.badgePositionAdjustment = CGPointMake(0, 12);
}

/**
 获取角标的数据： 注意：调All未读／调好友&&非好友方法 算All时，别调后者2各和来算，里面有耗时操作
 使用：1.在willApperar 2.SDK监听会发通知，通知的方法／block 里调用
 给控件初始化一个角标
 
 badage的 数据 获取（个人页面获取所有未读的条数）
 1.在willApear里调用一次   2.SDk消息变化，接受通知，在通知方法还要调用 用于更新 角标数据
 
 */
- (void)loadBtnBadageData
{
    [SFriendObj getAllUnReadCountComplete:^(int num) {
        //all
        int scount = num;
        if( scount )
        {
            if(scount > 98)
            {
                _badge.badgeText = @"99+";
            }
            else
            {
                _badge.badgeText = [NSString stringWithFormat:@"%d",scount];
            }
        }
        else
        {
            _badge.badgeText = nil;
        }
    }];
    
}

@end
