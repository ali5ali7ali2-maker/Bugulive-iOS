//
//  BGReadPackTableViewCell.m
//  BuguLive
//
//  Created by 志刚杨 on 2021/12/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGReadPackResultTableViewCell.h"

@implementation BGReadPackResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.avatar, 22);
    
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1"];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self);
        make.height.mas_equalTo(0.7);
    }];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
