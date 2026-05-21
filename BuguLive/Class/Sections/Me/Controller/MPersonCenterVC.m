//
//  MPersonCenterVC.m
//  BuguLive
//
//  Created by 丁凯 on 2017/7/19.
//  Copyright © 2017年 xfg. All rights reserved.
//


#import "MPersonCenterVC.h"
#import "userPageModel.h"
#import "SSearchVC.h"
#import "PersonCenterModel.h"
#import "MPersonCenterCell.h"
#import "MPCHeadView.h"
#import "UserCenterTopView.h"
#import "OnLiveViewController.h"
#import "MGInvateCodeViewController.h"//邀请码


@interface MPersonCenterVC ()<UITableViewDataSource,UITableViewDelegate>

@property ( nonatomic,strong) NSMutableArray         *titleArray;              //setion名字
@property ( nonatomic,strong) NSMutableArray         *imageArray;              //setion图片
@property ( nonatomic,strong) NSMutableArray         *detailArray;             //setion详情
@property ( nonatomic,strong) UITableView            *tableView;               //tableView
@property ( nonatomic,strong) userPageModel          *userModel;               //userModel
@property ( nonatomic,assign) BOOL                   isUserNav;                //是否使用导航栏
@property ( nonatomic,strong) UIButton               *topBtn;                  //tableView
//@property ( nonatomic,strong) MPCHeadView            *tableHeadView;           //tableHeadView
@property ( nonatomic,strong) UserCenterTopView            *tableHeadView;           //tableHeadView
@property ( nonatomic,strong) UIView                 *myLFFView;               //直播关注粉丝底部的view
@property ( nonatomic,strong) PersonCenterModel      *personCModel;            //处理UI的model
@property ( nonatomic,assign) BOOL                   isFirstLoad;              //是否第一次加载
@property ( nonatomic,assign) float                  scrollH;                  //滚动的高度

@end

@implementation MPersonCenterVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNetData) name:@"updateCoin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(IMChatHaveNewMsgNotification:) name:g_notif_chatmsg object:nil];
    
}

- (void)initFWUI
{
    [super initFWUI];
    
    
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F3F4F8"];
//    kBackGroundColor;
    self.personCModel = [[PersonCenterModel alloc]init];
//    self.tableHeadView = [[MPCHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 315) andHeadType:1];
    NSArray *objs = [[NSBundle mainBundle]loadNibNamed:@"UserCenterTopView" owner:nil options:nil];
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(390))];
    bgImgView.userInteractionEnabled = YES;
    bgImgView.image = [UIImage imageNamed:@"bogo_me_top_bgImgView"];
    [self.view addSubview:bgImgView];
    self.tableView.backgroundColor = kClearColor;
    UserCenterTopView *view = objs.firstObject;
    self.tableHeadView = view;
    
    if ([[GlobalVariables sharedInstance].appModel.ios_check_version isEqualToString:VersionNum]) {
        
    }else{
        self.tableView.tableHeaderView = self.tableHeadView;
    }
    
    

    FWWeakify(self)
    [self.tableHeadView setClickBtnBlock:^(UserCenterTopViewBtnType type) {
        FWStrongify(self)
        int section = 0;
        switch (type) {
                
            case UserCenterTopViewBtnTypeShop:
                section = MPBGSHOP;
                break;
            case UserCenterTopViewBtnTypeVIP://贵族中心
                section = MPGuiZu;
                break;
            case UserCenterTopViewBtnTypeLevel:
                section = MPCGradeSection;
                break;
            case UserCenterTopViewBtnTypeFamily:
            {
                if ([_userModel.family_id intValue] == 0)
                {
                    [self.personCModel createFamilyViewWithVC:self andModel:_userModel];
                }
                else
                {
                    [self.personCModel goToFamilyDesVCWithModel:_userModel];
                }
                return;
            }
                break;
                
            case UserCenterTopViewBtnTypeSet:
                section = MPCSetSection;
                break;
            case UserCenterTopViewBtnTypeAccount:
                section = MPCAcountSection;
                break;
            case UserCenterTopViewBtnTypeIncome:
                section = MPCIncomeSection;
                break;
            case UserCenterTopViewBtnTypeEdit:
                section = MPCMyEditSection;
                break;
            case UserCenterTopViewBtnTypeRecord:
            {
                OnLiveViewController *onliveVC = [[OnLiveViewController alloc]init];
                onliveVC.user_id = self.userModel.user_id;
                [[AppDelegate sharedAppDelegate] pushViewController:onliveVC animated:YES];
                return;
            }
                break;
            case UserCenterTopViewBtnTypeVideo:
                section = MPCMyVideoSection;
                break;
            case UserCenterTopViewBtnTypeFocus:
                section = 52;
                break;
            case UserCenterTopViewBtnTypeFan:
                section = 53;
                break;
            case UserCenterTopViewBtnTypeIcon:
                section = MPCMyInfoSection;
                break;
            case UserCenterTopViewBtnTypeSign:
                section = 999;
                break;
            default:
                break;
        }
        [self.personCModel didSelectWithModel:self.userModel andSection:section];
    }];
//    [self.tableHeadView setHeadViewBlock:^(int btnIndex){
//        FWStrongify(self)
//        int section = btnIndex-100;
//        if      (section == 0)  section = 24;   //搜索
//        else if (section == 1)  section = 25;   //IM消息
//        else if (section == 2)  section = 26;   //头像
//        else if (section == 3)  section = 27;   //编辑
//        else if (section == 4)  section = 21;   //直播
//        else if (section == 5)  section = 28;   //关注
//        else if (section == 6)  section = 22;   //粉丝
//        else if (section == 7)  section = 23;   //小视频
//        [self.personCModel didSelectWithModel:self.userModel andSection:section];
//    }];
    [self.view addSubview:self.tableView];
}

- (void)initFWData
{
    [super initFWData];
    [self loadNetData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestDataToady];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    if (!self.isFirstLoad)
    {
        [self loadNetData];
    }
    self.isFirstLoad = NO;
    [self userNavigation];
//    [self.personCModel loadBadageDataWithView:self.tableHeadView];
    [self.personCModel createExchangeCoinViewWithVC:self];
    
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:15]
    } forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isUserNav ==NO)
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



#pragma mark 导航栏相关操作的处理
- (void)userNavigation
{
    if (self.isUserNav ==NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self setStateBackColor];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)clickButtonTag:(UIButton *)button
{
    [self.personCModel didSelectWithModel:_userModel andSection:(int)button.tag+20];
}

- (void)loadNetData
{
    if (![IMAPlatform isAutoLogin])// 如果没有登录，就不需要后续操作
    {
        return;
    }
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"userinfo" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             _userModel = [userPageModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];
             UserModel *model = [UserModel modelWithDictionary:[responseJson objectForKey:@"user"]];
//             self.BuguLive.appModel.h5_url = [AppUrlModel mj_objectWithKeyValues:[responseJson objectForKey:@"h5_url"]];
             [GlobalVariables sharedInstance].is_noble_mysterious = _userModel.is_noble_mysterious;
             [GlobalVariables sharedInstance].userModel = model;
             [self.tableHeadView setViewWithModel:_userModel];
             if ([[GlobalVariables sharedInstance].appModel.ios_check_version isEqualToString:VersionNum]) {
                 
             }else{
                 self.tableView.tableHeaderView = self.tableHeadView;
             }
             [self.personCModel creatUIWithModel:_userModel andMArr:self.detailArray andMyView:self.myLFFView];
             [self.tableView reloadData];
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         [BGMJRefreshManager endRefresh:self.tableView];
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [BGMJRefreshManager endRefresh:self.tableView];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.personCModel getMyHeightWithModel:_userModel andBuguLive:self.BuguLive andSection:(int)section andType:1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
                
//    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
//    {
//        if (indexPath.section == MPCInviteUser ||indexPath.section == MPGuiZu ||indexPath.section ==   MPCGradeSection || indexPath.section == MPBGSHOP || indexPath.section == MPCarBuy || indexPath.section ==  MPCContributeSection || indexPath.section == MPCFamilySection || indexPath.section == MPCRenZhenSection || indexPath.section == MPCMySmallShop || indexPath.section == MPCLiveHostCenter )
//        {
//            return 0;
//        }
//        return 45*kAppRowHScale;
//    }
//    int  section = (int)indexPath.section;
//
//    if ([self.BuguLive.appModel.open_noble isEqualToString:@"0"] && section == MPBGSHOP) {
//        return kRealValue(45) + 8;
//    }
//
//    if (section == MPCSetInvateCode || section == MPGuiZu || section == MPCSZJLSection) {
//        return kRealValue(45) + 8;
//    }
    return kRealValue(45);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kRealValue(12), 0, kScreenW - kRealValue(12 * 2), 8)];
    view = [self setCornerViewWithView:view isTop:YES cornerNum:4];
    view.backgroundColor = kWhiteColor;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
    [bgView addSubview:view];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kRealValue(12), 0, kScreenW - kRealValue(12 * 2), 8)];
    view = [self setCornerViewWithView:view isTop:NO cornerNum:8];
    view.backgroundColor = kWhiteColor;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,8)];
    [bgView addSubview:view];
    
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        view.height = bgView.height = 0;
    }
    
    return bgView;
}

-(UIView *)setCornerViewWithView:(UIView *)view isTop:(BOOL)isTop cornerNum:(CGFloat)cornerNum{
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:isTop ? (UIRectCornerTopLeft | UIRectCornerTopRight) : (UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerNum,cornerNum)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        return 0;;
    }
    return section == 0 ? 5 : 0;
//    [self.personCModel getMyHeightWithModel:_userModel andBuguLive:self.BuguLive andSection:(int)section andType:2];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        return 0;;
    }
    
    if (section == MPCSetSection)
    {
        return 5;
//        10*kAppRowHScale;
    }else
    {
        return 0.01;
    }
}

#pragma mark HomePageDelegate 0搜索 3IM消息 4更换头像 5编辑
- (void)sentTagCount:(int)tagIndex
{
    if (tagIndex == 0)
    {
        tagIndex = 2;
    }
    [self.personCModel didSelectWithModel:_userModel andSection:22+tagIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int  section = (int)indexPath.section;
    MPersonCenterCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"MPersonCenterCell"];
    cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    [cell creatCellWithImgStr:self.imageArray[section] andLeftStr:self.titleArray[section] andRightStr:self.detailArray[section] andSection:section];
    if (section == MPCRenZhenSection && [_userModel.is_authentication integerValue] == 2)
    {
        cell.rightLabel.textColor = kAppGrayColor1;
    }else
    {
        cell.rightLabel.textColor  = kAppGrayColor3;
    }
    
    if (self.BuguLive.appModel.game_distribution !=1)// 游戏分享收益不存在  分享收益横线处理
    {
        if (self.BuguLive.appModel.distribution==1)
        {
            if (section == MPCShareISection)
            {
                cell.lineView.hidden = NO;
            }
        }
    }
    
    if ([self.BuguLive.appModel.shop_shopping_cart integerValue] != 1)//我的购物车不存在  订单管理 我的订单 商品管理横线处理
    {
        if (![_userModel.show_podcast_order isEqualToString:@""] &&[_userModel.show_podcast_order intValue] !=0)
        {
            if (section == MPCOrderMSection)
            {
                cell.lineView.hidden = YES;
            }
        }else
        {
            if (![_userModel.show_user_order isEqualToString:@""] &&[_userModel.show_user_order intValue] !=0)
            {
                if (section == MPCMyOrderSection)
                {
                    cell.lineView.hidden = YES;
                }
            }else
            {
                if (![_userModel.show_podcast_goods isEqualToString:@""] &&[_userModel.show_podcast_goods intValue] !=0)
                {
                    if (section == MPCGoodsMSection)
                    {
                        cell.lineView.hidden = YES;
                    }
                }
            }
        }
    }
    
    if (section == MPCSetInvateCode || section == MPGuiZu || section == MPCSZJLSection || ([self.BuguLive.appModel.open_noble isEqualToString:@"0"] && section == MPBGSHOP)) {
        cell.lineView.frame = CGRectMake(0, kRealValue(44), kScreenW, 8);
        cell.imgCenterConstraint.constant = -4;
    }else{
        cell.lineView.frame = CGRectMake(10, kRealValue(44), kScreenW-10, 1);
        cell.imgCenterConstraint.constant = 0;
    }

    if ([self.BuguLive.appModel.open_society_module integerValue] !=1)//我的公会不存在  我的公会横线处理
    {
        if ([self.BuguLive.appModel.open_family_module integerValue]==1)
        {
            if (section == MPCFamilySection)
            {
                cell.lineView.hidden = YES;
            }
        }
    }

    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        if (section == MPCInviteUser ||section == MPGuiZu ||section ==   MPCGradeSection || section == MPBGSHOP || section == MPCarBuy || section ==  MPCContributeSection || section == MPCFamilySection || section == MPCRenZhenSection || indexPath.section == MPCMySmallShop || indexPath.section == MPCLiveHostCenter)
        {
            cell.hidden = YES;
        }
    }
    
    if (section == MPCLiveHostCenter || section == MPCSZJLSection) {
        cell.rightLabel.hidden = YES;
    }
    
//    cell.lineView.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MPCexchangeCoinsSection)//兑换游戏币
    {
        [self.personCModel exchangeGaomeCoinsWithModel:_userModel];
    }else if (indexPath.section == MPCFamilySection)//我的公会
    {
        if ([_userModel.family_id intValue] == 0)
        {
            [self.personCModel createFamilyViewWithVC:self andModel:_userModel];
        }
        else
        {
            [self.personCModel goToFamilyDesVCWithModel:_userModel];
        }
    }else if (indexPath.section == MPCTradeSection)//我的公会
    {
        if ([_userModel.society_id intValue] == 0)
        {
            [self.personCModel createSocietyViewWithVC:self andModel:_userModel];
        }
        else
        {
            [self.personCModel goToSocietyDesVCWithModel:_userModel];
        }
    }else
    {
        [self.personCModel didSelectWithModel:_userModel andSection:(int)indexPath.section];
    }
}

#pragma mark 通知
- (void)IMChatHaveNewMsgNotification:(NSNotification*)notification
{
//    [self.personCModel loadBadageDataWithView:self.tableHeadView];
}

#pragma mark 解决Segmented的滑块快速滑动时的延迟，同时把点击滑块的情况排除在外
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isUserNav)
    {
        self.scrollH = scrollView.contentOffset.y;
        [self setStateBackColor];
    }
}
#pragma mark 状态栏颜色的控制
- (void)setStateBackColor
{

}

#pragma mark - 判断当日是否签到

- (void)requestDataToady{
    
    if (![IMAPlatform isAutoLogin])
    {
        return;
    }
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"is_signin" forKey:@"act"];

    FWWeakify(self)

    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
       FWStrongify(self)

        if ([responseJson toInt:@"today_signin"] == 0) {
            [self.tableHeadView.signButton setTitle:ASLocalizedString(@"签到") forState:UIControlStateNormal];
        }else{
            [self.tableHeadView.signButton setTitle:ASLocalizedString(@"已签到") forState:UIControlStateNormal];
        }
    } FailureBlock:^(NSError *error) {

    }];
}

#pragma mark ===============================================get方法==========================================================

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc]initWithObjects:ASLocalizedString(@"我的小店"),ASLocalizedString(@"邀请赚钱"),ASLocalizedString(@"主播认证"),ASLocalizedString(@"分享收益"),ASLocalizedString(@"布谷票贡献榜"),ASLocalizedString(@"直播间收支记录"),ASLocalizedString(@"设置"),nil];
    }
    return _titleArray;
}



- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [[NSMutableArray alloc]initWithObjects:
                       @"bogo_me_list_shop",@"bogo_me_list_invite",@"bogo_me_list_cert",@"bogo_me_list_shareIncome",@"bogo_me_list_Contribute",@"bogo_me_list_IncomeRecord",@"bogo_me_list_set", nil];
    }
    return _imageArray;
}

- (NSMutableArray *)detailArray
{
    if (!_detailArray)
    {
        _detailArray = [[NSMutableArray alloc]initWithObjects:@"no",@"no",@"no",@"no",@"no",@"no",@"no",
                         nil];
    }
    return _detailArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        if (self.isUserNav ==NO)
        {

            _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kScreenH-kTabBarHeight - kStatusBarHeight - 10 ) style:UITableViewStylePlain];

        }
        else
        {
            _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight- kStatusBarHeight + 10) style:UITableViewStylePlain];

        }
        
        if (isIPhoneX()) {
            _tableView.top = MG_TOP_MARGIN;
        }
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kBackGroundColor;
        [_tableView registerNib:[UINib nibWithNibName:@"MPersonCenterCell" bundle:nil] forCellReuseIdentifier:@"MPersonCenterCell"];
//        _tableView.tableHeaderView = self.tableHeadView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //        [BGMJRefreshManager refresh:_tableView target:self headerRereshAction:@selector(loadNetData) shouldHeaderBeginRefresh:YES footerRereshAction:nil];
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    if (@available(iOS 13, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}



@end
