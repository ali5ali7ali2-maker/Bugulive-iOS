//
//  BogoThirdLoginViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/29.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoThirdLoginViewController.h"
#import "BogoCountryChoiceViewController.h"
@interface BogoThirdLoginViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneT;

@property (weak, nonatomic) IBOutlet QMUIButton *codeBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *areaBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeT;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property(nonatomic, strong) BogoChoiceAreaModel *areaModel;
@end

@implementation BogoThirdLoginViewController{
    NSTimer                         *_timer;                //定时器
    int                             _timeCount;             //定时器时间
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.titleL setText:ASLocalizedString(@"绑定手机号")];
    self.navigationController.navigationBar.hidden = YES;
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBgView:)];
    [self.view addGestureRecognizer:tapView];
    
    if (!self.areaModel) {
        self.areaModel = [BogoChoiceAreaModel new];
        self.areaModel.area_code = @"+1";
    }
    
    
    self.headImgView.layer.cornerRadius = 60 / 2;
    self.headImgView.layer.masksToBounds = YES;
    
    
    self.phoneT.delegate = self;
    [self.phoneT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneT.keyboardType = UIKeyboardTypeNumberPad;
    
    self.codeT.delegate = self;
    [self.codeT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.codeT.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.areaBtn.imagePosition = QMUIButtonImagePositionRight;
    self.areaBtn.spacingBetweenImageAndTitle = 3;
    
    
    
    [self setPlaceholderTextWithTextfield:self.phoneT];
    
    [self setPlaceholderTextWithTextfield:self.codeT];
    
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.iconurl] completed:nil];
    self.nicknameL.text = self.userInfo.name;
    
    _timeCount = 60;
}

-(void)clickBgView:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

- (void)setUserInfo:(UMSocialUserInfoResponse *)userInfo{
    _userInfo = userInfo;
}


-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 11) {
        self.phoneT.text = [textField.text substringToIndex:11];
        [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
    }
    
    if (self.phoneT.text.length > 10 && self.codeT.text.length > 3) {
        self.confirmBtn.enabled = YES;
    }else{
        self.confirmBtn.enabled = NO;
    }
    
}



- (IBAction)getConfirmCodeBtn:(QMUIButton *)codeBtn {
    
    
    if (self.phoneT.text.length < 6)
    {
        [FanweMessage alert:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    
    codeBtn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timego) userInfo:nil repeats:YES];
    [self timego];

    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"send_mobile_verify_international" forKey:@"act"];
//    [parmDict setObject:@"1" forKey:@"wx_binding"];
    [parmDict setObject:self.phoneT.text forKey:@"mobile"];
    //area_code
    [parmDict setObject:SafeStr(self.areaModel.area_code) forKey:@"area_code"];
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

- (IBAction)clickConfirmBtn:(UIButton *)sender {
    
    if (self.phoneT.text.length < 6)
    {
        [FanweMessage alert:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    
    if (self.codeT.text.length == 0)
    {
        [FanweMessage alert:ASLocalizedString(@"验证码不能为空!")];
        return;
    }
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"bound_mobile" forKey:@"act"];
    [parmDict setObject:self.phoneT.text forKey:@"mobile"];
    [parmDict setObject:self.codeT.text forKey:@"code"];
    [parmDict setObject:self.areaModel.area_code forKey:@"tel_code"];
    [parmDict setObject:SafeStr(self.model.user_id) forKey:@"uid"];
    [parmDict setObject:SafeStr(self.model.access_token) forKey:@"access_token"];
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             if(self.bindSuccess)
             {
                 self.bindSuccess();
             }
             else
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

         }
     } FailureBlock:^(NSError *error) {
//         FWStrongify(self)
         [FanweMessage alertHUD:error.description];
     }];
    
    
    
}

- (IBAction)clickCancleBtn:(QMUIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
        [self.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"重新获取(%lds)"),(long)time] forState:UIControlStateNormal];
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




@end
