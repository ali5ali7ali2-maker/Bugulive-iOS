

#import "CustomPagerController.h"
#import "hotViewControllerHJ.h"
#import "FocusOnViewController.h"
#import "NewestViewController.h"
#import "SSearchVC.h"
#import "LeaderboardViewController.h"

#import "VideoViewController.h"

//#import "EveryDayFirstLoginPopView.h"/**<每日首次登录奖励*/
#import "MGSignHomeSuccessView.h"//每日签到

@interface CustomPagerController ()<CLLocationManagerDelegate,handleMainDelegate,PushToLiveControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *infoArrays;

@property (nonatomic, strong) NSMutableArray                            *itemTitleMutableArray;         // 完整的分类标题容器
@property (nonatomic, strong) NSMutableArray    *classifiedModelMutableArray;   // 服务端下发分类的模型容器
@property (nonatomic, strong) NSMutableArray    *videoVCMutableArray;           // 服务端下发分类的对应的控制器容器

@property(nonatomic, assign) NSInteger currentIndex;

@property(nonatomic, strong) NSString *password;

@property(nonatomic, strong) LivingModel *model;
@property(nonatomic, strong) NSArray *modelArr;

@end

@implementation CustomPagerController{
    JSBadgeView                     *_badge;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self loadBtnBadageData];
}

- (void)updateClassiFiedVC
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    @synchronized (self)
    {
        if (self.classifiedModelMutableArray.count > 0)
        {
            
        }
        
        // 动态添加视频分类
        for (VideoClassifiedModel *model in [GlobalVariables sharedInstance].appModel.video_classified)
        {
            [self.itemTitleMutableArray addObject:model.title];
        }
        
        self.classifiedModelMutableArray = [GlobalVariables sharedInstance].appModel.video_classified;
        
        
        

        for (NSInteger i = 0; i < self.classifiedModelMutableArray.count; ++i)
        {
            // 服务端下发的分类的在完整的分类容器中的起点

            VideoViewController *videoVC = [[VideoViewController alloc] init];
            VideoClassifiedModel * model = [[GlobalVariables sharedInstance].appModel.video_classified objectAtIndex:i];
            videoVC.viewFrame = CGRectMake(0, 0, kScreenW, kScreenH  - kTabBarHeight - kRealValue(5));
            videoVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH  - kTabBarHeight - kRealValue(5));
            videoVC.classified_id = model.classified_id;
            
            [self.videoVCMutableArray addObject:videoVC];
        }
        [self reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateContentView];
    [self moveToControllerAtIndex:self.curIndex animated:NO];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adjustStatusBarHeight = YES;
    self.cellSpacing = 8;
    
    [self setView];
//    self.curIndex = 3;
    
    [self setBarStyle:TYPagerBarStyleNoneView];

    
//    self.kCollectionViewBarHieght = 44 + 50;
//    50 + 40 + 10;
   
    self.pagerBarView.backgroundColor = kClearColor;
    
    self.collectionLayoutEdging = kRealValue(44 * 2) + kRealValue(20);
    
//    self.bgTopImgView.height = kStatusBarHeight + kRealValue(44) - kRealValue(5);
//    self.contentTopEdging = self.bgTopImgView.height;
    
    self.bgTopImgView.height = kTopHeight;
    self.contentTopEdging = self.bgTopImgView.height;

    
    if ([GlobalVariables sharedInstance].userModel.user_id.integerValue) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadBtnBadageData];
            [self requestDataToady];
        });
    }
    

    
    
    // 加载礼物列表
    [[GiftListManager sharedInstance] reloadGiftList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iMChatHaveNotification:) name:g_notif_chatmsg object:nil];
    
    self.itemTitleMutableArray = [NSMutableArray arrayWithObjects:ASLocalizedString(@"关注"),ASLocalizedString(@"热门"),ASLocalizedString(@"附近"),nil];
    self.classifiedModelMutableArray = [NSMutableArray array];
    self.videoVCMutableArray = [NSMutableArray array];
    
    self.classifiedModelMutableArray = [GlobalVariables sharedInstance].appModel.video_classified;
    
    FocusOnViewController *focusVC = [[FocusOnViewController alloc]init];
    focusVC.delegate = self;
    NewestViewController *hotVC = [[NewestViewController alloc]init];
    hotVC.types = @"1";
    hotVC.delegate = self;
    
    NewestViewController *nearbyVC = [[NewestViewController alloc]init];
    nearbyVC.delegate = self;
    nearbyVC.types = @"2";
    [self.videoVCMutableArray addObject:focusVC];
    [self.videoVCMutableArray addObject:hotVC];
    [self.videoVCMutableArray addObject:nearbyVC];
    
//    self.currentIndex = 1;
//    self.curIndex = 1;
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"init" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            [self updateClassiFiedVC];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
//    focusVC.view.height = self.viewHeight;
//    focusVC.view.top = 0;
//    focusVC.videoCollectionV.height = self.viewHeight;
//
//    hotVC.view.height = self.viewHeight;
//    hotVC.videoCollectionV.height = self.viewHeight;
//
//    nearbyVC.view.height = self.viewHeight;
//    nearbyVC.videoCollectionV.height = self.viewHeight;
    
//    [EveryDayFirstLoginPopView showEveryDayFirstLoginViewScore:@"5" WithComplete:^{
//
//    }];
}

-(void)setView{
    
//
//    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(175))];
//    bgImgView.image = [UIImage imageNamed:@"mg_hm_topBgImgView"];
//    [self.view addSubview:bgImgView];
    
    
    //搜索按钮
    QMUIButton *searchBTN = [QMUIButton buttonWithType:UIButtonTypeCustom];
    searchBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchBTN setImage:[UIImage imageNamed:@"hm_search_btn"] forState:UIControlStateNormal];
    searchBTN.frame = CGRectMake(10,25,kScreenW - kRealValue(110),kRealValue(30));
    [searchBTN addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchBTN setTitle:ASLocalizedString(@"搜索")forState:UIControlStateNormal];
    searchBTN.titleLabel.font = [UIFont systemFontOfSize:15];
    searchBTN.backgroundColor = kClearColor;
    searchBTN.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [searchBTN setBackgroundImage:[UIImage imageNamed:@"hm_search_btn_bgimgView"]];
//    [UIColor colorWithRed:255 green:255 blue:255 alpha:0.6];
    searchBTN.layer.cornerRadius = kRealValue(30 / 2);
    searchBTN.layer.masksToBounds = YES;
    searchBTN.spacingBetweenImageAndTitle = 5;
    searchBTN.imagePosition = QMUIButtonImagePositionLeft;
    [searchBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.view addSubview:searchBTN];
    searchBTN.hidden = YES;
    
    UIButton *privateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    privateBtn.frame = CGRectMake(kScreenW - 50,20,30,44);
    privateBtn.contentMode = UIViewContentModeScaleAspectFit;
    [privateBtn setImage:[UIImage imageNamed:@"hm_private_message"] forState:0];
    [privateBtn addTarget:self action:@selector(toChatListVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateBtn];
    
    
    UIButton *rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rankBtn.frame = CGRectMake(privateBtn.left - 50,20,44,44);
    rankBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rankBtn setImage:[UIImage imageNamed:@"mg_rank_top"] forState:0];
    [rankBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rankBtn];
    
    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        rankBtn.hidden = YES;
    }
    
    privateBtn.centerY = rankBtn.centerY;
    
    if(isIPhoneX())
    {
        searchBTN.y += 15;
        privateBtn.y += 15;
        rankBtn.y += 15;
    }
    [self initBadgeBtn:privateBtn];
}

- (void)toChatListVC{
    BGConversationSegmentController *chatListVC = [[BGConversationSegmentController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:chatListVC animated:YES];
}

-(void)toRankVC{
    LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
    lbVCtr.isHiddenTabbar = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:lbVCtr animated:YES];
}

#pragma mark - ----------------------- 私信消息、角标 -----------------------
#pragma mark IM

- (void)iMChatHaveNotification:(NSNotification*)notification
{
    //all 角标数据
    [self loadBtnBadageData];
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

//进入贡献榜
- (void)Incontribution
{
    LeaderboardViewController *vc = [[LeaderboardViewController alloc]init];
//    vc.isHiddenTabbar = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

-(void)search{
    SSearchVC *searchVC = [[SSearchVC alloc]init];
    searchVC.searchType = @"0";
    [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController
{
    return self.itemTitleMutableArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return self.itemTitleMutableArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
        return self.videoVCMutableArray[index];
}

#pragma mark - override delegate
- (void)pagerController:(TYTabPagerController *)pagerController configreCell:(TYTabTitleViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath
{
    [super pagerController:pagerController configreCell:cell forItemTitle:title atIndexPath:indexPath];
}

#pragma mark 跳转到话题页面和hotTopicViewController二级页面
- (void)pushToNextControllerWithModel:(cuserModel *)model
{
    if ([model.cate_id isEqualToString:@"0"])
    {
        // 暂时不能跳转
    }
    else
    {
        NewestViewController *tmpController = [[NewestViewController alloc]init];
        tmpController.topicName = model.title;
        tmpController.cate_id = model.cate_id;
        tmpController.types = @"1";
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
}

#pragma mark NewestViewController跳转到直播
-(void)pushToLiveController:(LivingModel *)model modelArr:(NSArray *)modelArr isFirstJump:(BOOL)isFirstJump
{
    _model = model;
    _modelArr = modelArr;
    if (![BGUtils isNetConnected])
    {
        return;
    }
    
    if (isFirstJump) {
        self.password = @"";
    }
    
    if (![BGUtils isBlankString:model.password] && isFirstJump) {
        [self clickPasswordActionDelegateWithPassWord:model.password];
        return;
    }
    
    [[GlobalVariables sharedInstance].newestLivingMArray removeAllObjects];
    [[GlobalVariables sharedInstance].newestLivingMArray addObject:model];
    
    if ([self checkUser:[IMAPlatform sharedInstance].host])
    {
        TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
        item.chatRoomId = model.group_id;
        item.avRoomId = model.room_id;
        item.title = StringFromInt(model.room_id);
        item.vagueImgUrl = model.head_image;
        item.is_voice = model.is_voice;

        TCShowUser *showUser = [[TCShowUser alloc]init];
        showUser.uid = model.user_id;
        showUser.avatar = model.head_image;
        item.host = showUser;
        
        if (model.live_in == FW_LIVE_STATE_ING)
        {
            item.liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        else if (model.live_in == FW_LIVE_STATE_RELIVE)
        {
            item.liveType = FW_LIVE_TYPE_RELIVE;
            [GlobalVariables sharedInstance].appModel.spear_live = @"0";
        }
        
        //先关闭悬浮的直播间
        if ([LiveCenterManager sharedInstance].itemModel) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clickLiveRoomNotification" object:nil];
        }
        
        [LiveCenterManager sharedInstance].itemModel=item;
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];

        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:item modelArr:modelArr  isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
            
        }];

    }
    else
    {
        [[BGHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
            [[BGIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        } completion:^{
            
        }];
    }
}

-(void)clickPasswordActionDelegateWithPassWord:(NSString *)password{
    WeakSelf
    
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
        NSString *md5Str = [[NSString md5String:self.password] uppercaseString];
        //转化为大写
        
        if ([md5Str isEqualToString:self.model.password]) {
            [self pushToLiveController:_model modelArr:_modelArr isFirstJump:NO];
        }else{
            [FanweMessage alertHUD:ASLocalizedString(@"密码不正确")];
        }
    }];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    self.password = textField.text;
}

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
}

#pragma mark 跳转HomePageController页面
- (void)goToMainPage:(NSString *)userID
{
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = userID;
    tmpController.type = 0;
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

- (void)goToNewestView
{
    
}

#pragma mark - 判断当日是否签到

- (void)requestDataToady{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"is_signin" forKey:@"act"];

    FWWeakify(self)

    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
       FWStrongify(self)

        if ([responseJson toInt:@"today_signin"] == 0) {
            [MGSignHomeSuccessView showTodaySignSuccessViewGift:@"" frame:CGRectMake(0, 0, kScreenW, kScreenH) WithComplete:^{
                
            }];
        }
    } FailureBlock:^(NSError *error) {

    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    if (@available(iOS 13, *)) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleLightContent;
}

@end


