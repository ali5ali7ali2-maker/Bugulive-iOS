//
//  LeaderboardTableViewCell.m
//  BuguLive
//
//  Created by yy on 16/10/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "LeaderboardTableViewCell.h"

@implementation LeaderboardTableViewCell
{
    GlobalVariables *_BuguLive;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _BuguLive = [GlobalVariables sharedInstance];
    self.nameLabel.textColor = kAppGrayColor1;
    self.numLabel.layer.cornerRadius = 2;
    self.numLabel.clipsToBounds = YES;
    self.ticketLabel.textColor = [UIColor colorWithHexString:@"#CC45FF"];
    self.contentView.backgroundColor = kWhiteColor;
}

- (void)createCellWithModel:(UserModel *)model withRow:(int)row withType:(int)type
{
    NSLog(@"createCellWithModel:(UserModel *)model withRow:(int)row withType:%d",type);
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    
    self.model = model;
    
    //名次
    self.numLabel.text = [NSString stringWithFormat:@"%d",row+4];
    //昵称
    self.nameLabel.text = model.nick_name;
    //头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    //认证
    if ([model.is_authentication intValue] == 2)
    {
        self.vImgView.hidden = NO;
        [self.vImgView sd_setImageWithURL:[NSURL URLWithString:model.v_icon]];
    }
    else
    {
        self.vImgView.hidden = YES;
    }
    //性别
    if ([model.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }
    else
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    //等级
    if ([model.user_level intValue] !=0)
    {
        self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@",model.user_level]];
    }
    else
    {
        self.rankImgView.image = [UIImage imageNamed:@"rank_1"];
    }
    //善券
    NSString *string = type <= 3 ? ASLocalizedString(@"贡献"): ASLocalizedString(@"获得");
    NSString *ticketName = type <= 3 ? _BuguLive.appModel.diamond_name : _BuguLive.appModel.ticket_name;
    self.ticketLabel.text = [NSString stringWithFormat:@"%@%@%@",string ,[self checkDiamondNum:model.ticket],ticketName];
    
    [self.concertBtn setTitle:@"" forState:UIControlStateNormal];
    if ([model.is_focus isEqualToString:@"1"]) {
        [self.concertBtn setTitle:ASLocalizedString(@"已关注")forState:UIControlStateNormal];
        [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"mg_new_rank_headBGGroup_Selected"] forState:UIControlStateNormal];
    }else{
        [self.concertBtn setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
        [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"mg_new_rank_headBGGroup"] forState:UIControlStateNormal];
    }
    
    if ([model.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId]) {
        self.concertBtn.hidden = YES;
    }else{
        self.concertBtn.hidden = NO;
    }
    
    
    if (model.is_noble_ranking_stealth.integerValue == 1) {
        
        self.nameLabel.text =ASLocalizedString(@"神秘人");
        
//        [NSString stringWithFormat:ASLocalizedString(@"神秘人%@"), model.user_id];
        //头像
        [self.headImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
        self.concertBtn.hidden = YES;
        self.rankImgView.hidden = self.sexImgView.hidden = YES;
    }else{
        self.concertBtn.hidden = NO;
        self.rankImgView.hidden = self.sexImgView.hidden = NO;
    }
    
    if ([model.user_id isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
        self.concertBtn.hidden = YES;
    }
    
}
-(NSString *)checkDiamondNum:(NSString *)num{
    
    NSString *numStr = @"";
    float numF = num.floatValue;
    if (numF > 10000) {
        numStr = [NSString stringWithFormat:ASLocalizedString(@"%.1f万"),floorf(numF/1000) / 10];
//        [NSString stringWithFormat:@"%.2f",num.floatValue];
    }else{
        numStr = [NSString stringWithFormat:@"%.0f",numF];
    }
    
    return numStr;
    
    
}


- (IBAction)clickAttentions:(UIButton *)sender {
    NSString *uid = self.model.user_id;
    
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"follow" forKey:@"act"];
    [dictM setObject:uid forKey:@"to_user_id"];
    
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         
         if ([responseJson toInt:@"status"] == 1)
         {
             NSInteger has_focus = [responseJson toInt:@"has_focus"];
             
             if (has_focus == 1) {
                 [sender setTitle:ASLocalizedString(@"已关注")forState:UIControlStateNormal];
                 [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"mg_new_rank_headBGGroup_Selected"] forState:UIControlStateNormal];
             }else{
                 [sender setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
                 [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"mg_new_rank_headBGGroup"] forState:UIControlStateNormal];
             }
             
         }
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
    
}

@end
