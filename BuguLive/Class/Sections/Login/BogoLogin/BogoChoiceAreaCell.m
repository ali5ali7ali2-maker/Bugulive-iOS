//
//  BogoChoiceAreaCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/25.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoChoiceAreaCell.h"

@implementation BogoChoiceAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoChoiceAreaModel *)model{
    
    self.countryL.text = model.country;
    self.numL.text = model.area_code;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
