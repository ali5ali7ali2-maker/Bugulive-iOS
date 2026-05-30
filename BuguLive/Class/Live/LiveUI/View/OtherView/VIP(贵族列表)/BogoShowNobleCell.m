//
//  BogoShowNobleCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/9.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoShowNobleCell.h"

@implementation BogoShowNobleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.rankImgView.hidden = self.concertBtn.hidden = NO;
    
    self.headImgView.layer.cornerRadius = 40 / 2;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHead:)];
    [self.headImgView addGestureRecognizer:tapHead];
    
}

-(void)clickHead:(UITapGestureRecognizer *)sender{
    if (self.clickHeadBlock) {
        self.clickHeadBlock(_model);
    }
}

- (void)resetModel:(MGShowVipModel *)model{
    _model = model;
    
    if ([model.uid isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
        model.is_noble_mysterious = @"0";
    }
    
    if (model.is_noble_mysterious.intValue == 1) {
        [self.headImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
        self.nickNameL.text = ASLocalizedString(@"神秘人");
        
        self.nobleImgView.hidden = self.rankImgView.hidden = self.concertBtn.hidden = YES;
        
        [self.nobleImgView sd_setImageWithURL:[NSURL URLWithString:model.noble_icon] placeholderImage:nil];
        
    }else{
        
        self.rankImgView.hidden = self.concertBtn.hidden = NO;
        
        [self.rankImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%@",model.user_level]]];
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
        self.nickNameL.text = model.nick_name;
        [self.nobleImgView sd_setImageWithURL:[NSURL URLWithString:model.noble_icon] placeholderImage:nil];
        
        if ([model.uid isEqualToString:[GlobalVariables sharedInstance].userModel.user_id]) {
            self.concertBtn.hidden = YES;
        }
        
        if (model.is_focus.intValue == 1) {
            [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"bogo_liveroom_noble_concert_Select"] forState:UIControlStateNormal];
        }else{
            [self.concertBtn setBackgroundImage:[UIImage imageNamed:@"bogo_liveroom_noble_concert_Normal"] forState:UIControlStateNormal];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickFocusBtn:(UIButton *)sender {
    
    
    if (self.model.is_noble_stealth.intValue == 1) {
        [FanweMessage alertHUD:ASLocalizedString(@"不能查看神秘人的信息")];
        return;
    }
    
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
    [dictM setObject:@"user" forKey:@"ctl"];
    [dictM setObject:@"follow" forKey:@"act"];
    [dictM setObject:self.model.uid forKey:@"to_user_id"];
    
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
     {
         
         if ([responseJson toInt:@"status"] == 1)
         {
             NSInteger has_focus = [responseJson toInt:@"has_focus"];
             if (has_focus == 1) {

                 
                 [sender setBackgroundImage:[UIImage imageNamed:@"bogo_liveroom_noble_concert_Select"] forState:UIControlStateNormal];

                 if (self.headViewAttentionBlock) {
                     self.headViewAttentionBlock(YES);
                 }
             }else{

                 [sender setBackgroundImage:[UIImage imageNamed:@"bogo_liveroom_noble_concert_Normal"] forState:UIControlStateNormal];
                 if (self.headViewAttentionBlock) {
                     self.headViewAttentionBlock(NO);
                 }
             }
         }
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}


@end
