//
//  LoginViewController.m
//  BuguLive
//
//  Created by fanwe2014 on 16/7/5.
//  Copyright © 2016年 xfg. All rights reserved.


#import "LoginViewController.h"
//#import "LPhoneLoginVC.h"
#import "JSONKit.h"
//#import "WeiboSDK.h"
//#import <TencentOpenAPI/TencentOAuth.h>
#import "PhoneLoginViewController.h"
#import "MGRegisterViewController.h"//注册界面

#import "MGLoginView.h"
#import "LPhoneRegistVC.h"
#import "BGLoginView.h"
#import "LoginRecommendVC.h"
//#import "OpenInstallSDK.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UMLink/UMLink.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


#import "AppleIDManager.h"

@interface LoginViewController ()<NLgDelegate,MobClickLinkDelegate>

//@property (strong, nonatomic) UIButton         *visitorsLoginBtn;              //游客登入的btn
@property (strong, nonatomic) NSMutableArray   *Marray;                        //登入方式的数组
//@property (strong, nonatomic) UIImageView      *selectedImageView;             //协议是否选择的图标
//@property (assign, nonatomic) BOOL             isSelectProtocol;               //是否选择了协议
@property (weak, nonatomic) IBOutlet UIButton *vistorLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

//@property(nonatomic, strong) MGLoginView *loginView;
@property(nonatomic, strong) BGLoginView *loginView;

@end

@implementation LoginViewController{
    NSTimer                         *_timer;                //定时器
    int                             _timeCount;             //定时器时间
}
-(BGLoginView *)loginView{
    if (!_loginView) {
        _loginView = [BGLoginView new];
        _loginView.frame = CGRectMake(0, 0, kScreenW , kScreenH);
       
        FWWeakify(self)
        
        _loginView.clickVistorBlock = ^(BOOL isClickVistoers) {
            FWStrongify(self)
            [self visitorLoginBtnAction:nil];
        };
        _loginView.clickForgetPWBlock = ^(BOOL clickForget) {
            MGRegisterViewController *vc = [[MGRegisterViewController alloc]initWithLoginType:MGLOGIN_TYPE_FINDPASSWORD];
            [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
        };
        
        _loginView.clickReigsterBlock = ^(BOOL clickRegister) {
            MGRegisterViewController *vc = [[MGRegisterViewController alloc]initWithLoginType:MGLOGIN_TYPE_REGISTER];
            [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
        };
        
        _loginView.clickLoginBlock = ^(NSInteger i) {
            FWStrongify(self)
            if (i == 0) {
                [self loginCodeBtn];
            }else if (i == 1){
                [self loginByPhone];
            }else if (i == 2){
                [self wechatLoginBtnAction:nil];
            }else if (i == 3){
                [self agreementBtnAction:nil];
            }
            
            if (i == 1000 + 1) {
                [self loginByQQ];
            }else if (i == 1000 + 2){
                [self loginByWechat];
            }else if (i == 1000 + 4){
                MGRegisterViewController *vc = [[MGRegisterViewController alloc]initWithLoginType:MGLOGIN_TYPE_CODELOGIN];
                [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
            }else if (i == 1000 + 5){//facebook
//                [self getUserInfoForPlatform:UMSocialPlatformType_Facebook];
                [self loginByFacebook];
            }else if (i == 1000 + 6){//google
                [self getUserInfoForPlatform:UMSocialPlatformType_GooglePlus];
            }
        };
    }
    return _loginView;
}

/*
-(MGLoginView *)loginView{
    if (!_loginView) {
        _loginView = [MGLoginView new];
        _loginView.frame = CGRectMake(kRealValue(21), 0, kScreenW - kRealValue(21 * 2), kRealValue(405));
        _loginView.centerY = kScreenH / 2  + kRealValue(15);
        _loginView.layer.masksToBounds = YES;
        _loginView.layer.cornerRadius = 5;
        _loginView.backgroundColor = kWhiteColor;
        FWWeakify(self)
        _loginView.clickLoginBlock = ^(NSInteger i) {
            FWStrongify(self)
            if (i == 0) {
                [self loginCodeBtn];
            }else if (i == 1){
                [self loginByPhone];
            }else if (i == 2){
                [self wechatLoginBtnAction:nil];
            }else if (i == 3){
                [self agreementBtnAction:nil];
            }
        };
    }
    return _loginView;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVisitorsBtn) name:@"getDeviceTokenComplete" object:nil];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [imgView setImage:[UIImage imageNamed:@"mg_ig_bgView"]];
    [self.view addSubview:imgView];
    [self.view addSubview:self.loginView];
    
    _timeCount = 60;

    self.LView.LDelegate = self;

    
    [MobClickLink getInstallParams:^(NSDictionary *params, NSURL *URL, NSError *error) {
        if(params != nil)
        {
            NSDictionary *openinstalDic =
            @{
                @"invite_code":[NSString stringWithFormat:@"%@",params[@"invite_code"]],
                @"channel":[NSString stringWithFormat:@"%@",params[@"channel"]],
            };
            [GlobalVariables sharedInstance].openinstallDic = openinstalDic;
            if (!error) {
                [MobClickLink handleLinkURL:URL delegate:self];
            }
        }
    } enablePasteboard:YES];
//    [[OpenInstallSDK defaultManager] getInstallParmsWithTimeoutInterval:300 completed:^(OpeninstallData * _Nullable appData) {
//        if(appData.data != nil)
//        {
//            NSDictionary *openinstalDic =
//            @{
//                @"invite_code":[NSString stringWithFormat:@"%@",appData.data[@"invite_code"]],
//                @"channel":[NSString stringWithFormat:@"%@",appData.data[@"channel"]],
//            };
//            [GlobalVariables sharedInstance].openinstallDic = openinstalDic;
//        }
//    }];
//    [self loginWay];
}

#pragma mark - MobClickLinkDelegate
- (void)getLinkPath:(NSString *)path params:(NSDictionary *)params{
    [GlobalVariables sharedInstance].openinstallDic = params;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpLocalizationString];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 5.0f;
}


- (void)initFWVariables
{
    [super initFWVariables];
    
    self.view.backgroundColor = kAppMainColor;
//    _isSelectProtocol = YES;
    _Marray = [[NSMutableArray alloc]init];
    _has_qq_login = (int)self.BuguLive.appModel.has_qq_login;
    _has_wx_login = (int)self.BuguLive.appModel.has_wx_login;
    _has_mobile_login = (int)self.BuguLive.appModel.has_mobile_login;
    _has_sina_login = (int)self.BuguLive.appModel.has_sina_login;
    
    _qqBtn.hidden = (int)self.BuguLive.appModel.has_qq_login == 0;
    _wechatBtn.hidden = (int)self.BuguLive.appModel.has_wx_login == 0;
    _phoneBtn.hidden = (int)self.BuguLive.appModel.has_mobile_login == 0;
    _weiboBtn.hidden = (int)self.BuguLive.appModel.has_sina_login == 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxloginback:) name:kWXLoginBack object:nil];
    
    
    
    
    
    
    
    
    
    
    
}

- (void)initFWUI
{
    [super initFWUI];
//    [self creatView];
}

#pragma mark 主UI
- (void)showVisitorsBtn
{
    self.vistorLoginBtn.hidden = YES;
}

#pragma mark 登入方式 0qq 1微信 2微博 3手机
- (void)loginWay
{
    if (self.has_qq_login == 1)//QQ
    {
        [_Marray addObject:@"1"];
    }
    
    if (self.has_wx_login == 1)//微信
    {
        [_Marray addObject:@"2"];
    }
    
    if (self.has_sina_login == 1)//微博
    {
        [_Marray addObject:@"3"];
    }
    
//    if (self.has_mobile_login == 1)//手机
//    {
        [_Marray addObject:@"4"];
//    }
    
    //如果各种登入方式都没有就将手机的登入方式都显示出来
    if (_Marray.count < 1)
    {
        _Marray = [[NSMutableArray alloc]initWithObjects:@"4", nil];
    }
    self.LView = [[ULGView alloc]initWithFrame:CGRectMake(0, kScreenH*0.7, kScreenW, 47) Array:_Marray];
    self.LView.LDelegate = self;
    [self.view addSubview:self.LView];
}

- (IBAction)phoneLoginBtnAction:(id)sender {
    [self loginByPhone];
}

//点击获取h验证码
-(void)loginCodeBtn{
    if (self.loginView.phoneText.text.length < 1)
    {
        [FanweMessage alert:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    self.loginView.codeBtn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timego) userInfo:nil repeats:YES];
    [self timego];

    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"send_mobile_verify_international" forKey:@"act"];
//    [parmDict setObject:@"1" forKey:@"wx_binding"];
    [parmDict setObject:self.loginView.phoneText.text forKey:@"mobile"];
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] != 1)
         {
             self.loginView.codeBtn.enabled = YES;
             [self.loginView.codeBtn setTitle:ASLocalizedString(@"发送验证码") forState:UIControlStateNormal];
             [_timer invalidate];
             _timer = nil;
         }
     } FailureBlock:^(NSError *error) {
         FWStrongify(self)
         [self hideMyHud];
         [self.loginView.codeBtn setTitle:ASLocalizedString(@"发送验证码") forState:UIControlStateNormal];
         [FanweMessage alert:ASLocalizedString(@"发送失败")];
         self.loginView.codeBtn.enabled = YES;
     }];
}

#pragma mark 获取验证码的倒计时
- (void)timego
{
    [self timerDec:_timeCount];
}

- (void)timerDec:(NSInteger)time
{
    if(time > 0)
    {
        [self.loginView.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"重新获取(%lds)"),(long)time] forState:UIControlStateDisabled];
//        [self.loginView.codeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateDisabled];
        _timeCount --;
    }else if(time == 0)
    {
        self.loginView.codeBtn.enabled = YES;
        [self.loginView.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"获取验证码")] forState:UIControlStateNormal];
        [_timer invalidate];
        _timeCount = 60;
    }
}

- (IBAction)wechatLoginBtnAction:(id)sender {
    if (![WXApi isWXAppInstalled])
    {
        [FanweMessage alert:ASLocalizedString(@"微信未安装")];
    }
    else
    {
        [self loginByWechat];
    }
}

- (IBAction)qqLoginBtnAction:(id)sender {
//    if (![TencentOAuth iphoneQQInstalled])
//    {
//        [FanweMessage alert:ASLocalizedString(@"QQ未安装")];
//    }
//    else
//    {
        [self loginByQQ];
//    }
}

- (IBAction)weiboLoginBtnAction:(id)sender {
//    if (![WeiboSDK isWeiboAppInstalled])
//    {
//        [FanweMessage alert:ASLocalizedString(@"新浪微博未安装")];
//    }
//    else
//    {
        [self loginByXinlang];
//    }
}

- (IBAction)agreementBtnAction:(id)sender {
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.privacy_link isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

#pragma mark 获取UserSig等参数
- (void)getLoginParam:(NSMutableDictionary *)param
{
    [self showMyHud];
    
    FWWeakify(self)
    
    [self.httpsManager POSTWithParameters:param SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         
         if ([responseJson toInt:@"status"] == 1)
         {
             if ([responseJson toInt:@"need_bind_mobile"] == 1)//是否需要绑定手机1需要 0为不需要
             {
                 [self hideMyHud];
                 PhoneLoginViewController *loginVC = [[PhoneLoginViewController alloc]initWithNibName:NSStringFromClass([PhoneLoginViewController class]) bundle:[NSBundle mainBundle]];
                 loginVC.loginId = self.loginId;
                 loginVC.loginType = self.loginType;
                 loginVC.accessToken = self.accessToken;
                 loginVC.LNSecBPhone = YES;
                 [[AppDelegate sharedAppDelegate] pushViewController:loginVC animated:YES];
                 
             }else
             {
                 [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"data"];
                 [BGIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
                 
                 self.BuguLive.appModel.first_login = [responseJson toString:@"first_login"];
                 self.BuguLive.appModel.new_level = [responseJson toInt:@"new_level"];
                 self.BuguLive.appModel.login_send_score = [responseJson toString:@"login_send_score"];
                 [GlobalVariables sharedInstance].token = [responseJson toString:@"token"];
                 [[BGIMLoginManager sharedInstance] getUserSig:^{
                     
                     [[AppDelegate sharedAppDelegate] enterMainUI];
                     
                     [self hideMyHud];
                     
                 } failed:^(int errId, NSString *errMsg) {
                     [self hideMyHud];
                     
                 }];
             }
         }
         else
         {
             [self hideMyHud];
         }
         
     } FailureBlock:^(NSError *error)
     {
         [self hideMyHud];
         
        [FanweMessage alertHUD:ASLocalizedString(@"获取登录参数失败，请稍后尝试")];
     }];
}

#pragma mark 微信登录

- (void)loginByWechat
{
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
    /*
     // 构造SendAuthReq结构体
     SendAuthReq* req =[[SendAuthReq alloc ] init ];
     req.scope = @"snsapi_userinfo" ;
     req.state = @"123" ;
     // 第三方向微信终端发送一个SendAuthReq消息结构
     [WXApi sendReq:req];
     */
}

#pragma mark 微信登录获取code后oc调用js把code等传上去
- (void)wxloginback:(NSNotification *)text
{
    /*
     NSString *string = text.object;
     NSDictionary *dict = [string objectFromJSONString];
     NSString *code = [dict toString:@"code"];
     NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
     [parmDict setObject:@"login" forKey:@"ctl"];
     [parmDict setObject:@"wx_login" forKey:@"act"];
     [parmDict setObject:code forKey:@"code"];
     
     [self getLoginParam:parmDict];
     */
}

#pragma mark qq登录
- (void)loginByQQ
{
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
}

#pragma mark 新浪登录
- (void)loginByXinlang
{
    [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
}

#pragma mark 根据对应类型进行登录操作
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    __weak typeof(self) ws = self;
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        if (resp)
        {
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"login" forKey:@"ctl"];
            
            if (platformType == UMSocialPlatformType_QQ)
            {
                [parmDict setObject:@"qq_login" forKey:@"act"];
                [parmDict setObject:resp.openid forKey:@"openid"];
                [parmDict setObject:resp.accessToken forKey:@"access_token"];
                self.loginType = @"qq_login";
                self.loginId = resp.openid;
            }
            else if (platformType == UMSocialPlatformType_WechatSession)
            {
                [parmDict setObject:@"wx_login" forKey:@"act"];
                [parmDict setObject:resp.openid forKey:@"openid"];
                [parmDict setObject:resp.accessToken forKey:@"access_token"];
                self.loginType = @"wx_login";
                self.loginId = resp.openid;
            }
            else if (platformType == UMSocialPlatformType_Sina)
            {
                [parmDict setObject:@"sina_login" forKey:@"act"];
                [parmDict setObject:resp.uid forKey:@"sina_id"];
                [parmDict setObject:resp.accessToken forKey:@"access_token"];
                self.loginType = @"sina_login";
                self.loginId = resp.uid;
            }else if (platformType == UMSocialPlatformType_Facebook){
                [parmDict setObject:@"sina_login" forKey:@"act"];
                [parmDict setObject:resp.uid forKey:@"sina_id"];
                [parmDict setObject:resp.accessToken forKey:@"access_token"];
                self.loginType = @"sina_login";
                self.loginId = resp.uid;
                
                
            }else if (platformType == UMSocialPlatformType_GooglePlus){
                NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
                [parmDict setObject:@"login" forKey:@"ctl"];
                [parmDict setObject:@"google_login" forKey:@"act"];
                [parmDict setObject:resp.uid forKey:@"openid"];
                [parmDict setObject:resp.accessToken forKey:@"access_token"];
                
                self.loginType = @"google_login";
                self.loginId = resp.uid;
                self.accessToken = resp.accessToken;
                
                [ws getLoginParam:parmDict];
                return;

            }
            
            
            self.accessToken = resp.accessToken;
            [ws getLoginParam:parmDict];
        }
    }];
}

#pragma mark 手机登录

- (void)loginByPhone
{
    
    if (self.loginView.phoneText.text.length < 1) {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    
    //6.28号修改为密码登录
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"password_login" forKey:@"act"];
    [parmDict setObject:self.loginView.phoneText.text forKey:@"mobile"];
    [parmDict setObject:self.loginView.codeText.text forKey:@"password"];
    FWWeakify(self)
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             self.BuguLive.appModel.new_level = [responseJson toInt:@"new_level"];
             self.BuguLive.appModel.first_login = [responseJson toString:@"first_login"];
             self.BuguLive.appModel.login_send_score = [responseJson toString:@"login_send_score"];
             
             
             if ([responseJson toInt:@"is_lack"] == 1)
             {
                 LPhoneRegistVC *phoneRegist = [[LPhoneRegistVC alloc]init];
                 phoneRegist.used_id = [responseJson toString:@"user_id"];
                 phoneRegist.userInfoDic = responseJson[@"user_info"];
                 phoneRegist.userName = [responseJson[@"user_info"] toString:@"nick_name"];
//                 [[AppDelegate sharedAppDelegate]pushViewController:phoneRegist];
                 [self.navigationController presentViewController:phoneRegist animated:YES completion:nil];
             }
             else
             {
                 [self showMyHud];
                 
                 NSDictionary *userDic = [responseJson valueForKey:@"user_info"];
                 
                 self.BuguLive.appModel.is_open_young = [userDic objectForKey:@"is_open_young"];
                 
                 
                 [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
                 [BGIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
                 
                 [GlobalVariables sharedInstance].token = [userDic toString:@"token"];
                 
                 [[BGIMLoginManager sharedInstance] getUserSig:^{
                     
                     [[AppDelegate sharedAppDelegate] enterMainUI];
                     [self hideMyHud];
                 } failed:^(int errId, NSString *errMsg) {
                     [self hideMyHud];
                 }];
             }
         }
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
     }];
//    PhoneLoginViewController *phoneVC = [[PhoneLoginViewController alloc]initWithNibName:NSStringFromClass([PhoneLoginViewController class]) bundle:[NSBundle mainBundle]];
//    [[AppDelegate sharedAppDelegate]pushViewController:phoneVC];
}

//游客登录
- (IBAction)visitorLoginBtnAction:(id)sender {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"visitors_login" forKey:@"act"];
    [parmDict setObject:[GlobalVariables sharedInstance].deviceToken forKey:@"um_reg_id"];
    [self showMyHud];
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            [BGIMLoginManager sharedInstance].loginParam.identifier = [[responseJson objectForKey:@"user_info"] toString:@"user_id"];
            [BGIMLoginManager sharedInstance].loginParam.isAgree = [[responseJson objectForKey:@"user"] toInt:@"is_agree"];
            
            self.BuguLive.appModel.first_login = [responseJson toString:@"first_login"];
            self.BuguLive.appModel.new_level = [responseJson toInt:@"new_level"];
            self.BuguLive.appModel.login_send_score = [responseJson toString:@"login_send_score"];
            
            [[BGIMLoginManager sharedInstance] getUserSig:^{
                
                [[AppDelegate sharedAppDelegate] enterMainUI];
                
                [self hideMyHud];
                
            } failed:^(int errId, NSString *errMsg) {
                
                [self hideMyHud];
            }];
        }
        else
        {
            [self hideMyHud];
        }
    } FailureBlock:^(NSError *error) {
        FWStrongify(self)
        [self hideMyHud];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//
//    if (@available(iOS 13, *)) {
//        return UIStatusBarStyleLightContent;
//    }
//    return UIStatusBarStyleLightContent;
//}




- (void)loginByFacebook {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//    [loginManager logOut];
    
    __weak __typeof(self)weakSelf = self;
    [loginManager logInWithPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if(result.isCancelled)
        {
            
        }
        else
        {
            
           [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result2, NSError *error) {
                                NSDictionary *resultDict = (NSDictionary *)result2;
                                NSString *userName = resultDict[@"name"];

                               NSString *headerImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",resultDict[@"id"]];

                               NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
                           [parmDict setObject:@"login" forKey:@"ctl"];

                               [parmDict setObject:@"fb_login" forKey:@"act"];
                               [parmDict setObject:result.token.userID forKey:@"openid"];
                               [parmDict setObject:result.token.tokenString forKey:@"access_token"];

                               [parmDict setObject:userName forKey:@"user_name"];
                               [parmDict setObject:headerImage forKey:@"user_icon"];
                               self.loginType = @"fb_login";
                               self.loginId = result.token.userID;

                               [weakSelf getLoginParam:parmDict];


                            }];
            

        
        }
    }];
//    [loginManager logInWithPermissions:@[] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        
//    }];
    
    
//    [loginManager logInWithReadPermissions:@[@"email"]
//                        fromViewController:self
//                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//      //TODO: process error or result
//     }];
    
}



@end
