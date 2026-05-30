//
//  BogoNoblePayCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNoblePayCell.h"

@implementation BogoNoblePayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.diamondBtn.spacingBetweenImageAndTitle = 5;
    self.diamondBtn.imagePosition = QMUIButtonImagePositionLeft;
    
    self.diamondBtn.userInteractionEnabled = NO;
    self.bgButton.userInteractionEnabled = NO;
}

- (void)setModel:(BogoNoblePayListModel *)model{
    
    [self.diamondBtn setTitle:[NSString stringWithFormat:@"%@",model.money] forState:UIControlStateNormal];
    self.numberL.text = [NSString stringWithFormat:@"%@%@",model.day,model.unit];

    if (model.isSelect) {
        [self.bgButton setBackgroundImage:[UIImage imageNamed:@"bogo_noble_money_select"] forState:UIControlStateNormal];
    }else{
        [self.bgButton setBackgroundImage:[UIImage imageNamed:@"bogo_noble_money_normal"] forState:UIControlStateNormal];
    }
    
}



@end
