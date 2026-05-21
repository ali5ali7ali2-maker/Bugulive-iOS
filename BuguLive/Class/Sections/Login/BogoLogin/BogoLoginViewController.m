//
//  BogoLoginViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoLoginViewController.h"
#import "BogoThirdLoginViewController.h"
#import "XYCountryCodeViewController.h"
#import "AppleIDManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "BGFirebaseSMS.h"

@import FirebaseCore;
@import GoogleSignIn;
@import FirebaseAuth;

@interface BogoLoginViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneT;
@property (weak, nonatomic) IBOutlet UITextField *passwordT;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordT;
@property (weak, nonatomic) IBOutlet QMUIButton *codeBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *areaBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextView *agreeT;

@property(nonatomic, assign) BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIButton *passwordLoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitleL;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswordView;

@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIButton *googleBtn;


//只在更换手机号界面显示 BOGO_LOGIN_TYPE_PHONE_CHANGE
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet QMUIButton *codeAreaBtn;
@property (weak, nonatomic) IBOutlet UITextField *codePhoneT;

@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxConstraint;


@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facebookConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeTWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *thirdLoginL;

@property(nonatomic, strong) FBSDKLoginManager *fbManager;

//fbManager = [[FBSDKLoginManager alloc] init];
@property(nonatomic, assign) int tryCount;
@end

@implementation BogoLoginViewController{
    NSTimer                         *_timer;                //定时器
    int                             _timeCount;             //定时器时间
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBgView:)];
    [self.view addGestureRecognizer:tapView];
    
    self.isSelect = NO;
    
    self.selectBtn.hidden = YES;
//    [self.selectBtn setImage:[UIImage imageNamed:@"mg_circle_select_normal"] forState:UIControlStateNormal];
    
    self.thirdLoginL.text = ASLocalizedString(@"第三方登录");
    [self.forgetBtn setTitle:ASLocalizedString(@"忘记密码?") forState:UIControlStateNormal];
    
    if (!self.areaModel) {
        self.areaModel = [BogoChoiceAreaModel new];
        self.areaModel.area_code = @"+1";
    }
    
    
    self.tryCount = 0;
    
    
    self.phoneT.delegate = self;
    [self.phoneT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneT.keyboardType = UIKeyboardTypeNumberPad;
    
    self.areaBtn.imagePosition = QMUIButtonImagePositionRight;
    self.areaBtn.spacingBetweenImageAndTitle = 3;
    self.codeAreaBtn.imagePosition = QMUIButtonImagePositionRight;
    self.codeAreaBtn.spacingBetweenImageAndTitle = 3;
    [self setAgreeTextView];
    
    
    
    
    [self setPlaceholderTextWithTextfield:self.phoneT];
    

    
    
    [self setPlaceholderTextWithTextfield:self.passwordT];
    [self setPlaceholderTextWithTextfield:self.confirmPasswordT];
    [self setPlaceholderTextWithTextfield:self.codePhoneT];
  
    //四个界面布局修改
    [self changeLoginStatusView];
    
    self.topConstraint.constant = kStatusBarHeight;
    if (_loginType == BOGO_LOGIN_TYPE_PHONE_CONFIRM || _loginType == BOGO_LOGIN_TYPE_PHONE_CHANGE) {
        
        self.confirmBtn.enabled = NO;
        
        return;
    }
    
    if (isIPhone6()) {
        self.agreeTWidthConstraint.constant = 275;
    }else{
        self.agreeTWidthConstraint.constant = 275;
    }
    
    self.googleBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)setPhoneNum:(NSString *)phoneNum{
    _phoneNum = phoneNum;
    _timeCount = 60;
    
    [self changeLoginStatusView];
    
    
    
    //只有验证码登录界面自动发送
    if (self.loginType != BOGO_LOGIN_TYPE_CODE_LOGIN) {
        return;
    }
    
    [self getConfirmCodeBtn:self.codeBtn];
}

- (void)setTel_code:(NSString *)tel_code{
    _tel_code = tel_code;
    self.areaModel = [BogoChoiceAreaModel new];
    self.areaModel.area_code = tel_code;
}

-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 11) {
        self.phoneT.text = [textField.text substringToIndex:11];
        [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
    }
    
    if (self.loginType == BOGO_LOGIN_TYPE_PHONE_CONFIRM){
        
        if (self.phoneT.text.length > 3) {
            self.confirmBtn.enabled = YES;
        }else{
            self.confirmBtn.enabled = NO;
        }
    }
    
    if (self.loginType == BOGO_LOGIN_TYPE_PHONE_CHANGE){
        
        if (self.phoneT.text.length > 3 && self.codePhoneT.text.length > 10) {
            self.confirmBtn.enabled = YES;
        }else{
            self.confirmBtn.enabled = NO;
        }
    }
    
    
    
    
    
    
}

-(void)clickBgView:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

-(void)changeLoginStatusView{
    self.codeBtn.hidden = YES;
    self.passwordView.hidden = YES;
    self.passwordLoginBtn.hidden = self.forgetBtn.hidden = YES;
    self.navView.hidden = NO;
    self.thirdView.hidden = YES;
    self.phoneTitleL.hidden = YES;

    self.codePhoneT.hidden = self.codeView.hidden = self.codeAreaBtn.hidden  =YES;
    self.selectBtn.hidden = self.agreeT.hidden = YES;
    
    self.qqBtn.hidden = self.wxBtn.hidden = YES;
    
    [self changeThirdView];
    
    
    
    
    

    if (self.loginType == BOGO_LOGIN_TYPE_CODE) {
        self.navView.hidden = YES;
        self.phoneT.placeholder = ASLocalizedString(@"请输入手机号");
        self.titleL.text = ASLocalizedString(@"手机验证码登录");
        self.subTitleL.text = ASLocalizedString(@"未注册的用户验证后将自动创建账户");
        self.passwordLoginBtn.hidden = NO;
        self.thirdView.hidden = NO;
        self.selectBtn.hidden = self.agreeT.hidden = NO;
        
    }else if (self.loginType == BOGO_LOGIN_TYPE_CODE_LOGIN){
        
        self.navTitleLabel.hidden = YES;
        
        self.areaBtn.hidden = YES;
        self.phoneLeftConstraint.constant = 15;
        self.phoneT.placeholder = ASLocalizedString(@"请输入验证码");
        [self.confirmBtn setTitle:ASLocalizedString(@"登录") forState:UIControlStateNormal];
        self.titleL.text = ASLocalizedString(@"手机验证码登录");
        self.subTitleL.text = [NSString stringWithFormat:@"%@%@ %@",ASLocalizedString(@"验证码将发送至"),self.areaModel.area_code,_phoneNum];
        
        self.passwordLoginBtn.hidden = self.codeBtn.hidden = NO;
        
    }else if (self.loginType == BOGO_LOGIN_TYPE_PHONE){
        if (self.loginType == BOGO_LOGIN_TYPE_PHONE) {
            self.phoneT.text = _phoneNum;
        }
        self.thirdView.hidden = NO;
        self.navView.hidden = YES;
        self.passwordView.hidden = NO;
        self.phoneT.placeholder = ASLocalizedString(@"请输入手机号");
        self.titleL.text = ASLocalizedString(@"账号密码登录");
        self.codeBtn.hidden = YES;
        self.subTitleL.hidden = YES;
        self.forgetBtn.hidden = NO;
        self.forgetBtn.hidden = self.passwordLoginBtn.hidden = NO;
        [self.passwordLoginBtn setTitle:ASLocalizedString(@"手机验证码登录") forState:UIControlStateNormal];
        [self.confirmBtn setTitle:ASLocalizedString(@"登录") forState:UIControlStateNormal];
        self.selectBtn.hidden = self.agreeT.hidden = NO;
        
    }else if (self.loginType == BOGO_LOGIN_TYPE_FORGET){
        self.navTitleLabel.text = ASLocalizedString(@"忘记密码");
        self.phoneT.placeholder = ASLocalizedString(@"请输入手机号");
        self.titleL.text = ASLocalizedString(@"请输入忘记密码的账号");
        [self.confirmBtn setTitle:ASLocalizedString(@"下一步") forState:UIControlStateNormal];
        
        self.subTitleL.hidden = YES;
    }else if (self.loginType == BOGO_LOGIN_TYPE_FORGET_CODE){
        self.navTitleLabel.text = ASLocalizedString(@"设置登录密码");
        self.confirmPasswordView.hidden = self.passwordView.hidden = NO;
        self.phoneTitleL.hidden = NO;
        self.phoneTopConstraint.constant = 20;
        self.phoneLeftConstraint.constant = 15;
        self.phoneT.placeholder = ASLocalizedString(@"请输入验证码");

        
        if (_phoneNum.length < 7) {
            return;
        }
        
        self.phoneTitleL.text = [NSString stringWithFormat:@"%@%@  %@****%@",ASLocalizedString(@"当前手机号"),self.areaModel.area_code,[_phoneNum substringToIndex:3],[_phoneNum substringFromIndex:_phoneNum.length - 4]];
        [self.confirmBtn setTitle:ASLocalizedString(@"确定") forState:UIControlStateNormal];
        self.titleL.hidden = self.subTitleL.hidden = self.thirdView.hidden = YES;
         self.areaBtn.hidden = YES;
        self.codeBtn.hidden = NO;
    }else if(_loginType == BOGO_LOGIN_TYPE_PHONE_CONFIRM){
        self.navTitleLabel.text = ASLocalizedString(@"手机号验证");
        self.phoneTitleL.hidden = NO;
        self.phoneTopConstraint.constant = 20;
        self.phoneLeftConstraint.constant = 15;
        self.phoneT.placeholder = ASLocalizedString(@"请输入验证码");
        self.phoneTitleL.text = [NSString stringWithFormat:@"%@%@  %@",ASLocalizedString(@"当前手机号"),self.areaModel.area_code,_phoneNum];
        [self.confirmBtn setTitle:ASLocalizedString(@"下一步") forState:UIControlStateNormal];
        self.titleL.hidden = self.subTitleL.hidden = self.thirdView.hidden = YES;
        self.areaBtn.hidden = YES;
        self.codeBtn.hidden = NO;
        
    }else if(_loginType == BOGO_LOGIN_TYPE_PHONE_CHANGE){
        self.navTitleLabel.text = ASLocalizedString(@"更换手机号");
        self.phoneTopConstraint.constant = 0;
        self.phoneLeftConstraint.constant = 15;
        self.phoneT.placeholder = ASLocalizedString(@"请输入验证码");
        [self.confirmBtn setTitle:ASLocalizedString(@"确定") forState:UIControlStateNormal];
        self.titleL.hidden = self.subTitleL.hidden = self.thirdView.hidden = YES;
        self.codeAreaBtn.hidden = NO;
        self.codeBtn.hidden = NO;
        self.codePhoneT.hidden = NO;
        self.codeView.hidden = NO;
        self.areaBtn.hidden = YES;

    }
}

-(void)changeThirdView{
    //第三方
    NSMutableArray *thirdArr = [NSMutableArray array];
    if ([GlobalVariables sharedInstance].appModel.has_qq_login == 1)//QQ
    {
        [thirdArr addObject:@"1"];
        self.qqBtn.hidden = NO;
    }
    
    if ([GlobalVariables sharedInstance].appModel.has_wx_login == 1)//微信
    {
        [thirdArr addObject:@"2"];
        self.wxBtn.hidden = NO;
    }
    /*
    if (@available(iOS 13.0, *) && self.thirdView) {

        AppleIDManager *manager = [AppleIDManager defaultManager];
        manager.window = [AppDelegate sharedAppDelegate].window;
        [self.thirdView addSubview:manager.loginBtn];
        manager.loginBtn.layer.cornerRadius = 20;
        manager.loginBtn.clipsToBounds = YES;
//        manager.loginBtn.backgroundColor = kgrar
        
        
        [manager.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.thirdView).offset(80);
            make.height.width.mas_equalTo(@40);
            make.centerY.equalTo(self.wxBtn);
        }];
//            .frame = button.frame;
        [self.thirdView addSubview:manager.loginBtn];
        [thirdArr addObject:@"3"];
        self.wxBtn.hidden = NO;


        [AppleIDManager defaultManager].successBlock = ^(NSString * _Nonnull authorizationCode, NSString * _Nonnull identityToken, NSString * _Nonnull user) {
            
//            if (self.isSelect == NO) {
//                [FanweMessage alertHUD:ASLocalizedString(@"请先阅读并勾选协议")];
//                return;
//            }
//        http://livev2020.bogokj.com/mapi/index.php?ctl=login&act=apple_login&user_id=001872.a22fc8cc2d0a4d0bacaf109007e19351.0650&verify_token=&nickname=
            FWWeakify(self)
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"login" forKey:@"ctl"];
            [parmDict setObject:@"apple_login" forKey:@"act"];
            [parmDict setObject:user forKey:@"user_id"];
            [parmDict setObject:identityToken forKey:@"verify_token"];
            [parmDict setObject:@"" forKey:@"nickname"];

            [self showMyHud];
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
             {
                 FWStrongify(self)
                 [self hideMyHud];
                 if ([responseJson toInt:@"status"] == 1)
                 {
                     UserModel *model = [UserModel modelWithDictionary:responseJson[@"user_info"]];
                     model.need_bind_mobile = [responseJson[@"need_bind_mobile"] integerValue];
//                     model.access_token = resp.accessToken;
//                     if (model.need_bind_mobile == 0) {
                         [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
                         [BGIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
                         
                         self.BuguLive.appModel.first_login = [responseJson toString:@"first_login"];
//                         self.BuguLive.appModel.new_level = [responseJson toInt:@"new_level"];
//                         self.BuguLive.appModel.login_send_score = [responseJson toString:@"login_send_score"];
                         [GlobalVariables sharedInstance].token = [responseJson toString:@"token"];
                         [[BGIMLoginManager sharedInstance] getUserSig:^{
                             
                             [[AppDelegate sharedAppDelegate] enterMainUI];
                             
                             [self hideMyHud];
                             
                         } failed:^(int errId, NSString *errMsg) {
                             [self hideMyHud];
                             
                         }];
                     }
//                 }else{
//                     [FanweMessage alertHUD:[responseJson toString:@"error"]];
//                 }
             } FailureBlock:^(NSError *error) {
        //         FWStrongify(self)
                 [self showMyHud];
                 [FanweMessage alertHUD:error];
             }];
        };
        [AppleIDManager defaultManager].failureBlock = ^(NSString * _Nonnull errorMsg) {
//            [[HUDHelper sharedInstance] tipMessage:errorMsg];
            [FanweMessage alertHUD:errorMsg];
        };

    }*/
    
   
    
    
    
    if (thirdArr.count == 1) {
        self.wxConstraint.constant = 0;
        self.qqConstraint.constant = 0;
    }
    self.wxBtn.hidden = self.qqBtn.hidden = YES;
    self.facebookBtn.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self changeThirdView];
}

- (IBAction)clickFacebookBtn:(UIButton *)sender {
    
    if (self.isSelect == NO) {
        [FanweMessage alertHUD:ASLocalizedString(@"请先阅读并勾选协议")];
        return;
    }
    
    if ([FBSDKAccessToken currentAccessToken]){
        [FanweMessage alertHUD:ASLocalizedString(@"User is logged in")];
    }
    
    
    // Objective-C // // 将下列代码添加到文件的头文件中，例如：在 ViewController.m 中 // 在 #import "ViewController.h" 之后 #import <FBSDKCoreKit/FBSDKCoreKit.h> #import <FBSDKLoginKit/FBSDKLoginKit.h> // 将下列代码添加到正文：@implementation ViewController - (void)viewDidLoad { [super viewDidLoad];
//        FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init]; // Optional: Place the button in the center of your view.
//        loginButton.center = self.view.center;
//
//        [self.view addSubview:loginButton];
 
    
    /*[[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Facebook currentViewController:nil completion:^(id result, NSError *error) {
           if (error) {
           } else {
               UMSocialUserInfoResponse *resp = result;
               // 授权信息
               NSLog(@"Wechat uid: %@", resp.uid);
               NSLog(@"Wechat openid: %@", resp.openid);
               NSLog(@"Wechat unionid: %@", resp.unionId);
               NSLog(@"Wechat accessToken: %@", resp.accessToken);
               NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
               NSLog(@"Wechat expiration: %@", resp.expiration);
               // 用户信息
               NSLog(@"Wechat name: %@", resp.name);
               NSLog(@"Wechat iconurl: %@", resp.iconurl);
               NSLog(@"Wechat gender: %@", resp.unionGender);
               // 第三方平台SDK源数据
               NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
               
                [self thirdLoginPlatform:UMSocialPlatformType_Facebook resp:resp];
               
           }
    }];*/
    
//    [self getWxLoginUserinfo];
    
    self.fbManager = [[FBSDKLoginManager alloc] init];
//    [self.fbManager logOut];
    
    [self.fbManager logInWithPermissions:@[@"public_profile"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Facebook登陆失败 error:%@",error);
        } else if (result.isCancelled) {
            NSLog(@"Facebook取消登录");
        } else {
            NSLog(@"Facebook登录成功:%@",result.token.userID);
            
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"login" forKey:@"ctl"];
            [parmDict setObject:result.token.userID forKey:@"openid"];
            [parmDict setObject:@"fb_login" forKey:@"act"];

            [parmDict setObject:result.token.tokenString forKey:@"access_token"];
            
//            NSString *loginId = token.userID;
            UMSocialUserInfoResponse *userInfo = [UMSocialUserInfoResponse new];
//            userInfo.name = result.
            
          
            
            FWWeakify(self)
            
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
             {
                 FWStrongify(self)
                 
                 if ([responseJson toInt:@"status"] == 1)
                 {
                     UserModel *model = [UserModel modelWithDictionary:responseJson[@"user_info"]];
                     model.need_bind_mobile = [responseJson[@"need_bind_mobile"] integerValue];
                     model.access_token = result.token.tokenString;
                     if (model.need_bind_mobile == 0) {
                         [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
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
                     }else{
                         [self hideMyHud];
                         BogoThirdLoginViewController *vc = [BogoThirdLoginViewController new];
//                         vc.userInfo = resp;
                         vc.model = model;
                         [self.navigationController pushViewController:vc animated:YES];
                     }
                 }
                 else
                 {
                     [self hideMyHud];
                     [FanweMessage alertHUD:[responseJson toString:@"error"]];
                 }
                 
             } FailureBlock:^(NSError *error)
             {
                
                 
                 [FanweMessage alertHUD:ASLocalizedString(@"获取登录参数失败，请稍后尝试")];
             }];
           
        }
    }];
    
    
}


- (IBAction)clickCancleBtn:(QMUIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickConfirmBtn:(UIButton *)sender {
    
    if (_loginType == BOGO_LOGIN_TYPE_CODE) {
        
        if (self.isSelect == NO) {
            [FanweMessage alertHUD:ASLocalizedString(@"请先阅读并勾选协议")];
            return;
        }
        
        if (self.phoneT.text.length == 0)
        {
            [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
            return;
        }
        
        if (self.phoneT.text.length < 6)
        {
            [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
            return;
        }
        
        BogoLoginViewController *vc = [BogoLoginViewController new];
        vc.loginType = BOGO_LOGIN_TYPE_CODE_LOGIN;
        vc.tel_code = self.areaModel.area_code;
        vc.phoneNum = self.phoneT.text;
        vc.areaModel = self.areaModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_loginType == BOGO_LOGIN_TYPE_CODE_LOGIN){
        
        [self phoneCodeLogin];
        
    }else if (_loginType == BOGO_LOGIN_TYPE_PHONE){
        if (self.isSelect == NO) {
            [FanweMessage alertHUD:ASLocalizedString(@"请先阅读并勾选协议")];
            return;
        }
        _phoneNum = self.phoneT.text;
        [self phonePasswordLogin];
        
    }else if (_loginType == BOGO_LOGIN_TYPE_FORGET){
        
        
        if (self.phoneT.text.length == 0)
        {
            [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
            return;
        }
        
        if (self.phoneT.text.length < 6)
        {
            [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
            return;
        }
        
        
        
        [self forgetCheckMobilPhone];
     
    }else if (_loginType == BOGO_LOGIN_TYPE_FORGET_CODE){
        [self forgetPasswordLogin];

    }else if(_loginType == BOGO_LOGIN_TYPE_PHONE_CONFIRM){
        
        
        [self verificationMobilPhone];
        
        
        
        
        
        
        
        
        
        
        
        
    }else if(_loginType == BOGO_LOGIN_TYPE_PHONE_CHANGE){
        [self changePhoneNum];
    }
}

//验证手机号
-(void)verificationMobilPhone{
    
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"verification_mobile" forKey:@"act"];
    [parmDict setObject:_phoneNum forKey:@"mobile"];
    [parmDict setObject:self.phoneT.text forKey:@"code"];

    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             //验证手机号
             BogoLoginViewController *vc = [BogoLoginViewController new];
             vc.loginType = BOGO_LOGIN_TYPE_PHONE_CHANGE;
             vc.phoneNum = self.phoneT.text;
             [self.navigationController pushViewController:vc animated:YES];
         }else{
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error) {
//         FWStrongify(self)
         [FanweMessage alertHUD:error];
     }];
}

- (IBAction)clickGoogleLogin:(id)sender {

    if (self.isSelect == NO) {
        [FanweMessage alertHUD:ASLocalizedString(@"请先阅读并勾选协议")];
        return;
    }
    
    [self showMyHud];
    
    [GIDSignIn.sharedInstance signInWithPresentingViewController:self
                                                      completion:^(GIDSignInResult * _Nullable signInResult,
                                                                   NSError * _Nullable error) {
        if (error) {
            [BGHUDHelper alert:error.description];
            [self hideMyHud];
            return;
        }
        if (signInResult == nil) {
            [BGHUDHelper alert:@"signInResult is nil"];
            [self hideMyHud];
            return;
        }

        [signInResult.user refreshTokensIfNeededWithCompletion:^(GIDGoogleUser * _Nullable user,
                                                                 NSError * _Nullable error) {
            if (error) {
                [self hideMyHud];
                return;
            }
            
            NSString *idToken = user.idToken.tokenString;
            
            FWWeakify(self)
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"login" forKey:@"ctl"];
            [parmDict setObject:@"google_verify_login" forKey:@"act"];
            [parmDict setObject:@"google" forKey:@"login_type"];
            [parmDict setObject:idToken forKey:@"google_token"];

            [self showMyHud];
            [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
             {
                 FWStrongify(self)
                 [self hideMyHud];
                 if ([responseJson toInt:@"status"] == 1)
                 {
                     [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
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
                 } else {
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self clickGoogleLogin:nil];
                     });
                 }
             } FailureBlock:^(NSError *error) {
                 [self hideMyHud];
                 [FanweMessage alertHUD:error.description];
             }];
        }];
    }];
    /*
    [[FIRAuth auth]
        addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
        NSLog(@"%@ --------- user",user);
    
    }];
    
    
    GIDConfiguration *config = [[GIDConfiguration alloc] initWithClientID:[FIRApp defaultApp].options.clientID];

    __weak __auto_type weakSelf = self;
    [GIDSignIn.sharedInstance signInWithConfiguration:config presentingViewController:self callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
      __auto_type strongSelf = weakSelf;
      if (strongSelf == nil) { return; }
        
        FIRUser *currentUser = [FIRAuth auth].currentUser;
        if(currentUser == nil)
        {
            
            GIDAuthentication *authentication = user.authentication;
    //        FIRAuthCredential *credential =
    //        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
    //                                         accessToken:authentication.accessToken];
      
                  
              FWWeakify(self)
              NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
              [parmDict setObject:@"login" forKey:@"ctl"];
              [parmDict setObject:@"firebase_login" forKey:@"act"];
              [parmDict setObject:@"google" forKey:@"login_type"];
              [parmDict setObject:user.authentication.refreshToken forKey:@"firebase_token"];

          //
              [self showMyHud];
              [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
               {
                   FWStrongify(self)
                   [self hideMyHud];
                   if ([responseJson toInt:@"status"] == 1)
                   {
                       [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
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
                  else
                  {
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          // 需要延迟执行的代码
                          [self clickGoogleLogin:nil];
                      });
                  }
               } FailureBlock:^(NSError *error) {
          //         FWStrongify(self)
                   [FanweMessage alertHUD:error.description];
               }];
             
              
              
              NSLog(@"google login");
            return;
        }
        
        [currentUser getIDTokenForcingRefresh:YES completion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (error == nil) {
              GIDAuthentication *authentication = user.authentication;
      //        FIRAuthCredential *credential =
      //        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
      //                                         accessToken:authentication.accessToken];
        
                    
                FWWeakify(self)
                NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
                [parmDict setObject:@"login" forKey:@"ctl"];
                [parmDict setObject:@"firebase_login" forKey:@"act"];
                [parmDict setObject:@"google" forKey:@"login_type"];
                [parmDict setObject:token forKey:@"firebase_token"];

            //
                [self showMyHud];
                [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
                 {
                     FWStrongify(self)
                     [self hideMyHud];
                     if ([responseJson toInt:@"status"] == 1)
                     {
                         [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
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
                    else
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            // 需要延迟执行的代码
                            [self clickGoogleLogin:nil];
                        });
                    }
                 } FailureBlock:^(NSError *error) {
            //         FWStrongify(self)
                     [FanweMessage alertHUD:error.description];
                 }];
               
                
                
                NSLog(@"google login");
              // ...
            } else {
              // ...
            }
        }];
//        [currentUser getIDTokenForcingRefresh:^(NSString * _Nullable token, NSError * _Nullable error) {
//
//        }];


    }];*/

    
}



//忘记密码-之前的下一步界面
-(void)forgetCheckMobilPhone{
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"check_mobile" forKey:@"act"];
    [parmDict setObject:self.phoneT.text forKey:@"mobile"];
    [parmDict setObject:self.areaModel.area_code forKey:@"tel_code"];

    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             //验证手机号
             BogoLoginViewController *vc = [BogoLoginViewController new];
             vc.loginType = BOGO_LOGIN_TYPE_FORGET_CODE;
             vc.phoneNum = self.phoneT.text;
             vc.tel_code = self.areaModel.area_code;
             [self.navigationController pushViewController:vc animated:YES];
         }else{
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error) {
//         FWStrongify(self)
         [FanweMessage alertHUD:error];
     }];

}


- (IBAction)clickAreaPhoneBtn:(QMUIButton *)sender {
//    BogoCountryChoiceViewController *vc = [BogoCountryChoiceViewController new];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
            appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        appearance.backgroundColor = kWhiteColor;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        }
    
    XYCountryCodeViewController *vc = [[XYCountryCodeViewController alloc] initWithShowType:XYCountryCodeShowTypeNone];
    [vc showViewController:self];
    __weak __typeof(self)weakSelf = self;
    [vc setChooseCodeRespose:^(NSString *code) {
        BogoChoiceAreaModel *model = [BogoChoiceAreaModel new];
        model.area_code = [NSString stringWithFormat:@"+%@",code];
        
        self.areaModel = model;
        [sender setTitle:[NSString stringWithFormat:@"+%@",code] forState:UIControlStateNormal];

//        weakSelf.labCountryCode.text = [NSString stringWithFormat:@"+%@",code];
//        weakSelf.countryCode = code;
    }];
    
    
//    vc.clickAreaBlock = ^(BogoChoiceAreaModel * _Nonnull model) {
//        [sender setTitle:model.area_code forState:UIControlStateNormal];
//        self.areaModel = model;
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickForgetBtn:(UIButton *)sender {
    BogoLoginViewController *vc = [BogoLoginViewController new];
    vc.loginType = BOGO_LOGIN_TYPE_FORGET;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickPasswordLoginBtn:(UIButton *)sender {
    BogoLoginViewController *vc = [BogoLoginViewController new];
    
    if (_loginType == BOGO_LOGIN_TYPE_PHONE) {
        
        if (self.returnPhoneNumBlock) {
            self.returnPhoneNumBlock(self.phoneT.text);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else{
        vc.loginType = BOGO_LOGIN_TYPE_PHONE;
        vc.phoneNum = self.phoneT.text;
        vc.returnPhoneNumBlock = ^(NSString * _Nonnull phone) {
            self.phoneT.text = phone;
        };
    }
   
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (IBAction)clickSelectBtn:(UIButton *)sender {
    self.isSelect = !self.isSelect;
    
    if (self.isSelect) {
        [self.selectBtn setImage:[UIImage imageNamed:@"bogo_regiset_select"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"bogo_regiset_normal"] forState:UIControlStateNormal];
    }
}


- (IBAction)clickWxBtn:(UIButton *)sender {
    
    if (self.isSelect == NO) {
        [FanweMessage alertHUD:ASLocalizedString(@"请先阅读并勾选协议")];
        return;
    }
    
    [self getWxLoginUserinfo];
    
}

- (IBAction)clickQQBtn:(UIButton *)sender {
    
    if (self.isSelect == NO) {
        [FanweMessage alertHUD:ASLocalizedString(@"请先阅读并勾选协议")];
        return;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
           if (error) {
           } else {
               UMSocialUserInfoResponse *resp = result;
               [self thirdLoginPlatform:UMSocialPlatformType_QQ resp:resp];
           }
    }];
}

-(void)getWxLoginUserinfo{

    
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
           if (error) {
           } else {
               UMSocialUserInfoResponse *resp = result;
               // 授权信息
               NSLog(@"Wechat uid: %@", resp.uid);
               NSLog(@"Wechat openid: %@", resp.openid);
               NSLog(@"Wechat unionid: %@", resp.unionId);
               NSLog(@"Wechat accessToken: %@", resp.accessToken);
               NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
               NSLog(@"Wechat expiration: %@", resp.expiration);
               // 用户信息
               NSLog(@"Wechat name: %@", resp.name);
               NSLog(@"Wechat iconurl: %@", resp.iconurl);
               NSLog(@"Wechat gender: %@", resp.unionGender);
               // 第三方平台SDK源数据
               NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
               
                [self thirdLoginPlatform:UMSocialPlatformType_WechatSession resp:resp];
               
           }
       }];
}

-(void)thirdLoginPlatform:(UMSocialPlatformType)platformType resp:(UMSocialUserInfoResponse *)resp{
    
    NSString *loginId = @"";
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    
    if (platformType == UMSocialPlatformType_QQ)
    {
        [parmDict setObject:@"qq_login" forKey:@"act"];
        [parmDict setObject:resp.openid forKey:@"openid"];
        [parmDict setObject:resp.accessToken forKey:@"access_token"];
//        self.loginType = @"qq_login";
        loginId = resp.openid;
    }
    else if (platformType == UMSocialPlatformType_WechatSession)
    {
        [parmDict setObject:@"wx_login" forKey:@"act"];
        [parmDict setObject:resp.openid forKey:@"openid"];
        [parmDict setObject:resp.accessToken forKey:@"access_token"];
        
        loginId = resp.openid;
    }
    
    [self showMyHud];
    
    FWWeakify(self)
    
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         
         if ([responseJson toInt:@"status"] == 1)
         {
             UserModel *model = [UserModel modelWithDictionary:responseJson[@"user_info"]];
             model.need_bind_mobile = [responseJson[@"need_bind_mobile"] integerValue];
             model.access_token = resp.accessToken;
             if (model.need_bind_mobile == 0) {
                 [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
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
             }else{
                 [self hideMyHud];
                 BogoThirdLoginViewController *vc = [BogoThirdLoginViewController new];
                 vc.userInfo = resp;
                 vc.model = model;
                 [self.navigationController pushViewController:vc animated:YES];
             }
         }
         else
         {
             [self hideMyHud];
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         
     } FailureBlock:^(NSError *error)
     {
         [self hideMyHud];
         
         [FanweMessage alertHUD:ASLocalizedString(@"获取登录参数失败，请稍后尝试")];
     }];
    
    
    
}


-(void)firbaseApiRequest:(NSString *)token
{
    
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"firebase_login" forKey:@"act"];
    [parmDict setObject:_phoneNum forKey:@"mobile"];
    [parmDict setObject:self.phoneT.text forKey:@"verify_coder"];
    [parmDict setObject:self.areaModel.area_code forKey:@"tel_code"];
    [parmDict setObject:@"phone" forKey:@"login_type"];
    [parmDict setObject:token forKey:@"firebase_token"];

//
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
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
        else
        {
            self.tryCount++;
            if(self.tryCount < 20)
            {
                [self firbaseApiRequest:token];
                NSLog(@"自动重试");
            }
            else
            {
                [self hideMyHud];
                [FanweMessage alertHUD:ASLocalizedString(@"登录失败，请稍后重试")];
            }
        }
     } FailureBlock:^(NSError *error) {
        FWStrongify(self)
        self.tryCount++;
        if (self.tryCount < 20)
        {
            [self firbaseApiRequest:token];
            NSLog(@"自动重试");
        }
        else
        {
            [self hideMyHud];
            [FanweMessage alertHUD:ASLocalizedString(@"登录失败，请稍后重试")];
        }
    }];
}

//验证码登录
-(void)phoneCodeLogin{
    
    if (!StrValid(self.phoneT.text)) {
        [FanweMessage alertHUD:ASLocalizedString(@"请填写验证码")];
        return;
    }
    
    
    if([GlobalVariables sharedInstance].openFirebaseSMS && self.areaModel.area_code.intValue != 86)
    {
        [[BGFirebaseSMS new] verifyCode:self.phoneT.text block:^(AppBlockModel *blockModel) {
            NSString *token = blockModel.retDict[@"token"];

            self.tryCount = 0;
            [self firbaseApiRequest:token];
        }];
        return;
    }
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"do_login_new" forKey:@"act"];
    [parmDict setObject:_phoneNum forKey:@"mobile"];
    [parmDict setObject:self.phoneT.text forKey:@"verify_coder"];
    [parmDict setObject:self.areaModel.area_code forKey:@"tel_code"];
//
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
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
     } FailureBlock:^(NSError *error) {
//         FWStrongify(self)
         [FanweMessage alertHUD:error.description];
     }];
}

//账号密码登录
-(void)phonePasswordLogin{
    
    
    if (_phoneNum.length == 0)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
        return;
    }
    
    if (_phoneNum.length < 6)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"password_login" forKey:@"act"];
//    [parmDict setObject:@"1" forKey:@"wx_binding"];
    [parmDict setObject:self.phoneT.text forKey:@"mobile"];
    [parmDict setObject:self.passwordT.text forKey:@"password"];
//
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
             [BGIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
             
             self.BuguLive.appModel.first_login = [responseJson toString:@"first_login"];
             self.BuguLive.appModel.new_level = [responseJson toInt:@"new_level"];
             self.BuguLive.appModel.login_send_score = [responseJson toString:@"login_send_score"];
             
             NSDictionary *userDic = [responseJson valueForKey:@"user_info"];
             [GlobalVariables sharedInstance].token = [userDic toString:@"token"];
             [[BGIMLoginManager sharedInstance] getUserSig:^{
                 
                 [[AppDelegate sharedAppDelegate] enterMainUI];
                 
                 [self hideMyHud];
                 
             } failed:^(int errId, NSString *errMsg) {
                 [self hideMyHud];
                 
             }];
         }else{
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error) {

         [FanweMessage alertHUD:error.description];
     }];
}

//忘记密码登录
-(void)forgetPasswordLogin{
    
    //这里验证码用_phoneT
    if (_phoneT.text.length == 0)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"请输入验证码!")];
        return;
    }
    
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];

    [parmDict setObject:@"update_password_new" forKey:@"act"];

//    [parmDict setObject:@"1" forKey:@"wx_binding"];
    [parmDict setObject:_phoneNum forKey:@"mobile"];
    [parmDict setObject:self.phoneT.text forKey:@"verify_coder"];
    [parmDict setObject:self.passwordT.text forKey:@"password"];

    [parmDict setObject:self.confirmPasswordT.text forKey:@"confirm_password"];
    [parmDict setObject:self.areaModel.area_code forKey:@"tel_code"];

    

    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error) {
//         FWStrongify(self)
         [FanweMessage alertHUD:error.description];
     }];
}

//更换新的手机号
-(void)changePhoneNum{
    
    if (self.codePhoneT.text.length == 0)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
        return;
    }
    
    if (self.codePhoneT.text.length < 6)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"exchange_mobile" forKey:@"act"];

    [parmDict setObject:self.codePhoneT.text forKey:@"mobile"];
    [parmDict setObject:self.phoneT.text forKey:@"code"];
    [parmDict setObject:self.areaModel.area_code forKey:@"tel_code"];

    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [FanweMessage alertHUD:[responseJson toString:@"error"]];
        }

     } FailureBlock:^(NSError *error) {
//         FWStrongify(self)
         [FanweMessage alertHUD:error];
     }];
}

- (IBAction)getConfirmCodeBtn:(QMUIButton *)codeBtn {
    
    
    if (_phoneNum.length == 0)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
        return;
    }
    
    if (_phoneNum.length < 6)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    
    codeBtn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timego) userInfo:nil repeats:YES];
    [self timego];

    //google sms
    if([GlobalVariables sharedInstance].openFirebaseSMS && self.areaModel.area_code.intValue != 86)
    {
        NSString *phoneSMS = [NSString stringWithFormat:@"+%@%@",self.areaModel.area_code,_phoneNum];
        [[[BGFirebaseSMS alloc] init] sendSMS:phoneSMS block:^(AppBlockModel *blockModel) {
            
        }];
        return;
    }

    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"send_mobile_verify_international" forKey:@"act"];
//    [parmDict setObject:@"1" forKey:@"wx_binding"];
    [parmDict setObject:_phoneNum forKey:@"mobile"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",self.areaModel.area_code] forKey:@"area_code"];

    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] != 1)
         {
             codeBtn.enabled = YES;
             [codeBtn setTitle:ASLocalizedString(@"发送验证码") forState:UIControlStateNormal];
             [_timer invalidate];
             _timer = nil;
         }else{
             
         }
     } FailureBlock:^(NSError *error) {
         FWStrongify(self)
         [self hideMyHud];
         [codeBtn setTitle:ASLocalizedString(@"发送验证码") forState:UIControlStateNormal];
         [FanweMessage alert:ASLocalizedString(@"发送失败")];
         codeBtn.enabled = YES;
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
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%@(%lds)",ASLocalizedString(@"重新获取"),(long)time] forState:UIControlStateNormal];
//        [self.loginView.codeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateDisabled];
        _timeCount --;
    }else if(time == 0)
    {
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"重新获取验证码")] forState:UIControlStateNormal];
        [_timer invalidate];
        _timeCount = 60;
    }
}

-(void)setPlaceholderTextWithTextfield:(UITextField *)textField{
    
    if (@available(iOS 13.0,*)) {
                
//        Ivar ivar = class_getInstanceVariable([UITextField class],@"_placeholderLabel");
        UILabel *placeholderLabel = [self getIvar:textField ivarName:@"_placeholderLabel"];
//        object_getIvar(textField, ivar);
        placeholderLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
        placeholderLabel.font = [UIFont boldSystemFontOfSize:14];
        placeholderLabel.alpha = 0.8;
    }else{
        [textField setValue:[UIColor colorWithHexString:@"#AAAAAA"] forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    }
    
}

- (id)getIvar:(id)obj ivarName:(NSString *)name {
    unsigned int numIvars; // 成员变量个数
    Ivar *vars = class_copyIvarList([obj class], &numIvars);
    id resultObj;
    for(int i =0; i < numIvars; i++) {
        if ([[NSString stringWithUTF8String:ivar_getName(vars[i])] isEqualToString:name]) {
            ptrdiff_t offset = ivar_getOffset(vars[i]);
            // 核心代码就只有下面这一句，类似的其他类的其他变量，你懂的...
            resultObj = (__bridge id)((void *)(*((long *)((__bridge void *)obj + offset))));
            break;
        }
    }
    free(vars);
    return resultObj;
}



//我已阅读并同意《用户服务协议》、《隐私权政策》
-(void)setAgreeTextView{
    
    [self.agreeT setText:ASLocalizedString(@"已阅读并同意《用户服务协议》和《隐私政策》")];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:ASLocalizedString(self.agreeT.text)];
        //设置行间距以及字体大小、颜色
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"action1://"
                             range:[[attributedString string] rangeOfString:ASLocalizedString(@"《用户服务协议》")]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"action2://"
                             range:[[attributedString string] rangeOfString:ASLocalizedString(@"《隐私政策》")]];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#9152F8"]};
    self.agreeT.backgroundColor = [UIColor clearColor];
    self.agreeT.linkTextAttributes = linkAttributes;
    self.agreeT.attributedText = attributedString;
    self.agreeT.scrollEnabled = NO;
    self.agreeT.font = [UIFont systemFontOfSize:12.0];
    self.agreeT.textAlignment = NSTextAlignmentCenter;
    self.agreeT.editable = NO;
    self.agreeT.delegate = self;
//    [self.view addSubview:self.agreeT];
    
}


#pragma mark -
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL absoluteString] isEqualToString:@"action1://"]) {
        BGMainWebViewController *vc = [BGMainWebViewController 
            webControlerWithUrlStr:self.BuguLive.appModel.user_agreement_link 
            isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    } else if ([[URL absoluteString] isEqualToString:@"action2://"]) {
        BGMainWebViewController *vc = [BGMainWebViewController 
            webControlerWithUrlStr:self.BuguLive.appModel.privacy_link 
            isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }
    return NO;
}

@end
