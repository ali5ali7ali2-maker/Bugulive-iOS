//
//  AppDelegate.m
//  BuguLive
//
//  Created by xfg on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.


#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "NewFeatureController.h"
#import <UMPush/UMessage.h>

#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
//#import "UMessage.h"
//#import "UMSocialWechatHandler.h"

#import "AppModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CustomMessageModel.h"
#import "BogoJHLogin.h"
#import "GTMBase64.h"
#import "UserModel.h"
#import "dataModel.h"
#import <UserNotifications/UserNotifications.h>
#import "AdJumpViewModel.h"

#import "FLAnimatedImage.h"
#import "BGInterface.h"
#import "SHomePageVC.h"
//#import <Bugly/Bugly.h>

#import <TXLiteAVSDK_Professional/TXLiveBase.h>
#import <TXUGCBase.h>
//#import "OpenInstallSDK.h"
#import "ViewController.h"

#import <XHLaunchAd/XHLaunchAd.h>
#import "MGAdvertViewController.h"
#import "BogoNetworkKit.h"

#import <UMLink/UMLink.h>


//BogoGuideViewController

//#import <TXLiteAVSDK_UGC/TXLiveBase.h>

#import "BogoShopKit.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "BogoPrivacyPopView.h"
#import "BogoGuildKit.h"
#import "SIdentificationVC.h"

//导入UMAPM的OC的头文件
#import <UMAPM/UMLaunch.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMAPM/UMAPMConfig.h>

//#import <DoraemonKit/DoraemonManager.h>

@import FirebaseCore;
@import GoogleSignIn;

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

#define SavePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"user.archive"]

#define kAdImgViewLoadFromNetTimes  1     // 启动广告图从网络下载的最大时间，如果超过该时间则该次启动不显示

static SystemSoundID shake_sound_male_id = 0;

@import FirebaseCore;
@import FirebaseFirestore;
@import FirebaseAuth;

@interface AppDelegate ()<NewFeatureControllerDelegate,NewFeatureControllerDatasourse,WXApiDelegate,QMapLocationViewDelegate,XHLaunchAdDelegate,MobClickLinkDelegate,UITextFieldDelegate,BogoPrivacyPopViewDelegate,BMKGeneralDelegate>
{
    NetHttpsManager         *_httpsManager;
    MBProgressHUD           *_HUD;
    
    QMapLocationView        *_mapLocationView;          // 腾讯地图
    IMALoginParam           *_loginParam;               // 判断是否登录
    
    FLAnimatedImageView     *_advImgView;
    HMHotBannerModel        *_adModel;
    BOOL                    _isAdTouched;               // 广告图是否能够点击
    
    NSString                *_pboardString;             // 粘贴板的字符串
    
    NSDictionary            *_pushInfoDict;
    
    BOOL                    _isEnterForeground;         // YES:在前台，NO:在后台或程序还没有启动
    BOOL                    _isFirstLoad;               // YES:第一次启动
    BOOL                    _isFirstLoadInit;           // 是否第一次加载初始化接口
    
    BOOL                    _isShowAdImgViewIng;        // 是否正在显示启动广告图
    NSInteger               _currentMainUrlIndex;       // 当前域名对应备用域名数组的所在下标
    
    NSInteger               _netChangedTimes;           // 网络变化次数
    NSTimeInterval          _willResignActiveDate;      // 将要进入后台的时间（秒）
}

@property (nonatomic, strong) GlobalVariables       *BuguLive;
@property (nonatomic, assign) BOOL                  isShowAdImgView;    // 是否需要显示启动广告图
@property (nonatomic, copy) NSString                *homePageUserId;    // 私密直播关闭之后用户的userID，目的进入主页看回看
@property (nonatomic, strong) UserModel             *pushUserModel;

@property(nonatomic, strong) LivingModel *model;
@property(nonatomic, strong) NSArray *modelArr;
@property(nonatomic, copy) NSString *password;

@property(nonatomic, strong) NSDictionary *launchOptions;
@property(nonatomic, strong) BogoPrivacyPopView *privacyPopView;
@property(nonatomic, strong) NSDictionary *responseJson;

@end


@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[DoraemonManager shareInstance] installWithPid:@"productId"];//productId为在“平台端操作指南”中申请的产品id

    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
//    [dic setValue:@"com.buguliveS.com" forKey:@"CFBundleIdentifier"];
    
    [FIRApp configure];

    
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *))
    {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
#endif
        
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0)
    {
        NSLog(@"NSFoundationVersionNumber==%d",(int)NSFoundationVersionNumber);
    }
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = kWhiteColor;

        [[UINavigationBar appearance] setStandardAppearance:appearance];
        [[UINavigationBar appearance] setScrollEdgeAppearance:appearance];
    } else {
        // Fallback on earlier versions
        [[UINavigationBar appearance] setBarTintColor:kWhiteColor];
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:KAppLanguage]) {

        //如果设置过语言
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KAppLanguage]) {
            NSString * preferredLang = [[NSUserDefaults standardUserDefaults] objectForKey:KAppLanguage];
            if([preferredLang isEqualToString:@"ar"])
            {
                [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
                [UISearchBar appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
                [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            }
            [[LocalizationSystem sharedLocalSystem] setLanguage:preferredLang];
            
//            [[NSUserDefaults standardUserDefaults] setObject:preferredLang[0] forKey:KAppLanguage];
//
//            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:preferredLang[0],nil] forKey:@"AppleLanguages"];
//
//            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:KAppLanguage];
            
        }else{//如果没有设置语言就跟随本地
            //默认英文
            [[LocalizationSystem sharedLocalSystem] setLanguage:@"en"];

            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en",nil] forKey:@"AppleLanguages"];
            [[LocalizationSystem sharedLocalSystem] setLanguage:@"en"];

            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:KAppLanguage];

//
//            NSString * preferredLang = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
//            [[NSUserDefaults standardUserDefaults] setObject:preferredLang forKey:KAppLanguage];
        }
        
//    }else{
////        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:KAppLanguage];
//    }
    
//    BuglyConfig * config = [[BuglyConfig alloc] init];
//    // 设置自定义日志上报的级别，默认不上报自定义日志
//    config.reportLogLevel = BuglyLogLevelWarn;
//
//    [Bugly startWithAppId:@"6bb6f8a46b" config:config];
    
//    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
//    [Bugly startWithAppId:@"6bb6f8a46b"];
//     @"ec1d5f8ab0"];
//     @"a9b93e8c34"];

//    // iOS 10之前
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//    [application registerUserNotificationSettings:settings];
//    
//    // iOS 10
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error)
//    {
//        if (!error)
//        {
//            NSLog(@"request authorization succeeded!");
//        }
//    }];
//    
//    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//        NSLog(@"%@",settings);
//    }];
    
    _sus_window = [[SuspenionWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [_sus_window makeKeyWindow];
    _sus_window.hidden = YES;
    
    //iOS11以后iPhone X相册偏移适配
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }

    
//    [TXUGCBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/9d11149e7ab9409d37960b76d72513d3/TXUgcSDK.licence" key:@"c42c151886efa4877920bcf60d364ad0"];
    
    // 用来延时遮盖，等异步请求初始化接口成功后替换掉
    UIViewController *tmpController = [[UIViewController alloc]init];
    UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
    tmpImgView.clipsToBounds = YES;
    [tmpImgView setImage:[UIImage imageNamed:@"wel"]];
    [tmpController.view addSubview:tmpImgView];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tmpController;
    [self.window makeKeyAndVisible];
    
    _isFirstLoad = YES;
    _isShowAdImgView = YES;
    
    self.BuguLive = [GlobalVariables sharedInstance];
    _httpsManager = [NetHttpsManager manager];
    _pushInfoDict = [NSDictionary dictionary];
    
    // 异步加载初始化接口
    _isFirstLoadInit = YES;
    self.launchOptions = launchOptions;
    [self asyncInit];
    
    // 网络监听
    [self performSelector:@selector(startMonitor) withObject:nil afterDelay:3];
    
//    // 配置第三方sdk
//    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
//    [self configureOhter:launchOptions];
    
//    [TXUGCBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/9d11149e7ab9409d37960b76d72513d3/TXUgcSDK.licence" key:@"c42c151886efa4877920bcf60d364ad0"];
    
  
    if (@available(iOS 11, *)) {

        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
//    [OpenInstallSDK initWithDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveOSSNoti) name:kFDOSSManagerSendNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLive:) name:GoToLiveFromShopKit object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToUserPage:) name:GoToUserPageFromShopKit object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToUserMsgVC:) name:GoToUserMsgVCShopKit object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterLoginUI) name:@"enterLoginUI" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToUserPage:) name:kNotificationGuildToUserPageKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToAuth) name:kNotificationGuildToAuthKey object:nil];
    
    //facebook登录
    [[FBSDKApplicationDelegate sharedInstance] application:application
                               didFinishLaunchingWithOptions:launchOptions];
    [[FBSDKSettings sharedSettings] setAppID:@"533941785070370"];
//    [FBSDKSettings setAppID:@"1689775438036292"];

    //解决第一次点击textfield卡顿问题
    [self textfieldResponderRemove];
    return YES;
}

- (void)goToAuth{
    SIdentificationVC *identificationVC = [[SIdentificationVC alloc]init];
    identificationVC.user_id = [GlobalVariables sharedInstance].userModel.user_id;
    identificationVC.sexString = [GlobalVariables sharedInstance].userModel.sex;
    identificationVC.nameString = [GlobalVariables sharedInstance].userModel.nick_name;
    [[AppDelegate sharedAppDelegate] pushViewController:identificationVC animated:YES];
}

- (void)doAfterAgreePrivacy{
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];

    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [XHLaunchAd setWaitDataDuration:3];
    if (self.responseJson)
    {
        [self setLaunchAboutViewWithDic:self.responseJson];
        
        [self setFirstLoad:self.responseJson];
    }
    
    BogoNetworkInitModel *indexModel = [BogoNetworkInitModel mj_objectWithKeyValues:self.responseJson];
    [[BogoNetwork shareInstance] saveIndexModel:indexModel];
    
    [self.BuguLive storageAppCurrentMainUrl:self.BuguLive.currentDoMianUrlStr];
    
    [self configThird];
}

- (void)configThird{
    // 配置第三方sdk
    [self configureOhter:self.launchOptions];
    
//    [TXUGCBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/9d11149e7ab9409d37960b76d72513d3/TXUgcSDK.licence" key:@"c42c151886efa4877920bcf60d364ad0"];
    
    // 地图定位
    _mapLocationView = [QMapLocationView sharedInstance];
    _mapLocationView.delegate = self;
    [_mapLocationView startLocate];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    if (@available(iOS 11, *)) {

        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
//    [OpenInstallSDK initWithDelegate:self];
    [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:self.launchOptions];
    
//    BuglyConfig * config = [[BuglyConfig alloc] init];
//    // 设置自定义日志上报的级别，默认不上报自定义日志
//    config.reportLogLevel = BuglyLogLevelWarn;
//
//    [Bugly startWithAppId:@"6bb6f8a46b" config:config];
    
//    [Bugly startWithAppId:@"6bb6f8a46b"];
//     @"ec1d5f8ab0"];
//     @"a9b93e8c34"];

    // iOS 10之前
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    // iOS 10
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"request authorization succeeded!");
        }
    }];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
}

- (void)goToLive:(NSNotification *)noti{
    NSDictionary *dict = (NSDictionary *)noti.object;
    LivingModel *model = [LivingModel mj_objectWithKeyValues:dict];
    model.room_id = model.id.intValue;
    [self pushToLiveController:model modelArr:@[model] isFirstJump:YES];
}

- (void)goToUserPage:(NSNotification *)noti{
    SHomePageVC *pageVC = [[SHomePageVC alloc]init];
    pageVC.user_id = (NSString *)noti.object;
    [[AppDelegate sharedAppDelegate] pushViewController:pageVC animated:YES];
}

-(void)goToUserMsgVC:(NSNotification *)noti{
//    NSString *userID = (NSString *)noti.object;
//    @property(nonatomic, strong) BogoCommodityDetailModel *model;
    BogoCommodityDetailModel *model = (BogoCommodityDetailModel *)noti.object;
    SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:[model.uid intValue]];
    chattag.mNick_name = model.shop.nick_name;
    chattag.mHead_image = StrValid(model.shop.logo) ? model.shop.logo : model.icon;
    BGConversationServiceController* chatvc = [BGConversationServiceController makeChatVCWith:chattag];
    [[AppDelegate sharedAppDelegate] pushViewController:chatvc animated:YES];
}

#pragma mark - BogoShopKit进入直播间
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
        // Do not log password hashes or raw passwords.
        
        if ([md5Str isEqualToString:self.model.password]) {
            [self pushToLiveController:_model modelArr:_modelArr isFirstJump:NO];
        }else{
            [FanweMessage alertHUD:ASLocalizedString(@"密码不正确")];
        }
    }];
    [alertController addAction:actionConfirm];
    UIViewController *top = [self topViewController];
    [top presentViewController:alertController animated:YES completion:nil];
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

- (void)recieveOSSNoti{
    NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"app" forKey:@"ctl"];
    [mDict setObject:@"aliyun_sts" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFDOSSManagerRecieveNoti object:responseJson];
    } FailureBlock:^(NSError *error){
        
    }];
}
    
-(void)textfieldResponderRemove{
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
}

    

#pragma mark 配置第三方sdk
- (void)configureOhter:(NSDictionary *)launchOptions
{
    [TIMManager sharedInstance];
    
    // 设置ILiveSDK日志级别
    //    [[TIMManager sharedInstance] initLogSettings:YES logPath:[[TIMManager sharedInstance] getLogPath]];
    //    [[TIMManager sharedInstance] setLogLevel:TIM_LOG_NONE];
    
    /* 设置友盟appkey */
#if DEBUG
    [UMConfigure setLogEnabled:YES];
#else
#endif

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = infoDict[@"CFBundleShortVersionString"];
    NSString *build = infoDict[@"CFBundleVersion"];
    [UMCrashConfigure setAppVersion:version buildVersion:build];
        [UMConfigure initWithAppkey:UmengKey channel:@"App Store"]; // 新版
    //    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengKey];//旧版

    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:WeixinAppId
                                       appSecret:WeixinSecret
                                     redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:QQAppId
                                       appSecret:QQSecret
                                     redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:SinaAppId
                                       appSecret:SinaSecret
                                     redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    [[FBSDKApplicationDelegate sharedInstance] initializeSDK];

    [[FBSDKSettings sharedSettings] setAppID:@"533941785070370"];

//    [FBSDKSettings setAppID:@"1689775438036292"];


    // 腾讯地图
    [QMapServices sharedServices].apiKey = QQMapKey;
    [[QMapServices sharedServices] setApiKey:QQMapKey];
    [[QMSSearchServices sharedServices] setApiKey:QQMapKey];
    

    [[UIApplication sharedApplication]registerForRemoteNotifications];
//    // 友盟推送
//    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
//    [UMessage registerForRemoteNotifications];

//    // for log

//    [UMessage setLogEnabled:NO];
    
    //BMK
    
    
    //直播SDK
    
//    if ([BGUtils isBlankString:[GlobalVariables sharedInstance].appModel.tencent_live_sdk_licence]) {
//        [TXLiveBase setLicenceURL:TXRTMPLicence key:TXRTMPKey];
//    }else{
    
//    }
    
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
        NSLog(@"wxlog:%@",log);
//        [BGHUDHelper alert:log];
    }];
    [WXApi registerApp:WeixinAppId universalLink:@"https://aaa.com/guoxiuvideo/"];
    // 键盘事件
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
//    // jubao pay
//    if (WeixinAppId.length>0)
//    {
//        [BGInterface init:JBFAppId useAPI:YES withWXAppId:WeixinAppId];
//    }
//    else
//    {
//        [BGInterface init:JBFAppId useAPI:YES withWXAppId:nil];
//    }
}



#pragma mark ------ BMK
- (void)showBMK
{
    BMKMapManager *manager = [[BMKMapManager alloc]init];
    BOOL result = [manager start:BaiduMapKey generalDelegate:self];
//    [manager start:BaiduMapKey generalDelegate:nil];
    if (result)
    {
        
    }
    else
    {
        
    }
}

#pragma mark - ----------------------- 进入相关页面 -----------------------
- (void)beginEnterMianUI
{
    if (![NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class] fromFile:SavePath error:nil] && [IsNeedFirstIntroduce isEqualToString:@"YES"])
    {
        [self setNewFeatureVisiable];
    }
    else
    {
        if (kSupportH5Shopping == 1)
        {
            [self loadH5MianView];
        }
        else
        {
            BOOL isAutoLogin = [IMAPlatform isAutoLogin];
            if (isAutoLogin)
            {
                _isTabBarShouldLoginIMSDK = YES;
                [self enterMainUI];
            }
            else
            {
                _isTabBarShouldLoginIMSDK = NO;
                [self enterLoginUI];
            }
        }
    }
}

#pragma mark 进入登录页面
- (void)enterLoginUI
//ShowVC:(BOOL)showVC
{
    [BGIMLoginManager sharedInstance].isIMSDKOK = NO;

    if (!kSupportH5Shopping)
    {
        if ([self.window.rootViewController isKindOfClass:[BGTabBarController class]])
        {
            BGTabBarController *tmpNav = (BGTabBarController *)self.window.rootViewController;
            for (UIViewController *vc in tmpNav.childViewControllers)
            {
                if ([vc isKindOfClass:[BogoJHLogin class]])
                {
                    return;
                }
            }
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:kIMAPlatform_AutoLogin_Key];
        [userDefaults removeObjectForKey:kIMALoginParamUserKey];
        [userDefaults removeObjectForKey:kMyCookies];
        [userDefaults synchronize];
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
        for (id obj in cookieArray)
        {
            [cookieJar deleteCookie:obj];
        }
        
        
//        if (showVC) {
            BogoJHLogin *login = [[BogoJHLogin alloc]initWithNibName:NSStringFromClass([BogoJHLogin class]) bundle:[NSBundle mainBundle]];
            BGNavigationController *nav = [[BGNavigationController alloc]initWithRootViewController:login];
            self.window.rootViewController = nav;
//        }
    }
}

#pragma mark 加载h5主页
- (void)loadH5MianView
{
    if (!_webViewNav)
    {
        NSString *tmpUrl;
        if ([self.BuguLive.appModel.site_url length]>7)
        {
            tmpUrl = self.BuguLive.appModel.site_url;
        }
        else
        {
            tmpUrl = H5MainUrlStr;
        }
        
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrl isShowIndicator:YES];
        tmpController.isShowLaunchImgView = YES;
        _webViewNav = [[BGNavigationController alloc] initWithRootViewController:tmpController];
        
        self.window.rootViewController = _webViewNav;
    }
    else
    {
        self.window.rootViewController = _webViewNav;
    }
}

#pragma mark 加载原生主页
- (void)enterMainUI
{
    if (_isTabBarShouldLoginIMSDK)
    {
        _isTabBarShouldLoginIMSDK = NO;
        [[BGIMLoginManager sharedInstance] loginImSDK:NO succ:nil failed:nil];
    }
    [BGTabBarController sharedInstance].selectedIndex = 0;
    self.window.rootViewController = [BGTabBarController sharedInstance];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"haveLanch"];
    // 换号登录发出这个通知，才会再一次调动每日首次登陆奖励,否则登录提示不会显示
    [[NSNotificationCenter defaultCenter]postNotificationName:@"rewardView" object:nil];
}

#pragma mark进入tabBar
- (void)entertabBar
{
    UITabBarController *tabBars = [BGTabBarController sharedInstance];
#if  kSupportH5Shopping
    tabBars.selectedIndex = 1;
#endif
    self.window.rootViewController = tabBars;
}

- (void)validateCurrentUrl
{
    if (self.BuguLive.doMainUrlArray)
    {
        for (NSString *tmpUrl in self.BuguLive.doMainUrlArray)
        {
            [BGUtils validateUrl:[NSURL URLWithString:tmpUrl]validateResult:^(NSURL *currentUrl, BOOL isSucc) {
                
            }];
        }
    }
}

#pragma mark - ----------------------- 初始化接口 -----------------------
#pragma mark 异步加载初始化接口
- (void)asyncInit
{
    BOOL isAgreePrivacy = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAgreePrivacy"];
    if (isAgreePrivacy) {
        //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
        [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];

        //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
        //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
        //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
        //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
        [XHLaunchAd setWaitDataDuration:3];
        [self configThird];
    }
    
    
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"init" forKey:@"act"];
    
    NSString *postUrl;
    
#if kSupportH5Shopping
    postUrl = H5InitUrlStr;
#else
    postUrl = self.BuguLive.currentDoMianUrlStr;
#endif
//    isAgreePrivacy = NO;
    __weak AppDelegate *ws = self;
    [_httpsManager POSTWithUrl:postUrl paramDict:parmDict SuccessBlock:^(NSDictionary *responseJson){
        if (isAgreePrivacy) {
            if (responseJson)
            {
                [self setLaunchAboutViewWithDic:responseJson];
                
                [ws setFirstLoad:responseJson];
            }
            else
            {
                [ws loadInitError];
            }
            
            BogoNetworkInitModel *indexModel = [BogoNetworkInitModel mj_objectWithKeyValues:responseJson];
            [[BogoNetwork shareInstance] saveIndexModel:indexModel];
            
            [ws.BuguLive storageAppCurrentMainUrl:ws.BuguLive.currentDoMianUrlStr];
        }else{
            self.responseJson = responseJson;
            if (![self.window.rootViewController.view.subviews containsObject:self.privacyPopView]) {
                self.privacyPopView.url = [NSString stringWithFormat:@"%@",responseJson[@"compliance_policy"]];
                [self.privacyPopView show:self.window.rootViewController.view];
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
        NSLog(ASLocalizedString(@"=====初始化接口失败，错误码：%ld"),error.code);
        
        // 如果非网络原因导致的错误，尝试切换域名
        if (error.code != NSURLErrorNetworkConnectionLost && error.code != NSURLErrorNotConnectedToInternet)
        {
            if (_currentMainUrlIndex < [ws.BuguLive.doMainUrlArray count])
            {
                NSString *tmpMainUrl = [ws.BuguLive.doMainUrlArray objectAtIndex:_currentMainUrlIndex];
                tmpMainUrl = [tmpMainUrl stringByAppendingString:AppDoMainUrlSuffix];
                ws.BuguLive.currentDoMianUrlStr = tmpMainUrl;
            }
            
            if (_currentMainUrlIndex >= [ws.BuguLive.doMainUrlArray count]-1)
            {
                _currentMainUrlIndex = 0;
            }
            else
            {
                _currentMainUrlIndex ++;
            }
        }
        
        [ws loadInitError];
        
    }];
}

//设置启动轮播图UI
-(void)setLaunchAboutViewWithDic:(NSDictionary *)response{
    
    NSArray *adArr = [response valueForKey:@"start_diagram"];
    NSMutableArray *diagramArr = [NSMutableArray array];
    NSMutableArray *urlArray = [NSMutableArray array];
    
    for (int i = 0; i < adArr.count; i ++) {
        NSDictionary *dic = [adArr objectAtIndex:i];
        [diagramArr addObject:[dic valueForKey:@"image"]];
        [urlArray addObject:[dic valueForKey:@"url"]];
    }
    
    [GlobalVariables sharedInstance].guardImgArr = adArr;
    
    
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    imageAdconfiguration.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeTime;
    
    

    
    if(diagramArr.count == 0)
    {
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = @"wel";
    }
    else
    {
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = diagramArr.firstObject;
    }
//            @"LaunchImage.jpg";
//            @"app"
//            response[@"data"][@"img"];
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    imageAdconfiguration.openModel = urlArray.firstObject;
//    response[@"data"][@"plug_ad_url"];
    imageAdconfiguration.duration = 3;
//    imageAdconfiguration.showFinishAnimateTime = 0.8;
//    [response[@"data"][@"start_figure"] integerValue];

    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}


//点击了广告页面
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    NSString *url = (NSString *)openModel;

//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = kWhiteColor;
//    BGTabBarController *mainViewController = [[BGTabBarController alloc] init];
//    //    CAAnimation *transition = [self animationFrom:self.window.rootViewController to:mainViewController];
////    BGNavigationController *nav = [[BGNavigationController alloc]initWithRootViewController:mainViewController];
//    
//    BGTabBarController *tabBarController = [[BGTabBarController alloc] init];
//    self.window.rootViewController = tabBarController;
    
//    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    if (!url.length) {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(ASLocalizedString(@"链接为空"), nil)];
        return;
    }
    [self performSelector:@selector(pushWebVC:) withObject:url afterDelay:3];
//    self.mainViewController = mainViewController;
}

- (void)pushWebVC:(id)object{
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:object isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
    //    tmpController.navTitleStr = @"";
    [[AppDelegate sharedAppDelegate] presentViewController:tmpController animated:YES completion:nil];
}

#pragma mark 首次加载的时候相关的业务逻辑
- (void)setFirstLoad:(NSDictionary *)responseDict
{
    
    [self setInitData:responseDict];
    
    [self setAppConfig];
    
    if (_isFirstLoadInit)
    {
        _isFirstLoadInit = NO;
        
        [self initAdvView:responseDict];
        
        // 如果有启动广告图，则暂不加载主页
        NSArray *addArray = [responseDict objectForKey:@"start_diagram"];
        if (addArray  && addArray.count >0 && [addArray isKindOfClass:[NSArray class]])
        {
            if (addArray.count)
            {
                if (![BGUtils isBlankString:_adModel.image])
                {
                    MGAdvertViewController *mainViewController = [[MGAdvertViewController alloc] init];
                    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                    BGNavigationController *nav = [[BGNavigationController alloc]initWithRootViewController:mainViewController];
                    self.window.rootViewController = nav;
                    [self.window makeKeyAndVisible];
                    
//                    [self beginEnterMianUI];
                    return;
                }
            }
        }else{
            [self beginEnterMianUI];
        }
    }
}

- (void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd{
    
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    
    if (isAutoLogin) {
        [BGTabBarController sharedInstance].selectedIndex = 0;
        self.window.rootViewController = [BGTabBarController sharedInstance];

        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"haveLanch"];
    }else{
        MGAdvertViewController *mainViewController = [[MGAdvertViewController alloc] init];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        BGNavigationController *nav = [[BGNavigationController alloc]initWithRootViewController:mainViewController];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
}

#pragma mark 初始化接口接在失败的情况
- (void)loadInitError
{
    [self setAppConfig];
    [self setAppLoginType];
    if (_isFirstLoadInit)
    {
        _isFirstLoadInit = NO;
        
        [self beginEnterMianUI];
    }
    
    [self performSelector:@selector(asyncInit) withObject:nil afterDelay:5];
}

#pragma mark 接收初始化接口的参数
- (void)setInitData:(NSDictionary *)responseDict
{
    self.BuguLive.appModel = [AppModel mj_objectWithKeyValues:responseDict];
    self.BuguLive.appModel.isInitSucceed = YES;
    
    if (![BGUtils isBlankString:[GlobalVariables sharedInstance].appModel.tencent_live_sdk_key]) {
        [TXLiveBase setLicenceURL:[GlobalVariables sharedInstance].appModel.tencent_live_sdk_licence key:[GlobalVariables sharedInstance].appModel.tencent_live_sdk_key];
    }
    
    if (![BGUtils isBlankString:[GlobalVariables sharedInstance].appModel.tencent_video_sdk_key]) {
        [TXUGCBase setLicenceURL:[GlobalVariables sharedInstance].appModel.tencent_video_sdk_licence key:[GlobalVariables sharedInstance].appModel.tencent_video_sdk_key];
    }
    
//    [TXUGCBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/c81c650cf0669fef99ef446feafe3107/TXUgcSDK.licence" key:@"90ce296d9754df2ddfdc7169eed312d9"];
        
    NSArray *domainArray = [responseDict objectForKey:@"domain_list"];
    if (domainArray && [domainArray isKindOfClass:[NSArray class]])
    {
        [self.BuguLive storageAppMainUrls:domainArray];
    }
    
    if (self.BuguLive.listMsgMArray)
    {
        [self.BuguLive.listMsgMArray removeAllObjects];
    }
    NSArray *listmsg = [responseDict objectForKey:@"listmsg"];
    if (listmsg && [listmsg isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *tmpDic in listmsg)
        {
            CustomMessageModel *customMessageModel = [CustomMessageModel mj_objectWithKeyValues:tmpDic];
            [customMessageModel prepareForRender];
            [self.BuguLive.listMsgMArray addObject:customMessageModel];
        }
    }
    
    if (self.BuguLive.appModel.version.has_upgrade == 1)
    {
        self.BuguLive.ios_down_url = self.BuguLive.appModel.version.ios_down_url;
        
        //强制升级:forced_upgrade ; 0:非强制升级，可取消; 1:强制升级
        if (self.BuguLive.appModel.version.forced_upgrade == 1)
        {
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.BuguLive.ios_down_url] options:@{} completionHandler:nil];
        }
        else
        {
            FWWeakify(self)
            [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"发现新版本，需要升级吗？")destructiveAction:^{
                
                FWStrongify(self)
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.BuguLive.ios_down_url] options:@{} completionHandler:nil];
                
            } cancelAction:^{
                
            }];
        }
    }
}

#pragma mark 配置app内的相关称呼
- (void)setAppConfig
{
    if (!self.BuguLive.appModel.short_name || [self.BuguLive.appModel.short_name isEqualToString:@""])
    {
        self.BuguLive.appModel.short_name = ShortNameStr;
    }
    if (!self.BuguLive.appModel.ticket_name || [self.BuguLive.appModel.ticket_name isEqualToString:@""])
    {
        self.BuguLive.appModel.ticket_name = TicketNameStr;
    }
    if (!self.BuguLive.appModel.account_name || [self.BuguLive.appModel.account_name isEqualToString:@""])
    {
        self.BuguLive.appModel.account_name = AccountNameStr;
    }
    if (!self.BuguLive.appModel.diamond_name || [self.BuguLive.appModel.diamond_name isEqualToString:@""])
    {
        self.BuguLive.appModel.diamond_name = DiamondNameStr;
    }
}

#pragma mark 如果异步初始化接口失败，则显示所有的登录方式
- (void)setAppLoginType
{
    if (![BGUtils isBlankString:WeixinAppId])
    {
        self.BuguLive.appModel.has_wx_login = 1;
    }
    if (![BGUtils isBlankString:QQAppId])
    {
        self.BuguLive.appModel.has_qq_login = 1;
    }
    if (![BGUtils isBlankString:SinaAppId])
    {
        self.BuguLive.appModel.has_sina_login = 1;
    }
    
    self.BuguLive.appModel.has_mobile_login = 1;
}


#pragma mark - ----------------------- 启动广告图 -----------------------
#pragma mark 初始化广告图
- (void)initAdvView:(NSDictionary *)responseDict
{
    if (![NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class] fromFile:SavePath error:nil] && [IsNeedFirstIntroduce isEqualToString:@"YES"])
    {
        return;
    }
    
    // 启动广告图
    NSArray *addArray = [responseDict objectForKey:@"start_diagram"];
    if (addArray && [addArray isKindOfClass:[NSArray class]])
    {
        if (addArray.count)
        {
            _adModel = [HMHotBannerModel mj_objectWithKeyValues:[addArray firstObject]];
            
            _advImgView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            _advImgView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToAdView)];
            [_advImgView addGestureRecognizer:singleRecognizer];
            
            [self performSelector:@selector(changeShowAdImgView) withObject:nil afterDelay:kAdImgViewLoadFromNetTimes];
            
            if ([BGUtils isBlankString:_adModel.image])
            {
                return;
            }
            
            FWWeakify(self)
            [_advImgView sd_setImageWithURL:[NSURL URLWithString:_adModel.image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                FWStrongify(self)
                
                if (self.isShowAdImgView)
                {
                    [self beginEnterMianUI];
                    [self.window addSubview:_advImgView];
                    [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:3];
                    self.isShowAdImgView = NO;
                }
                
            }];
        }
    }
}

- (void)changeShowAdImgView
{
    if (self.isShowAdImgView)
    {
//        [self beginEnterMianUI];
    }
    _isShowAdImgView = NO;
}

#pragma mark 退出广告图
- (void)removeAdvImage
{
    [UIView animateWithDuration:0.3f animations:^{
        _advImgView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _advImgView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_advImgView removeFromSuperview];
    }];
}

#pragma mark 启动广告图的点击跳转
- (void)jumpToAdView
{
    if (_adModel.url && !_isAdTouched)
    {
        if (kSupportH5Shopping)
        {
            [self loadH5MianView];
        }
        else
        {
            if ([AdJumpViewModel adToOthersWith:_adModel])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"adjump" object:[AdJumpViewModel adToOthersWith:_adModel]];
            }
        }
    }
    _isAdTouched = YES;
}


#pragma mark - ----------------------- 首次安装简介 -----------------------
#pragma mark 首次安装显示的多张简介图
- (void)setNewFeatureVisiable
{
    [NSKeyedArchiver archiveRootObject:@"NOFirst_login" toFile:SavePath];
    NewFeatureController *controller = [[NewFeatureController alloc]init];
    controller.delegate=self;
    controller.Datasourse=self;
    __weak AppDelegate *weakSelf = self;
    [controller setStartAppBlock:^{
        
        
        BOOL isAutoLogin = [IMAPlatform isAutoLogin];
        if (isAutoLogin)
        {
            _isTabBarShouldLoginIMSDK = YES;
            [weakSelf enterMainUI];
        }
        else
        {
            _isTabBarShouldLoginIMSDK = NO;
            [weakSelf enterLoginUI];
        }
    }];
    self.window.rootViewController=controller;
}

#pragma mark NewFeatureControllerDatasourse (数据源代理，告诉控制器显示几张图片，和显示什么图片)
- (NSInteger)NewFeatureControllerPhotosNumber
{
    NSString *countStr = FirstIntroduceImgCount;
    return [countStr integerValue];
}

-(UIImageView*)NewFeatureControllerImageViewIndex:(NSUInteger)index
{
    NSString *imageName = [NSString stringWithFormat:@"new_feature_%ld.jpg",(unsigned long)index];
    return [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
}


#pragma mark - ----------------------- 监听网络 -----------------------
- (void)startMonitor
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring]; //开始监听网络状态变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)ReachabilityDidChange:(NSNotification *)not
{
    BOOL netConnected;
    [self.noNetworkView removeFromSuperview];
    self.noNetworkView = nil;
    if (self.noNetworkView) {
        self.noNetworkView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        [self.window addSubview:self.noNetworkView];
    }
    NSDictionary *userInfo = not.userInfo;
    _reachabilityStatus = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    NSLog(@"============:ReachabilityDidChange");
    switch (_reachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            
            
            netConnected = _isFirstLoadInit;
            
            break;
        case AFNetworkReachabilityStatusNotReachable:
            
            netConnected = _isFirstLoadInit;
            
            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"哎呀！网络不大给力！")];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            netConnected = YES;
            NSLog(ASLocalizedString(@"您正在使用手机自带网络进行访问"));
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            netConnected = YES;
            NSLog(ASLocalizedString(@"您正在使用wifi进行访问"));
            break;
        default:
            break;
    }
    
    self.noNetworkView.hidden = netConnected;
    
    if (_netChangedTimes >= 1 && netConnected && !self.BuguLive.appModel.isInitSucceed)
    {
        [self showBMK];
        [self loadInitError];
        [_mapLocationView startLocate];
    }
    
    _netChangedTimes ++;
}


#pragma mark - ----------------------- 应用回调 -----------------------
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    if([MobClickLink handleUniversalLink:userActivity delegate:self])
    {
        return YES;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
//    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url];
     
    if ([MobClickLink handleLinkURL:url delegate:self]) {
        return YES;
    }
    return [self handleAllUrl:application url:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleAllUrl:application url:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([MobClickLink handleLinkURL:url delegate:self]) {
        return YES;
    }
    
    [[GIDSignIn sharedInstance] handleURL:url];

    [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
    
    return [self handleAllUrl:app url:url];
}

- (BOOL)handleAllUrl:(UIApplication*)app url:(NSURL*)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    [GIDSignIn.sharedInstance handleURL:url];
    if ([url.host isEqualToString:@"safepay"])
    {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
        return YES;
    }
    else if([url.absoluteString rangeOfString:WeixinAppId].location != NSNotFound)
    {
        // 微信支付
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return result;
}

#pragma mark - MobClickLinkDelegate
- (void)getLinkPath:(NSString *)path params:(NSDictionary *)params{
    [GlobalVariables sharedInstance].openinstallDic = params;
}

//微信支付回调处理
- (void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:ASLocalizedString(@"发送媒体消息结果")];
    }
    if([resp isKindOfClass:[PayResp class]])
    {
        // 支付返回结果，实际支付结果需要去微信服务器端查询
        if([SResBase shareClient].mg_pay_block)
        {
            // 充值界面的支付回掉处理
            SResBase* retobj = SResBase.new;
            if( resp.errCode == -1 )
            {
                retobj.msuccess = NO;
                retobj.mmsg = ASLocalizedString(@"支付出现异常");
            }
            else if( resp.errCode == -2 )
            {
                retobj.msuccess = NO;
                retobj.mmsg = ASLocalizedString(@"用户取消了支付");
            }
            else
            {
                retobj.msuccess = YES;
                retobj.mmsg = ASLocalizedString(@"支付成功");
            }
            
            [SResBase shareClient].mg_pay_block( retobj );
            return;
        }
        
        strTitle = [NSString stringWithFormat:ASLocalizedString(@"支付结果")];
        
        switch (resp.errCode)
        {
                // retcode 0:支付成功 -1：支付失败 -2：用户取消
            case WXSuccess:
                strMsg = ASLocalizedString(@"支付成功！");
                NSLog(ASLocalizedString(@"支付成功－PaySuccess，retcode = %d"), resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccess" object:nil];
                
                break;
            default:
                if (resp.errCode == -2)
                {
                    strMsg = ASLocalizedString(@"用户取消");
                }
                else if(resp.errCode == -1)
                {
                    strMsg = ASLocalizedString(@"支付失败");
                }
                NSLog(ASLocalizedString(@"支付结果：错误，retcode = %d, retstr = %@"), resp.errCode,resp.errStr);
                break;
        }
        [FanweMessage alert:strMsg];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *myresp = (SendAuthResp *)resp;
        
        NSString *jsonStr = [NSString stringWithFormat:@"{\"login_sdk_type\":\"wxlogin\",\"code\":\"%@\",\"err_code\":\"%d\"}",myresp.code,resp.errCode];
        [[NSNotificationCenter defaultCenter]postNotificationName:kWXLoginBack object:jsonStr];
        
        switch (resp.errCode)
        {
                // retcode: 0：用户同意 -4：用户拒绝授权 -2：用户取消
            case -4:
                strMsg = ASLocalizedString(@"用户拒绝授权！");
                NSLog(ASLocalizedString(@"支付成功－PaySuccess，retcode = %d"), resp.errCode);
                break;
            case -2:
                strMsg = ASLocalizedString(@"用户取消！");
                NSLog(ASLocalizedString(@"支付成功－PaySuccess，retcode = %d"), resp.errCode);
                break;
                
            default:
                
                break;
        }
    }
}

#pragma mark - ----------------------- 推送相关 -----------------------
#pragma mark 推送设置
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    
//    NSLog(@"deviceToken=%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                              stringByReplacingOccurrencesOfString: @">" withString: @""]
//                             stringByReplacingOccurrencesOfString: @" " withString: @""]);
//    self.BuguLive.deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                                  stringByReplacingOccurrencesOfString: @">" withString: @""]
//                                 stringByReplacingOccurrencesOfString: @" " withString: @""];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
            if (![deviceToken isKindOfClass:[NSData class]]) {
                //记录获取token失败的描述
                return;
            }
            const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
            NSString *strToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                  ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                  ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                  ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        self.BuguLive.deviceToken = strToken;
        } else {
            NSString *token = [NSString
                           stringWithFormat:@"%@",deviceToken];
            token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
            token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
            token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.BuguLive.deviceToken = token;
        }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getDeviceTokenComplete" object:nil];
    
    [self performSelector:@selector(configApns) withObject:nil afterDelay:5];
}

#pragma mark 上传设备id（友盟推送）
- (void)configApns
{
    [AppViewModel updateApnsCode];
}

#pragma mark 播放自定义推送声音
- (void)playCustomSound
{
    //声音文件格式转换代码
    //afconvert /System/Library/Sounds/Submarine.aiff ~/Desktop/sub.caf -d ima4 -f caff -v
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mycustomsound2" ofType:@"aiff"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s",__func__);
    NSLog(@"%@",userInfo);
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"%s",__func__);
    NSLog(@"%@",userInfo);
    if([[userInfo allKeys] containsObject:@"com.google.firebase.auth"])
    {
        return;
    }
    if ([userInfo toInt:@"type"] == 0)//检查直播状态
    {
        [self checkVideoStatus:userInfo andTag:0];
    }
    else if ([userInfo toInt:@"type"] == 5)//友盟推送到付款界面
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_user_pai isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = ASLocalizedString(@"我的竞拍");
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
    else if ([userInfo toInt:@"type"] == 4)//会员中心
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:[userInfo toString:@"url"] isShowIndicator:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    }
    else
    {
        if (_isEnterForeground)
        {
            [self playCustomSound];//播放自定义推送声音
        }
    }
}

#pragma mark - ----------------------- 其他 -----------------------
//已经进入前台
-(void)applicationDidBecomeActive:(UIApplication *)application{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

//即将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%s",__func__);
    
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    if ([BGIMLoginManager sharedInstance].isIMSDKOK)
    {
        [AppViewModel userStateChange:@"Login"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHome object:nil userInfo:nil];
        
        [self getInformation];
    }
    
    if (!_isFirstLoad && [IMAPlatform sharedInstance].host.imUserId)
    {
        if ([[IMAPlatform sharedInstance].host.imUserId intValue])
        {
            [[IMAPlatform sharedInstance].host getMyInfo:nil];
        }
    }
    
    NSDate *nowDate = [NSDate date];
    self.BuguLive.foreGroundTime = [nowDate timeIntervalSince1970];
    
#if kSupportH5Shopping
    
    //    if (!_isFirstLoad) {
    //
    //        NSTimeInterval nowInterval = [nowDate timeIntervalSince1970];
    //
    //        if (nowInterval - _willResignActiveDate > self.BuguLive.appModel.reload_time)
    //        {
    //            [self loadH5MianView];
    //        }
    //    }
#endif
    
    _isFirstLoad = NO;
    _isEnterForeground =  YES;
    
    // 必须
    // FW code start
//    [BGInterface applicationWillEnterForeground:application];
    // FW code end
}

#pragma mark 已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%s",__func__);
    
//    [AppViewModel userStateChange:@"Logout"];
    
    NSDate *nowDate = [NSDate date];
    self.BuguLive.backGroundTime = [nowDate timeIntervalSince1970];
    
#if kSupportH5Shopping
    
    if (self.BuguLive.appModel.reload_time>0)
    {
        
        _willResignActiveDate = [nowDate timeIntervalSince1970];
    }
    
#endif
    
    _isEnterForeground = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
//
//    [self pauseVideo];
}

-(void)pauseVideo{
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    
    UIApplication* app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

}



#pragma mark 获取粘贴板的信息
- (void)getInformation
{
    self.BuguLive = [GlobalVariables sharedInstance];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    _pboardString = pboard.string;
    NSString *keyString =[GTMBase64 decodeBase64:@"8J+UkQ=="];
    
    if ([_pboardString rangeOfString:keyString].location != NSNotFound)
    {
        NSArray *firstSplit = [_pboardString componentsSeparatedByString:keyString];
        if (firstSplit.count > 1)
        {
            NSArray *secondSplit = [firstSplit[1] componentsSeparatedByString:keyString];
            if (secondSplit.count > 0)
            {
                self.BuguLive.privateKeyString = (NSString *)secondSplit[0];
            }
        }
        if (self.BuguLive.privateKeyString)
        {
            if ([self.BuguLive.privateKeyString length])
            {
                NSDictionary *dict = [NSDictionary dictionary];
                [self checkVideoStatus:dict andTag:1];
            }
        }
    }
}

#pragma mark 检查直播状态 tag: 0：推送 1：私密直播
// 私密直播的提示:首先如果直播结束跳转到个人中心，否则判断是否在直播间，不在直播间就进入直播间否则做已在直播间的提示
- (void)checkVideoStatus:(NSDictionary *)dict andTag:(NSInteger)tag
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"check_status" forKey:@"act"];
    
    NSString *room_id = [dict toString:@"room_id"];
    
    if (tag == 0 && room_id && ![room_id isEqualToString:@""])
    {
        [mDict setObject:[dict toString:@"room_id"] forKey:@"room_id"];
    }
    if (tag == 1 && self.BuguLive.privateKeyString.length > 0)
    {
        [mDict setObject:self.BuguLive.privateKeyString forKey:@"private_key"];
    }
    
    FWWeakify(self)
    [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"live_in"] == FW_LIVE_STATE_ING) //正在直播
        {
            self.pushUserModel = [UserModel mj_objectWithKeyValues:responseJson];
            
            if (![IMAPlatform isHost:self.pushUserModel.user_id])
            {
                if ([self.BuguLive.liveState.roomId intValue] && tag == 1) // 当前正在直播间
                {
                    // 表示当前用户正在直播间（可能是直播或者看直播）
                    if (self.BuguLive.liveState.isLiveHost == YES) // 主播
                    {
                        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"您当前正在直播")];
                        self.BuguLive.privateKeyString = @"";
                        return ;
                    }
                    else//不是主播
                    {
                        if ([self.BuguLive.liveState.roomId isEqualToString:self.pushUserModel.room_id])//正在直播间
                        {
                            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"您当前正在直播间内")];
                            self.BuguLive.privateKeyString = @"";
                            return;
                        }
                        else
                        {
                            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"您当前正在直播间内")];
                            return;
                        }
                    }
                }
                else // 当前不在直播间内，接收到推送或者私密直播
                {
                    if (tag == 0)
                    { // 推送
                        [self showAlert:responseJson tag:2];
                    }
                    else
                    { // 私密直播
                        [self showAlert:responseJson tag:3];
                    }
                }
            }
        }
        else if ([responseJson toInt:@"live_in"] == FW_LIVE_STATE_OVER)
        {
            [UIPasteboard generalPasteboard].string = @"";
            [self showAlert:responseJson tag:8];
            self.homePageUserId = [responseJson toString:@"user_id"];
            self.BuguLive.privateKeyString = @"";
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)showAlert:(NSDictionary *)responseJson tag:(int)tag
{
    FWWeakify(self)
    [FanweMessage alert:nil message:[responseJson toString:@"content"] destructiveAction:^{
        
        FWStrongify(self)
        if (tag == 2)
        { //用户正在前台时收到推送
            [self enterNowLive];
        }
        else if (tag == 3)
        { //私密直播
            [self enterNowLive];
        }
        else if (tag == 8)
        {
            SHomePageVC *tmpController= [[SHomePageVC alloc]init];
            tmpController.user_id = self.homePageUserId;
            tmpController.type = 0;
            [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
        }
        
    } cancelAction:^{
        
    }];
}

- (void)enterNowLive
{
    UserModel *model = _pushUserModel;
    
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
    item.chatRoomId = model.group_id;
    item.avRoomId = [model.room_id intValue];
    item.title = model.room_id;
    item.vagueImgUrl = model.head_image;
    
    TCShowUser *showUser = [[TCShowUser alloc]init];
    showUser.uid = model.user_id;
    showUser.avatar = model.head_image;
    item.host = showUser;
    
    if (self.BuguLive.liveState.isInPubViewController)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLiveView" object:nil];
    }
    item.liveType = FW_LIVE_TYPE_AUDIENCE;
    //2020-1-7 小直播变大
    [LiveCenterManager sharedInstance].itemModel=item;
    BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
    
    [[LiveCenterManager sharedInstance]showLiveOfAudienceLiveofTCShowLiveListItem:item modelArr:nil isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL isFinished) {
        
    }];
}

//// 切换当前直播间
//- (void)changeNowLive
//{
//    [FanweMessage alertHUD:ASLocalizedString(@"请退出当前直播间后重新尝试！")];
//}

#pragma mark 是否显示hud
- (void)isShowHud:(BOOL)isShow hideTime:(float)hideTime
{
    if (isShow && !_HUD)
    {
        _HUD = [[BGHUDHelper sharedInstance] loading:@""];
        if (hideTime)
        {
            [self performSelector:@selector(hideHud) withObject:nil afterDelay:hideTime];
        }
    }
    else
    {
        [self hideHud];
    }
}

- (void)hideHud
{
    if (_HUD)
    {
        [[BGHUDHelper sharedInstance] stopLoading:_HUD];
        _HUD = nil;
    }
}

-(BogoNoNetworkView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [[NSBundle mainBundle]loadNibNamed:@"BogoNoNetworkView" owner:self options:nil].lastObject;
        _noNetworkView.hidden = YES;
    }
    return _noNetworkView;
}

#pragma mark - BogoPrivacyPopViewDelegate
- (void)privacyPopView:(BogoPrivacyPopView *)privacyPopView didClickAgreeBtn:(UIButton *)sender{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAgreePrivacy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self doAfterAgreePrivacy];
}

- (void)privacyPopView:(BogoPrivacyPopView *)privacyPopView didClickUserAgreement:(UIButton *)sender{
    BGBaseWebViewController *webVC = [BGBaseWebViewController webControlerWithUrlStr:[NSString stringWithFormat:@"%@",self.responseJson[@"user_agreement_link"]] isShowIndicator:NO isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    BGNavigationController *nav = [[BGNavigationController alloc]initWithRootViewController:webVC];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)privacyPopView:(BogoPrivacyPopView *)privacyPopView didClickPrivacyAgreement:(UIButton *)sender{
    BGBaseWebViewController *webVC = [BGBaseWebViewController webControlerWithUrlStr:[NSString stringWithFormat:@"%@",self.responseJson[@"privacy_link"]] isShowIndicator:NO isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    BGNavigationController *nav = [[BGNavigationController alloc]initWithRootViewController:webVC];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (BogoPrivacyPopView *)privacyPopView{
    if (!_privacyPopView) {
        _privacyPopView = [[NSBundle mainBundle] loadNibNamed:@"BogoPrivacyPopView" owner:nil options:nil].lastObject;
        _privacyPopView.delegate = self;
    }
    return _privacyPopView;
}

@end
