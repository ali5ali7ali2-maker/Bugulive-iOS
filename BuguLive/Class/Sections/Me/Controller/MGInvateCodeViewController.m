//
//  MGInvateCodeViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/1/15.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGInvateCodeViewController.h"

@interface MGInvateCodeViewController ()

@property(nonatomic, strong) UITextField *textField;

@end

@implementation MGInvateCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = ASLocalizedString(@"邀请码");
    [self backBtnWithBlock];
    [self setUpView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)backBtnWithBlock
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}

-(void)setUpView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenW, kRealValue(44))];
    bgView.backgroundColor = kWhiteColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kRealValue(80), kRealValue(44))];
    label.text = ASLocalizedString(@"邀请码");
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kBlackColor;
    label.font = [UIFont systemFontOfSize:15];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = ASLocalizedString(@"请输入邀请码");
    textField.frame = CGRectMake(label.right, 0, kScreenW - kRealValue(80 * 2), kRealValue(44));
    textField.font = [UIFont systemFontOfSize:15];
    _textField = textField;
    
    [self.view addSubview:bgView];
    [bgView addSubview:label];
    [bgView addSubview:textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, bgView.bottom + kRealValue(80), kRealValue(180), kRealValue(40));
    btn.centerX = kScreenW / 2;
    [btn setTitle:ASLocalizedString(@"提交")forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"mg_hm_topBgImgView"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)clickBtn:(UIButton *)sender
{
    
    if ([BGUtils isBlankString:self.textField.text]) {
        [BGHUDHelper alert:ASLocalizedString(@"邀请码不能为空")];
        return;
    }

    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"login" forKey:@"ctl"];
    [mDict setObject:@"invitation" forKey:@"act"];
    [mDict setObject:self.textField.text forKey:@"invitation_id"];
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
        {
            [FanweMessage alert:ASLocalizedString(@"提交成功")];
        }
        else
        {
//            [BGHUDHelper alert:[responseJson valueForKey:@"error"] action:^{
//
//            }];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
    //
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
