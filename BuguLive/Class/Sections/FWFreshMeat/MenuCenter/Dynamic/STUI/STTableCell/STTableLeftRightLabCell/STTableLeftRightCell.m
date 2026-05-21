//
//  STTableLeftRightLabCell.m
//  BuguLive
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableLeftRightCell.h"

@implementation STTableLeftRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftLab.hidden = YES;
    
    
    QMUIButton *leftBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
           leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

           [leftBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
           leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
           [leftBtn setTitle:ASLocalizedString(@"选择商品")forState:UIControlStateNormal];
           leftBtn.imagePosition = QMUIButtonImagePositionLeft;
           [leftBtn setImage:[UIImage imageNamed:@"选择商品"] forState:UIControlStateNormal];
           leftBtn.spacingBetweenImageAndTitle = 15;
           leftBtn.userInteractionEnabled = NO;
    self.leftBtn = leftBtn;
    [self addSubview:self.leftBtn];

    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(@0);
        make.width.equalTo(@110);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
