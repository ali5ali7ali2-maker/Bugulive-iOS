//
//  SetTableViewself.m
//  BuguLive
//
//  Created by GuoMs on 16/7/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SetTableViewCell.h"
#import "BogoNobleViewController.h"
@implementation SetTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.setText.textColor = self.loginBack.textColor = kAppGrayColor1;
    self.memoryText.textColor = kAppGrayColor3;
    
    self.labOutLogin.text = ASLocalizedString(@"退出登录");
    
//    NSString *is_noble_mysterious = [dic objectForKey:@"is_noble_mysterious"];
//    //是否是神秘人
//    if ([is_noble_mysterious integerValue] == 1){
//        //如果是
//        sender.head_image = [dic valueForKey:@"mysterious_picture"];
//        sender.nick_name = [dic valueForKey:@"mysterious_name"];
//    }
//
//    self.nobleOpenSwitch.onImage = [UIImage imageNamed:@"bogo_set_privite_on"];
//    self.nobleOpenSwitch.offImage = [UIImage imageNamed:@"bogo_set_privite_off"];
    
    self.nobleOpenSwitch.onTintColor = kAppNewMainColor;
    _nobleOpenSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [self.nobleOpenSwitch addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    self.line.hidden = YES;
}

- (void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
    if (indexRow == 0) {//隐身进场
        if ([[GlobalVariables sharedInstance].userModel.is_noble_mysterious isEqualToString:@"1"]) {
            self.nobleOpenSwitch.on = YES;
        }else{
            self.nobleOpenSwitch.on = NO;
        }
    }else if (indexRow == 1){//榜单隐身
        if ([[GlobalVariables sharedInstance].userModel.is_noble_ranking_stealth isEqualToString:@"1"]) {
            self.nobleOpenSwitch.on = YES;
        }else{
            self.nobleOpenSwitch.on = NO;
        }
    }
}

- (void)configurationCellWithSection:(NSInteger)section row:(NSInteger)row distribution_module:(NSString *)distribution_module
{
 
    
    
    self.indexRow = row;
    self.indexSection = section;
    self.nobleOpenSwitch.hidden = YES;
    if (section == 3)
    {
        self.setText.hidden = YES;
        self.memoryText.hidden = YES;
        self.comeBackIMG.hidden = YES;
        self.loginBack.textColor = kAppGrayColor1;
        
    }
    else
    {
        self.loginBack.hidden = YES;
    }
    
    if (section == 0)
    {
        NSArray *text = @[ASLocalizedString(@"帐号与安全")];
        self.setText.text = text[row];
    }
    else if (section == 1)
    {
        NSArray *sectionArr;
        if ([[GlobalVariables sharedInstance].appModel.open_noble isEqualToString:@"1"]) {
            sectionArr = @[ASLocalizedString(@"黑名单管理"),ASLocalizedString(@"隐私特权设置"),ASLocalizedString(@"消息推送设置"),ASLocalizedString(@"切换语言")];
        }else{
            sectionArr = @[ASLocalizedString(@"黑名单管理"),ASLocalizedString(@"消息推送设置"),ASLocalizedString(@"切换语言")];
        }
        self.setText.text = sectionArr[row];
    }
    else if (section == 2)
    {
        if (row == 2 || row == 1)
        {
            self.memoryText.hidden = NO;
        }
        NSArray *sectionArr  = @[ASLocalizedString(@"帮助与反馈"),ASLocalizedString(@"清理缓存"),ASLocalizedString(@"检查更新"),ASLocalizedString(@"关于我们")];
            
            if (row == 1) {
                [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                    self.memoryText.text = [NSString stringWithFormat:@"%ldMB",totalSize/1024/1024];
                }];
                
            }else if (row == 2) {
                NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
                self.memoryText.text = buildVersion;
//                VersionNum;
            }
        self.setText.text = sectionArr[row];
    }
}

-(void)onSwitchChanged:(UISwitch *)sender{
    
    NSString *actStr = @"";
    if (self.indexRow == 0) {//隐身进场
        actStr = @"is_noble_mysterious";
    }else{
        actStr = @"is_noble_ranking_stealth";
    }
    
    NSMutableDictionary * parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:actStr forKey:@"act"];
    if (sender.on) {
        [parmDict setObject:@"1" forKey:@"type"];
    }else{
        [parmDict setObject:@"0" forKey:@"type"];
    }
    
    [[NetHttpsManager manager]POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([[responseJson valueForKeyPath:@"status"]integerValue] == 0) {
            
            
            
            [FanweMessage alert:@"" message:[responseJson valueForKeyPath:@"error"] destructiveAction:^{
                BogoNobleViewController *vc = [BogoNobleViewController new];
                [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
            } cancelAction:^{
                
            }];
            
//            [BGHUDHelper alert:[responseJson valueForKeyPath:@"error"] action:^{
//
//            }];
            self.nobleOpenSwitch.on = NO;
        }else if([[responseJson valueForKeyPath:@"status"]integerValue] == 200){
            sender.on = !sender.on;
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
