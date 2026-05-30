//
//  MGRegisterViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/6/28.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGRegisterViewController.h"
#import "MGLoginTextBgView.h"

#import "LPhoneRegistVC.h"
#import <QPDialCodePickerView/QPDialCodePickerView.h>
@interface MGRegisterViewController ()<UITextFieldDelegate>


@property(nonatomic, strong) MGLoginTextBgView *countryView;;
@property(nonatomic, strong) MGLoginTextBgView *phoneView;
@property(nonatomic, strong) MGLoginTextBgView *codeView;
@property(nonatomic, strong) MGLoginTextBgView *passwordView;
@property(nonatomic, strong) MGLoginTextBgView *rePasswordView;
@property(nonatomic, strong) NSString *curCode;
@property(nonatomic, strong) UIButton *registerBtn;
@property(nonatomic, strong) UIButton *agreeBtn;

@end

@implementation MGRegisterViewController{
    NSTimer                         *_timer;                //定时器
    int                             _timeCount;             //定时器时间
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
    [self setupBackBtnWithBlock:nil];
    self.view.backgroundColor = kWhiteColor;
    
    if (self.loginType == MGLOGIN_TYPE_REGISTER) {//注册账号
        self.title = ASLocalizedString(@"注册账号");
        [self.registerBtn setTitle:ASLocalizedString(@"完成注册")forState:UIControlStateNormal];
    }else if (self.loginType == MGLOGIN_TYPE_FINDPASSWORD){//找回密码
        self.title = ASLocalizedString(@"找回密码");
        [self.registerBtn setTitle:ASLocalizedString(@"确定")forState:UIControlStateNormal];
        self.agreeBtn.hidden = YES;
    }else if (self.loginType == MGLOGIN_TYPE_CODELOGIN){//验证码登录
        self.title = ASLocalizedString(@"验证码登录");
        self.passwordView.hidden = self.rePasswordView.hidden =  YES;
        self.registerBtn.top = self.codeView.bottom + kRealValue(30);
        [self.registerBtn setTitle:ASLocalizedString(@"登录")forState:UIControlStateNormal];
    }
}

- (instancetype)initWithLoginType:(MGLOGIN_TYPE)loginType{
    MGRegisterViewController *vc = [MGRegisterViewController new];
    vc.loginType = loginType;
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)setUpView{
    
    _timeCount = 60;
    
    CGFloat viewHeight = kRealValue(57);
    
    WeakSelf
    
    self.countryView = [[MGLoginTextBgView alloc]initWithFrame:CGRectMake(0, kRealValue(20), kScreenW, viewHeight)];
    
//    if (self.loginType == MGLOGIN_TYPE_REGISTER || self.loginType == MGLOGIN_TYPE_CODELOGIN) {
        [self.view addSubview:self.countryView];
//    }else{
//        self.countryView.top = self.countryView.height = 0;
//    }
    
    self.phoneView = [[MGLoginTextBgView alloc]initWithFrame:CGRectMake(0, self.countryView.bottom + kRealValue(5), kScreenW, viewHeight)];
    self.phoneView.textField.delegate = self;
    [self.phoneView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.codeView = [[MGLoginTextBgView alloc]initWithFrame:CGRectMake(0,
                                                                       self.phoneView.bottom + kRealValue(5), kScreenW, viewHeight)];
    self.codeView.clickCodeBtnBlock = ^(BOOL clickRegister) {
        [weakSelf loginCodeBtn];
    };
    self.passwordView = [[MGLoginTextBgView alloc]initWithFrame:CGRectMake(0, self.codeView.bottom, kScreenW, viewHeight)];
    self.rePasswordView = [[MGLoginTextBgView alloc]initWithFrame:CGRectMake(0, self.passwordView.bottom, kScreenW, viewHeight)];
    
    
    [self.countryView setUpTextViewWithPlaceholder:@"" text:ASLocalizedString(@"中国大陆 +1")showRightBtn:YES type:MGREGISTER_VIEW_TYPE_COUNTRY];
    [self.phoneView setUpTextViewWithPlaceholder:ASLocalizedString(@"请输入手机号")text:@"" showRightBtn:NO  type:MGREGISTER_VIEW_TYPE_PHONE];
    [self.codeView setUpTextViewWithPlaceholder:ASLocalizedString(@"请输入验证码")text:@"" showRightBtn:YES  type:MGREGISTER_VIEW_TYPE_CODE];
    [self.passwordView setUpTextViewWithPlaceholder:ASLocalizedString(@"请输入密码")text:@"" showRightBtn:NO  type:MGREGISTER_VIEW_TYPE_PASSWORD];
    [self.rePasswordView setUpTextViewWithPlaceholder:ASLocalizedString(@"再次输入密码")text:@"" showRightBtn:NO  type:MGREGISTER_VIEW_TYPE_REPASSWORD];

    
    
    self.passwordView.textField.secureTextEntry = YES;
    self.rePasswordView.textField.secureTextEntry = YES;
    
    
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer)];
    [self.countryView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.rePasswordView];
    [self.view addSubview:self.passwordView];
    
    
    
    self.registerBtn.frame = CGRectMake(kRealValue(20), self.rePasswordView.bottom + kRealValue(15), kScreenW - kRealValue(20 * 2), kRealValue(44));
    _registerBtn.layer.cornerRadius = kRealValue(44 / 2);
    [self.view addSubview:self.registerBtn];
    
    self.agreeBtn.frame = CGRectMake(self.registerBtn.left, self.registerBtn.bottom + kRealValue(15), kScreenW - self.registerBtn.left * 2, kRealValue(20));
    [self.view addSubview:self.agreeBtn];
}

//iOS 13以上
//-(void)textFieldDidChangeSelection:(UITextField *)textField{
//
//
//    if (self.phoneView.textField.text.length < 1 && [self.countryView.textField.text containsString:@"中国"])
//    {
//
////    if (textField == self.mobileTF) {
//        if (self.phoneView.textField.text.length > 11) {
//            [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
//            self.phoneView.textField.text = [self.phoneView.textField.text substringToIndex:11];
//        }
//    }
//}

- (void)handleTapGestureRecognizer {
    
    [self.view endEditing:YES];
    
    __weak typeof (MGLoginTextBgView*) weakCountryView = self.countryView;
    QPDialCodePickerView *pickerView = [[QPDialCodePickerView alloc] initWithAreaFormat:QPDialCodeAreaNameFormatCurrentLocale complete:^(QPDialCodeObject *item) {
        self.curCode = item.dial_code;
        [weakCountryView setUpTextViewWithPlaceholder:@"" text:[NSString stringWithFormat:@"%@ +%@",item.area_name,item.dial_code] showRightBtn:YES type:MGREGISTER_VIEW_TYPE_COUNTRY];

        
//        [weakBtn setTitle:[NSString stringWithFormat:@"+%@", item.dial_code] forState:UIControlStateNormal];
    }];
    pickerView.roundCorner = YES;
    [pickerView show];
}

-(void)clickBtn:(UIButton *)sender{
    
    if (self.phoneView.textField.text.length < 1 && [self.countryView.textField.text containsString:@"中国"])
    {
        [FanweMessage alert:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }

    if ([BGUtils isBlankString:self.codeView.textField.text]) {
        [FanweMessage alertHUD:ASLocalizedString(@"请输入验证码")];
        return;
    }
    
    if (self.loginType == MGLOGIN_TYPE_REGISTER) {
        
        if ([BGUtils isBlankString:self.phoneView.textField.text]) {
            [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
            return;
        }
        if (![self.passwordView.textField.text isEqualToString:self.rePasswordView.textField.text]) {
            [FanweMessage alertHUD:ASLocalizedString(@"两次密码输入不一致")];
            return;
        }
        
        [self clickRegister];
        
    }else if (self.loginType == MGLOGIN_TYPE_FINDPASSWORD){
        
        if ([BGUtils isBlankString:self.phoneView.textField.text]) {
            [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
            return;
        }
        if (![self.passwordView.textField.text isEqualToString:self.rePasswordView.textField.text]) {
            [FanweMessage alertHUD:ASLocalizedString(@"两次密码输入不一致")];
            return;
        }
        
        
        [self clickFindPassword];
    }else if (self.loginType == MGLOGIN_TYPE_CODELOGIN){
        [self loginByPhone];
    }
}

#pragma mark 手机登录

- (void)loginByPhone
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"do_login" forKey:@"act"];
    [parmDict setObject:self.phoneView.textField.text forKey:@"mobile"];
    [parmDict setObject:self.codeView.textField.text forKey:@"verify_coder"];
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
                 
                 NSDictionary *userDic = [responseJson valueForKey:@"user_info"];
                 
                 [GlobalVariables sharedInstance].token = [userDic toString:@"token"];
//                 [[AppDelegate sharedAppDelegate]pushViewController:phoneRegist];
                 [self.navigationController presentViewController:phoneRegist animated:YES completion:nil];
             }
             else
             {
                 [self showMyHud];
                 [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
                 [BGIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
                 
                 NSDictionary *userDic = [responseJson valueForKey:@"user_info"];
                 
                 
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
}

-(void)clickRegister{
    
//    LPhoneRegistVC *phoneRegist = [[LPhoneRegistVC alloc]init];
//    phoneRegist.used_id = @"";
////    [responseJson toString:@"user_id"];
////    phoneRegist.userInfoDic = @"12312";
//    phoneRegist.userName = @"123132";
////                 [[AppDelegate sharedAppDelegate]pushViewController:phoneRegist];
//    [self.navigationController presentViewController:phoneRegist animated:YES completion:nil];
//
//
//    return;
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"password_registered" forKey:@"act"];
    [parmDict setObject:self.phoneView.textField.text forKey:@"mobile"];
    [parmDict setObject:self.codeView.textField.text forKey:@"verify_coder"];
    [parmDict setObject:self.passwordView.textField.text forKey:@"password"];
    [parmDict setObject:self.rePasswordView.textField.text forKey:@"confirm_password"];
    
    
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
            
            NSDictionary *userDic = [responseJson valueForKey:@"user_info"];
            [GlobalVariables sharedInstance].token = [userDic toString:@"token"];
            
            [[BGIMLoginManager sharedInstance] getUserSig:^{
                
                [[AppDelegate sharedAppDelegate] enterMainUI];
                
//                LPhoneRegistVC *phoneRegist = [[LPhoneRegistVC alloc]init];
//                phoneRegist.used_id = [responseJson toString:@"user_id"];
//                phoneRegist.userInfoDic = responseJson[@"user_info"];
//                phoneRegist.userName = [responseJson[@"user_info"] toString:@"nick_name"];
////                 [[AppDelegate sharedAppDelegate]pushViewController:phoneRegist];
//                [self.navigationController presentViewController:phoneRegist animated:YES completion:nil];
                
                
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

//找回密码\修改密码
-(void)clickFindPassword{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"update_password" forKey:@"act"];
    [parmDict setObject:self.phoneView.textField.text forKey:@"mobile"];
    [parmDict setObject:self.codeView.textField.text forKey:@"verify_coder"];
    [parmDict setObject:self.passwordView.textField.text forKey:@"password"];
    [parmDict setObject:self.rePasswordView.textField.text forKey:@"confirm_password"];
    
    
    [self showMyHud];
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            [FanweMessage alertHUD:ASLocalizedString(@"修改密码成功")];
                
            [self hideMyHud];

            [self.navigationController popToRootViewControllerAnimated:YES];
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

//点击获取验证码
-(void)loginCodeBtn{
    if (self.phoneView.textField.text.length < 1 && [self.countryView.textField.text containsString:@"中国"])
    {
        [FanweMessage alert:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    self.codeView.codeBtn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timego) userInfo:nil repeats:YES];
    [self timego];

    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"send_mobile_verify_international" forKey:@"act"];
    [parmDict setObject:SafeStr(self.curCode) forKey:@"area_code"];

    
//    [parmDict setObject:@"1" forKey:@"wx_binding"];
    [parmDict setObject:[NSString stringWithFormat:@"%@", self.phoneView.textField.text] forKey:@"mobile"];

//    [parmDict setObject:self.phoneView.textField.text forKey:@"mobile"];
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] != 1)
         {
             self.codeView.codeBtn.enabled = YES;
             [self.codeView.codeBtn setTitle:ASLocalizedString(@"发送验证码")forState:UIControlStateNormal];
             [_timer invalidate];
             _timer = nil;
         }
     } FailureBlock:^(NSError *error) {
         FWStrongify(self)
         [self hideMyHud];
         [self.codeView.codeBtn setTitle:ASLocalizedString(@"发送验证码")forState:UIControlStateNormal];
         [FanweMessage alert:ASLocalizedString(@"发送失败")];
         self.codeView.codeBtn.enabled = YES;
     }];
}

#pragma mark 获取验证码的倒计时
- (void)timego
{
    [self timerDec:_timeCount];
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField == self.phoneView.textField && [self.countryView.textField.text containsString:@"中国"]) {
        if (textField.text.length > 11) {
            [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.phoneView.textField && [self.countryView.textField.text containsString:@"中国"]) {
        if (textField.text.length > 11) {
            [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
            textField.text = [textField.text substringToIndex:11];
        }
    }
}


- (void)timerDec:(NSInteger)time
{
    if(time > 0)
    {
        [self.codeView.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"重新获取(%lds)"),(long)time] forState:UIControlStateDisabled];
//        [self.loginView.codeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateDisabled];
        _timeCount --;
    }else if(time == 0)
    {
        self.codeView.codeBtn.enabled = YES;
        [self.codeView.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"获取验证码")] forState:UIControlStateNormal];
        [_timer invalidate];
        _timeCount = 60;
    }
}


-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:ASLocalizedString(@"完成注册")forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_registerBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"mg_button_global"] forState:UIControlStateNormal];
        _registerBtn.layer.masksToBounds = YES;
    }
    return _registerBtn;
}

-(UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *firstStr = ASLocalizedString(@"登录即代表你同意");
        NSString *secondStr = ASLocalizedString(@"《用户隐私政策》");
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",firstStr,secondStr]];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#646464"] range:NSMakeRange(0,  firstStr.length)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9E63FE"] range:NSMakeRange(firstStr.length,  secondStr.length)];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_agreeBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
        _agreeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [_agreeBtn addTarget:self action:@selector(clickAgreement:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

-(void)clickAgreement:(UIButton *)sender{
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.privacy_link isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    if (@available(iOS 13, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}


@end
