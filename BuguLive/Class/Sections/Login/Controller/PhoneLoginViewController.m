//
//  PhoneLoginViewController.m
//  BuguLive
//
//  Created by 范东 on 2019/1/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "PhoneLoginViewController.h"
#import "LPhoneRegistVC.h"

@interface PhoneLoginViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>{
    NSTimer                         *_timer;                //定时器
    int                             _timeCount;             //定时器时间
    NSString                        *_verify_url;           //图形验证码
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PhoneLoginViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackGroundColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 5.0f;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)initFWUI
{
    [super initFWUI];
    _timeCount = 60;
    if (self.LNSecBPhone||self.LSecBPhone)
    {
        self.titleLabel.text = ASLocalizedString(@"手机绑定");
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"lg_btn_bind_nor"] forState:UIControlStateNormal];
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"lg_btn_bind_sel"] forState:UIControlStateSelected];
    }else
    {
        self.titleLabel.text = ASLocalizedString(@"手机登录");
    }
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    [self.phoneTextField becomeFirstResponder];
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)initFWData
{
    [super initFWData];
}

- (IBAction)backBtnAction:(id)sender {
    [self myFiledResignFirstResP];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 键盘回退
- (void)myFiledResignFirstResP
{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
}

#pragma mark 发验证码的倒计时
- (void)timego
{
    [self timerDec:_timeCount];
}

- (void)timerDec:(NSInteger)time
{
    if(time > 0)
    {
        [self.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"%ld秒"),(long)time] forState:UIControlStateDisabled];
        _timeCount --;
    }else if(time == 0)
    {
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"发验证码")] forState:UIControlStateNormal];
        [_timer invalidate];
        _timeCount = 60;
    }
}

#pragma mark ============UITextFieldDelegate===================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self myFiledResignFirstResP];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTextField)
    {
        if (![string isNumber])
        {
            return NO;
        }
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11)
        {
            return NO;
        }
    }
    if (textField == self.codeTextField)
    {
        if (![string isNumber])
        {
            return NO;
        }
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 4)
        {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        self.codeBtn.enabled = (textField.text.length == 11);
    }
    if (textField == self.codeTextField) {
        if (self.phoneTextField.text.length == 11) {
            self.loginBtn.enabled = (textField.text.length == 4);
        }
    }
}

- (IBAction)codeBtnAction:(id)sender {
    if (self.phoneTextField.text.length < 1)
    {

        [FanweMessage alert:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    self.codeBtn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timego) userInfo:nil repeats:YES];
    [self timego];
    if (self.LSecBPhone || self.LNSecBPhone)
    {
        FWWeakify(self)
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"login" forKey:@"ctl"];
        [parmDict setObject:@"send_mobile_verify_international" forKey:@"act"];
        [parmDict setObject:@"1" forKey:@"wx_binding"];
        [parmDict setObject:self.phoneTextField.text forKey:@"mobile"];
        [self showMyHud];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
         {
             FWStrongify(self)
             [self hideMyHud];
             if ([responseJson toInt:@"status"] != 1)
             {
                 self.codeBtn.enabled = YES;
                 [self.codeBtn setTitle:ASLocalizedString(@"发验证码")forState:UIControlStateNormal];
                 [self->_timer invalidate];
                 self->_timer = nil;
             }
         } FailureBlock:^(NSError *error) {
             FWStrongify(self)
             [self hideMyHud];
             [self->_timer invalidate];
             self->_timer = nil;
             [self.codeBtn setTitle:ASLocalizedString(@"发验证码")forState:UIControlStateNormal];
             [FanweMessage alert:ASLocalizedString(@"发送失败")];
             self.codeBtn.enabled = YES;
         }];
    }
    else
    {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"login" forKey:@"ctl"];
        [parmDict setObject:@"send_mobile_verify_international" forKey:@"act"];
        [parmDict setObject:self.phoneTextField.text forKey:@"mobile"];
        if (_verify_url.length > 1 && self.codeTextField.text.length)
        {
            [parmDict setObject:self.codeTextField.text forKey:@"image_code"];
        }
        FWWeakify(self)
        [self showMyHud];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
         {
             FWStrongify(self)
             [self hideMyHud];
             if ([responseJson toInt:@"status"] != 1)
             {
                 self.codeBtn.enabled = YES;
                 [self.codeBtn setTitle:ASLocalizedString(@"发验证码")forState:UIControlStateNormal];
                 [self->_timer invalidate];
                 self->_timer = nil;
                 [self.phoneTextField resignFirstResponder];
             }
             
         } FailureBlock:^(NSError *error)
         {
             [self hideMyHud];
             self.codeBtn.enabled = YES;
             [self->_timer invalidate];
             self->_timer = nil;
             [self.codeBtn setTitle:ASLocalizedString(@"发验证码")forState:UIControlStateNormal];
         }];
    }
}
- (IBAction)loginBtnAction:(id)sender {
    if (self.phoneTextField.text.length < 1) {
        [FanweMessage alert:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    if (self.codeTextField.text.length < 1)
    {
        [FanweMessage alert:ASLocalizedString(@"请输入验证码")];
        return;
    }
    if (self.LNSecBPhone || self.LSecBPhone)
    {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"settings" forKey:@"ctl"];
        if (self.LNSecBPhone)
        {
            [parmDict setObject:@"mobile_login" forKey:@"act"];
        }
        if (self.LSecBPhone)
        {
            [parmDict setObject:@"mobile_binding" forKey:@"act"];
        }
        
        [parmDict setObject:self.phoneTextField.text forKey:@"mobile"];
        [parmDict setObject:self.codeTextField.text forKey:@"verify_code"];
        if (self.loginId.length)
        {
            [parmDict setObject:self.loginId forKey:@"openid"];
        }
        if (self.loginType.length)
        {
            [parmDict setObject:self.loginType forKey:@"login_type"];
        }
        if (self.accessToken.length)
        {
            [parmDict setObject:self.accessToken forKey:@"access_token"];
        }
        FWWeakify(self)
        [self showMyHud];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
         {
             FWStrongify(self)
             if ([responseJson toInt:@"status"] == 1)
             {
                 if (self.LSecBPhone)
                 {
                     [[AppDelegate sharedAppDelegate]popViewController];
                 }else
                 {
                     [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"data"];
                     [BGIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
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
             }else
             {
                 [self hideMyHud];
             }
         } FailureBlock:^(NSError *error) {
             FWStrongify(self)
             [self hideMyHud];
             [FanweMessage alert:ASLocalizedString(@"验证码过程出错，请重新尝试")];
         }];
    }
    else
    {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"login" forKey:@"ctl"];
        [parmDict setObject:@"do_login" forKey:@"act"];
        [parmDict setObject:self.phoneTextField.text forKey:@"mobile"];
        [parmDict setObject:self.codeTextField.text forKey:@"verify_coder"];
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
                     [[AppDelegate sharedAppDelegate]pushViewController:phoneRegist animated:YES];
                 }
                 else
                 {
                     [self showMyHud];
                     [BGIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
                     [BGIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
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
