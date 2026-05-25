//
//  BogoYoungModeBlindPhoneVC.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoYoungModeBlindPhoneVC.h"
#import "BogoYouthModePassWordViewController.h"
#import "BogoNetworkKit.h"
#import "AccSecModel.h"

#import "AccSecModel.h"


@interface BogoYoungModeBlindPhoneVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *mobileBtn;
@property (weak, nonatomic) IBOutlet UITextField *blindT;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeT;



@end

@implementation BogoYoungModeBlindPhoneVC{
    NSTimer                         *_timer;                //定时器
    int                             _timeCount;             //定时器时间
}

- (instancetype)initWithBlindType:(BOGO_YOUNTH_BLIND_TYPE)type{
    BogoYoungModeBlindPhoneVC *vc = [BogoYoungModeBlindPhoneVC new];
    vc.type = type;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    [self.navigationItem setHidesBackButton:YES animated:YES];
//
//    self.navigationItem.leftBarButtonItem = nil;

    _timeCount = 60;
    
    [self setupBackBtnWithBlock:nil];
    [self replaceChangeType];
    if (StrValid(self.phoneNum)) {
        
        [self clickCodeBtn:self.codeBtn];
        
    }
}

- (void)setPhoneNum:(NSString *)phoneNum{
    _phoneNum = phoneNum;
    [self replaceChangeType];
    
    
}

-(void)replaceChangeType{
    
    NSString *contentStr = ASLocalizedString(@"启动青少年模式需要先设置独立密码，修改或者关闭青少年模式都需要此密码。");
    
    
    if (self.type == BOGO_YOUNTH_BLIND_TYPE_PHONE) {
        self.navigationItem.title = ASLocalizedString(@"验证手机号");
        contentStr = ASLocalizedString(@"请输入绑定的手机号，通过验证码验证后，即可关闭青少年模式。");
        
        [self.nextBtn setTitle:ASLocalizedString(@"下一步") forState:UIControlStateNormal];
        self.codeView.hidden = YES;
        
    }else if (self.type == BOGO_YOUNTH_BLIND_TYPE_CODE) {
        self.navigationItem.title = ASLocalizedString(@"输入验证码");
        contentStr = [NSString stringWithFormat:@"%@%@",ASLocalizedString(@"验证码已发送至"),self.phoneNum];
        [self.nextBtn setTitle:ASLocalizedString(@"确定") forState:UIControlStateNormal];
        self.codeView.hidden = NO;
    }
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;  //设置行间距
    paragraphStyle.lineBreakMode = _titleLabel.lineBreakMode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];

    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    _titleLabel.attributedText = attributedString;
    
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
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%@(%lds)",ASLocalizedString(@"重新获取"), (long)time] forState:UIControlStateDisabled];
//        [self.loginView.codeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateDisabled];
        _timeCount --;
    }else if(time == 0)
    {
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"获取验证码")] forState:UIControlStateNormal];
        [_timer invalidate];
        _timeCount = 60;
    }
}

- (IBAction)clickCodeBtn:(UIButton *)sender {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timego) userInfo:nil repeats:YES];
    [self timego];
    self.codeBtn.enabled = NO;

    FWWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"send_mobile_verify_international" forKey:@"act"];
//    [parmDict setObject:@"1" forKey:@"wx_binding"];
    [parmDict setObject:self.phoneNum forKey:@"mobile"];
    [self showMyHud];
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] != 1)
         {
             self.codeBtn.enabled = YES;
             [self.codeBtn setTitle:ASLocalizedString(@"发送验证码") forState:UIControlStateNormal];
             [_timer invalidate];
             _timer = nil;
         }
     } FailureBlock:^(NSError *error) {
         FWStrongify(self)
         [self hideMyHud];
         [self.codeBtn setTitle:ASLocalizedString(@"发送验证码") forState:UIControlStateNormal];
         [FanweMessage alert:ASLocalizedString(@"发送失败")];
         self.codeBtn.enabled = YES;
     }];
    
}


- (IBAction)clickNextBtn:(UIButton *)sender {
    
    if (self.type == BOGO_YOUNTH_BLIND_TYPE_PHONE) {
        if (self.blindT.text.length < 1) {
            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"手机号限制11位数!")];
            return;
        }
        

        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:@"settings" forKey:@"ctl"];
        [dict setValue:@"security" forKey:@"act"];
        [dict setObject:[IMAPlatform sharedInstance].host.imUserId forKey:@"to_user_id"];
        [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
            
            AccSecModel *model = [AccSecModel mj_objectWithKeyValues:responseJson];
            if ([model.mobile isEqualToString:self.blindT.text]) {
                BogoYoungModeBlindPhoneVC *vc = [[BogoYoungModeBlindPhoneVC alloc]initWithBlindType:BOGO_YOUNTH_BLIND_TYPE_CODE];
                vc.phoneNum = self.blindT.text;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"输入的手机号与绑定的手机号不一致")];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
        
        
    }else if (self.type == BOGO_YOUNTH_BLIND_TYPE_CODE){
//        /shopapi/young/forgetPass?token=499bf32dd443dbbb57156d295057e5c7&phone=15053896991&code=8966
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:self.phoneNum forKey:@"phone"];
        [paramDic setObject:self.codeT.text forKey:@"code"];
        [[BogoNetwork shareInstance]GET:@"young/forgetPass" param:paramDic success:^(BogoNetworkResponseModel * _Nonnull result) {
            [GlobalVariables sharedInstance].isShutDownYoung = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            

        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
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
