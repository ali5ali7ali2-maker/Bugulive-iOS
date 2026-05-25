//
//  BogoDTHeadCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoDTHeadCell.h"

@implementation BogoDTHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.topicTitleBtn.layer.cornerRadius = 4;
    self.topicTitleBtn.layer.masksToBounds = YES;
    self.topicTitleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.imgView.layer.cornerRadius = 4;
    self.imgView.layer.masksToBounds = YES;
    
}

- (void)resetControlModel:(MGDynamicTopicModel *)model{
    
    [self.topicTitleBtn setTitle:[NSString stringWithFormat:@"  #%@  ",model.name] forState:UIControlStateNormal];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
}

@end
