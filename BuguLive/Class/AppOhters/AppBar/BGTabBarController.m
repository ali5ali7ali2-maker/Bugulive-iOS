//
//  BGTabBarController.m
//  BuguLive
//
//  Created by xfg on 2017/6/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGTabBarController.h"
#import "BGTabBar.h"
#import "BGNavigationController.h"
#import "HMHomeViewController.h"
#import "PublishLivestViewController.h"
#import "AgreementViewController.h"
#import "MPersonCenterVC.h"
#import "MSmallVideoVC.h"
#import "ListDayViewController.h"
#import "LeaderboardViewController.h"
#import "SChargerVC.h"
#import "LEEAlertHelper.h"
#import "LEEAlert.h"
#import "HMCenterPopView.h"
#import "SmallVideoViewController.h"
#import "CustomPagerController.h"


#import "NewSmallVideoViewController.h"


#import "TCVideoRecordViewController.h"

#import "YHTimeLineViewController.h"

#import "MGAlertIncodeView.h"

#import "UpgradeTipView.h"

//#import <UGCKit/UGCKit.h>
#import <UGCKit/UGCKit.h>


//主页
#import "BogoHomeViewController.h"
//广场
#import "BogoSquareViewController.h"
//消息
#import "BogoNewsViewController.h"
//青少年模式弹窗
#import "BogoYounthModePopView.h"

#import "SIdentificationVC.h"
#import "IMALoginParam.h"


#import "BogoNewsTabNumModel.h"

#import "MineViewController.h"

#import "BogoShopKit.h"
#import "BogoYouthModeViewController.h"
#import "BogoYoungModeVideoViewController.h"


#import "BogoYoungModeVideoViewController.h"
#import "BogoNewSquareViewController.h"

#import "VoiceHomeListViewController.h"
#import "GKDBViewController.h"
#import "GKAllRefreshViewController.h"
#import "TLVoiceListViewController.h"
@interface BGTabBarController ()<UITabBarControllerDelegate,UIActionSheetDelegate,BogoHomeTopViewDelegate>

@property (nonatomic, strong) HMCenterPopView *popView;
@property (nonatomic, strong) VideoDynamicViewC *videoDynamicViewC;

@property(nonatomic, strong) MGAlertIncodeView *alertView;

@property(nonatomic, strong) BogoYounthModePopView *youthView;
@property(nonatomic, strong) UIImageView *tabBgImgView;


@property(nonatomic, strong) UIView *tipView;
@property(nonatomic, assign) BOOL canClickItem;
@end

@implementation BGTabBarController

BogoSingletonM(Instance);

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.canClickItem = YES;
    [[GiftListManager sharedInstance] reloadGiftList];
    
    [BGIMMsgHandler sharedInstance];
    [BGIMPrivateMsgHandler sharedInstance];
    
    if ([BGIMLoginManager sharedInstance].isIMSDKOK) {
        NSLog(@"已经登录了");
    }else{
        NSLog(@"没有");
        
        [[BGIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
    }

    
    self.delegate = self;
    
    [self setUpChildViewControllers];
    self.view.backgroundColor = kWhiteColor;
    self.alertView = [MGAlertIncodeView new];
    self.alertView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.alertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    FWWeakify(self)
    self.alertView.clickBlock = ^(NSInteger i) {
        FWStrongify(self)
        if (i == 0) {
//            [self.alertView removeAllSubViews];
            self.alertView.hidden = YES;
        }
    };
    
    self.alertView.hidden = YES;
    [self.view addSubview:self.alertView];
    

    if ([VersionNum isEqualToString: [GlobalVariables sharedInstance].appModel.ios_check_version])
    {
        
    }
    else
    {
        [self checkCode];
    }

    
//    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kClearColor,
//                                                             NSFontAttributeName:[UIFont systemFontOfSize:20.0]
//    } forState:UIControlStateNormal];



  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isOpenYoung:) name:@"isOpenYoung" object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    
    //添加到window一个日志按钮
    UIButton *logBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 180, 150, 50)];
    [logBtn setTitle:@"Send Log" forState:UIControlStateNormal];
    logBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [logBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [logBtn setBackgroundColor:kYellowColor];
    [logBtn addTarget:self action:@selector(getLogFile:) forControlEvents:UIControlEventTouchUpInside];
    
//    [kCurrentWindow addSubview:logBtn];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 需要延迟执行的代码
//        //放到最前面
//        [kCurrentWindow bringSubviewToFront:logBtn];
//    });
}


- (void)getGiftNumber {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"deal" forKey:@"ctl"];
    [dict setValue:@"get_gift_quantity" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        if ([responseJson toInt:@"status"] == 1) {
            NSArray *list = responseJson[@"data"];
            [GlobalVariables sharedInstance].giftQuantityModelList = [NSArray modelArrayWithClass:GiftQuantityModel.class json:list];
            
//            for (int i = 0; i<list.count; i++) {
//                GiftQuantityModel *model = [GiftQuantityModel modelWithDictionary:list[i]];
//
//            }
        }else{
            //接口请求失败
            NSLog(ASLocalizedString(@"礼物responseJson:%@"),responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"礼物error:%@"),error);
    }];
}

- (void)isOpenYoung:(NSNotification *)center{
    
    
    NSDictionary *dic = center.object;
    

    
    if ([GlobalVariables sharedInstance].userModel.is_open_young.integerValue) {
        NSMutableDictionary *hotDic = [NSMutableDictionary dictionary];
        
        [hotDic setObject:@"1" forKey:@"order"];
        [hotDic setObject:@"0" forKey:@"cate"];
        BogoYoungModeVideoViewController *vc = [BogoYoungModeVideoViewController new];
        vc.isHaveNavBar = NO;
        vc.paramDict = hotDic;
        vc.notHaveTabbar = NO;
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewControllers.firstObject pushViewController:vc animated:YES];
    }else{
        if (![GlobalVariables sharedInstance].isShutDownYoung) {
            [self.youthView show:self.view type:FDPopTypeCenter];
        }else{
            [self.view addSubview:self.tipView];
            [UIView animateWithDuration:0.25 animations:^{
                self.tipView.alpha = 1;
            }];
            [self performSelector:@selector(hideTipView) afterDelay:3];
        }
    }
}

- (void)hideTipView{
    [UIView animateWithDuration:0.25 animations:^{
        self.tipView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tipView removeFromSuperview];
    }];
}


- (UIView *)tipView{
    if (!_tipView) {
        _tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 40)];
        _tipView.backgroundColor = [FD_BlackColor colorWithAlphaComponent:0.4];
        _tipView.layer.cornerRadius = 20;
        _tipView.clipsToBounds = YES;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 20)];
        titleLabel.textColor = FD_WhiteColor;
        titleLabel.center = _tipView.center;
        titleLabel.text =ASLocalizedString( @"青少年模式已关闭");
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_tipView addSubview:titleLabel];
        _tipView.center = self.view.center;
        _tipView.alpha = 0;
    }
    return _tipView;
}

- (void)viewWillAppear:(BOOL)animated {
    self.canClickItem = YES;

    [super viewWillAppear:animated];
    [self getGiftNumber];

    [self showNesBarRedNum];
    NSLog(@"%@",self.view);
    
}


- (void)checkCode {
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"login" forKey:@"ctl"];
    [mDict setObject:@"is_invitation" forKey:@"act"];
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        
            if([[GlobalVariables sharedInstance].appModel.is_invite_code intValue] == 1)
            {
                
                if([responseJson toInt:@"state"] == 0)
                {
                    self.alertView.hidden = NO;
                    self.alertView.textField.placeholder = ASLocalizedString(@"请输入邀请码");
                }

            }
            else
            {
                
                if([responseJson toInt:@"state"] == 0)
                {
                    self.alertView.hidden = NO;
              }

                
            }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

-(void)postCode:(NSString *)code
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"login" forKey:@"ctl"];
    [mDict setObject:@"invitation" forKey:@"act"];
    [mDict setObject:code forKey:@"invitation_id"];
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
                
        {
            [LEEAlert closeWithCompletionBlock:^{
                
            }];
            [FanweMessage alert:ASLocalizedString(@"提交成功")];

        }
        else
        {
            
            __block UITextField *tf = nil;
            
            [BGHUDHelper alert:[responseJson valueForKey:@"error"] action:^{
                [LEEAlert alert].config
                .LeeTitle(ASLocalizedString(@"邀请码"))
                .LeeAddTextField(^(UITextField *textField) {
                    
                    // 这里可以进行自定义的设置
                    textField.placeholder = ASLocalizedString(@"请输入邀请码");
                    
                    textField.textColor = [UIColor darkGrayColor];
                    
                    tf = textField; //赋值
                })
                .LeeAction(ASLocalizedString(@"确定"), ^{
                    
                    if(tf.text == nil || tf.text.length < 1)
                    {
                        //                             [self checkCode];
                        [BGHUDHelper alert:ASLocalizedString(@"邀请码不能为空")action:^{
                            [self checkCode];
                        }];
                        //                            [BGHUDHelper alert:ASLocalizedString(@"邀请码不能为空")];
                        return;
                    }
                    
                    [self postCode:tf.text];
                    [tf resignFirstResponder];
                })
                // 点击事件的Block如果不需要可以传nil
                .LeeShow();
            }];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
    //
}

#pragma mark - 设置子控制器
- (void)setUpChildViewControllers
{
    if (@available(iOS 13.0, *)) {

        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor colorWithHexString:@"#999999"]];
        self.tabBar.tintColor = [UIColor colorWithHexString:@"#9152F8"];
//        kAppMainColor;
    }else{
        
    }
    

    
    // 首页
    BogoHomeViewController *home = [[BogoHomeViewController alloc] init];
    home.topViewdelegate = self;
    
    [self addChildViewController:home image:@"ic_live_tab_live_normal" seletedImage:@"ic_live_tab_live_selected" title:ASLocalizedString(@"直播")];
    
//    VoiceHomeListViewController *voiceRoom = [VoiceHomeListViewController new];
//    voiceRoom.types = @"1";
//    voiceRoom.delegate = home;
//    voiceRoom.topViewdelegate = self;
//    [self addChildViewController:voiceRoom image:@"语音1" seletedImage:@"语音2" title:ASLocalizedString(@"语音")];

    
//    GKAllRefreshViewController *voiceRoom2 = [GKAllRefreshViewController new];
//    voiceRoom2.types = @"1";
//    voiceRoom2.delegate = home;
//    voiceRoom2.topViewdelegate = self;
//    [self addChildViewController:voiceRoom2 image:@"语音1" seletedImage:@"语音2" title:ASLocalizedString(@"语音")];
    TLVoiceListViewController *voice = [TLVoiceListViewController new];
    voice.topViewdelegate = self;
    voice.types = @"1";
    [self addChildViewController:voice image:@"语音1" seletedImage:@"语音2" title:ASLocalizedString(@"语音")];


    
    
    // guangc
    if (![GlobalVariables sharedInstance].appModel.short_video.integerValue) {
        BogoSquareViewController *squareVC = [BogoSquareViewController new];
        squareVC.clickSquareBtnBlock = ^(NSInteger index) {
            [self showDynamicVC];
        };
        [self addChildViewController:squareVC image:@"ic_live_tab_rank_normal" seletedImage:@"ic_live_tab_rank_selected" title:ASLocalizedString(@"广场")];
    }else{
        BogoNewSquareViewController *squareVC = [BogoNewSquareViewController new];
        squareVC.clickSquareBtnBlock = ^(NSInteger index) {
            [self showDynamicVC];
        };
        [self addChildViewController:squareVC image:@"ic_live_tab_rank_normal" seletedImage:@"ic_live_tab_rank_selected" title:ASLocalizedString(@"广场")];
    }
    // 发布直播==》放在FWTabBar里面
//    [self setupTabBar];
    // 直播

    
    [self addChildViewController:[[BogoNewsViewController alloc] init] image:@"ic_live_tab_video_normal" seletedImage:@"ic_live_tab_video_selected" title:ASLocalizedString(@"消息")];
    // 我的
    [self addChildViewController:[[MineViewController alloc] initWithNibName:@"MineViewController" bundle:[NSBundle mainBundle]] image:@"ic_live_tab_me_normal"  seletedImage:@"ic_live_tab_me_selected"  title:ASLocalizedString(@"我的")];
    
    //fix
    if(self.tabBgImgView == nil)
    {
        [self.tabBgImgView removeFromSuperview];
        
        self.tabBgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -14, kScreenW, FD_Bottom_Height + 14)];
    //    tabBgImgView.backgroundColor = kRedColor;
        self.tabBgImgView.image = [UIImage imageNamed:@"mg_tab_bgImg"];
        self.tabBgImgView.contentMode = UIViewContentModeScaleToFill;
        [self.tabBar addSubview:self.tabBgImgView];
        self.tabBar.backgroundImage = [UIImage imageNamed:@"mg_tab_bgImg"];
        self.tabBar.backgroundColor = kWhiteColor;
    }
    
}


- (void)getLogFile:(id)sender {
    ///Library/Caches/com_tencent_imsdk_log
    //获取log目录下的文件
    // 获取日志文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (paths.count == 0) {
        [FanweMessage alertHUD:ASLocalizedString(@"日志目录不可用")];
        return;
    }
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logDirectory = [documentsDirectory stringByAppendingPathComponent:@"com_tencent_imsdk_log"];

    // 获取日志文件列表
    NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logDirectory error:nil];

    // 创建文件URL数组
    NSMutableArray *fileURLs = [NSMutableArray array];
    for (NSString *fileName in logFiles) {
        NSString *filePath = [logDirectory stringByAppendingPathComponent:fileName];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        [fileURLs addObject:fileURL];
    }

    if (fileURLs.count == 0) {
        [FanweMessage alertHUD:ASLocalizedString(@"暂无日志文件")];
        return;
    }

    // 创建分享视图控制器
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:fileURLs applicationActivities:nil];

    // 设置完成处理块（可选）
    activityViewController.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *error) {
        if (completed) {
            NSLog(@"文件分享成功");
        } else {
            NSLog(@"文件分享失败");
        }
    };

    // 显示分享视图控制器
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    
}

-(void)showNesBarRedNum{
    if (self.tabBar.items.count <= 2) {
        return;
    }
    UITabBarItem *itme = [self.tabBar.items objectAtIndex:2];
    
    SFriendObj *xxx = nil;
    
//    [SFriendObj getMyFriendMsgList:0
//                           lastObj:xxx
//                             block:^(SResBase *resb, NSArray *all, int unReadNum) {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"dynamic" forKey:@"ctl"];
        [parmDict setObject:@"unread_messages" forKey:@"act"];
        
        [[NetHttpsManager manager]POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                
            if ([[responseJson valueForKey:@"status"]integerValue] == 1) {
                
                BogoNewsTabNumModel *model = [BogoNewsTabNumModel modelWithDictionary:[responseJson valueForKey:@"data"]];
    
                
                if ((model.bzone_reply + model.bzone_like) == 0) {
                    itme.badgeValue = nil;
                }else{
                    [SFriendObj getAllUnReadCountComplete:^(int num) {
                        itme.badgeValue = [NSString stringWithFormat:@"%ld",model.bzone_reply + model.bzone_like + num + model.msg.count];
                    }];
                    
                }
    //            self.headView.model = model;
                
            }
            
        } FailureBlock:^(NSError *error) {
                
        }];
}

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize withTop:(CGFloat)top
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,top,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - 添加子控制器
- (UIViewController *)addChildViewController:(UIViewController *)childController image:(NSString *)image seletedImage:(NSString *)selectedImage title:(NSString *)title
{
    if (![BGUtils isBlankString:title])
    {
        childController.title = title;
        
        NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
        normalAttrs[NSForegroundColorAttributeName] = kAppGrayColor3;
        [childController.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        
        NSMutableDictionary *selectedAtrrs = [NSMutableDictionary dictionary];
        selectedAtrrs[NSForegroundColorAttributeName] = kAppMainColor;
        [childController.tabBarItem setTitleTextAttributes:selectedAtrrs forState:UIControlStateSelected];
        //        childController.tabBarItem.imageInsets = UIEdgeInsetsMake(12, 12, 12, 12);
//        childController.tabBarItem.imageInsets = UIEdgeInsetsMake(-10, 0, -5, 0);
        
        childController.tabBarItem.imageInsets = UIEdgeInsetsMake(-10, 0, -5, 0);
    }
    else
    {
        childController.tabBarItem.imageInsets = UIEdgeInsetsMake(-16, 0, -5, 0);
    }
    
    // 设置图片
    if ([title isEqualToString:@""]) {
//        UIImage *imageS = [[self imageResize:[UIImage imageNamed:image] andResizeTo:CGSizeMake(50, 50)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [childController.tabBarItem setImage:imageS];
//        [imageS drawInRect:CGRectMake(-10,0,50,50)];
        [childController.tabBarItem setImage:[[self imageResize:[UIImage imageNamed:image] andResizeTo:CGSizeMake(kRealValue(45), kRealValue(45)) withTop:0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        
        UITabBarItem* itm= [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:selectedImage]];

        childController.tabBarItem = itm;
        
        [childController.tabBarItem setImage:[[self imageResize:[UIImage imageNamed:image] andResizeTo:CGSizeMake(20, 20)  withTop:0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [childController.tabBarItem setSelectedImage:[[self imageResize:[UIImage imageNamed:selectedImage] andResizeTo:CGSizeMake(20, 20) withTop:0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    
    // 导航条
    BGNavigationController *nav = [[BGNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
    return childController;
}

- (void)setupTabBar
{
    BGTabBar *tabbar = [[BGTabBar alloc] init];
    tabbar.backgroundColor = kWhiteColor;
    [self setValue:tabbar forKey:@"tabBar"];
    FWWeakify(self)
    [tabbar setCenterBtnClickBlock:^{
        FWStrongify(self)
        [self onClickedCenterTabBar];
    }];
}

- (void)startLive {
    
    [[BGHUDHelper sharedInstance] syncLoading];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"user" forKey:@"ctl"];
    [dict setValue:@"user_home" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
        
        NSDictionary *liveDict = responseJson[@"video"];
        NSString *live_in = liveDict[@"live_in"];
        if(live_in.intValue == 1)
        {
            UserModel *model = [UserModel mj_objectWithKeyValues:liveDict];
            [self joinRoom:model];
        }
        else
        {
            [self openLive];
        }
    } FailureBlock:^(NSError *error) {
        
        NSLog(ASLocalizedString(@"获取对方用户信息失败error:%@")
              ,error);
    }];
    
}

- (void)openLive {
    if ([GlobalVariables sharedInstance].appModel.must_authentication.intValue == 1) {
        if ([GlobalVariables sharedInstance].userModel.is_authentication.intValue != 2) {
            [self showAuthView];
            return;
        }
    }
    
    
    
    IMALoginParam *loginParam = [IMALoginParam loadFromLocal];
    if (loginParam.isAgree ==1)
    {
        PublishLivestViewController *pvc = [[PublishLivestViewController alloc] init];
        [[AppDelegate sharedAppDelegate] presentViewController:pvc animated:YES completion:^{
            
        }];
    }
    else
    {
        AgreementViewController *agreeVC = [AgreementViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.agreement_link isShowIndicator:YES isShowNavBar:YES];
        [[AppDelegate sharedAppDelegate] presentViewController:agreeVC animated:YES completion:^{
            
        }];
    }
}

#pragma mark 点击直播
- (void)onClickedCenterTabBar
{
//    PopMenuCenter *popMenuCenter = [PopMenuCenter sharePopMenuCenter];
//    [popMenuCenter setTabBarC:self];
//    [popMenuCenter setStPopMenuShowState:STPopMenuShow];
    
    NSArray *objs = [[NSBundle mainBundle]loadNibNamed:@"HMCenterPopView" owner:nil options:nil];
    self.popView = objs.firstObject;
    [self setUpLocalizationStringForView:self.popView];
    FWWeakify(self)
    [self.popView setClickPopViewBtnBlock:^(HMCenterPopViewBtnType type) {
        FWStrongify(self)
        switch (type) {
            case HMCenterPopViewBtnTypeLive:
            {
                
                [self startLive];
            }
                break;
            case HMCenterPopViewBtnTypeVideo:
            {
                
                [self showDynamicVC];
                
            }
                break;
            case HMCenterPopViewBtnTypeClose:
                break;
            default:
                break;
        }
    }];
    [self.popView show:[UIApplication sharedApplication].keyWindow];
}

-(void)showDynamicVC{
    self.videoDynamicViewC = (VideoDynamicViewC *)[VideoDynamicViewC showSTBaseViewCOnSuperViewC:self.selectedViewController
                                                                                    andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                                        andSTViewCTransitionType:STViewCTransitionTypeOfModal
                                                                                     andComplete:^(BOOL finished,
                                                                                                   STBaseViewC *stBaseViewC) {
                                                                                         
                                                                                     }];
    self.videoDynamicViewC.recordTabBarC = self;
    [self.videoDynamicViewC videoDynamicView];
    
    // 开启IQ
    self.videoDynamicViewC.isOpenIQKeyboardManager = YES;
    // 加载View层
    //[videoDynamicViewC graphicDynamicView];
    //跳转
    //找到当前ViewC
    UIViewController *currentViewC = self.selectedViewController.childViewControllers[0];
    //TabBarc隐藏
    currentViewC.hidesBottomBarWhenPushed=YES;
    currentViewC.navigationController.navigationBar.tintColor = kAppGrayColor1;
    self.videoDynamicViewC.navigationController.navigationBar.hidden = NO;
    self.videoDynamicViewC.title = ASLocalizedString(@"发布短视频");
    self.videoDynamicViewC.navigationController.navigationBar.tintColor =kAppGrayColor1;
    
    
    
    
    //改变颜色  必须跳转后
    self.videoDynamicViewC.navigationController.navigationBar.hidden = NO;
    [self.videoDynamicViewC.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:kAppGrayColor1}];
    currentViewC.hidesBottomBarWhenPushed=NO;
    
    UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [headImgSheet addButtonWithTitle:ASLocalizedString(@"拍摄视频")];
    [headImgSheet addButtonWithTitle:ASLocalizedString(@"相册中获取视频")];
    [headImgSheet addButtonWithTitle:ASLocalizedString(@"取消")];
    headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
    headImgSheet.delegate = self;
    [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0) {
        
        //如果短视频key为空，调本地视频
        if ([BGUtils isBlankString:[GlobalVariables sharedInstance].appModel.tencent_video_sdk_key]) {
            [[AppDelegate sharedAppDelegate]pushViewController:self.videoDynamicViewC animated:YES];
            [self.videoDynamicViewC ceartVideoViewWithType:(int)buttonIndex];
            return;
        }
        UGCKitRecordViewController *recordViewController = [[UGCKitRecordViewController alloc] initWithConfig:nil theme:nil];
        recordViewController.completion = ^(UGCKitResult *result) {
            
            if (result.cancelled) {
                [[AppDelegate sharedAppDelegate]popViewController];
//                UGCKitEditViewController *vc=  [UGCKitEditViewController new];
//                [[AppDelegate sharedAppDelegate]pushViewController:vc];
            }else{
                [self showEditViewController:result rotation:TCEditRotation0 inNavigationController:[AppDelegate sharedAppDelegate].topViewController.navigationController];
//                 self.navigationController];
            }
        };

//        TCVideoRecordViewController *vc = [[TCVideoRecordViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:recordViewController animated:YES];
        return;
    }else if (buttonIndex == 1){
        [[AppDelegate sharedAppDelegate]pushViewController:self.videoDynamicViewC animated:YES];
        [self.videoDynamicViewC ceartVideoViewWithType:(int)buttonIndex];
    }
}

- (void)showEditViewController:(UGCKitResult *)result
                      rotation:(TCEditRotation)rotation
        inNavigationController:(UINavigationController *)nav
{
    UGCKitMedia *media = result.media;
    UGCKitEditConfig *config = [[UGCKitEditConfig alloc] init];
    config.rotation = (TCEditRotation)(rotation / 90);

    UIImage *tailWatermarkImage = [UIImage imageNamed:@"tcloud_logo"];
    TXVideoInfo *info = [TXVideoInfoReader getVideoInfoWithAsset:media.videoAsset];
    float w = 0.15;
    float x = (1.0 - w) / 2.0;
    float width = w * info.width;
    float height = width * tailWatermarkImage.size.height / tailWatermarkImage.size.width;
    float y = (info.height - height) / 2 / info.height;
    config.tailWatermark = [UGCKitWatermark watermarkWithImage:tailWatermarkImage
                                                     frame:CGRectMake(x, y, w, 0)
                                                  duration:2];
    __weak __typeof(self) wself = self;
    UGCKitEditViewController *vc = [[UGCKitEditViewController alloc] initWithMedia:media
                                                                            config:config
                                                                             theme:nil];
    
    __weak UGCKitEditViewController *weakEditController = vc;
    __weak UINavigationController *weakNavigation = nav;
    
    vc.onTapNextButton = ^(void (^finish)(BOOL)) {
//        [wself showEditFinishOptionsWithResult:result editController:weakEditController finishBloack:finish];
        finish(YES);
    };

    vc.completion = ^(UGCKitResult *result) {
        __strong __typeof(wself) self = wself; if (self == nil) { return; }
        if (result.cancelled) {
            [[AppDelegate sharedAppDelegate]popViewController];
        } else {
            [_videoDynamicViewC upLoadVideoUrl:vc.videoOutputPath];
            [[AppDelegate sharedAppDelegate]popToRootViewController];
            [[AppDelegate sharedAppDelegate]pushViewController:_videoDynamicViewC animated:YES];
            [self showVideoDynamicViewC];
        }
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CACHE_PATH_LIST];
//        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
//    [nav pushViewController:vc animated:YES];
}


#pragma mark -  5 - 视频动态页面
-(void)showVideoDynamicViewC
{
    
    _videoDynamicViewC = (VideoDynamicViewC *)[VideoDynamicViewC showSTBaseViewCOnSuperViewC:[AppDelegate sharedAppDelegate].topViewController.tabBarController.selectedViewController
                                                                                    andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                                        andSTViewCTransitionType:STViewCTransitionTypeOfModal
                                                                                     andComplete:^(BOOL finished,
                                                                                                   STBaseViewC *stBaseViewC) {
                                                                                         
                                                                                     }];
    
    _videoDynamicViewC.recordTabBarC = [AppDelegate sharedAppDelegate].topViewController.tabBarController;
    [_videoDynamicViewC videoDynamicView];
    [_videoDynamicViewC showPublishDynamic];
    // 开启IQ
    _videoDynamicViewC.title = ASLocalizedString(@"发布短视频");
    _videoDynamicViewC.navigationItem.title = ASLocalizedString(@"发布短视频");
    _videoDynamicViewC.navigationController.navigationBar.tintColor =kAppGrayColor1;
    self.navigationController.navigationItem.title = ASLocalizedString(@"发布短视频");
    //改变颜色  必须跳转后
    _videoDynamicViewC.navigationController.navigationBar.hidden = NO;
    [_videoDynamicViewC.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:kAppGrayColor1}];
    _videoDynamicViewC.isOpenIQKeyboardManager = YES;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//是否已认证
-(void)showAuthView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"您当前还未实名认证，需要认证后才能开始直播")preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:ASLocalizedString(@"立即认证")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UserModel *userModel = [GlobalVariables sharedInstance].userModel;
        SIdentificationVC *identificationVC = [[SIdentificationVC alloc]init];
        identificationVC.user_id = userModel.user_id;
        identificationVC.sexString = userModel.sex;
        identificationVC.nameString = userModel.nick_name;
        [[AppDelegate sharedAppDelegate] pushViewController:identificationVC animated:YES];

    }];
    
    [alertController addAction:actionCacel];
    [alertController addAction:actionConfirm];
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController
{
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    [self showNesBarRedNum];
//    if (index == 2) {//点击直播
//        [self onClickedCenterTabBar];
////        IMALoginParam *loginParam = [IMALoginParam loadFromLocal];
////        if (loginParam.isAgree ==1)
////        {
////            PublishLivestViewController *pvc = [[PublishLivestViewController alloc] init];
////            [[AppDelegate sharedAppDelegate] presentViewController:pvc animated:YES completion:^{
////
////            }];
////        }
////        else
////        {
////            AgreementViewController *agreeVC = [AgreementViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.agreement_link isShowIndicator:YES isShowNavBar:YES];
////            [[AppDelegate sharedAppDelegate] presentViewController:agreeVC animated:YES completion:^{
////
////            }];
////        }
//        return NO;
//    }
    
#if kSupportH5Shopping
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 0)
    {
        [APP_DELEGATE beginEnterMianUI];
        return NO;
    }
    return YES;
#else
    return YES;
#endif
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    [self showNesBarRedNum];
//    switch (item.tag) {
//        case 1:
//            NSLog(@"tab bar: 1");
//            break;
//
//        case 2:
//            NSLog(@"tab bar: 2");
//            break;
//    }
}

-(BogoYounthModePopView *)youthView{
    if (!_youthView) {
        _youthView = [[BogoYounthModePopView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(254 + 62 / 2))];
        WeakSelf
        _youthView.clickInYounthBlock = ^(BOOL isComeIn) {
            
//            BogoYouthModeViewController *vc = [BogoYouthModeViewController new];
//            
//            [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
////            [weakSelf.navigationController pushViewController:vc animated:YES];
//            [weakSelf.youthView hide];
        };
    }
    return _youthView;
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

- (void)clickLiveBtn
{
    [self startLive];
}

@end
