//
//  CarCollectionViewCell.m
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "CarCollectionViewCell.h"

@implementation CarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        //选中时
        self.layer.borderColor = [UIColor orangeColor].CGColor;
        self.layer.borderWidth = 2;
        
    }else{
        //非选中
//        self.layer.borderColor = KHighlight.CGColor;
        self.layer.borderWidth = 0;
    }
}

-(void)setModel:(CarItemModel *)model
{
    _model = model;
    [self.carpic sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"no_pic"]];
    self.carname.text = model.name;
    self.carcoin.text = model.money;
    self.exp.text = [NSString stringWithFormat:ASLocalizedString(@"%@经验值"), model.experience];
}

@end
