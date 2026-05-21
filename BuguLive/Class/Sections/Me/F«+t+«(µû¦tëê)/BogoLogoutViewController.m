//
//  BogoLogoutViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/29.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoLogoutViewController.h"
#import "BogoChoiceAreaModel.h"
@interface BogoLogoutViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneT;
@property (weak, nonatomic) IBOutlet QMUIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeT;
@property (weak, nonatomic) IBOutlet QMUIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property(nonatomic, strong) BogoChoiceAreaModel *areaModel;


@end

@implementation BogoLogoutViewController{
    NSTimer                         *_timer;                //定时器
    int                             _timeCount;             //定时器时间
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.phoneT.delegate = self;
    [self.phoneT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneT.keyboardType = UIKeyboardTypeNumberPad;
    
    self.codeT.delegate = self;
    [self.codeT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.codeT.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.areaBtn.imagePosition = QMUIButtonImagePositionRight;
    self.areaBtn.spacingBetweenImageAndTitle = 3;
    self.topConstraint.constant = kStatusBarHeight;
    self.confirmBtn.enabled = NO;
    _timeCount = 60;
}

-(void)textFieldDidChange:(UITextField *)textField{
    if (self.phoneT.text.length > 11) {
        self.phoneT.text = [textField.text substringToIndex:11];
        [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
    }
    

    if (self.phoneT.text.length == 11 && self.codeT.text.length > 3) {
        self.confirmBtn.enabled = YES;
    }else{
        self.confirmBtn.enabled = NO;
    }
    
    
    
    
    
    
}



- (IBAction)clickCancleBtn:(QMUIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickAreaBtn:(QMUIButton *)sender {
    
}


- (IBAction)clickCodeBtn:(QMUIButton *)sender {
    
    
    if (self.phoneT.text.length == 0)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
        return;
    }
    
    if (self.phoneT.text.length < 1)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    
    if (![self.phoneT.text isEqualToString:_phoneNum]) {
        [FanweMessage alertHUD:ASLocalizedString(@"您输入的手机号与当前账号不符!")];
        return;
    }
    
    self.codeBtn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timego) userInfo:nil repeats:YES];
    [self timego];

    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"send_mobile_verify_international" forKey:@"act"];
//    [parmDict setObject:@"1" forKey:@"wx_binding"];
    [parmDict setObject:self.phoneT.text forKey:@"mobile"];
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] != 1)
         {
             self.codeBtn.enabled = YES;
             [self.codeBtn setTitle:ASLocalizedString(@"发送验证码") forState:UIControlStateNormal];
             [_timer invalidate];
             _timer = nil;
         }else{
             
         }
     } FailureBlock:^(NSError *error) {
         FWStrongify(self)
         [self hideMyHud];
         [self.codeBtn setTitle:ASLocalizedString(@"发送验证码") forState:UIControlStateNormal];
         [FanweMessage alert:ASLocalizedString(@"发送失败")];
         self.codeBtn.enabled = YES;
     }];
}

//注销
-(void)phoneUnsubscribe{
    
    if (![self.phoneT.text isEqualToString:_phoneNum]) {
        [FanweMessage alertHUD:ASLocalizedString(@"您输入的手机号与当前账号不符!")];
        return;
    }
    
    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"unsubscribe" forKey:@"act"];
    [parmDict setObject:self.phoneT.text forKey:@"mobile"];
    [parmDict setObject:self.codeT.text forKey:@"code"];
    
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             [self.navigationController popToRootViewControllerAnimated:NO];
             
             
             [[AppDelegate sharedAppDelegate] enterLoginUI];
             
         }else{
             
         }
        
         [FanweMessage alertHUD:[responseJson toString:@"error"]];
        
     } FailureBlock:^(NSError *error) {
         FWStrongify(self)
         [FanweMessage alertHUD:error.description];
         [self hideMyHud];
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

- (IBAction)clickConfrimBtn:(id)sender {
    
    if (self.phoneT.text.length == 0)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"请输入手机号!")];
        return;
    }
    
    if (self.phoneT.text.length < 1)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
        return;
    }
    
    [FanweMessage alert:@"" message:ASLocalizedString(@"确认注销该账户?") destructiveAction:^{
        [self phoneUnsubscribe];
    } cancelAction:^{
        
    }];
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
