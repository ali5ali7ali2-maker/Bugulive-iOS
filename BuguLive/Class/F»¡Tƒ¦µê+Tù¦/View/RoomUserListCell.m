//
//  RoomUserListCell.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/16.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomUserListCell.h"
#import "RoomUserInfo.h"

@interface RoomUserListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet CommonLevelView *levelView;
@property (weak, nonatomic) IBOutlet UIImageView *metalView;

@end

@implementation RoomUserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RoomUserInfo *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:nil];
    [self.nameLabel setText:model.nick_name];
    [self.sexImageView setImage:[UIImage imageNamed:model.sex.integerValue == 1 ? @"dy_sex_male" : @"dy_sex_female"]];
//    [self.levelView setLevel:model.level];
    [self.metalView sd_setImageWithURL:[NSURL URLWithString:model.medal_icon]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
