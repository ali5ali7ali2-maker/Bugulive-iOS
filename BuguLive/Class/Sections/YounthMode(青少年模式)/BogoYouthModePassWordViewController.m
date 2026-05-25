//
//  BogoYouthModePassWordViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/11.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoYouthModePassWordViewController.h"
#import "BogoDelTextfield.h"
#import "BogoYoungModeBlindPhoneVC.h"
#import "BogoYoungModeVideoViewController.h"

#import "MBProgressHUD+MJ.h"

#import "BogoNetworkKit.h"

@interface BogoYouthModePassWordViewController ()<UITextFieldDelegate,ZTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet BogoDelTextfield *firstT;
@property (weak, nonatomic) IBOutlet BogoDelTextfield *secondT;
@property (weak, nonatomic) IBOutlet BogoDelTextfield *thirdT;
@property (weak, nonatomic) IBOutlet BogoDelTextfield *fourthT;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UIButton *changePasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


@property(nonatomic, strong) NSMutableArray *itemTextArr;

@end

@implementation BogoYouthModePassWordViewController


- (instancetype)initWithYounthType:(BOGO_YOUNTH_TYPE)type{
    BogoYouthModePassWordViewController *vc = [BogoYouthModePassWordViewController new];
    vc.type = type;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = ASLocalizedString(@"青少年模式");
    [self backBtnWithBlock];
    
    
    [self setUpView];
    
    
    self.firstT.delegate = self;
    self.secondT.delegate = self;
    self.thirdT.delegate = self;
    self.fourthT.delegate = self;
    
    self.firstT.z_delegate = self;
    self.secondT.z_delegate = self;
    self.thirdT.z_delegate = self;
    self.fourthT.z_delegate = self;
    
    self.confirmBtn.enabled = NO;
    
    [self.firstT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.secondT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.thirdT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.fourthT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    [self replaceChangeType];
    
    [self.changePasswordBtn setTitle:ASLocalizedString(@"修改密码") forState:UIControlStateNormal];
    [self.changePasswordBtn setTitle:ASLocalizedString(@"忘记密码") forState:UIControlStateNormal];
}

-(void)replaceChangeType{
    
    NSString *contentStr = ASLocalizedString(@"启动青少年模式需要先设置独立密码，修改或者关闭青少年模式都需要此密码。");
    
    if (self.type == BOGO_YOUNTH_TYPE_PASSWORD_SET) {
        self.navigationItem.title = ASLocalizedString(@"设置密码");
        contentStr = ASLocalizedString(@"启动青少年模式需要先设置独立密码，修改或者关闭青少年模式都需要此密码。");
    }else if (self.type == BOGO_YOUNTH_TYPE_PASSWORD_CONFIRM) {
        self.navigationItem.title = ASLocalizedString(@"确认密码");
        contentStr = ASLocalizedString(@"请再次确认密码");
    }else if (self.type == BOGO_YOUNTH_TYPE_PASSWORD_CLOSE) {
        self.navigationItem.title = ASLocalizedString(@"关闭青少年模式");
        contentStr = ASLocalizedString(@"关闭青少年模式，需输入密码进行确认");
        
        self.changePasswordBtn.hidden = self.forgetBtn.hidden = NO;
        
    }else if (self.type == BOGO_YOUNTH_TYPE_PASSWORD_INPUTORIGIN) {
        self.navigationItem.title = ASLocalizedString(@"输入密码");
        contentStr = ASLocalizedString(@"请输入原密码");
    }
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;  //设置行间距
    paragraphStyle.lineBreakMode = _contentL.lineBreakMode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];

    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    _contentL.attributedText = attributedString;
    
}

- (void)backBtnWithBlock
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}

-(void)setUpView{
    
    self.itemTextArr = [NSMutableArray array];
    
}

- (IBAction)clickTagBtn:(UIButton *)sender {
    switch (self.itemTextArr.count) {
        case 0:
            [self.firstT becomeFirstResponder];
            break;
        case 1:
            [self.secondT becomeFirstResponder];
            break;
        case 2:
            [self.thirdT becomeFirstResponder];
            break;
        case 3:
            [self.fourthT becomeFirstResponder];
            break;
        case 4:
            [self.fourthT becomeFirstResponder];
            break;
        default:
            break;
    }
}

-(void)zTextFieldDeleteBackward:(BogoDelTextfield *)textField{
    
    NSString *string = textField.text;
    NSInteger arrCount = self.itemTextArr.count;
    
    if ([string isEqualToString:@""]) {
        [self.itemTextArr removeLastObject];
        arrCount = self.itemTextArr.count - 1;
    }
    
    switch (arrCount) {
        case 0:
            [self.firstT becomeFirstResponder];
            break;
        case 1:
            [self.secondT becomeFirstResponder];
            break;
        case 2:
            [self.thirdT becomeFirstResponder];
            break;
        case 3:
            [self.fourthT becomeFirstResponder];
            break;
        default:
            break;
    }
}


-(void)textFieldDidChange:(UITextField *)textField{
    
    NSString *text = textField.text;
    
    NSInteger arrCount = self.itemTextArr.count;
    
    if ([text isEqualToString:@""]) {
//        [self.itemTextArr removeLastObject];
//        arrCount = self.itemTextArr.count - 1;
        return;
    }else{
        
        if (text.length > 1) {
            textField.text = [text substringWithRange:NSMakeRange(0, 1)];
            text = [text substringFromIndex:1];
        }
        
        [self.itemTextArr addObject:text];
        arrCount = self.itemTextArr.count;
    }
    
    switch (arrCount) {
        case 0:
            [self.firstT becomeFirstResponder];
            
            break;
        case 1:
            self.firstT.text = self.itemTextArr[0];
            [self.secondT becomeFirstResponder];
            break;
        case 2:
            self.secondT.text = self.itemTextArr[1];
            [self.thirdT becomeFirstResponder];
            break;
        case 3:
            self.thirdT.text = self.itemTextArr[2];
            [self.fourthT becomeFirstResponder];
            break;
        case 4:
            self.fourthT.text = self.itemTextArr[3];
            [self.fourthT becomeFirstResponder];
            break;
        default:
            break;
    }
    
    self.confirmBtn.enabled = self.itemTextArr.count == 4;
    
    if (self.confirmBtn.enabled) {
        [self.view endEditing:YES];
    }
    
}

- (IBAction)clickConfirmBtn:(UIButton *)sender {
    
    __block BogoYouthModePassWordViewController *vc;
    
    if (self.type == BOGO_YOUNTH_TYPE_PASSWORD_SET) {
        
        vc = [[BogoYouthModePassWordViewController alloc]initWithYounthType:BOGO_YOUNTH_TYPE_PASSWORD_CONFIRM];
        vc.phone = [self.itemTextArr componentsJoinedByString:@","];
        
        
    }else if (self.type == BOGO_YOUNTH_TYPE_PASSWORD_CONFIRM) {
        
        NSString *phoneStr = [self.itemTextArr componentsJoinedByString:@","];
        if (![phoneStr isEqualToString:self.phone]) {
            
            [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"两次密码不一致")];
            
//             showError:ASLocalizedString(@"两次密码不一致")];
            
            return;
        }
        
        self.phone  = [self.phone stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:self.phone forKey:@"password"];
        [[BogoNetwork shareInstance]GET:@"young/setYoung" param:paramDic success:^(BogoNetworkResponseModel * _Nonnull result) {
            [GlobalVariables sharedInstance].userModel.is_open_young = @"1";
            NSMutableDictionary *hotDic = [NSMutableDictionary dictionary];
            
            [hotDic setObject:@"1" forKey:@"order"];
            [hotDic setObject:@"0" forKey:@"cate"];
            
            BogoYoungModeVideoViewController *vc = [BogoYoungModeVideoViewController new];
            vc.isHaveNavBar = NO;
            vc.paramDict = hotDic;
            vc.notHaveTabbar = NO;
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];

        
        
        
        
    }else if (self.type == BOGO_YOUNTH_TYPE_PASSWORD_CLOSE) {
//        /shopapi/young/closeYoung?token=499bf32dd443dbbb57156d295057e5c7&password=123456
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:[NSString stringWithFormat:@"%@%@%@%@",self.firstT.text,self.secondT.text,self.thirdT.text,self.fourthT.text] forKey:@"password"];
        [[BogoNetwork shareInstance]GET:@"young/closeYoung" param:paramDic success:^(BogoNetworkResponseModel * _Nonnull result) {
            [GlobalVariables sharedInstance].isShutDownYoung = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
        
        return;
        
        
    }else if (self.type == BOGO_YOUNTH_TYPE_PASSWORD_INPUTORIGIN) {
//        /shopapi/young/editYoung?token=499bf32dd443dbbb57156d295057e5c7&old_password=111111
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:[NSString stringWithFormat:@"%@%@%@%@",self.firstT.text,self.secondT.text,self.thirdT.text,self.fourthT.text] forKey:@"old_password"];
        [[BogoNetwork shareInstance]GET:@"young/editYoung" param:paramDic success:^(BogoNetworkResponseModel * _Nonnull result) {
            
            vc = [[BogoYouthModePassWordViewController alloc]initWithYounthType:BOGO_YOUNTH_TYPE_PASSWORD_SET];
            vc.phone = [self.itemTextArr componentsJoinedByString:@","];
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:self.view];
        }];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickChangeBtn:(UIButton *)sender {
    BogoYouthModePassWordViewController *vc = [[BogoYouthModePassWordViewController alloc]initWithYounthType:BOGO_YOUNTH_TYPE_PASSWORD_INPUTORIGIN];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickForgetBtn:(UIButton *)sender {
    BogoYoungModeBlindPhoneVC *vc = [BogoYoungModeBlindPhoneVC new];
    [self.navigationController pushViewController:vc animated:YES];
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
