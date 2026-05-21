//
//  MineViewController.m
//  BuguLive
//
//  Created by Mac on 2021/7/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "MineViewController.h"
#import "userPageModel.h"
#import "BogoShopKit.h"
#import "SIdentificationVC.h"
#import "SChargerVC.h"
#import "BogoSetViewController.h"
#import "SHomePageVC.h"
#import "SignViewController.h"
#import "SVGAHeader.h"

#import "EditFamilyViewController.h"
#import "FamilyDesViewController.h"
#import "FamilyListViewController.h"
#import "SocietyListViewController.h"
#import "EditSocietyViewController.h"
#import "SocietyDesViewController.h"
#import "SocietyDetailVC.h"

//邀请赚钱
#import "BogoShareInviteViewController.h"
//新充值界面
#import "BogoRechargeViewController.h"
//贵族列表
#import "BogoNobleViewController.h"
#import "IncomeViewController.h"
#import "BogoNetworkKit.h"

#import "BGEditInfoController.h"
#import "PerfectInfoPopView.h"

#import "BogoGuildKit.h"
#import "BogoInviteViewController.h"
#import "UIImageView+RTL.h"
#import "IconInfoView.h"
@interface MineViewController ()<PerfectInfoPopViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet QMUIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIImageView *authImgView;

@property (weak, nonatomic) IBOutlet QMUIButton *nobleCenterBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *itemShopBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *levelBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *familyBtn;

@property (weak, nonatomic) IBOutlet QMUIButton *allOrderBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *waitPayBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *waitTransferBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *waitConfirmBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *refundBtn;

@property (weak, nonatomic) IBOutlet QMUIButton *applyBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *goodManageBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *orderManageBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *dataBtn;

@property (weak, nonatomic) IBOutlet QMUIButton *authBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *logBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *setBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *openVipBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *serverBtn;

@property(nonatomic, strong) userPageModel *userModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;

@property (weak, nonatomic) IBOutlet UIView *profitView;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIImageView *topView;

@property (weak, nonatomic) IBOutlet QMUIButton *earningsBtn;


/*
 公会相关
 */
@property (nonatomic, strong) UIView     *backgroundView;    //大的背景遮罩
@property (nonatomic, strong) UIView     *backView;          //小的背景遮罩
@property (nonatomic, strong) UIView     *bigView;           //背景图
@property (nonatomic, strong) UIButton   *addFamilyBtn;      //加入公会按钮
@property (nonatomic, strong) UIButton   *createBtn;         //创建公会按钮
@property (nonatomic, strong) UIButton   *bigButton;

/*
 公会相关
 */
@property (nonatomic, strong) UIView      *backgroundViewTwo;      //大的背景遮罩
@property (nonatomic, strong) UIView      *backViewTwo;            //小的背景遮罩
@property (nonatomic, strong) UIView      *bigViewTwo;             //背景图
@property (nonatomic, strong) UIButton    *addSocietyBtn;          //加入公会按钮
@property (nonatomic, strong) UIButton    *createSocietyBtn;       //创建公会按钮
@property (nonatomic, strong) UIButton    *bigBtn;

@property (weak, nonatomic) IBOutlet UIImageView *nobleImageView;
@property (weak, nonatomic) IBOutlet UILabel *nobleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nobleTipLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *nobleMoreBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyShopWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopManagerWidthConstraint;


@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nobleNextBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@property(nonatomic, strong) PerfectInfoPopView *infoPopView;
@property (weak, nonatomic) IBOutlet UIImageView *wimage;
@property(nonatomic, strong) SVGAHeader *svgaHeader;
@property(nonatomic, strong) IconInfoView *iconInfoView;

@property (weak, nonatomic) IBOutlet UIImageView *rtlDiamonds;
@property (weak, nonatomic) IBOutlet UIImageView *rtlInccome;

@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems; // 修改为数组
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topViewHeight.constant = 342;
    self.contentViewHeight.constant = kTopHeight + 776;
    
    self.view.backgroundColor = kWhiteColor;
    
    self.nobleCenterBtn.imagePosition = QMUIButtonImagePositionTop;
    self.itemShopBtn.imagePosition = QMUIButtonImagePositionTop;
    self.levelBtn.imagePosition = QMUIButtonImagePositionTop;
    self.familyBtn.imagePosition = QMUIButtonImagePositionTop;
    self.allOrderBtn.imagePosition = QMUIButtonImagePositionRight;
    self.waitPayBtn.imagePosition = QMUIButtonImagePositionTop;
    self.waitTransferBtn.imagePosition = QMUIButtonImagePositionTop;
    self.waitConfirmBtn.imagePosition = QMUIButtonImagePositionTop;
    self.refundBtn.imagePosition = QMUIButtonImagePositionTop;
    self.applyBtn.imagePosition = QMUIButtonImagePositionTop;
    self.goodManageBtn.imagePosition = QMUIButtonImagePositionTop;
    self.orderManageBtn.imagePosition = QMUIButtonImagePositionTop;
    self.dataBtn.imagePosition = QMUIButtonImagePositionTop;
    self.authBtn.imagePosition = QMUIButtonImagePositionTop;
    self.inviteBtn.imagePosition = QMUIButtonImagePositionTop;
    self.logBtn.imagePosition = QMUIButtonImagePositionTop;
    self.setBtn.imagePosition = QMUIButtonImagePositionTop;
    self.serverBtn.imagePosition = QMUIButtonImagePositionTop;
    self.earningsBtn.imagePosition = QMUIButtonImagePositionTop;

    self.openVipBtn.imagePosition = QMUIButtonImagePositionRight;
    self.signBtn.imagePosition = QMUIButtonImagePositionLeft;
    
    self.nobleCenterBtn.spacingBetweenImageAndTitle = 5;
    self.itemShopBtn.spacingBetweenImageAndTitle = 5;
    self.levelBtn.spacingBetweenImageAndTitle = 5;
    self.familyBtn.spacingBetweenImageAndTitle = 5;
    self.allOrderBtn.spacingBetweenImageAndTitle = 5;
    self.waitPayBtn.spacingBetweenImageAndTitle = 5;
    self.waitTransferBtn.spacingBetweenImageAndTitle = 5;
    self.waitConfirmBtn.spacingBetweenImageAndTitle = 5;
    self.refundBtn.spacingBetweenImageAndTitle = 5;
    self.applyBtn.spacingBetweenImageAndTitle = 5;
    self.goodManageBtn.spacingBetweenImageAndTitle = 5;
    self.orderManageBtn.spacingBetweenImageAndTitle = 5;
    self.dataBtn.spacingBetweenImageAndTitle = 5;
    self.authBtn.spacingBetweenImageAndTitle = 5;
    self.inviteBtn.spacingBetweenImageAndTitle = 5;
    self.logBtn.spacingBetweenImageAndTitle = 5;
    self.setBtn.spacingBetweenImageAndTitle = 5;
    self.serverBtn.spacingBetweenImageAndTitle = 5;
    self.openVipBtn.spacingBetweenImageAndTitle = 5;
    self.signBtn.spacingBetweenImageAndTitle = 5;
    [self.serverBtn setTitle:ASLocalizedString(@"客服") forState:UIControlStateNormal];
    [self.earningsBtn setTitle:ASLocalizedString(@"收益") forState:UIControlStateHighlighted];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.accountView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountViewAction)]];
    
    [self.allOrderBtn setTitle:ASLocalizedString(@"查看全部订单") forState:UIControlStateNormal];
    [self.openVipBtn setTitle:ASLocalizedString(@"开通") forState:UIControlStateNormal];
    [self.profitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profitViewAction)]];
    [self.topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewAction)]];
    
    [self.signBtn setTitle:ASLocalizedString(@"已签到") forState:UIControlStateSelected];
    [self.signBtn.titleLabel adjustsFontSizeToFitWidth];
    
    self.wimage.image = [UIImage imageNamed:@"bogo_me_top_income"];
    
    ViewRadius(self.imgBanner, 5);
    
    self.svgaHeader = [[SVGAHeader alloc] init];
    self.svgaHeader.layer.masksToBounds = NO;
    self.svgaHeader.userInteractionEnabled = NO;
    [self.view addSubview:self.svgaHeader];
    [self.svgaHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconImageView);
        make.height.and.width.equalTo(self.iconImageView).offset(32);
    }];
    
    self.iconInfoView = [[IconInfoView alloc] init];
    [self.view addSubview:self.iconInfoView];
    [self.iconInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idLabel.mas_bottom).offset(3);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@17);
    }];
    self.iconInfoView.ageView.hidden = YES;
    self.iconInfoView.vipView.hidden = YES;
    self.iconInfoView.nobleView.hidden = YES;
    [self.iconInfoView updateConstraintsIfNeeded];
    
    //rtl
    self.rtlDiamonds.image = [self.rtlDiamonds.image checkOverturn];
    self.rtlInccome.image = [self.rtlInccome.image checkOverturn];
    
    // 初始化 menuItems 数组
    self.menuItems = @[
        @{@"title": @"实名认证", @"icon": @"my_实名认证"},
        @{@"title": @"邀请赚钱", @"icon": @"my_邀请赚钱"},
        @{@"title": @"收支记录", @"icon": @"my_收支记录"},
        @{@"title": @"收益", @"icon": @"earnings"},
        @{@"title": @"系统设置", @"icon": @"my_系统设置"}
    ];
    
    self.tableView = [[QMUITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 禁止滑动
    self.tableView.scrollEnabled = NO;
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authBtn);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@324);
    }];
    
}
- (IBAction)earningsClick:(id)sender {
    NSString *url = [GlobalVariables sharedInstance].appModel.h5_url.month_statistics_log;
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:url isShowIndicator:YES isShowNavBar:NO isShowBackBtn:NO];
//    tmpController.navTitleStr = ASLocalizedString(@"道具商城");
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    return;
}


- (IBAction)serverClick:(id)sender {
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self requestData];
    [self requestDataToady];
    [self requestNumberData];
}

- (void)requestData{
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
//             [GlobalVariables sharedInstance].is_noble_mysterious = _userModel.is_noble_mysterious;
             
             
             [GlobalVariables sharedInstance].userModel = model;
             
             CGFloat viewWidth = (kScreenW - 10 * 2) / 4;
             if (_userModel.shop_status.integerValue == 1 || _userModel.shop_status.integerValue == 4) {
                 self.applyShopWidthConstraint.constant = 0;
                 self.shopManagerWidthConstraint.constant = viewWidth;
                 self.applyBtn.hidden = YES;
             }else{
                 
                 self.applyBtn.hidden = NO;
                 self.shopManagerWidthConstraint.constant = self.applyShopWidthConstraint.constant = viewWidth;
             }
             self.vipImageView.hidden = !_userModel.is_vip.integerValue;
             if (_userModel.is_vip.integerValue) {
                 self.editLeftConstraint.constant = 20;
             }else{
                 self.editLeftConstraint.constant = 5;
             }
             [self.svgaHeader setHeaderUrl:model.avatar_frame_url];

             [self reloadData];
             
             /*if (!_userModel.is_tips.integerValue) {
                 [self.infoPopView show:[UIApplication sharedApplication].keyWindow type:FDPopTypeBottom];
                 [self.httpsManager POSTWithParameters:[NSMutableDictionary dictionaryWithDictionary:@{@"ctl":@"login",@"act":@"is_tips"}] SuccessBlock:^(NSDictionary *responseJson) {
                     
                 } FailureBlock:^(NSError *error) {
                     
                 }];
             }*/
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error)
     {
     }];
}

- (void)reloadData{
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.nameLabel.text = _userModel.nick_name;
    if (_userModel.sex.integerValue) {
        self.sexImageView.image = [UIImage imageNamed:_userModel.sex.integerValue == 1 ? @"dy_sex_male" : @"dy_sex_female"];
    }
    self.iconInfoView.levelView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%ld",_userModel.user_level.integerValue]];
    if(StrValid(_userModel.noble_icon))
    {
        self.iconInfoView.nobleView.hidden = NO;
        [self.iconInfoView.nobleView sd_setImageWithURL:[NSURL URLWithString:SafeStr(_userModel.noble_icon)]];
    }
    else
    {
        self.iconInfoView.nobleView.hidden = YES;
    }

    if(_userModel.is_vip.intValue)
    {
        self.iconInfoView.vipView.hidden = NO;
    }
    else
    {
        self.iconInfoView.vipView.hidden = YES;
    }
    if(_userModel.is_authentication)
    {
        self.iconInfoView.certificationView.hidden = NO;
    }
    else
    {
        self.iconInfoView.certificationView.hidden = YES;
    }
    [self.iconInfoView updateConstraintsIfNeeded];
    
    self.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%ld",_userModel.user_level.integerValue]];
    self.idLabel.text = [NSString stringWithFormat:@"ID：%@",_userModel.user_id];
    if (_userModel.luck_num.length && [_userModel.luck_num intValue] > 0)
    {
        self.idLabel.text = [NSString stringWithFormat:@"ID: %@",_userModel.luck_num];
    }
//    float diamond = _userModel.diamonds.doubleValue;
//    if (diamond > 10000) {
        self.accountLabel.text = _userModel.n_diamonds;
//    }else{
//        self.accountLabel.text = [NSString stringWithFormat:@"%@：%.0f",ASLocalizedString(@"钻石余额"),diamond];
//    }
    
    self.profitLabel.text = [NSString stringWithFormat:@"%@：%@",ASLocalizedString(@"布谷票"),_userModel.ticket];
    self.authImgView.hidden = _userModel.is_authentication.intValue != 2;
    self.authImgView.hidden = YES;
    [self.authImgView setImage:[UIImage imageNamed:ASLocalizedString(@"mg_zhifu_certication")]];
    if (_userModel.noble_name.length) {
        self.nobleNameLabel.text = _userModel.noble_name;
        [self.nobleImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.noble_shop]];
        self.nobleTipLabel.text = ASLocalizedString(@"解锁更多专属特权");
        [self.nobleMoreBtn setTitle:ASLocalizedString(@"查看权益") forState:UIControlStateNormal];

        self.openBtnWidthConstraint.constant = 75;

        self.nobleNextBtnWidth.constant = 80;

    }
}

- (void)requestDataToady{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"is_signin" forKey:@"act"];

    FWWeakify(self)

    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
       FWStrongify(self)

        self.signBtn.selected = [responseJson toInt:@"today_signin"] == 1;
        self.signBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.signBtn.titleLabel adjustsFontSizeToFitWidth];
    } FailureBlock:^(NSError *error) {

    }];
}

- (void)requestNumberData{
//    /shopapi/order_api/getUserOrderNumUrl?token=5128c13ee8ecce49649a47187a4bcd0a
    [[BogoNetwork shareInstance] GET:@"order_api/getUserOrderNumUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
//        goods_payment": 5, 待付款数量
//                "goods_shipped": 0, 待发货数量
//                "goods_received": 1, 待收货数量
//                "goods_refund": 0,  退货退款的数量
//                "order_manage": 0 商家订单管理
        NSString *goods_payment = [NSString stringWithFormat:@"%@",result.data[@"goods_payment"]];
        NSString *goods_shipped = [NSString stringWithFormat:@"%@",result.data[@"goods_shipped"]];
        NSString *goods_received = [NSString stringWithFormat:@"%@",result.data[@"goods_received"]];
        NSString *goods_refund = [NSString stringWithFormat:@"%@",result.data[@"goods_refund"]];
        NSString *order_manage = [NSString stringWithFormat:@"%@",result.data[@"order_manage"]];
        
        [self addBadgeForButton:self.waitPayBtn andBadge:goods_payment];
        [self addBadgeForButton:self.waitTransferBtn andBadge:goods_shipped];
        [self addBadgeForButton:self.waitConfirmBtn andBadge:goods_received];
        [self addBadgeForButton:self.refundBtn andBadge:goods_refund];
        [self addBadgeForButton:self.orderManageBtn andBadge:order_manage];
        
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)addBadgeForButton:(UIButton *)sender andBadge:(NSString *)badge{
    sender.shouldHideBadgeAtZero = YES;
    sender.badgeValue = badge;
    sender.badgeOriginX = self.waitPayBtn.width * 3 / 5;
    sender.badgeOriginY = self.waitPayBtn.height / 8;
    sender.badgeFont = [UIFont systemFontOfSize:10];
}

- (IBAction)itemShopBtnAction:(QMUIButton *)sender {
    NSString *pay_nobleUrl = [GlobalVariables sharedInstance].appModel.h5_url.shop_url;
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:pay_nobleUrl isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
    tmpController.navTitleStr = ASLocalizedString(@"道具商城");
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

- (void)topViewAction{
    SHomePageVC *vc = [SHomePageVC new];
    vc.user_id = self.userModel.user_id;
    [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
}

- (IBAction)signBtnAction:(QMUIButton *)sender {
    SignViewController *setViewController = [[SignViewController alloc]init];
    setViewController.userID = self.userModel.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:setViewController animated:YES];
}

- (IBAction)nobleCenterBtnAction:(QMUIButton *)sender {
    BogoNobleViewController *vc = [BogoNobleViewController new];
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

- (IBAction)levelBtnAction:(QMUIButton *)sender {
    NSString *tmpUrlStr;
#if kSupportH5Shopping
    tmpUrlStr = [NSString stringWithFormat:@"%@&user_id=%@",[GlobalVariables sharedInstance].appModel.h5_url.url_my_grades,_userModel.user_id];
#else
    tmpUrlStr = [GlobalVariables sharedInstance].appModel.h5_url.url_my_grades;
#endif
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
    tmpController.navTitleStr = ASLocalizedString(@"我的等级");
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

- (IBAction)familyBtnAction:(QMUIButton *)sender {
    if (1) {
        BogoGuildViewController *guildVC = [[BogoGuildViewController alloc]init];
        guildVC.family_id = _userModel.family_id;
        guildVC.hidesBottomBarWhenPushed = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:guildVC animated:YES];
    }
    return;
    if ([_userModel.family_id intValue] == 0)
    {
        [self createFamilyViewWithVC:self andModel:_userModel];
    }
    else
    {
        [self goToFamilyDesVCWithModel:_userModel];
    }
}

- (IBAction)applyBtnAction:(QMUIButton *)sender {
    
    if (self.userModel.shop_status.integerValue == 1) {
        
        [[FDHUDManager defaultManager] show:@"您已开店" ToView:self.view];
        
        return;
    }
    [[BogoNetwork shareInstance] GET:@"api/getIsCertificationUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
//        "state": "0", 是否实名认证【0未认证；1已认证；2审核不通过；3审核中】
//                "shop_status": -1 是否认证店铺【0 审核中 1通过 2失败 -1未提交】
        NSInteger state = [NSString stringWithFormat:@"%@",result.data[@"state"]].integerValue;
        NSInteger shop_status = [NSString stringWithFormat:@"%@",result.data[@"shop_status"]].integerValue;
        if (state == 0 || state == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:ASLocalizedString(@"账户还未进行实名认证，不能申请开店") message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"实名认证") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                SIdentificationVC *identificationVC = [[SIdentificationVC alloc]init];
                identificationVC.user_id = self.userModel.user_id;
                identificationVC.sexString = self.userModel.sex;
                identificationVC.nameString = self.userModel.nick_name;
                [[AppDelegate sharedAppDelegate] pushViewController:identificationVC animated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else if (state == 3){
            [[FDHUDManager defaultManager] show:@"实名认证审核中" ToView:self.view];
        }else if (state == 1){
            if (shop_status == 2 || shop_status == -1) {
                BogoShopInfoFillViewController *fillVC = [[BogoShopInfoFillViewController alloc]init];
                fillVC.status = shop_status;
                fillVC.hidesBottomBarWhenPushed = YES;
                [[AppDelegate sharedAppDelegate] pushViewController:fillVC animated:YES];
            }else if (shop_status == 0){
                [[FDHUDManager defaultManager] show:@"店铺资料审核中" ToView:self.view];
            }
        }
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
    
}

- (IBAction)dataBtnAction:(id)sender {
    
    if (self.userModel.shop_status.integerValue != 1) {
        
        if (self.userModel.shop_status.integerValue == 4) {
            
            [[FDHUDManager defaultManager] show:ASLocalizedString(@"店铺存在异常，已被关停") ToView:self.view];
            return;
        }else{
            [[FDHUDManager defaultManager] show:ASLocalizedString(@"您还未开通店铺，请先去申请开店") ToView:self.view];
            
            return;
        }
    }
    
    BogoShopDataViewController *fillVC = [[BogoShopDataViewController alloc]initWithNibName:@"BogoShopDataViewController" bundle:kShopKitBundle];
    fillVC.hidesBottomBarWhenPushed = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:fillVC animated:YES];
}

- (IBAction)allOrderBtnAction:(QMUIButton *)sender {
    BogoOrderManageViewController *orderManage = [[BogoOrderManageViewController alloc]init];
    orderManage.listType = BogoOrderManageViewControllerTypeUser;
    orderManage.index = 0;
    orderManage.hidesBottomBarWhenPushed = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:orderManage animated:YES];
}

- (IBAction)waitPayBtnAction:(QMUIButton *)sender {
    BogoOrderManageViewController *orderManage = [[BogoOrderManageViewController alloc]init];
    orderManage.listType = BogoOrderManageViewControllerTypeUser;
    orderManage.index = 1;
    orderManage.hidesBottomBarWhenPushed = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:orderManage animated:YES];
}

- (IBAction)waitTransferBtnAction:(QMUIButton *)sender {
    BogoOrderManageViewController *orderManage = [[BogoOrderManageViewController alloc]init];
    orderManage.listType = BogoOrderManageViewControllerTypeUser;
    orderManage.index = 2;
    orderManage.hidesBottomBarWhenPushed = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:orderManage animated:YES];
}

- (IBAction)waitConfirmBtnAction:(QMUIButton *)sender {
    BogoOrderManageViewController *orderManage = [[BogoOrderManageViewController alloc]init];
    orderManage.listType = BogoOrderManageViewControllerTypeUser;
    orderManage.index = 3;
    orderManage.hidesBottomBarWhenPushed = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:orderManage animated:YES];
}

- (IBAction)refundBtnAction:(QMUIButton *)sender {
    BogoOrderManageViewController *orderManage = [[BogoOrderManageViewController alloc]init];
    orderManage.listType = BogoOrderManageViewControllerTypeUser;
    orderManage.index = 4;
    orderManage.hidesBottomBarWhenPushed = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:orderManage animated:YES];
}

- (IBAction)goodManageBtnAction:(QMUIButton *)sender {
    
    if (self.userModel.shop_status.integerValue != 1) {
        
        if (self.userModel.shop_status.integerValue == 4) {
            
            [[FDHUDManager defaultManager] show:@"店铺存在异常，已被关停" ToView:self.view];
        }else{
            [[FDHUDManager defaultManager] show:ASLocalizedString(@"您还未开通店铺，请先去申请开店") ToView:self.view];
            
            return;
        }
        
        return;
    }
    
    BogoCommodityManagementViewController *manageVC = [[BogoCommodityManagementViewController alloc]init];
    manageVC.hidesBottomBarWhenPushed = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:manageVC animated:YES];
}

- (IBAction)orderManageBtnAction:(QMUIButton *)sender {
    
    if (self.userModel.shop_status.integerValue != 1) {
        
        if (self.userModel.shop_status.integerValue == 4) {
            
            [[FDHUDManager defaultManager] show:@"店铺存在异常，已被关停" ToView:self.view];
        }else{
            [[FDHUDManager defaultManager] show:ASLocalizedString(@"您还未开通店铺，请先去申请开店") ToView:self.view];
            
            return;
        }
        
        return;
    }
    
    BogoOrderManageViewController *orderManage = [[BogoOrderManageViewController alloc]init];
    orderManage.listType = BogoOrderManageViewControllerTypeShop;
    orderManage.index = 0;
    orderManage.hidesBottomBarWhenPushed = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:orderManage animated:YES];
}

- (IBAction)authBtnAction:(QMUIButton *)sender {
    SIdentificationVC *identificationVC = [[SIdentificationVC alloc]init];
    identificationVC.user_id = self.userModel.user_id;
    identificationVC.sexString = self.userModel.sex;
    identificationVC.nameString = self.userModel.nick_name;
    [[AppDelegate sharedAppDelegate] pushViewController:identificationVC animated:YES];
}

- (IBAction)inviteBtnAction:(QMUIButton *)sender {
    
    
//    BogoInviteViewController *inviteVC = [[BogoInviteViewController alloc]initWithNibName:@"BogoInviteViewController" bundle:[NSBundle mainBundle]];
//    inviteVC.hidesBottomBarWhenPushed = YES;
//    [[AppDelegate sharedAppDelegate] pushViewController:inviteVC animated:YES];
    NSString *tmpUrlStr = [GlobalVariables sharedInstance].appModel.h5_url.invite_rewards;
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    tmpController.navTitleStr = ASLocalizedString(@"邀请赚钱");
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

- (IBAction)logBtnAction:(QMUIButton *)sender {
    NSString *tmpUrlStr = [GlobalVariables sharedInstance].appModel.h5_url.emcee_income_log_url;
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    tmpController.navTitleStr = ASLocalizedString(@"收支记录");
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    return;
    SChargerVC *chargerVC = [[SChargerVC alloc]init];
    chargerVC.recordIndex = 0;
    chargerVC.feeIndex = [GlobalVariables sharedInstance].appModel.live_pay_time ? 0:1;
    [[AppDelegate sharedAppDelegate] pushViewController:chargerVC animated:YES];
}

- (IBAction)setBtnAction:(QMUIButton *)sender {
    BogoSetViewController *setViewController = [[BogoSetViewController alloc]init];
    setViewController.userID = self.userModel.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:setViewController animated:YES];
}

- (void)accountViewAction{
    BogoRechargeViewController *acountVC = [BogoRechargeViewController new];
//        AccountRechargeVC *acountVC = [[AccountRechargeVC alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:acountVC animated:YES];
}

- (void)profitViewAction{
    IncomeViewController *profitVC = [[IncomeViewController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:profitVC animated:YES];
}

- (IBAction)clickEditBtn:(UIButton *)sender {
    
    BGEditInfoController *editVC = [[BGEditInfoController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:editVC animated:YES];
    
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

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark PerfectInfoPopViewDelegate
- (void)infoPopView:(PerfectInfoPopView *)infoPopView didClickEditBtn:(UIButton *)sender{
    BGEditInfoController *editVC = [[BGEditInfoController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:editVC animated:YES];
}

- (PerfectInfoPopView *)infoPopView{
    if (!_infoPopView) {
        _infoPopView = [[NSBundle mainBundle] loadNibNamed:@"PerfectInfoPopView" owner:nil options:nil].lastObject;
        _infoPopView.delegate = self;
    }
    return _infoPopView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *menuItem = self.menuItems[indexPath.row];
    NSString *title = menuItem[@"title"];
    NSString *iconName = menuItem[@"icon"];
    
    // 设置图标
    UIImage *iconImage = [UIImage imageNamed:iconName];
    iconImage = [iconImage imageByResizeToSize:CGSizeMake(20, 20)];
    cell.imageView.image = iconImage;
    
    // 设置标题
    cell.textLabel.text = ASLocalizedString(title);
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *menuItem = self.menuItems[indexPath.row];
    NSString *title = menuItem[@"title"];
    
    if ([title isEqualToString:@"实名认证"]) {
        // 跳转到实名认证页面
        [self authBtnAction:nil];
    } else if ([title isEqualToString:@"邀请赚钱"]) {
        // 跳转到邀请赚钱页面
        [self inviteBtnAction:nil];
    } else if ([title isEqualToString:@"收支记录"]) {
        // 跳转到收支记录页面
        [self logBtnAction:nil];
    } else if ([title isEqualToString:@"收益"]) {
        // 跳转到收益页面
        [self earningsClick:nil];
    } else if ([title isEqualToString:@"系统设置"]) {
        // 跳转到系统设置页面
        [self setBtnAction:nil];
    }
}

@end
