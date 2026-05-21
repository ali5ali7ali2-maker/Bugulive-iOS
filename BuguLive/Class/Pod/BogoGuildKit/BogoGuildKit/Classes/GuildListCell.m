//
//  GuildListCell.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "GuildListCell.h"
#import "GuildDetailModel.h"
#import <UIImageView+WebCache.h>

@interface GuildListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation GuildListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GuildDetailModelFamily_info *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
    [self.nameLabel setText:model.family_name];
    [self.contentLabel setText:model.family_manifesto];
}

@end
