//
//  GainsWithdrawVC.m
//  BuguLive
//
//  Created by hym on 2016/11/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GainsWithdrawVC.h"
#import "IncomeViewController.h"
#import "ReactiveObjC.h"
#import "SChargerVC.h"
#import "ReceiverRecordViewController.h"
@interface GainsWithdrawVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbAllTickets;
@property (weak, nonatomic) IBOutlet UILabel *lbTodayTickets;
@property (weak, nonatomic) IBOutlet UITextField *tfWithdrawTickets;
@property (weak, nonatomic) IBOutlet UIButton *btnAffirm;
@property (weak, nonatomic) IBOutlet UILabel *lbRatioTickets;

@property (assign, nonatomic) CGFloat ratio;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (weak, nonatomic) IBOutlet UILabel *canGetLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UILabel *withdrawDepositLbl;
@property (weak, nonatomic) IBOutlet UILabel *labArrivalTime;
@property(nonatomic, strong) NSString *withdrawalType;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation GainsWithdrawVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self withdrawDeposit];
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [releaseButton setTitle:ASLocalizedString(@"提现记录") forState:normal];
            [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
            self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    [releaseButton setTitleColor:RGB(11, 11, 11) forState:UIControlStateNormal];
    
    self.title = ASLocalizedString(@"提现");
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                             itemWithTarget:self
                                             action:@selector(backToVC)
                                             image:@"com_arrow_vc_back"
                                             highImage:@"com_arrow_vc_back"];
    
//    self.btnAffirm.layer.borderColor = kAppMainColor.CGColor;
//    [self.btnAffirm setBackgroundColor:kAppMainColor];
    [self.btnAffirm setBackgroundImage:[UIImage imageNamed:@"mg_button_global"] forState:UIControlStateNormal];
    [self.btnAffirm setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
//    self.btnAffirm.layer.borderWidth = 1.0f;
    self.btnAffirm.layer.cornerRadius = self.btnAffirm.frame.size.height/2.0f;
    self.btnAffirm.layer.masksToBounds = YES;
    
    [self.editBtn setBackgroundImage:[UIImage imageNamed:@"mg_button_global"] forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
//    self.btnAffirm.layer.borderWidth = 1.0f;
    self.editBtn.layer.cornerRadius = self.editBtn.frame.size.height/2.0f;
    self.editBtn.layer.masksToBounds = YES;
    
    
    
    self.tfWithdrawTickets.keyboardType = UIKeyboardTypeDecimalPad;
    self.view.backgroundColor = kBackGroundColor;
    self.lbRatioTickets.text = @"0";
    self.tfWithdrawTickets.delegate = self;
//    [self.tfWithdrawTickets addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    //注意：事件类型是：`UIControlEventEditingChanged`
    _httpManager = [NetHttpsManager manager];
    
    //添加手势
    self.labArrivalTime.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.labArrivalTime addGestureRecognizer:tapGesture];
    
//    [RACObserve(self, withdrawalType) subscribeNext:^(NSString *x) {
//        if([x isEqualToString:@"1"])
//        {
//            self.labArrivalTime.text = @"48小时到账";
//        }
//        else
//        {
//            self.labArrivalTime.text = @"一周到账";
//        }
//        
//        [self passConTextChange:nil];
//    }];
    
    self.withdrawalType = @"1"; //一周到账
    
    [self reqData];
    [self setUpLocalizationString];
}

- (IBAction)editInfo:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@&token=%@",[GlobalVariables sharedInstance].appModel.h5_url.withdrawal_account_url,[GlobalVariables sharedInstance].token];

      
      BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:url isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
      [self.navigationController pushViewController:tmpController animated:NO];
}

- (void)releaseInfo {
    
    ReceiverRecordViewController *receiveVC =[[ReceiverRecordViewController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:receiveVC animated:YES];
//    SChargerVC *chargerVC = [[SChargerVC alloc]init];
//    chargerVC.recordIndex = 0;
//    chargerVC.feeIndex = [GlobalVariables sharedInstance].appModel.live_pay_time ? 0:1;
//    [[AppDelegate sharedAppDelegate] pushViewController:chargerVC animated:YES];
    
//    NSString *tmpUrlStr = [GlobalVariables sharedInstance].appModel.h5_url.withdrawal_account_url;
//    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
//    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    FDActionSheet *alert = [[FDActionSheet alloc] initWithTitle:@"" message:nil];
    
    
    [alert addAction:[FDAction actionWithTitle:@"一周到账" type:FDActionTypeDefault CallBack:^{
        self.withdrawalType = @"2";
    }]];
    
    [alert addAction:[FDAction actionWithTitle:@"48小时到账" type:FDActionTypeDefault CallBack:^{
        self.withdrawalType = @"1";

    }]];
    
    [alert addAction:[FDAction actionWithTitle:@"取消" type:FDActionTypeCancel CallBack:^{
        
    }]];
    
    [alert show:self.view];
    
}

- (void)withdrawDeposit
{
    NSString *ticketName = [GlobalVariables sharedInstance].appModel.ticket_name;
    self.totalLbl.text = [NSString stringWithFormat:ASLocalizedString(@"%@"),ticketName];
    self.canGetLbl.text = [NSString stringWithFormat:ASLocalizedString(@"今日可领%@数"),ticketName];
    self.withdrawDepositLbl.text = [NSString stringWithFormat:ASLocalizedString(@"%@提现金额"),ticketName];
}

- (void)backToVC {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)reqData {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"money_carry_alipay" forKey:@"act"];
    [parmDict setObject:@"type" forKey:self.withdrawalType];;

    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] ==1) {
             _ratio = [responseJson toFloat:@"ratio"];
             _lbAllTickets.text = [NSString stringWithFormat:@"%d",([responseJson toInt:@"can_use_ticket"])];
             _lbTodayTickets.text = [responseJson toString:@"day_ticket_max"];
         }else {
             
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tfWithdrawTickets resignFirstResponder];
}

- (IBAction)onClick:(id)sender
{
    if ([_tfWithdrawTickets.text integerValue] == 0)
    {
//        [FanweMessage alertHUD:[NSString stringWithFormat:ASLocalizedString(@"请输入要提现的%@数"),[GlobalVariables sharedInstance].appModel.ticket_name]];
        [FanweMessage alert:[NSString stringWithFormat:ASLocalizedString(@"请输入要提现的%@数"),[GlobalVariables sharedInstance].appModel.ticket_name]];
        return;
    }
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"submit_refund_alipay" forKey:@"act"];
    [parmDict setObject:_tfWithdrawTickets.text forKey:@"ticket"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] ==1)
         {
             for (UIViewController *vc in self.navigationController.viewControllers)
             {
                 if ([vc isKindOfClass:[IncomeViewController class]])
                 {
                     [self.navigationController popToViewController:vc animated:YES];
                 }
                 [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"提现成功")];
             }
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    
    if (res) {
        
    }
    
    return res;
}

//- (void)passConTextChange:(id)sender{
//    if ([self.tfWithdrawTickets.text length] == 0) {
//        _lbRatioTickets.text = ASLocalizedString(@"0元");
//    }else {
//        float ratio2 = self.model.ticket_catty_ratio.floatValue;
//
//        if([self.withdrawalType isEqualToString:@"2"])
//        {
//            ratio2 = self.model.week_ticket_catty_ratio.floatValue;
//        }
//
//       _lbRatioTickets.text = [NSString stringWithFormat:ASLocalizedString(@"%0.2lf元"),(ratio2 * [self.tfWithdrawTickets.text integerValue])];
//    }
//
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
