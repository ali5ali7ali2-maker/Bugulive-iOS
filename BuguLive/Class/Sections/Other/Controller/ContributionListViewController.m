//
//  ContributionListViewController.m
//  BuguLive
//
//  Created by fanwe2014 on 16/6/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ContributionListViewController.h"
#import "SHomePageVC.h"
#import "LeaderboardViewController.h"
#import "SContributionView.h"
#import "BogoRankHeadGifView.h"

@interface ContributionListViewController ()<SegmentViewDelegate,ContriButionDeleGate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView            *cScrollView;
@property (nonatomic, assign) NSInteger               startPage;
@property (nonatomic, assign) CGRect                  segmentFrame;
@property (nonatomic, strong) UITableView             *myTableview;
@property (nonatomic, strong) SContributionView       *contributionV1;       //当前排行
@property (nonatomic, strong) SContributionView       *contributionV2;       //累计排行

@property(nonatomic, strong) UIImageView *bgImgView;

@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UIButton *backBtn;

@property(nonatomic, strong) UIImageView *segBgView;

@end

@implementation ContributionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    
    [self.view addSubview:self.bgImgView];
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.title = [NSString stringWithFormat:ASLocalizedString(@"%@贡献榜"),self.BuguLive.appModel.ticket_name];
    self.view.backgroundColor = kWhiteColor;
    
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW * 0.6, kRealValue(40))];
    self.titleL.text = self.title;
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.centerX = kScreenW / 2;
    self.titleL.textColor = kWhiteColor;
    
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    self.backBtn.frame = CGRectMake(0, kStatusBarHeight, kRealValue(30), kRealValue(30));
    self.backBtn.centerY = self.titleL.centerY;
    [self.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if ([self.type intValue] == 1)
    {
        NSArray* items = [NSArray arrayWithObjects:ASLocalizedString(@"当天排行"), ASLocalizedString(@"累计排行"), nil];
        _segmentFrame = CGRectMake(0,self.titleL.bottom + kRealValue(10),  kScreenW, kRealValue(40));
        _listSegmentView = [[SegmentView alloc]initWithFrame:_segmentFrame andItems:items andSize:12 border:NO isrankingRist:NO];
        _listSegmentView.backgroundColor = kClearColor;
        _listSegmentView.frame = _segmentFrame;
        _listSegmentView.delegate = self;
        
        [self.view addSubview:self.segBgView];
        [self.view addSubview:_listSegmentView];
    }
    
    _cScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_listSegmentView.frame), kScreenW,kScreenH-kTopHeight-_listSegmentView.height)];
    _cScrollView.backgroundColor = kClearColor;
    if ([self.type intValue] == 1)
    {
      _cScrollView.contentSize = CGSizeMake(2*kScreenW, 0);
    }else
    {
     _cScrollView.contentSize = CGSizeMake(kScreenW, 0);
    }
    _cScrollView.pagingEnabled = YES;
    _cScrollView.bounces = NO;
    _cScrollView.showsHorizontalScrollIndicator = NO;
    _cScrollView.delegate = self;
    [self.view addSubview:_cScrollView];
    [_listSegmentView setSelectIndex:0];
    
    if ([self.type intValue] == 1)
    {
        //当日排行
        if (!_contributionV1)
        {
            _contributionV1 = [[SContributionView alloc]initWithFrame:CGRectMake(0, 0,_cScrollView.width, _cScrollView.height) andDataType:1 andUserId:self.user_id andLiveRoomId:self.liveAVRoomId];
            _contributionV1.CDelegate = self;
            _contributionV1.backgroundColor = kClearColor;
            [_cScrollView addSubview:_contributionV1];
        }
    }
    
    //累计排行
    if (!_contributionV2)
    {
        if ([self.type intValue] == 1)
        {
          _contributionV2 = [[SContributionView alloc]initWithFrame:CGRectMake(kScreenW, 0,_cScrollView.width, _cScrollView.height) andDataType:2 andUserId:self.user_id andLiveRoomId:self.liveAVRoomId];
        }else
        {
        _contributionV2 = [[SContributionView alloc]initWithFrame:CGRectMake(0, 0,_cScrollView.width, _cScrollView.height) andDataType:2 andUserId:self.user_id andLiveRoomId:self.liveAVRoomId];
        }
        _contributionV2.backgroundColor = kClearColor;
        _contributionV2.CDelegate = self;
     [_cScrollView addSubview:_contributionV2];
    }
    
    
    if ([self.type intValue]== 1)
    {
      [_cScrollView scrollRectToVisible:CGRectMake(0, 0, _cScrollView.width, CGRectGetHeight(_cScrollView.frame)) animated:NO];
    }else
    {
      [_cScrollView scrollRectToVisible:CGRectMake(_cScrollView.width, 0, _cScrollView.width, CGRectGetHeight(_cScrollView.frame)) animated:NO];
      _cScrollView.alwaysBounceHorizontal = NO;
    }
   
    if ([self.BuguLive.appModel.open_ranking_list intValue] ==1)
    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 5, 50, 30);
        rightButton.tag = 1;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [rightButton setTitle:ASLocalizedString(@"总榜")forState:UIControlStateNormal];
        [rightButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [rightButton setTitleColor:kAppGrayColor4 forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(totalListClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    [self.view addSubview:self.titleL];
    [self.view addSubview:self.backBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark --SegmentView代理方法
- (void)segmentView:(SegmentView*)segmentView selectIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2f animations:^{
        _cScrollView.contentOffset = CGPointMake(_cScrollView.frame.size.width*index, 0);
    }];
    
    self.segBgView.centerX = index ==0 ? kScreenW / 4 : kScreenW / 4 * 3;
    self.segBgView.centerY = _listSegmentView.centerY;
    
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

- (void)goToHomeWithModel:(UserModel *)model
{
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = model.user_id;
    tmpController.type = 0;
    [self.navigationController pushViewController:tmpController animated:NO];
}

- (void)backClick
{
    if (self.navigationController.viewControllers.count >1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)totalListClick:(UIButton *)button
{
    LeaderboardViewController *boardVC = [[LeaderboardViewController alloc]init];
    boardVC.isHiddenTabbar = YES;
    if (self.liveHost_id.length)
    {
        boardVC.hostLiveId = self.liveHost_id;
    }
    [self.navigationController pushViewController:boardVC animated:YES];
}

-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 420)];
        _bgImgView.image = [UIImage imageNamed:@"bogo_contributeList_BGImage"];
        BogoRankHeadGifView *headGifView = [[BogoRankHeadGifView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, _bgImgView.height)];
        headGifView.backgroundColor = kClearColor;
        [_bgImgView addSubview:headGifView];
    }
    return _bgImgView;
}


-(UIImageView *)segBgView{
    if (!_segBgView) {
        _segBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(66), kRealValue(23))];
        _segBgView.image = [UIImage imageNamed:@"bogo_contribute_seg_bgView"];
        _segBgView.userInteractionEnabled = YES;
        
        _segBgView.centerX =kScreenW / 4;
        _segBgView.centerY = _listSegmentView.centerY;
    }
    return _segBgView;
}

@end
