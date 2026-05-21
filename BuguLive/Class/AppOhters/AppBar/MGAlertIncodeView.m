//
//  MGAlertIncodeView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/8/24.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "MGAlertIncodeView.h"

@implementation MGAlertIncodeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    
    CGFloat textFieldHeight = kRealValue(48);
    
    self.bgImgView = [UIImageView new];
    self.bgImgView.image = [UIImage imageNamed:@"mg_tab_inviteCode_bg"];
    self.bgImgView.userInteractionEnabled = YES;
    [self addSubview:self.bgImgView];
    
    self.titleImgView = [UILabel new];
//    self.titleImgView.image = [UIImage imageNamed:@"mg_tab_inviteCode"];
    [self.bgImgView addSubview:self.titleImgView];
    
    self.titleImgView.text = ASLocalizedString(@"请填写邀请码");
    self.titleImgView.textColor = kWhiteColor;
    self.titleImgView.font = [UIFont boldSystemFontOfSize:16];
    self.titleImgView.userInteractionEnabled = YES;
    
    
    self.textImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mg_tab_inviteCodeTextImage"]];
    self.textImgView.userInteractionEnabled = YES;
    [self.bgImgView addSubview:self.textImgView];
    
    self.textField = [UITextField new];
    self.textField.placeholder = ASLocalizedString(@"请填写邀请码");
//    self.textField.backgroundColor = kWhiteColor;
//    self.textField.layer.cornerRadius = textFieldHeight / 2;
//    self.textField.layer.masksToBounds = YES;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textImgView addSubview:self.textField];
    
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleBtn setTitle:ASLocalizedString(@"取消")forState:UIControlStateNormal];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"#A885F5"] forState:UIControlStateNormal];
    self.cancleBtn.tag = 1000 + 0;
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:self.cancleBtn];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:ASLocalizedString(@"确定")forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#A885F5"] forState:UIControlStateNormal];
    self.confirmBtn.tag = 1000 + 1;
    [self.confirmBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:self.confirmBtn];
    
    
    self.bgImgView.frame = CGRectMake(0, 0, kRealValue(291), kRealValue(193));
    self.bgImgView.centerX = kScreenW / 2;
    self.bgImgView.centerY = kScreenH / 2;
    
    self.titleImgView.frame = CGRectMake(0, kRealValue(39), kRealValue(140), kRealValue(29));
    self.textImgView.frame = CGRectMake(0, self.titleImgView.bottom + kRealValue(26), kRealValue(235), textFieldHeight);
    self.textField.frame = self.textImgView.bounds;
    self.textField.width = self.textImgView.width - kRealValue(30);
//    CGRectMake(0, self.titleImgView.bottom + kRealValue(26), kRealValue(230), textFieldHeight);
    self.cancleBtn.frame = CGRectMake(0, self.textImgView.bottom, self.bgImgView.width / 2, kRealValue(40));
    self.confirmBtn.frame = CGRectMake(0, self.textImgView.bottom, self.bgImgView.width / 2, kRealValue(40));
    
    self.textField.centerX = self.textImgView.width / 2;
    self.textImgView.centerX = self.titleImgView.centerX = self.bgImgView.width / 2;
    self.cancleBtn.right = self.bgImgView.width / 2;
    self.confirmBtn.left = self.bgImgView.width / 2;
}

-(void)btnClick:(UIButton *)sender{
    
    [self.textField resignFirstResponder];
    
    if (sender == self.confirmBtn && self.textField.text.length < 1) {
        [FanweMessage alert:ASLocalizedString(@"邀请码不能为空")];
        
        return;
    }else if (sender == self.confirmBtn && self.textField.text.length > 1){
        
        [self postCode:self.textField.text];
        
    }
    
    if (self.clickBlock && sender == self.cancleBtn) {
        self.clickBlock(sender.tag - 1000);
    }
}


-(void)postCode:(NSString *)code
{
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"login" forKey:@"ctl"];
    [mDict setObject:@"invitation" forKey:@"act"];
    [mDict setObject:code forKey:@"invitation_id"];
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
            
        {
            self.clickBlock(0);
            [FanweMessage alert:ASLocalizedString(@"提交成功")];
            
        }
        else
        {
            [FanweMessage alert:[responseJson valueForKey:@"error"]];
//            __block UITextField *tf = nil;
//            
//            [BGHUDHelper alert:[responseJson valueForKey:@"error"] action:^{
//                [LEEAlert alert].config
//                .LeeTitle(ASLocalizedString(@"邀请码"))
//                .LeeAddTextField(^(UITextField *textField) {
//                    
//                    // 这里可以进行自定义的设置
//                    textField.placeholder = ASLocalizedString(@"请输入邀请码");
//                    
//                    textField.textColor = [UIColor darkGrayColor];
//                    
//                    tf = textField; //赋值
//                })
//                .LeeAction(ASLocalizedString(@"确定"), ^{
//                    
//                    
//                    if(tf.text == nil || tf.text.length < 1)
//                    {
//                        //                             [self checkCode];
//                        [BGHUDHelper alert:ASLocalizedString(@"邀请码不能为空")action:^{
//                            [self checkCode];
//                        }];
//                        //                            [BGHUDHelper alert:ASLocalizedString(@"邀请码不能为空")];
//                        return;
//                    }
//                    
//                    [self postCode:tf.text];
//                    [tf resignFirstResponder];
//                })
//                // 点击事件的Block如果不需要可以传nil
//                .LeeShow();
//            }];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
    //
}

@end
