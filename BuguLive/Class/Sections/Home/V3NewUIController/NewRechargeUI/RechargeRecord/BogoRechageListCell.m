//
//  BogoRechageListCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechageListCell.h"

@implementation BogoRechageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoRechargeRecordModel *)model{
    
    self.rechargeTitleL.text = [NSString stringWithFormat:@"%@",model.content];
    self.timeL.text = [NSString stringWithFormat:@"%@",model.create_time];
    
    if (model.isRecharge) {
        self.coinL.text = [NSString stringWithFormat:@"+%@",model.diamonds];
    }else{
        self.coinL.text = [NSString stringWithFormat:@"-%@",model.diamonds];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
