//
//  PersonCenterModel.m
//  BuguLive
//
//  Created by 丁凯 on 2017/7/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PersonCenterModel.h"
#import "userPageModel.h"
#import "AccountRechargeVC.h"
#import "IncomeViewController.h"
#import "DistributionController.h"
#import "SIdentificationVC.h"
#import "BogoSetViewController.h"
#import "GameDistributionViewController.h"
#import "ShopListViewController.h"
#import "OnLiveViewController.h"
#import "FollowerViewController.h"
#import "EditFamilyViewController.h"
#import "FamilyDesViewController.h"
#import "FamilyListViewController.h"
#import "SocietyListViewController.h"
#import "EditSocietyViewController.h"
#import "SocietyDesViewController.h"
#import "MPCHeadView.h"
#import "SSearchVC.h"
#import "BGEditInfoController.h"
#import "GetHeadImgViewController.h"
#import "SocietyDetailVC.h"
#import "MSmallVideoVC.h"
#import "SChargerVC.h"
#import "BGShopViewController.h"
#import "SignViewController.h"
#import "GuiZuViewController.h"
#import "MGInvateCodeViewController.h"

//邀请赚钱
#import "BogoShareInviteViewController.h"
//新充值界面
#import "BogoRechargeViewController.h"
//贵族列表
#import "BogoNobleViewController.h"

@implementation PersonCenterModel

- (void)creatUIWithModel:(userPageModel *)userModel andMArr:(NSMutableArray *)detailArray andMyView:(UIView *)myView
{
    self.BuguLive = [GlobalVariables sharedInstance];
//    if (userModel.n_diamonds.length)//账户
//    {
////        [detailArray replaceObjectAtIndex:MPCAcountSection withObject:[NSString stringWithFormat:@"%@%@",userModel.n_diamonds,self.BuguLive.appModel.diamond_name]];
//    }
//    if (userModel.n_useable_ticket.length && self.BuguLive.appModel.ticket_name.length)//收益
//    {
////        [detailArray replaceObjectAtIndex:MPCIncomeSection withObject:[NSString stringWithFormat:@"%@%@",userModel.n_useable_ticket,self.BuguLive.appModel.ticket_name]];
//    }
//
//    if ([self.BuguLive.appModel.open_vip isEqualToString:@"1"])//VIP会员
//    {
//        if ([userModel.is_vip isEqualToString:@"1"])
//        {
////            [detailArray replaceObjectAtIndex:MPCVIPSection withObject:ASLocalizedString(@"已开通")];
//        }
//        else
//        {
////            [detailArray replaceObjectAtIndex:MPCVIPSection withObject:userModel.vip_expire_time];
//        }
//    }
//    else
//    {
//        [detailArray replaceObjectAtIndex:MPCVIPSection withObject:@""];
//    }
    
//    if (userModel.n_coin.length)//兑换游戏币
//    {
//        [detailArray replaceObjectAtIndex:MPCexchangeCoinsSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@游戏币"),userModel.n_coin]];
//    }
//    if (userModel.use_diamonds.length)//送出
//    {
//        [detailArray replaceObjectAtIndex:MPCOutPutSection withObject:[NSString stringWithFormat:@"%@%@",userModel.use_diamonds,self.BuguLive.appModel.diamond_name]];
//    }
    
//    if (userModel.user_level.length)//等级
//    {
//        [detailArray replaceObjectAtIndex:MPCGradeSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@级"),userModel.user_level]];
//    }
    
    NSString *idStr;  //认证
    if ([userModel.is_authentication intValue] ==0)
    {
        idStr = ASLocalizedString(@"未认证");
    }
    if ([userModel.is_authentication intValue] ==1)
    {
        idStr = ASLocalizedString(@"等待审核");
    }
    if ([userModel.is_authentication intValue] ==2)
    {
        idStr = ASLocalizedString(@"已认证");
    }
    if ([userModel.is_authentication intValue] ==3)
    {
        idStr = ASLocalizedString(@"审核不通过");
    }
    [detailArray replaceObjectAtIndex:MPCRenZhenSection withObject:idStr];
    
   
//    if (userModel.n_podcast_goods.length)//商品管理
//    {
//        [detailArray replaceObjectAtIndex:MPCGoodsMSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@ 个商品"),userModel.n_podcast_goods]];
//    }
//    if (userModel.show_user_order.length)//我的订单
//    {
//        [detailArray replaceObjectAtIndex:MPCMyOrderSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@ 个订单"),userModel.n_user_order]];
//    }
//    if (userModel.n_podcast_order.length)//订单管理
//    {
//        [detailArray replaceObjectAtIndex:MPCOrderMSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@ 个订单"),userModel.n_podcast_order]];
//    }
//    if (userModel.n_shopping_cart.length)//我的购物车
//    {
//        [detailArray replaceObjectAtIndex:MPCShopCartSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@ 个商品"),userModel.n_shopping_cart]];
//    }
//    if (userModel.n_user_pai.length)//我的竞拍
//    {
//        [detailArray replaceObjectAtIndex:MPCMyAutionSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@ 个竞拍"),userModel.n_user_pai]];
//    }
//    if (userModel.n_podcast_pai.length)//竞拍管理
//    {
//        [detailArray replaceObjectAtIndex:MPCAutionMSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@ 个竞拍"),userModel.n_podcast_pai]];
//    }
//    if (userModel.open_podcast_goods.length)//我的小店
//    {
//        [detailArray replaceObjectAtIndex:MPCMyLitteShopSection withObject:[NSString stringWithFormat:ASLocalizedString(@"%@ 个商品"),userModel.n_shop_goods]];
//    }
}

-(void)didSelectWithModel:(userPageModel *)userModel andSection:(int)section
{
    self.BuguLive = [GlobalVariables sharedInstance];

    if (section == MPCMyVideoSection) //小视频
    {
        MSmallVideoVC  *sVideoVC = [[MSmallVideoVC alloc]init];
        sVideoVC.notHaveTabbar      = YES;
        sVideoVC.isHaveNavBar = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:sVideoVC animated:YES];
    }

    if (section == MPCMyInfoSection) {
        SHomePageVC *vc = [SHomePageVC new];
        vc.user_id = userModel.user_id;
        [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
    }else if (section == MPCMyEditSection)//27编辑
    {
        BGEditInfoController *editVC = [[BGEditInfoController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:editVC animated:YES];
    }
    else if (section == MPCSetInvateCode) {
        MGInvateCodeViewController *vc = [MGInvateCodeViewController new];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if (section == MPCInviteUser) {
//        BogoShareInviteViewController *shareVC = [BogoShareInviteViewController new];
//        [[AppDelegate sharedAppDelegate]pushViewController:shareVC];
        //邀请好友
        NSString *tmpUrlStr = _BuguLive.appModel.h5_url.invite_rewards;
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
        tmpController.navTitleStr = ASLocalizedString(@"邀请赚钱");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
    else if (section == MPCAcountSection)//账户
    {
        BogoRechargeViewController *acountVC = [BogoRechargeViewController new];
//        AccountRechargeVC *acountVC = [[AccountRechargeVC alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:acountVC animated:YES];
    }
    else if (section == MPCIncomeSection)//收益
    {
        IncomeViewController *profitVC = [[IncomeViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:profitVC animated:YES];
    }
    else if(section == MPCarBuy)//vip会员
    {
        NSString *tmpUrlStr = _BuguLive.appModel.h5_url.pay_car;
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"座驾");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
    else if(section == MPBGSHOP)//商城
    {
        NSString *pay_nobleUrl = _BuguLive.appModel.h5_url.shop_url;
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:pay_nobleUrl isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"道具商城");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
        
//        BGShopViewController *shop = [BGShopViewController new];
//        shop.title = ASLocalizedString(@"道具商城");
//        [[AppDelegate sharedAppDelegate] pushViewController:shop];
    }
    else if(section == MPGuiZu)//贵族中心
    {
        
        BogoNobleViewController *vc = [BogoNobleViewController new];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
//        GuiZuViewController *nextVC = [GuiZuViewController new];
//        nextVC.title = ASLocalizedString(@"贵族中心");
//        [[AppDelegate sharedAppDelegate] pushViewController:nextVC];
//        NSString *pay_nobleUrl = _BuguLive.appModel.h5_url.pay_noble;
//        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:pay_nobleUrl isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
//        tmpController.navTitleStr = ASLocalizedString(@"贵族中心");
//        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
    else if (section == MPCLiveHostCenter){
         NSString *pay_nobleUrl = _BuguLive.appModel.h5_url.emcee_center_url;
         BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:pay_nobleUrl isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
         tmpController.navTitleStr = ASLocalizedString(@"主播中心");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    } else if (section == MPCMySmallShop){
        
        NSString *url;
        
        if ([userModel.is_open_shop isEqualToString:@"1"]) {
            url = _BuguLive.appModel.h5_url.shop_manage_url;
        }else{
            url = _BuguLive.appModel.h5_url.shop_product_url;
        }
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:url isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"我的小店");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
    else if(section == MPCVIPSection)
    {
        NSString *tmpUrlStr = _BuguLive.appModel.h5_url.members_url;
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"VIP会员");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }

    else if(section == MPCLuckNumber)
    {
        NSString *tmpUrlStr = _BuguLive.appModel.h5_url.luck_num_url;
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"靓号商城");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
    else if(section == MPCVIPSection)//vip会员
    {
        AccountRechargeVC *acountVC = [[AccountRechargeVC alloc]init];
        acountVC.is_vip = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:acountVC animated:YES];
    }
    else if(section == MPCSZJLSection)//直播间收支记录
    {
        SChargerVC *chargerVC = [[SChargerVC alloc]init];
        chargerVC.recordIndex = 0;
        chargerVC.feeIndex = _BuguLive.appModel.live_pay_time ? 0:1;
        [[AppDelegate sharedAppDelegate] pushViewController:chargerVC animated:YES];
    }
   
    else if (section == MPCGradeSection)//等级
    {
        NSString *tmpUrlStr;
#if kSupportH5Shopping
        tmpUrlStr = [NSString stringWithFormat:@"%@&user_id=%@",_BuguLive.appModel.h5_url.url_my_grades,_userModel.user_id];
#else
        tmpUrlStr = _BuguLive.appModel.h5_url.url_my_grades;
#endif
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"我的等级");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];

    }
    else if(section == MPCRenZhenSection)//认证
    {
        SIdentificationVC *identificationVC = [[SIdentificationVC alloc]init];
        identificationVC.user_id = userModel.user_id;
        identificationVC.sexString = userModel.sex;
        identificationVC.nameString = userModel.nick_name;
        [[AppDelegate sharedAppDelegate] pushViewController:identificationVC animated:YES];

    }
    else if(section == MPCContributeSection)//贡献榜
    {
        ContributionListViewController *contributionVC =[[ContributionListViewController alloc]init];
        contributionVC.type = @"1";
        contributionVC.user_id = userModel.user_id;
        contributionVC.hidesBottomBarWhenPushed = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:contributionVC animated:YES];
    }
    else if(section == MPCShareISection)//分享收益
    {
        DistributionController *DistributionVC = [[DistributionController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:DistributionVC animated:YES];
    }else if(section == MPCGameSISection)//游戏分享收益
    {
        GameDistributionViewController *gameDistributionVC = [[GameDistributionViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:gameDistributionVC animated:YES];

    }
    else if(section == MPCGoodsMSection) //商品管理
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_podcast_goods isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"商品管理");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];

    }
    else if(section == MPCMyOrderSection)//我的订单
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_user_order isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"我的订单");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }else if(section == MPCOrderMSection)//订单管理
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_podcast_order isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"订单管理");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }else if(section == MPCShopCartSection)//我的购物车
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_shopping_cart isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"我的购物车");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }else if(section == MPCMyAutionSection)//我的竞拍
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_user_pai isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"我的竞拍");
        tmpController.isFrontRefresh = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];

    }else if(section == MPCAutionMSection)//竞拍管理
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_podcast_pai isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"竞拍管理");
        tmpController.isFrontRefresh = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }else if(section == MPCMyLitteShopSection)//我的小店
    {
        ShopListViewController *shopListVC = [[ShopListViewController alloc]init];
        shopListVC.user_id = userModel.user_id;
        shopListVC.isOTOShop = YES;
        shopListVC.hidesBottomBarWhenPushed = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:shopListVC animated:YES];
    }else if(section == MPCSetSection)//设置
    {
        BogoSetViewController *setViewController = [[BogoSetViewController alloc]init];
        setViewController.userID = userModel.user_id;
        [[AppDelegate sharedAppDelegate] pushViewController:setViewController animated:YES];
    }else if(section == 999)//设置
    {
        BogoSetViewController *setViewController = [[BogoSetViewController alloc]init];
        setViewController.userID = userModel.user_id;
        [[AppDelegate sharedAppDelegate] pushViewController:setViewController animated:YES];
//
        
    }else if(section == 21)//回播
    {
        OnLiveViewController *onliveVC = [[OnLiveViewController alloc]init];
        onliveVC.user_id = userModel.user_id;
        [[AppDelegate sharedAppDelegate] pushViewController:onliveVC animated:YES];
    }else if(section == 52 || section == 53)//关注22  粉丝23
    {
        FollowerViewController *FollowVC = [[FollowerViewController alloc]init];
        FollowVC.user_id = userModel.user_id;
        FollowVC.type = [NSString stringWithFormat:@"%d",section-51];
        [[AppDelegate sharedAppDelegate] pushViewController:FollowVC animated:YES];
    }else if (section == 24)//24搜索
    {
        SSearchVC *searchVC = [[SSearchVC alloc]init];
        searchVC.searchType = @"0";
        [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
    }else if (section == 25)//25IM消息
    {
        BGConversationSegmentController *chatListVC = [[BGConversationSegmentController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:chatListVC animated:YES];
    }else if (section == 26)//26更换头像
    {
        SHomePageVC *tmpController= [[SHomePageVC alloc]init];
        tmpController.user_id = userModel.user_id;
        tmpController.type = 0;
        [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
        
//        [self.videoView.player pausePlay];
        
//        GetHeadImgViewController *headVC =[[GetHeadImgViewController alloc]init];
//        headVC.headImgString =userModel.head_image;
//        headVC.userId =userModel.user_id;
//        [[AppDelegate sharedAppDelegate]pushViewController:headVC];

    }
}

#pragma mark ======================兑换游戏币======================
- (void)createExchangeCoinViewWithVC:(UIViewController *)myVC
{
    _bgWindow = [[UIApplication sharedApplication].delegate window];
    
    if (!_exchangeView)
    {
        _exchangeBgView                    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _exchangeBgView.backgroundColor    = kGrayTransparentColor4;
        _exchangeBgView.hidden             = YES;
        [myVC.view addSubview:_exchangeBgView];
        
        UITapGestureRecognizer  *bgViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeBgViewTap)];
        [_exchangeBgView addGestureRecognizer:bgViewTap];
        
        _exchangeView                      = [ExchangeCoinView EditNibFromXib];
        _exchangeView.exchangeType         = 1;
        _exchangeView.delegate             = self;
        _exchangeView.frame                = CGRectMake((kScreenW - 300)/2, kScreenH, 300, 230);
        [_exchangeView createSomething];
        [_bgWindow addSubview:_exchangeView];
    }
}

- (void)exchangeViewDownWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView
{
    if (_exchangeView == exchangeCoinView)
    {
        [_exchangeView.diamondLeftTextfield resignFirstResponder];
        _exchangeView.diamondLeftTextfield.text = nil;
        _exchangeView.coinLabel.text = ASLocalizedString(@"0游戏币");
        [UIView animateWithDuration:0.3 animations:^{
            _exchangeView.frame = CGRectMake((kScreenW - 300)/2, kScreenH, 300, 230);
        } completion:^(BOOL finished) {
            _exchangeBgView.hidden = YES;
        }];
    }
}

- (void)exchangeBgViewTap
{
    [self exchangeViewDownWithExchangeCoinView:_exchangeView];
}

- (void)exchangeGaomeCoinsWithModel:(userPageModel *)userModel
{
    [_bgWindow bringSubviewToFront:_exchangeBgView];
    [_bgWindow bringSubviewToFront:_exchangeView];
    [_exchangeView obtainCoinProportion];
    [UIView animateWithDuration:0.3 animations:^{
        _exchangeBgView.hidden = NO;
        [_exchangeView.diamondLeftTextfield becomeFirstResponder];
        _exchangeView.ticket = userModel.diamonds;
        _exchangeView.diamondLabel.text =[NSString stringWithFormat:ASLocalizedString(@"%@余额:%@"),self.BuguLive.appModel.diamond_name,userModel.diamonds];
        _exchangeView.frame = CGRectMake((kScreenW - 300)/2, (kScreenH - 350)/2, 300, 230);
    }];
}

#pragma mark ======================我的公会======================
- (void)createFamilyViewWithVC:(UIViewController *)myVC andModel:(userPageModel *)userModel
{
    self.userModel = userModel;
    if (!self.backgroundView)
    {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        self.backgroundView.backgroundColor = kAppGrayColor6;
        self.backgroundView.alpha = 0.5;
        self.backgroundView.hidden = NO;
        [myVC.view addSubview:self.backgroundView];
        self.bigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [self.bigButton addTarget:self action:@selector(closeFamilyView) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:_bigButton];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(10, (kScreenH-170)/2, kScreenW-20, 170)];
        self.backView.backgroundColor = [UIColor grayColor];
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        [myVC.view addSubview:_backView];
        self.bigView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenW-30, 160)];
        self.bigView.backgroundColor = [UIColor whiteColor];
        self.bigView.layer.cornerRadius = 5;
        self.bigView.layer.masksToBounds = YES;
        [self.backView addSubview:self.bigView];
        self.addFamilyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addFamilyBtn.frame = CGRectMake(15, 20, kScreenW-60, 48);
        self.addFamilyBtn.backgroundColor = kAppMainColor;
        self.addFamilyBtn.layer.cornerRadius = 15;
        self.addFamilyBtn.layer.masksToBounds = YES;
        [self.addFamilyBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.addFamilyBtn setTitle:ASLocalizedString(@"加入公会")forState:UIControlStateNormal];
        [self.bigView addSubview:self.addFamilyBtn];
        self.createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.createBtn.backgroundColor = kAppFamilyBtnColor;
        self.createBtn.layer.cornerRadius = 15;
        self.createBtn.layer.masksToBounds = YES;
        [self.createBtn setTitle:ASLocalizedString(@"创建公会")forState:UIControlStateNormal];
        [self.createBtn addTarget:self action:@selector(clickCreateBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.bigView addSubview:self.createBtn];
        
        if ([self.BuguLive.appModel.family_join intValue] == 0)
        {
            self.backView.frame = CGRectMake(10, (kScreenH-85)/2, kScreenW-20, 85);
            self.bigView.frame = CGRectMake(5, 2.5, kScreenW-30, 80);
            self.addFamilyBtn.hidden = YES;
            self.createBtn.frame = CGRectMake(15, CGRectGetMidY(_bigView.frame)-26, kScreenW-60, 48);
        }
        else if ([self.BuguLive.appModel.family_join intValue] == 1)
        {
            self.backView.frame = CGRectMake(10, (kScreenH-170)/2, kScreenW-20, 170);
            self.bigView.frame = CGRectMake(5, 5, kScreenW-30, 160);
            self.addFamilyBtn.hidden = NO;
            self.createBtn.frame = CGRectMake(15, 92, kScreenW-60, 48);
        }
    }
    else
    {
        self.backgroundView.hidden = NO;
        self.backView.hidden = NO;
    }
}
//关闭公会页面
- (void)closeFamilyView
{
    self.backgroundView.hidden = YES;
    self.backView.hidden = YES;
}

//加入公会
- (void)clickAddBtn
{
    self.backgroundView.hidden = YES;
    self.backView.hidden = YES;
    FamilyListViewController *familyListVC = [[FamilyListViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:familyListVC animated:YES];
}

//创建公会
- (void)clickCreateBtn
{
    self.backgroundView.hidden = YES;
    self.backView.hidden = YES;
    EditFamilyViewController * editFamilyVC = [[EditFamilyViewController alloc] init];
    editFamilyVC.hidesBottomBarWhenPushed = YES;
    //创建公会时type=0;
    editFamilyVC.type = 0;
    editFamilyVC.user_id = self.userModel.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:editFamilyVC animated:YES];
}

//公会详情
- (void)goToFamilyDesVCWithModel:(userPageModel *)userModel
{
    FamilyDesViewController * familyDesVc = [[FamilyDesViewController alloc] init];
    //是否是族长
    familyDesVc.isFamilyHeder = [userModel.family_chieftain intValue];
    familyDesVc.jid =userModel.family_id;
    familyDesVc.user_id =userModel.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:familyDesVc animated:YES];
}

#pragma mark ======================我的公会======================
- (void)createSocietyViewWithVC:(UIViewController *)myVC andModel:(userPageModel *)userModel
{
//    if (!self.backgroundViewTwo)
//    {
//        self.backgroundViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//        self.backgroundViewTwo.backgroundColor = kAppGrayColor6;
//        self.backgroundViewTwo.alpha = 0.5;
//        self.backgroundViewTwo.hidden = NO;
//        [myVC.view addSubview:self.backgroundViewTwo];
//        self.bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//        [self.bigBtn addTarget:self action:@selector(closeSocietyView) forControlEvents:UIControlEventTouchUpInside];
//        [self.backgroundViewTwo addSubview:self.bigBtn];
//        self.backViewTwo = [[UIView alloc] initWithFrame:CGRectMake(10, (kScreenH-170)/2, kScreenW-20, 110)];
//        self.backViewTwo.backgroundColor = [UIColor grayColor];
//        self.backViewTwo.layer.cornerRadius = 5;
//        self.backViewTwo.layer.masksToBounds = YES;
//        [myVC.view addSubview:self.backViewTwo];
//        self.bigViewTwo = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenW-30, 100)];
//        self.bigViewTwo.backgroundColor = [UIColor whiteColor];
//        self.bigViewTwo.layer.cornerRadius = 5;
//        self.bigViewTwo.layer.masksToBounds = YES;
//        [self.backViewTwo addSubview:self.bigViewTwo];
//        self.createSocietyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.createSocietyBtn.frame = CGRectMake(15, CGRectGetMidY(_bigViewTwo.frame)-27.5, kScreenW-60, 48);
//        self.createSocietyBtn.backgroundColor = kAppFamilyBtnColor;
//        self.createSocietyBtn.layer.cornerRadius = 15;
//        self.createSocietyBtn.layer.masksToBounds = YES;
//        [self.createSocietyBtn setTitle:ASLocalizedString(@"创建公会")forState:UIControlStateNormal];
//        [self.createSocietyBtn addTarget:self action:@selector(clickCreateSocietyBtn) forControlEvents:UIControlEventTouchUpInside];
//        [self.bigViewTwo addSubview:self.createSocietyBtn];
//    }
//    else
//    {
//        self.backgroundViewTwo.hidden = NO;
//        self.backViewTwo.hidden = NO;
//    }
    [self clickCreateSocietyBtn:userModel];
}

//关闭公会页面
- (void)closeSocietyView
{
    self.backgroundViewTwo.hidden = YES;
    self.backViewTwo.hidden = YES;
}
//加入公会
- (void)clickAddSocietyBtn
{
    self.backgroundViewTwo.hidden = YES;
    self.backViewTwo.hidden = YES;
    SocietyListViewController * societyListVC = [[SocietyListViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:societyListVC animated:YES];
}

//创建公会
- (void)clickCreateSocietyBtn:(userPageModel *)model
{
    self.backgroundViewTwo.hidden = YES;
    self.backViewTwo.hidden = YES;
    EditSocietyViewController * editSocietyVC = [[EditSocietyViewController alloc] init];
    //创建公会时type=0;
    editSocietyVC.type = 0;
    editSocietyVC.user_id = model.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:editSocietyVC animated:YES];
}

//公会详情
- (void)goToSocietyDesVCWithModel:(userPageModel *)userModel
{
    SocietyDetailVC *detailVC = [[SocietyDetailVC alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.mySocietyID =[userModel.society_id intValue];
    detailVC.type =[userModel.society_chieftain intValue];
    detailVC.mygh_status = [userModel.gh_status intValue];
    detailVC.flagStr = @"MySociety";
    [[AppDelegate sharedAppDelegate] pushViewController:detailVC animated:YES];
}

//消息的角标
- (void)loadBadageDataWithView:(MPCHeadView *)headV
{
    return;
    [SFriendObj getAllUnReadCountComplete:^(int num) {
        
        int scount = num;
        if(scount)
        {
            if(scount >98){
                headV.badge.badgeText = @"99+";
            }else{
                headV.badge.badgeText = [NSString stringWithFormat:@"%d",scount];
            }
        }
        else
        {
            headV.badge.badgeText = @"";
        }
    }];
}

- (GlobalVariables *)BuguLive
{
    if (!_BuguLive)
    {
        _BuguLive = [GlobalVariables sharedInstance];
    }
    return _BuguLive;
}

- (CGFloat)getMyHeightWithModel:(userPageModel *)myUserModel andBuguLive:(GlobalVariables *)myBuguLive andSection:(int)section andType:(int)type
{
    if (type == 1)
    {
        if (section == MPCInviteUser) {
            return 1;
        }
        
        if(section == MPCarBuy || section == MPCVIPSection ||  section == MPCLuckNumber || section == MPCOutPutSection )
        {
            return 0;
        }
        
        if(section == MPBGSHOP)
        {
            return 1;
        }
        if(section == MPGuiZu)
        {
            if ([self.BuguLive.appModel.open_noble isEqualToString:@"1"]) {
                return 1;
            }
            return 0;
        }
        if (section == MPCSetSection) {
            return 1;
        }
        
        if (section == MPCOutPutSection || section == MPCGradeSection || section == MPCAcountSection ||section == MPCRenZhenSection  || section ==  MPCLuckNumber || section == MPCInviteUser)//送出 等级 账户 贡献榜 认证 设置
        {
            return 1;
        }else if (section == MPCContributeSection){
            return 1;
        }
        else if (section == MPCVIPSection)//VIP会员
        {
            if ([myBuguLive.appModel.open_vip isEqualToString:@"1"])
            {
                return 1;
            }else
            {
                return 0;
            }
        }
        else if(section == MPCarBuy)
        {
            return 1;
        }
        else if (section == MPCexchangeCoinsSection)//兑换游戏币
        {
            if (myBuguLive.appModel.open_diamond_game_module == 0 && myBuguLive.appModel.open_game_module == 1)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCIncomeSection)//收益
        {
//            if ([VersionNum isEqualToString:self.BuguLive.appModel.ios_check_version])
//            {
                return 0;
//            }else
//            {
//                return 1;
//            }
        }else if (section == MPCOrderMSection )//订单管理
        {
            if (![myUserModel.show_podcast_order isEqualToString:@""] &&[myUserModel.show_podcast_order intValue] !=0)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCAutionMSection)//竞拍管理
        {
            if (![myUserModel.show_podcast_pai isEqualToString:@""] &&[myUserModel.show_podcast_pai intValue] !=0)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCMyOrderSection)//我的订单
        {
            if (![myUserModel.show_user_order isEqualToString:@""] &&[myUserModel.show_user_order intValue] !=0)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCGoodsMSection)//商品管理
        {
            if (![myUserModel.show_podcast_goods isEqualToString:@""] &&[myUserModel.show_podcast_goods intValue] !=0)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCMyAutionSection)//我的竞拍
        {
            if (![myUserModel.show_user_pai isEqualToString:@""] &&[myUserModel.show_user_pai intValue] !=0)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCShopCartSection)//我的购物车
        {
            if ([myBuguLive.appModel.shop_shopping_cart integerValue] == 1)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCMyLitteShopSection)//我的小店
        {
            if ([myUserModel.open_podcast_goods  integerValue] == 1)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCFamilySection)//我的公会
        {
            if ([myBuguLive.appModel.open_family_module integerValue]==1)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCSZJLSection)//直播间收支记录
        {
            if (myBuguLive.appModel.live_pay==1)
            {
                return 1;
            }else
            {
                return 0;
            }
        }else if (section == MPCTradeSection)//我的公会
        {
            if ([myBuguLive.appModel.open_society_module integerValue]==1)
            {
                return 1;
            }else
            {
                return 0;
            }
        }
        else if (section == MPCLiveHostCenter){
            return 1;
        }
        else if (section == MPCMySmallShop){
            
                return 1;
            
        }
        else if (section == MPCShareISection)//分享收益
        {
            if (myBuguLive.appModel.distribution==1)
            {
                return 1;
            }else
            {
                return 0;
            }
        }
        else if(section == MPCSetInvateCode)//邀请码
        {
            if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
            {
                return 0;
            }
            return 1;
        }
        else//游戏分享收益
        {
            if (myBuguLive.appModel.game_distribution==1)
            {
                return 1;
            }else
            {
                return 0;
            }
        }
    }else
    {
        if (section == MPCGradeSection || section == MPCSetSection)//等级 设置
        {
            return 0.01;
//            10*kAppRowHScale;
        }else if (section == MPCSetInvateCode){
            return 0.01;
        }
        else if (section == MPCShareISection)//分享收益
        {
            return 0.01;
//            if (myBuguLive.appModel.distribution==1)
//            {
//                return 10*kAppRowHScale;
//            }else
//            {
//                if (myBuguLive.appModel.game_distribution==1)
//                {
//                    return 10*kAppRowHScale;
//                }else
//                {
//                    return 0.01;
//                }
//            }
        }else if (section == MPCGoodsMSection)//商品管理
        {
            if (![myUserModel.show_podcast_goods isEqualToString:@""] &&[myUserModel.show_podcast_goods intValue] !=0)
            {
                return 10*kAppRowHScale;
            }else
            {
                if ((![myUserModel.show_user_order isEqualToString:@""] &&[myUserModel.show_user_order intValue] !=0)||(![myUserModel.show_podcast_order isEqualToString:@""] &&[myUserModel.show_podcast_order intValue] !=0)||([myBuguLive.appModel.shop_shopping_cart integerValue] == 1))
                {
                  return 10*kAppRowHScale;
                }else
                {
                  return 0.01;
                }
            }
        }else if (section == MPCMyAutionSection)//我的竞拍
        {
            if (![myUserModel.show_user_pai isEqualToString:@""] &&[myUserModel.show_user_pai intValue] !=0)
            {
                return 10*kAppRowHScale;
            }else
            {
                return 0.01;
            }
        }else if (section == MPCMyLitteShopSection)//我的小店
        {
            if ([myUserModel.open_podcast_goods  integerValue] == 1)
            {
                return 10*kAppRowHScale;
            }else
            {
                return 0.01;
            }
        }else if (section == MPCFamilySection)//我的公会
        {
            return 0.01;
//            if ([myBuguLive.appModel.open_family_module integerValue]==1)
//            {
//                return 10*kAppRowHScale;
//            }else
//            {
//                if ([myBuguLive.appModel.open_society_module integerValue]==1)
//                {
//                    return 10*kAppRowHScale;
//                }else
//                {
//                    return 0.01;
//                }
//            }
        }else
        {
            return 0.01;
        }
    }
}

@end
