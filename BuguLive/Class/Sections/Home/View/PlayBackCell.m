//
//  PlayBackCell.m
//  BuguLive
//
//  Created by 范东 on 2019/1/14.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "PlayBackCell.h"
#import "HMHotItemModel.h"

@implementation PlayBackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HMHotItemModel *)model{
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    self.watchCountLabel.text = model.watch_number_format;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.nameLabel.text = model.nick_name;
    self.contentLabel.text = model.title;
    self.timeLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@之前"),model.playback_time];
}

@end
