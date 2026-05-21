
//
//  Type3ViewControllerFirst.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/5.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "SHomePageVC.h"
#import "TCNestScrollPageView.h"
#import "TTCCom.h"
#import "ReactiveObjC.h"
#define imageScale (18.0/11)
#define headerHeight kRealValue(437)
#define naviHederH kTopHeight
#define nestScrollPageYOffset  kTopHeight

#import "SHomeSVideoV.h"
#import "SHomeInfoV.h"

//#import "YHTimeLineListController.h"

#import "BogoTimeLineListViewController.h"
#import "UserHomeModel.h"
#import "MainPageView.h"
#import "MPCHeadView.h"
#import "SHomeNavView.h"
#import "SSaveHeadViewVC.h"
#import "GetHeadImgViewController.h"
#import "FollowerViewController.h"
#import "MGSaveHeadImgViewController.h"
#import "HMVideoPlayerViewController.h"
#import "BogoShopKit.h"
#import "BGVideoDetailController.h"
#import "ContributionListViewController.h"

//MGTimeLineDidScrollViewDelegate
@interface SHomePageVC ()<privateLetterDelegate,videoDeleGate,BogoTimeLineDidScrollViewDelegate,MPCHeadViewDelegate>

@property (nonatomic, strong) UIView *titleHeaderView;
//@property (nonatomic, strong) MyHeaderView *nestPageScrollHeaderView;

@property ( nonatomic, strong) SHomeInfoV           *homeInfoV;                    //主页的view
@property ( nonatomic, strong) SHomeSVideoV         *smallVideoV;                  //小视频的view
@property(nonatomic, strong) BogoTimeLineListViewController *smallDynamicV;

@property(nonatomic, strong) UserHomeModel *model;
@property(nonatomic, strong) NSMutableArray *imageArray;
@property ( nonatomic, strong) MainPageView         *bottomView;                   //底部的view
@property ( nonatomic, strong) MPCHeadView          *myTableHeadView;              //myTableview的headView
@property(nonatomic, strong) SHomeNavView *navView;
@property ( nonatomic, assign) BOOL                 canClickItem;                  //防止重复点击

@end

@implementation SHomePageVC

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.canClickItem = YES;
    self.homeInfoV = [[SHomeInfoV alloc] init];
    self.smallDynamicV = [[BogoTimeLineListViewController alloc]initWithIndexAct:MGDTHOMETYPE_MY withUID:self.user_id isHomePageFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight - 40 - 60)];
//    self.smallDynamicV.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight - 40 - 60 - 50);
//
//    self.smallDynamicV.view.height = kScreenH - kTopHeight - 40 - 60 - 50 - 100;
    
    self.smallVideoV = [[SHomeSVideoV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight - 40 - 60) andUserId:self.user_id];
    self.smallVideoV.VDelegate = self;
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:@[self.homeInfoV,self.smallDynamicV,self.smallVideoV]];
    NSMutableArray *arry_seg_title = [NSMutableArray arrayWithArray:@[ASLocalizedString(@"资料"),ASLocalizedString(@"动态"),ASLocalizedString(@"小视频")]];
    //分别创建 处理分页的  |  嵌套滚动的View  |  header头
    //1.创建TCViewPage处理分页(有些开发者可能之前已经写过分页的控件,只不过是没有实现嵌套滚动功能,那么你完全可以不需要用我的TCViewPager,你继续创建你项目里之前的分页控件,然后最后把你的分页控件传给TCNestScrollPageView就可以了)
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.titleArray = arry_seg_title;
    pageParam.showBottomGradientLayer = NO;
    pageParam.tabTitleColor = [UIColor colorWithHexString:@"777777"];
    pageParam.tabSelectedTitleColor = [UIColor colorWithHexString:@"#9152F8"];
    pageParam.labelFont = [UIFont systemFontOfSize:16];
//    pageParam.tabSelectedBottomLineColor = [UIColor purpleColor];
    pageParam.showSelectedBottomLine = YES;
    pageParam.selectedBottomLineScale = 0.5;
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) views:vcArray param:pageParam];
   
    //2.创建你自己界面需要展示的嵌套headser
//    self.nestPageScrollHeaderView = [self getHeader];
    //3.创建TCNestScrollPageView处理嵌套滚动
    TCNestScrollParam *nestScrollParam = [[TCNestScrollParam alloc] init];
    nestScrollParam.pageType = NestScrollPageViewHeadViewSuckTopType;
    nestScrollParam.yOffset = kTopHeight;
    TCNestScrollPageView *scrollPageView = [[TCNestScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self.user_id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier] ? SCREEN_HEIGHT : SCREEN_HEIGHT - 60 - MG_BOTTOM_MARGIN) headView:self.myTableHeadView viewPageView:viewPager nestScrollParam:nestScrollParam];
    [self.view addSubview:scrollPageView];
    @weakify(self);
    scrollPageView.didScrollBlock = ^(CGFloat dy) {
        @strongify(self);
        //滚动过程中你需要的界面UI变化
        [self nestScrollPageViewDidScroll:dy];
    };
    [self createtitleHeaderView];
    [self loadHomeNetWithPage:1];
    if (![self.user_id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        [self.view addSubview:self.bottomView];
    }
}

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
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
    
        self.model = [UserHomeModel mj_objectWithKeyValues:responseJson];
        if (self.model.status == 1) {
            self.bottomView.has_focus = self.model.has_focus;
            self.bottomView.has_black = self.model.has_black;
            [self.bottomView changeState];
            [self.myTableHeadView setViewWithModel:self.model withUserId:self.user_id];
            NSArray *array = [[responseJson objectForKey:@"user"] objectForKey:@"new_item"];
            [self.homeInfoV setViewWithArray:array andMDict:nil];
            NSDictionary *liveDict = responseJson[@"video"];
            [self.myTableHeadView setUIWithDict:liveDict];
        }
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        
    }];
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

#pragma mark - privateLetterDelegate
- (void)sentPersonLetter:(NSString*)taguserid
{
    SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:[self.user_id intValue]];
    chattag.mNick_name = self.model.user.nick_name;
    chattag.mHead_image = self.model.user.head_image;
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
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

#pragma mark - MPCHeadViewDelegate
- (void)headView:(MPCHeadView *)headView didClickContribution:(UITableViewCell *)cell{
    ContributionListViewController *contributionVC = [[ContributionListViewController alloc]init];
    contributionVC.user_id = self.user_id;
    contributionVC.type = @"1";
    
    [self.navigationController pushViewController:contributionVC animated:NO];
}

#pragma mark - Action
- (void)rightBtnAction{
    FDActionSheet *actionSheet = [[FDActionSheet alloc] initWithTitle:@"" message:@""];
    [actionSheet addAction:[FDAction actionWithTitle:self.model.has_black == 1 ?ASLocalizedString( @"解除拉黑") :ASLocalizedString( @"加入黑名单") type:FDActionTypeDefault CallBack:^{
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
        [dictM setObject:@"user" forKey:@"ctl"];
        [dictM setObject:@"set_black" forKey:@"act"];
        [dictM setObject:[NSString stringWithFormat:@"%@",self->_user_id] forKey:@"to_user_id"];
        
        [[NetHttpsManager manager] POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
         {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
             if ([responseJson toInt:@"status"] == 1)
             {
                 if (self.model.has_black == 1)//未拉黑
                 {
                      [mDict setObject:@"0" forKey:@"isShowFollow"];
                     
                 }else if (self.model.has_black == 0)//已拉黑
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
            if ([[GlobalVariables sharedInstance].liveState.roomId intValue]>0)
            {
                [FanweMessage alertHUD:ASLocalizedString(@"当前有视频正在播放")];
            }
            else
            {
                UserModel *liveModel = [UserModel mj_objectWithKeyValues:self.model.video];
//                [self joinRoom:liveModel];
                
                if(liveModel.password.length > 0)
                {
                    
                }
                else
                {
                    [self joinRoom:liveModel];
                    return;
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"请输入房间密码")preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = ASLocalizedString(@"请输入密码");
                    textField.delegate = self;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }];
                UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:actionCacel];
                UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:ASLocalizedString(@"确定")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *password = alertController.textFields.firstObject.text;
                    NSString *md5Str = [[NSString md5String:password] uppercaseString];
                    //转化为大写
                    
                    if ([md5Str isEqualToString:liveModel.password]) {
                        [self joinRoom:liveModel];
                    }else{
                        [FanweMessage alertHUD:ASLocalizedString(@"密码不正确")];
                    }
                }];
                [alertController addAction:actionConfirm];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
            break;
        case 102:
        {
            SSaveHeadViewVC *headVC = [[SSaveHeadViewVC alloc]init];
            headVC.url = [NSURL URLWithString:self.model.user.head_image];
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
//            BogoOtherShopDetailViewController *shopVC = [[BogoOtherShopDetailViewController alloc]initWithNibName:@"BogoOtherShopDetailViewController" bundle:kShopKitBundle];
//            shopVC.user_id = self.user_id;
//            [self.navigationController pushViewController:shopVC animated:YES];
        }
            break;
            
        case 114:
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

- (void)changeClickState
{
    self.canClickItem = YES;
}



- (void)createtitleHeaderView {
    UIView *titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, naviHederH)];
    self.titleHeaderView = titleHeaderView;
    titleHeaderView.alpha = 0.0;
    [self.view addSubview:titleHeaderView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = titleHeaderView.bounds;
    imageView.clipsToBounds = YES;
    [titleHeaderView addSubview:imageView];

    //设置UIVisualEffectView
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.backgroundColor = RGBA(0, 0, 0, 0.3);
    visualView.frame = imageView.bounds;
    [imageView addSubview:visualView];
   
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.tintColor = [UIColor whiteColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIButton *rightBtn = [[UIButton alloc] init];
//    rightBtn.frame = CGRectMake(kScreenW - 44, kStatusBarHeight, 44, 44);
//    [rightBtn setImage:[UIImage imageNamed:ASLocalizedString(@"主页_更多")] forState:UIControlStateNormal];
//    rightBtn.tintColor = [UIColor whiteColor];
//    [self.view addSubview:rightBtn];
//    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nestScrollPageViewDidScroll:(CGFloat)dy {
    NSLog(@"%lf  %lf",dy,headerHeight - nestScrollPageYOffset);
    if(dy >= headerHeight - nestScrollPageYOffset) {
        self.titleHeaderView.alpha = 1;
    } else {
        self.titleHeaderView.alpha = dy / (headerHeight - nestScrollPageYOffset);
    }
}

//返回
- (void)leftAction
{
    
//    BOOL isFocus = self.myTableHeadView.concertBtn.
    
    if (self.clickHomePageBlock) {
        self.clickHomePageBlock(self.model);
    }
    if (self.navigationController.viewControllers.count >1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
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

-(SHomeNavView *)navView{
    if (!_navView) {
        _navView = [[SHomeNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kTopHeight)];
        _navView.backgroundColor = kClearColor;
        [self.view bringSubviewToFront:_navView];
        __weak __typeof(self)weakSelf = self;
        _navView.clickBtnBlock = ^(NSInteger index) {
            if (index == 10) {


            }else if (index == 11){
//                [weakSelf pushToVCWithIndex:101];
                
            }
        };
    }
    return _navView;
}

- (MPCHeadView *)myTableHeadView{
    if (!_myTableHeadView) {
        
        if (isIPhone6P()) {
//            _myTableHeadView.height = kRealValue(400);
            _myTableHeadView = [[MPCHeadView alloc]initWithFrame:CGRectMake(0,0 , kScreenW,kRealValue(420)) andHeadType:2];
        }else{
            _myTableHeadView = [[MPCHeadView alloc]initWithFrame:CGRectMake(0,0 , kScreenW,kRealValue(447)) andHeadType:2];
        }
        
        FWWeakify(self)
        [_myTableHeadView setHeadViewBlock:^(int btnIndex){
            FWStrongify(self)
            [self pushToVCWithIndex:btnIndex];
        }];
        [_myTableHeadView setHeadViewAttentionBlock:^(BOOL isAttention) {
            
        }];
        _myTableHeadView.headViewBgImageBlock = ^(UIImage *image) {
            FWStrongify(self)
            MGSaveHeadImgViewController *vc = [[MGSaveHeadImgViewController alloc]initWithHeadImageWithImage:image];
            [self.navigationController pushViewController:vc animated:YES];
        };
        _myTableHeadView.delegate = self;
    }
    return _myTableHeadView;
}

@end
