//
//  GuildRankBottomView.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/26.
//

#import "GuildRankBottomView.h"
#import "FDUIKitObjC.h"
#import "GuildDetailModel.h"
#import "UIImageView+WebCache.h"

@interface GuildRankBottomView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@end

@implementation GuildRankBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, FD_ScreenHeight - FD_Bottom_Height - FD_Top_Height - 40, FD_ScreenWidth, FD_Bottom_Height);
    for (UIView *subView in self.subviews) {
        [subView setLocalizedString];
    }
}

- (void)setModel:(GuildDetailModelLists *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
    if (model.sums.integerValue) {
        [self.scoreLabel setText:[NSString stringWithFormat:ASLocalizedString(@"贡献%@积分"),model.sums]];
    }else{
        [self.scoreLabel setText:@""];
    }
    if (model.order.integerValue <= 100) {
        [self.rankLabel setText:model.order];
    }else{
        [self.rankLabel setText:ASLocalizedString(@"未上榜")];
    }
}

@end
