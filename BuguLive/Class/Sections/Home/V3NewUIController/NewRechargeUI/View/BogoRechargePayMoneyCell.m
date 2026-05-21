//
//  BogoRechargePayTypeCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargePayMoneyCell.h"

@implementation BogoRechargePayMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.diamondBtn.spacingBetweenImageAndTitle = 5;
    self.diamondBtn.imagePosition = QMUIButtonImagePositionLeft;
    
    self.diamondBtn.userInteractionEnabled = NO;
    self.bgButton.userInteractionEnabled = NO;
}

- (void)setModel:(PayMoneyModel *)model{
    [self.diamondBtn setTitle:[NSString stringWithFormat:@"%ld",model.diamonds] forState:UIControlStateNormal];
    
    if([[[NSBundle mainBundle]bundleIdentifier] isEqualToString:@"com.zebo.zebolive"])
    {
        self.numberL.text = [NSString stringWithFormat:@"INR%@",model.money];

    }
    else
    {
        self.numberL.text = [NSString stringWithFormat:@"￥%@",model.money];

    }
    
    
    if (model.isSelect) {
        [self.bgButton setBackgroundImage:[UIImage imageNamed:@"bogo_recharge_money_select"] forState:UIControlStateNormal];
    }else{
        [self.bgButton setBackgroundImage:[UIImage imageNamed:@"bogo_recharge_money_normal"] forState:UIControlStateNormal];
    }
}

@end
