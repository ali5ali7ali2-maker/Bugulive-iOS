//
//  BogoSearchHistoryCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchHistoryCell.h"

@implementation BogoSearchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headImgView.layer.cornerRadius = self.imgWidthConstraint.constant / 2;
    self.headImgView.layer.masksToBounds = YES;
}

- (void)setModel:(LivingModel *)model{
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] completed:nil];
    self.nickNameL.text = model.nick_name;
    self.idLabel.text = model.id;
}





@end
