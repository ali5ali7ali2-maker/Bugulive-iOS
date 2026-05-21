//
//  SHomePageVC.m
//  BuguLive
//
//  Created by 丁凯 on 2017/7/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SHomePageVC_old.h"
#import "MainPageView.h"
#import "HPContributionCell.h"
#import "MJRefresh.h"
#import "MainLiveTableViewCell.h"
#import "FollowerViewController.h"
#import "GetHeadImgViewController.h"
#import "SSaveHeadViewVC.h"
#import "MPCHeadView.h"
#import "SHomeSVideoV.h"
#import "SHomeLiveV.h"
#import "SHomeInfoV.h"
#import "BGVideoDetailController.h"

#import "SHomeNavView.h"
#import "SHomeDynamicView.h"

#import "YHTimeLineListController.h"
#import "MGSaveHeadImgViewController.h"

#import "HMVideoPlayerViewController.h"
#import "BogoShopKit.h"

@interface SHomePageVC_old ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,privateLetterDelegate,videoDeleGate,LiveDeleGate,MGTimeLineDidScrollViewDelegate>

@property ( nonatomic, strong) MainPageView         *bottomView;                   //底部的view
@property ( nonatomic, strong) UIView               *homeOrLiveView;               //主页 直播 小视频的view
@property ( nonatomic, strong) UIImageView               *HLineView1;                   //横线1
@property ( nonatomic, strong) UIView               *VLineView;                    //竖线1
@property ( nonatomic, strong) UIView               *newestOrHotView;              //最新 最热的view
@property ( nonatomic, strong) NSMutableArray       *imageArray;                   //贡献右边显示的头像
@property ( nonatomic, strong) NSArray              *countArray;                   //主页信息的个数
@property ( nonatomic, strong) MPCHeadView          *myTableHeadView;              //myTableview的headView

@property ( nonatomic, strong) UITableView          *myTableView;                  //tableView
@property ( nonatomic, strong) NSDictionary         *liveDict;                     //进入直播的信息
@property (nonatomic, strong) NSArray *nameArray;
@property ( nonatomic, strong) UserModel            *userModel;                    //用户信息的模型
@property ( nonatomic, assign) BOOL                 isCouldLiveData;               //是否可以加载
@property ( nonatomic, assign) int                  currentPage;                   //当前页
@property ( nonatomic, assign) int                  has_next;                      //是否还有下一页
@property ( nonatomic, assign) BOOL                 canClickItem;                  //防止重复点击
@property ( nonatomic, strong) UIScrollView         *myScrollView;                 //滚动的ScrollView
@property ( nonatomic, strong) SHomeInfoV           *homeInfoV;                    //主页的view
@property ( nonatomic, strong) SHomeLiveV           *homeLiveV;                    //直播的view
@property ( nonatomic, strong) SHomeSVideoV         *smallVideoV;                  //小视频的view
//@property ( nonatomic, strong) SHomeDynamicView     *smallDynamicV;
@property(nonatomic, strong) YHTimeLineListController *smallDynamicV;

@property ( nonatomic, assign) NSInteger            startPage;                     //起始页

@property(nonatomic, strong) SHomeNavView *navView;

@property(nonatomic, assign) BOOL isAttention;

@end

@implementation SHomePageVC_old{
    CGFloat _scrollOffsetHeight;
}

-(NSArray *)nameArray{
    if (!_nameArray) {
        _nameArray = @[ASLocalizedString(@"资料"),ASLocalizedString(@"动态"),ASLocalizedString(@"小视频")];
    }
    return _nameArray;
}

-(SHomeNavView *)navView{
    if (!_navView) {
        _navView = [[SHomeNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kTopHeight)];
        _navView.backgroundColor = kClearColor;
        [self.view bringSubviewToFront:_navView];
        __weak __typeof(self)weakSelf = self;
        _navView.clickBtnBlock = ^(NSInteger index) {
            if (index == 10) {

                [weakSelf leftAction];

            }else if (index == 11){
//                [weakSelf pushToVCWithIndex:101];
                FDActionSheet *actionSheet = [[FDActionSheet alloc] initWithTitle:@"" message:@""];
                [actionSheet addAction:[FDAction actionWithTitle:self.userModel.has_black.integerValue == 1 ?ASLocalizedString( @"解除拉黑") :ASLocalizedString( @"加入黑名单") type:FDActionTypeDefault CallBack:^{
                    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
                    [dictM setObject:@"user" forKey:@"ctl"];
                    [dictM setObject:@"set_black" forKey:@"act"];
                    [dictM setObject:[NSString stringWithFormat:@"%@",self->_user_id] forKey:@"to_user_id"];
                    
                    [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
                     {
                        NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
                         if ([responseJson toInt:@"status"] == 1)
                         {
                             self.userModel.has_black = [responseJson toString:@"has_black"];
                             if (self.userModel.has_black.integerValue == 1)//未拉黑
                             {
                                  [mDict setObject:@"0" forKey:@"isShowFollow"];
                                 
                             }else if (self.userModel.has_black.integerValue == 0)//已拉黑
                             {
                                 [mDict setObject:@"1" forKey:@"isShowFollow"];
                             }
                             if (self.user_id.length)
                             {
                                 [mDict setObject:self.user_id forKey:@"userId"];
                             }
                             [[NSNotificationCenter defaultCenter]postNotificationName:@"liveIsShowFollow" object:mDict];
                         }
                         
                     } FailureBlock:^(NSError *error)
                     {
                         
                     }];
                }]];
                [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:nil]];
                [actionSheet show:[UIApplication sharedApplication].keyWindow];
            }
        };
    }
    return _navView;
}

- (void)leftAction
{
    
//    BOOL isFocus = self.myTableHeadView.concertBtn.
    
    if (self.clickHomePageBlock) {
        self.clickHomePageBlock(self.isAttention);
    }
    if (self.navigationController.viewControllers.count >1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 是否显示关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowFollow:) name:@"liveIsShowFollow" object:nil];
    self.view.backgroundColor = kWhiteColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.smallVideoV refreshHeader];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)initFWUI
{
    [super initFWUI];
    self.startPage  = 0;
    self.currentPage = 1;
    self.canClickItem = YES;
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.navView];
    if (![self.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId])
    {
        self.bottomView.hidden = NO;
        self.navView.rightBtn.hidden = NO;
//        [self.view addSubview:self.bottomView];
    }else
    {
        self.myTableHeadView.concertBtn.hidden = YES;
        self.navView.rightBtn.hidden = YES;
        self.bottomView.hidden = YES;
        CGRect rect = self.myTableView.frame;
        rect.size.height = kScreenH;
        self.myTableView.frame = rect;
    }
}

#pragma mark 是否显示关注通知的实现
- (void)isShowFollow:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.object;
    if ([interuptionDict toString:@"userId"])
    {

        if ([[interuptionDict objectForKey:@"isShowFollow"] isEqualToString:@"1"]) {
            
        }else{
//            [self.myTableHeadView.concertBtn setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
            [self.myTableHeadView.concertBtn setBackgroundImage:[UIImage imageNamed:@"bogo_home_person_Concert_normal"] forState:UIControlStateNormal];
            self.isAttention = NO;
//             setImage:[UIImage imageNamed:@"bogo_home_person_Concert_normal"] forState:UIControlStateNormal];
//            bogo_home_person_Concert_select
//            [self.myTableHeadView.concertBtn setBackgroundImage:[UIImage imageNamed:@"mg_new_list_concert"] forState:UIControlStateNormal];
//            [self.myTableHeadView.concertBtn setBackgroundColor:kWhiteColor];
            self.myTableHeadView.concertBtn.layer.cornerRadius = 5;
        }
    }
}


- (void)initFWData
{
    [super initFWData];
    [self loadHomeNetWithPage:1];
    [self showMyHud];
}

#pragma mark  数据加载
//主页数据请求
- (void)loadHomeNetWithPage:(int)page
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"user" forKey:@"ctl"];
    if (self.user_id)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [parmDict setObject:@"user_home" forKey:@"act"];
    
    FWWeakify(self)
    
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        [self hideMyHud];
        if ([responseJson toInt:@"status"] == 1)
        {
            if ([responseJson objectForKey:@"user"] && [[responseJson objectForKey:@"user"] count])
            {
                self.user_headimg = [[responseJson objectForKey:@"user"] toString:@"head_image"];
                self.user_nickname = [[responseJson objectForKey:@"user"] toString:@"nick_name"];
                //                 [self changeAlaphViewUI];
            }
            //印票贡献前3名的图标
            NSArray *cuser_listArray = [responseJson objectForKey:@"cuser_list"];
            if (cuser_listArray)
            {
                if (cuser_listArray.count > 0 )
                {
                    for (NSDictionary *dict in cuser_listArray)
                    {
                        SenderModel *model = [SenderModel new];
                        model.head_image = [dict objectForKey:@"head_image"];
                        [self.imageArray addObject:model.head_image];
                    }
                }
            }
            //获取字典的个数
            
//            NSArray *itemArr = [NSArray modelArrayWithClass:<#(nonnull Class)#> json:<#(nonnull id)#>]
            
            NSArray *array = [[responseJson objectForKey:@"user"] objectForKey:@"new_item"];
            self.countArray = array;
            self.bottomView.has_focus = [responseJson toInt:@"has_focus"];
            self.bottomView.has_black = [responseJson toInt:@"has_black"];
            [self.bottomView changeState];
            
//            self.userModel = [UserModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];
            UserModel *infomodel = [UserModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];
            self.userModel = [UserModel mj_objectWithKeyValues:responseJson];
            self.userModel.shop_status = infomodel.shop_status;
            [self.myTableHeadView setViewWithModel:self.userModel withUserId:self.user_id];
            self.isAttention = [self.userModel.has_focus isEqualToString:@"1"];
            self.liveDict = responseJson[@"video"];
            [self.myTableHeadView setUIWithDict:self.liveDict];
            
            
            UserModel *model2 = [UserModel mj_objectWithKeyValues:self.liveDict];
            if (model2.live_in == FW_LIVE_STATE_ING)
            {
//                [self.navView.rightBtn setTitle:ASLocalizedString(@"直播中")forState:UIControlStateNormal];
            }
            else if (model2.live_in == FW_LIVE_STATE_RELIVE)
            {
//                [self.navView.rightBtn setTitle:ASLocalizedString(@"回播中")forState:UIControlStateNormal];
            }
            
            [self.homeInfoV setViewWithArray:self.countArray andMDict:self.userModel.user.item];
            
            if (self.liveDict) {
                UserModel *model2 = [UserModel mj_objectWithKeyValues:self.userModel.user.item];
//                if (model2.live_in == FW_LIVE_STATE_ING)
//                {
//                    [self.navView.rightBtn setTitle:ASLocalizedString(@"直播中")forState:UIControlStateNormal];
//                }
//                else if (model2.live_in == FW_LIVE_STATE_RELIVE)
//                {
//                    [self.navView.rightBtn setTitle:ASLocalizedString(@"回播中")forState:UIControlStateNormal];
//                }
                self.navView.rightBtn.hidden = [[IMAPlatform sharedInstance].host.imUserId isEqualToString:self.user_id];
            }else{
            }
            
            
            
            [self.myTableView reloadData];
        }
        [BGMJRefreshManager endRefresh:self.myTableView];
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [self hideMyHud];
        [BGMJRefreshManager endRefresh:self.myTableView];
        
    }];
}

#pragma mark 主页和直播的点击事件
- (void)HLBtnClick:(UIButton *)btn
{
    [self updateUIWithTag:(int)btn.tag];
}

- (void)updateUIWithTag:(int)tag
{
    for (UIButton *newBtn in self.homeOrLiveView.subviews)
    {
        if ([newBtn isKindOfClass:[UIButton class]])
        {
            if (newBtn.tag ==tag)
            {
                [newBtn setTitleColor:kAppGrayColor1 forState:0];
                [UIView animateWithDuration:0.5 animations:^{
                    self.HLineView1.centerX = newBtn.centerX;
                    //                CGRect rect = self.HLineView1.frame;
                    //                rect.origin.x = kScreenW/6 -25 + kScreenW*tag/3;
                    //                self.HLineView1.frame = rect;
                }];
            }else
            {
                [newBtn setTitleColor:kAppGrayColor3 forState:0];
            }
           
        }
    }
    
    [self.myTableView setContentOffset:CGPointMake(0,0)];
    
    [_myScrollView scrollRectToVisible:CGRectMake(tag * kScreenW, 0, kScreenW, CGRectGetHeight(_myScrollView.frame)) animated:YES];
}

#pragma mark -UITableViewDelegate&UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HPZeroSection)
    {
        return kRealValue(50);
    }else if (indexPath.section == HPFirstSection)
    {
        return 0.01;
//        10*kAppRowHScale;
    }else
    {
        return kScreenW;
    }
}

//返回段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HPTab_Count;
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newNection = (int)indexPath.section;
    if (newNection == HPZeroSection)
    {
        HPContributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HPContributionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellWithArray:self.imageArray];
        return cell;
    }else if (newNection == 1)
    {
        static NSString *CellIdentifier0 = @"CellIdentifier0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackGroundColor;
        }
        return cell;
    }else
    {
        static NSString *CellIdentifier1 = @"CellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackGroundColor;
            [cell.contentView addSubview:self.myScrollView];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == HPSecondSection)
    {
        return 45*kAppRowHScale;
    }else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == HPSecondSection)
    {
        return self.homeOrLiveView;
    }else
    {
        return nil;
    }
}

#pragma mark -- 进入正在直播的直播间
-(void)joinRoom:(UserModel *)model
{
    if (self.canClickItem)// 防止重复点击
    {
        self.canClickItem = NO;
        [self performSelector:@selector(changeClickState) withObject:nil afterDelay:2];
    }else{
        return;
    }
    if (![BGUtils isNetConnected])
    {
        return;
    }
    NSDictionary *dic = model.mj_keyValues;
    // 直播管理中心 开启观众直播
    // 开启直播（先API拿直播后台类型）  非悬浮 非小屏幕
    BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
    BOOL isSmallScreen = [[LiveCenterManager sharedInstance] judgeIsSmallSusWindow];
    [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofPramaDic:dic.mutableCopy isSusWindow:isSusWindow isSmallScreen:isSmallScreen block:^(BOOL finished) {
    }];
}

- (void)changeClickState
{
    self.canClickItem = YES;
}

#pragma mark 私信
- (void)sentPersonLetter:(NSString*)taguserid
{
    SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:[self.user_id intValue]];
    chattag.mNick_name = self.user_nickname;
    chattag.mHead_image = self.user_headimg;
    BGConversationServiceController* chatvc = [BGConversationServiceController makeChatVCWith:chattag];
    //ykk
    //加判断 避免循环push
    //如果上个界面是 聊天信息VC
    for(UIViewController *last_C in self.navigationController.viewControllers)
    {
        if([last_C isKindOfClass:[BGConversationServiceController class]])
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController pushViewController:chatvc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HPZeroSection)
    {
        ContributionListViewController *contributionVC = [[ContributionListViewController alloc]init];
        contributionVC.user_id = self.user_id;
        contributionVC.type = @"1";
        
        [self.navigationController pushViewController:contributionVC animated:NO];
    }
}

- (void)comeBackTap
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

#pragma mark ===============================================getter方法===================================================
#pragma mark 主页和直播
- (UIView *)homeOrLiveView
{
    if (!_homeOrLiveView)
    {
        _homeOrLiveView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 45*kAppRowHScale)];
        _homeOrLiveView.backgroundColor = kWhiteColor;
        
        CGFloat btnWidth = kScreenW / _nameArray.count - kRealValue(10);
        for (int i = 0; i < _nameArray.count; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(btnWidth*i ,10,btnWidth, 40);
            [button setTitle:_nameArray[i] forState:0];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            if (self.type == i)
            {
                [button setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            }else
            {
                [button setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
            }
            button.tag = i;
            [button addTarget:self action:@selector(HLBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_homeOrLiveView addSubview:button];
            
//            if (i < nameArray.count -1)
//            {
//                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW*(i+1)/3 - 1, (45-15)*kAppRowHScale/2, 1,15*kAppRowHScale)];
//                lineView.backgroundColor = kAppSpaceColor4;
//                [_homeOrLiveView addSubview:lineView];
//            }
        }
        
        self.HLineView1 = [[UIImageView alloc]init];
        self.HLineView1.frame = CGRectMake(kScreenW/6 -25 +kScreenW*(self.type)/3, 45*kAppRowHScale - 10, 20, 3);
        [self.HLineView1 setImage:[UIImage imageNamed:@"mg_text_bottomView"]];
        self.HLineView1.centerX = btnWidth / 2;
        [_homeOrLiveView addSubview:self.HLineView1];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( kRealValue(10),0, kScreenW - kRealValue(10 * 2),1)];
        view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [_homeOrLiveView addSubview:view];
    }
    return _homeOrLiveView;
}

- (UITableView *)myTableView
{
    if (!_myTableView)
    {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,-22 - MG_BOTTOM_MARGIN, kScreenW, kScreenH-50)];
        _myTableView.backgroundColor = kBackGroundColor;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        self.myTableHeadView = [[MPCHeadView alloc]initWithFrame:CGRectMake(0,0 , kScreenW,kRealValue(387)) andHeadType:2];
//        self.myTableHeadView.clearView.backgroundColor = kWhiteColor;
        FWWeakify(self)
        [self.myTableHeadView setHeadViewBlock:^(int btnIndex){
            FWStrongify(self)
            [self pushToVCWithIndex:btnIndex];
        }];
        [self.myTableHeadView setHeadViewAttentionBlock:^(BOOL isAttention) {
            FWStrongify(self)
            self.isAttention = isAttention;
            self.bottomView.has_black = isAttention ? 0 : 1;
            if (isAttention) [self.bottomView changeState];
        }];
        self.myTableHeadView.headViewBgImageBlock = ^(UIImage *image) {
            FWStrongify(self)
            MGSaveHeadImgViewController *vc = [[MGSaveHeadImgViewController alloc]initWithHeadImageWithImage:image];
            [self.navigationController pushViewController:vc animated:YES];
        };
   
        _myTableView.tableHeaderView = self.myTableHeadView;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:@"HPContributionCell" bundle:nil] forCellReuseIdentifier:@"HPContributionCell"];
    }
    return _myTableView;
}

- (void)pushToVCWithIndex:(int)btnTag
{
    switch (btnTag) {
        case 100:
        {
            if ([self.navigationController topViewController] == self)
            { //如果有导航控制器,并且顶部就是自己,那么应该返回
                if (self.navigationController.viewControllers.count == 1)
                { //如果只有一个
                    if (self.presentingViewController)
                    { //如果有就dismiss
                        
                        [self dismissViewControllerAnimated:YES
                                                 completion:^{
                                    
                         }];
                        return;
                    }
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }
            else //其他情况,就再判断是否有 presentingViewController
            {
                if (self.presentingViewController)
                { //如果有就dismiss
                    [self dismissViewControllerAnimated:YES
                                             completion:^{
                                             }];
                    return;
                }
            }
            
        }
            break;
        case 101:
        {
            if ([self.BuguLive.liveState.roomId intValue]>0)
            {
                [FanweMessage alertHUD:ASLocalizedString(@"当前有视频正在播放")];
            }
            else
            {
                UserModel *liveModel = [UserModel mj_objectWithKeyValues:self.liveDict];
                [self joinRoom:liveModel];
            }
        }
            break;
        case 102:
        {
            SSaveHeadViewVC *headVC = [[SSaveHeadViewVC alloc]init];
            headVC.url = [NSURL URLWithString:self.userModel.user.head_image];
            [[AppDelegate sharedAppDelegate]pushViewController:headVC animated:YES];
        }
            break;
        case 103:
        {
            //送出 没有，个人中心才有
        }
            break;
        case 104:
        {
            //送出 没有，没有点击事件
            BogoOtherShopDetailViewController *shopVC = [[BogoOtherShopDetailViewController alloc]initWithNibName:@"BogoOtherShopDetailViewController" bundle:kShopKitBundle];
            shopVC.user_id = self.user_id;
            [self.navigationController pushViewController:shopVC animated:YES];
        }
            break;
        case 105:
        {
            FollowerViewController *followVC = [[FollowerViewController alloc]init];
            followVC.user_id = self.user_id;
            followVC.type = @"1";
            [self.navigationController pushViewController:followVC animated:NO];
//            [[AppDelegate sharedAppDelegate] pushViewController:followVC animated:YES];
        }
            break;
        case 106:
        {
            FollowerViewController *followVC = [[FollowerViewController alloc]init];
            followVC.user_id = self.user_id;
            followVC.type = @"2";
            [self.navigationController pushViewController:followVC animated:NO];
//            [[AppDelegate sharedAppDelegate] pushViewController:followVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)didVideoCollectionViewScrollView:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y;
    
    NSLog(@"%f",offset);
        
//    CGFloat scrollHeight = self.navView.height + _homeOrLiveView.height + _bottomView.height;
    
    CGFloat homeOrLiveTop = self.myTableHeadView.height + self.homeOrLiveView.height - 45*kAppRowHScale - self.navView.height;
    
    if (offset > homeOrLiveTop) {
        
        [self.myTableView setContentOffset:CGPointMake(0, homeOrLiveTop)];
        
        return;
    }
    
    [self.myTableView setContentOffset:CGPointMake(0, offset < 0 ? 0 : offset)];
//    [self.myScrollView setContentOffset:CGPointMake(kScreenW * 2, offset < 0 ? 0 : offset)];
//    self.myScrollView.height = self.smallVideoV.height = self.smallVideoV.videoCollectionV.height =  kScreenH - homeOrLiveTop + 44 - MG_BOTTOM_MARGIN * 3;
    
//    self.myTableView.height =  self.myScrollView.height = self.smallVideoV.height = self.smallVideoV.videoCollectionV.height = self.smallVideoV.videoCollectionV.height = kScreenH - kTopHeight - MG_BOTTOM_MARGIN - self.bottomView.height;
    
    NSLog(@"offsetoffsetoffset%f",offset);
    NSLog(@"%f",kScreenH - kTopHeight - MG_BOTTOM_MARGIN - self.bottomView.height);
    
//    kScreenH - homeOrLiveTop  - self.bottomView.height - MG_BOTTOM_MARGIN + 45*kAppRowHScale ;
    
    
    [self didDynamicCollectionViewScrollView:scrollView];
}

-(void)didDynamicCollectionViewScrollView:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y;
    
    CGFloat homeOrLiveTop = self.myTableHeadView.height + self.homeOrLiveView.height - 45*kAppRowHScale - self.navView.height - 50 - kStatusBarHeight;
    
    if (offset > homeOrLiveTop) {
        
        [self.myTableView setContentOffset:CGPointMake(0, homeOrLiveTop)];
        
        return;
    }
    
    [self.myTableView setContentOffset:CGPointMake(0, offset < 0 ? 0 : offset)];
    self.myScrollView.height = self.smallDynamicV.view.height = self.smallDynamicV.tableView.height = kScreenH - homeOrLiveTop  - self.bottomView.height - MG_BOTTOM_MARGIN ;
//    self.smallVideoV.height = self.smallVideoV.videoCollectionV.height =  kScreenH - homeOrLiveTop + 44;
    
    
    [self scrollViewDidScroll:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > kScreenH * 0.1) {
        self.navView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }else if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y == 0){
        self.navView.backgroundColor = kClearColor;
    }
    
    NSLog(@"contentOffsetcontentOffsetY:%f",scrollView.contentOffset.y);
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"MainPageView" owner:self options:nil] objectAtIndex:0];
        _bottomView.delegate = self;
        _bottomView.user_id = self.user_id;
        _bottomView.frame = CGRectMake(0,kScreenH - 60 - MG_BOTTOM_MARGIN,kScreenW,60);
        _bottomView.backgroundColor = kClearColor;
    }
    return _bottomView;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

- (UIScrollView *)myScrollView
{
    if (!_myScrollView)
    {
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,kScreenW)];
        _myScrollView.delegate = self;
        _myScrollView.backgroundColor = kBackGroundColor;
        _myScrollView.pagingEnabled = YES;
        _myScrollView.scrollEnabled = NO;
        _myScrollView.contentSize = CGSizeMake(kScreenW * self.nameArray.count, CGRectGetHeight(_myScrollView.frame));
        
        self.homeInfoV = [[SHomeInfoV alloc]initWithFrame:CGRectMake(0, 0, kScreenW, _myScrollView.height - 60 + MG_BOTTOM_MARGIN) ];
        [_myScrollView addSubview:self.homeInfoV];
        
//        self.homeLiveV = [[SHomeLiveV alloc]initWithFrame:CGRectMake(kScreenW, 0, kScreenW, _myScrollView.height  - 60 + MG_BOTTOM_MARGIN) andUserId:self.user_id];
//        self.homeLiveV.LDelegate = self;
//        [_myScrollView addSubview:self.homeLiveV];

        
        self.smallDynamicV = [[YHTimeLineListController alloc]initWithIndexAct:MGDTHOMETYPE_MY withUID:self.user_id];
        self.smallDynamicV.vDelegate = self;
        [self addChild:self.smallDynamicV];
        self.smallDynamicV.view.frame = CGRectMake(kScreenW, -kStatusBarHeight, kScreenW, _myScrollView.height + kStatusBarHeight);
        self.smallDynamicV.tableView.frame = CGRectMake(0, 0, kScreenW, _myScrollView.height);
        [_myScrollView addSubview:self.smallDynamicV.view];
        
        
        self.smallVideoV = [[SHomeSVideoV alloc]initWithFrame:CGRectMake(kScreenW * 2, 0, kScreenW, _myScrollView.height) andUserId:self.user_id];
        self.smallVideoV.VDelegate = self;
        [_myScrollView addSubview:self.smallVideoV];
        
    }
    return _myScrollView;
}

- (void)goToLiveRoomWithModel:(UserModel *)model andView:(SHomeLiveV *)homeLiveView
{
    [self joinRoom:model];
}

- (void)pushToVideoDetailWithWeiboId:(NSString *)weiboId andView:(SHomeSVideoV *)homeSVideoV
{
    BGVideoDetailController *VideoVC = [[BGVideoDetailController alloc]init];
    VideoVC.weibo_id = weiboId;
//    [[AppDelegate sharedAppDelegate] pushViewController:VideoVC animated:YES];
    [self.navigationController pushViewController:VideoVC animated:NO];
}

-(void)pushToVideoDetailWithArr:(NSArray *)videos index:(NSInteger)index IsPushed:(BOOL)isPushed requestDict:(NSDictionary *)dict{
    HMVideoPlayerViewController *vc = [[HMVideoPlayerViewController alloc]initWithVideos:videos index:index IsPushed:YES requestDict:nil];
    vc.isRefreshVideoBlock = ^(BOOL isRefresh) {
//        [self refreshHeader];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _myScrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
        float tmpPage2    = scrollView.contentOffset.x / pageWidth;
        NSInteger page    = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
        
        if (_startPage != page)
        {
            [self updateUIWithTag:(int)page];
            _startPage = page;
        }
    }
}



@end
