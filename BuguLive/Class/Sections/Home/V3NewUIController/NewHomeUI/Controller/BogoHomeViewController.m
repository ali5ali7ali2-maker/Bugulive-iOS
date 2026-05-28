//
//  BogoHomeViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/18.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoHomeViewController.h"

#import "NewestViewController.h"
#import "BogoHomeTopView.h"
#import "VideoViewController.h"

#import "BogoGuideViewController.h"

#import "MGSignHomeSuccessView.h"
#import "VoiceHomeListViewController.h"

#import "MLMSegmentManager.h"
#import "GKDBViewController.h"
#import "GameListViewController.h"

@interface BogoHomeViewController ()<MLMSegmentHeadDelegate,PushToLiveControllerDelegate,UITextFieldDelegate,BogoHomeTopViewDelegate>

@property (nonatomic, strong) NSMutableArray                            *itemTitleMutableArray;         // 完整的分类标题容器
@property (nonatomic, strong) NSMutableArray    *classifiedModelMutableArray;   // 服务端下发分类的模型容器
@property (nonatomic, strong) NSMutableArray    *videoVCMutableArray;           // 服务端下发分类的对应的控制器容器

@property(nonatomic, strong) NSArray *listArr;
@property(nonatomic, strong) BogoHomeTopView *topView;

@property(nonatomic, strong) LivingModel *model;
@property(nonatomic, strong) NSArray *modelArr;

@property(nonatomic, assign) NSInteger currentIndex;

@property(nonatomic, strong) NSString *password;





@end

@implementation BogoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //顶部渐变

    UIImageView *topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64+kStatusBarHeight)];
    topImgView.image = [UIImage imageNamed:@"顶部渐变"];
    [self.view addSubview:topImgView];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    
    [self.view addSubview:self.topView];
    [self setUpSegView];
    
    [self reloadUserInfoWithOne:YES];

    [self requestDataToady];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    NSDate *now = [NSDate date];
    if (!self.lastReloadTime || [now timeIntervalSinceDate:self.lastReloadTime] > 30) {
        self.lastReloadTime = now;
        [self reloadUserInfoWithOne:NO];
    }
    
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    } else {
        // Fallback on earlier versions
    }
    
    if (self.videoVCMutableArray.count < 1) {
//        [self updateClassiFiedVC];
    }
    // [self reloadUserInfoWithOne:NO];
}

-(void)reloadUserInfoWithOne:(BOOL)isOne{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"userinfo" forKey:@"act"];
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             UserModel *model = [UserModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];

             [GlobalVariables sharedInstance].is_noble_mysterious = model.is_noble_mysterious;
             [GlobalVariables sharedInstance].userModel = model;

//             if (isOne) {
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"isOpenYoung" object:nil];
//             }
             
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         
     }];
}

-(void)setUpSegView{
    self.itemTitleMutableArray = [NSMutableArray array];
    self.videoVCMutableArray = [NSMutableArray array];
    _listArr = @[ASLocalizedString(@"推荐"),ASLocalizedString(@"关注"),ASLocalizedString(@"最新"),ASLocalizedString(@"游戏")];
//    _listArr = @[ASLocalizedString(@"关注"),ASLocalizedString(@"推荐")];

    
    [self.itemTitleMutableArray addObjectsFromArray:_listArr];

//     动态添加视频分类
    for (VideoClassifiedModel *model in [GlobalVariables sharedInstance].appModel.video_classified)
    {
        [self.itemTitleMutableArray addObject:model.title];
    }
    /*_segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(kRealValue(12), kTopHeight + kRealValue(5), kScreenW - kRealValue(24), kRealValue(50)) titles:self.itemTitleMutableArray headStyle:SegmentHeadStyleSlide layoutStyle:MLMSegmentLayoutCenter];
    //tab颜色
    _segHead.selectColor = kWhiteColor;
    _segHead.delegate = self;
    
    _segHead.fontScale = 1;
//    _segHead.lineHeight = 0;
//    _segHead.lineColor = kClearColor;
    _segHead.fontSize = 14;
    //滑块设置
    _segHead.slideHeight = kRealValue(32);
    _segHead.slideCorner = 4;
    _segHead.moreButton_width = kRealValue(64);
    _segHead.singleW_Add = kRealValue(64);
    _segHead.slideColor = nil;
//    _segHead.slideScale = 1.5;
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#EBDBFC"];
    _segHead.btnBgImg = @"bogo_home_top_bgSelectImg";
    _segHead.btnBeforeBgImg = @"bogo_home_top_bgBeforeImg";
    
    _segHead.bottomLineHeight = 0;
    
    _segHead.headColor = kClearColor;
    _segHead.deSelectColor = kBlackColor;
    */
    
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(kRealValue(9.5), kStatusBarHeight - kRealValue(15), kScreenW - kRealValue(150), kRealValue(46)) titles:self.itemTitleMutableArray headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutLeft];
    //tab颜色
    _segHead.lineScale = 0.3;
    _segHead.selectColor = [UIColor colorWithHexString:@"#1A1A1A"];;
    _segHead.delegate = self;

    _segHead.fontScale = 1.2;
//    _segHead.lineHeight = 0;
//    _segHead.lineColor = kClearColor;
    _segHead.fontSize = 15;
//    _segHead.tag = 1101;
    _segHead.lineColor = [UIColor clearColor];
    _segHead.lineHeight = kRealValue(3);
    _segHead.lineScale = 0.3;
    //滑块设置
//    _segHead.slideHeight = kRealValue(32);
//    _segHead.slideCorner = 4;
//    _segHead.moreButton_width = kRealValue(64);
//    _segHead.singleW_Add = kRealValue(64);
//    _segHead.slideColor = nil;
//    _segHead.slideScale = 1.5;
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#333333"];
//    _segHead.btnBgImg = @"bogo_home_top_bgSelectImg";
//    _segHead.btnBeforeBgImg = @"bogo_home_top_bgBeforeImg";
    
    _segHead.bottomLineHeight = 0;
    
    _segHead.headColor = kClearColor;
//    _segHead.deSelectColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    self.view.backgroundColor = kClearColor;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)  + 10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame) - kNavigationBarHeight - 40) vcOrViews:[self vcArr:_listArr.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.topView addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
//    [self updateClassiFiedVC];
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
            videoVC.viewFrame = CGRectMake(0, 0, kScreenW, kScreenH  - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
            videoVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
            videoVC.classified_id = model.classified_id;
            
            [self.videoVCMutableArray addObject:videoVC];
        }
    }
    
    
//    [self.segHead addMoreTitles:self.itemTitleMutableArray];
//    [self.segScroll addVcOrViews:self.videoVCMutableArray];
}



#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray array];
    
    FocusOnViewController *focusVC = [[FocusOnViewController alloc]init];
    focusVC.delegate = self;
    focusVC.collectionViewFrame = CGRectMake(0, 0, kScreenW, kScreenH - self.segHead.bottom  - kTabBarHeight  - kRealValue(50) + kRealValue(10) );
    NewestViewController *concertVC = [NewestViewController new];
    concertVC.types = @"1";
    concertVC.delegate = self;
    concertVC.collectionViewFrame = CGRectMake(0, 0, kScreenW, kScreenH - self.segHead.bottom - MG_BOTTOM_MARGIN );
    NewestViewController *recommandVC = [NewestViewController new];
    recommandVC.delegate = self;
    recommandVC.types = @"1";
    recommandVC.delegate = self;
    recommandVC.collectionViewFrame = CGRectMake(0, 0, kScreenW, kScreenH - self.segHead.bottom - MG_BOTTOM_MARGIN - kRealValue(5) );
    
    NewestViewController *nearbyVC = [[NewestViewController alloc]init];
    nearbyVC.delegate = self;
    nearbyVC.types = @"2";
    
    //附近和推荐不一样
    nearbyVC.collectionViewFrame = CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight - kTabBarHeight - kRealValue(50) - MG_BOTTOM_MARGIN + kRealValue(56) - kRealValue(10));
    
    VoiceHomeListViewController *voiceRoom = [VoiceHomeListViewController new];
    voiceRoom.types = @"1";
    voiceRoom.delegate = self;
    voiceRoom.topViewdelegate = self;

    

    GameListViewController *gameVc = [[GameListViewController alloc] init];
    
    [arr addObject:recommandVC];
    [arr addObject:focusVC];
    [arr addObject:nearbyVC];
    [arr addObject:gameVc];

    if (self.classifiedModelMutableArray.count > 0)
    {
        
    }
    
    
    
    self.classifiedModelMutableArray = [GlobalVariables sharedInstance].appModel.video_classified;
    
    
    

    // for (NSInteger i = 0; i < self.classifiedModelMutableArray.count; ++i)
    // {
    //     // 服务端下发的分类的在完整的分类容器中的起点

    //     VideoViewController *videoVC = [[VideoViewController alloc] init];
    //     VideoClassifiedModel * model = [[GlobalVariables sharedInstance].appModel.video_classified objectAtIndex:i];
    //     videoVC.viewFrame = CGRectMake(0, 0, kScreenW, kScreenH  - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
    //     videoVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - kRealValue(5) - kRealValue(50) - kTopHeight);
    //     videoVC.classified_id = model.classified_id;
        
    //     [arr addObject:videoVC];
    // }
    
    return arr;
}


//输入密码
-(void)clickPasswordActionDelegateWithPassWord:(NSString *)password{
    WeakSelf
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"请输入房间密码")preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = ASLocalizedString(@"请输入密码");
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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

-(void)textFieldDidChange:(UITextField *)textField{
    self.password = textField.text;
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

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
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


-(BogoHomeTopView *)topView{
    if (!_topView) {
        _topView = [[BogoHomeTopView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(44) + kStatusBarHeight)];
        _topView.delegate = self;
    }
    return _topView;
}

- (void)clickLiveBtn
{
    if(self.topViewdelegate && [self.topViewdelegate respondsToSelector:@selector(clickLiveBtn)]){
        [self.topViewdelegate clickLiveBtn];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
