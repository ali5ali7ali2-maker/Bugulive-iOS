//
//  BogoLogoutTextItmeCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/29.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoLogoutTextItmeCell.h"

@implementation BogoLogoutTextItmeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.dotView.layer.cornerRadius = 8 / 2;
    self.dotView.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
