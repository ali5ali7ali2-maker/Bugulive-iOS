//
//  BogoGameListHeadCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoGameListHeadCell.h"

@implementation BogoGameListHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.topicTitleBtn.layer.cornerRadius = kRealValue(20 / 2);
    self.topicTitleBtn.layer.masksToBounds = NO;
    self.topicTitleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.imgView.layer.cornerRadius = 4;
    self.imgView.layer.masksToBounds = YES;
    self.backgroundColor = kClearColor;
    
    self.topicTitleBtn.titleLabel.numberOfLines = 0;

    
}

- (void)resetControlModel:(GameBottomListModel *)model{
    
    [self.topicTitleBtn setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
}

@end
