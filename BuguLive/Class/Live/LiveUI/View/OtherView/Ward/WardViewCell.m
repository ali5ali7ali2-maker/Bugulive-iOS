//
//  WardViewCell.m
//  BuguLive
//
//  Created by 范东 on 2019/1/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "WardViewCell.h"
#import "WardPopViewModel.h"

@interface WardViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation WardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = kClearColor;
    self.contentView.backgroundColor = kClearColor;
    
    // Initialization code
}

- (void)setModel:(WardPopViewModel *)model{
    _model = model;
    
    if (model.nick_name.length > 10) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@...",[model.nick_name substringToIndex:10]];
    }else{
        self.nameLabel.text = model.nick_name;
    }
    
    
    self.sexImageView.image = [model.sex isEqualToString:@"1"] ? [UIImage imageNamed:@"com_male_selected"] : [UIImage imageNamed:@"com_female_selected"];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    [self.rankImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%@",model.user_level]]];
    if (model.total_diamonds.integerValue) {
        [self.moneyLabel setText:[NSString stringWithFormat:ASLocalizedString(@"消费%@%@"),model.total_diamonds,[GlobalVariables sharedInstance].appModel.diamond_name]];
    }else{
        [self.moneyLabel setText:[NSString stringWithFormat:ASLocalizedString(@"消费%@%@"),@"0",[GlobalVariables sharedInstance].appModel.diamond_name]];
    }
    self.timeLabel.text = [NSString stringWithFormat:ASLocalizedString(@"剩余%@"),model.endtime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
