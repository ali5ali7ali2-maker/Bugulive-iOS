//
//  GuildRankListCell.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/26.
//

#import "GuildRankListCell.h"
#import "GuildDetailModel.h"
#import "UIImageView+WebCache.h"
#import "BogoGuildKit.h"

@interface GuildRankListCell ()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@end

@implementation GuildRankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFamilyModel:(GuildDetailModelFamily_info *)familyModel{
    _familyModel = familyModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:familyModel.head_image]];
    [self.nameLabel setText:familyModel.family_name];
    [self.contentLabel setText:familyModel.family_manifesto];
    [self.scoreLabel setText:familyModel.sums];
    [self.indexLabel setText:familyModel.order];
}

- (void)setUserModel:(GuildDetailModelLists *)userModel{
    _userModel = userModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.head_image]];
    [self.nameLabel setText:userModel.nick_name];
    [self.contentLabel setText:userModel.signature];
    [self.scoreLabel setText:[NSString stringWithFormat:@"贡献%@积分",userModel.sums]];
    [self.indexLabel setText:userModel.order];
    NSString *rankImageName = [NSString stringWithFormat:@"level%@",userModel.user_level];
    self.rankImageView.image = kBogoGuildKitBundleImageNamed(rankImageName);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
