//
//  GuildMemberListCell.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/25.
//

#import "GuildMemberListCell.h"
#import "GuildDetailModel.h"
#import "UIImageView+WebCache.h"
#import "BogoNetworkKit.h"

@interface GuildMemberListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;

@end

@implementation GuildMemberListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.creatorLabel setLocalizedString];
    [self.deleteBtn setTitle:ASLocalizedString(@"踢出家族") forState:UIControlStateNormal];
    [self.refuseBtn setTitle:ASLocalizedString(@"拒绝") forState:UIControlStateNormal];
    [self.agreeBtn setTitle:ASLocalizedString(@"同意") forState:UIControlStateNormal];
    // Initialization code
}

- (void)setModel:(GuildDetailModelLists *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    self.creatorLabel.hidden = !model.family_chieftain.integerValue;
    self.nameLabel.text = model.nick_name;
    self.signLabel.text = model.signature;
    if (model.family_chieftain.integerValue) {
        if ([self.familyModel.user_id isEqualToString:[BogoNetwork shareInstance].uid]) {
            if (self.type == GuildMemberSubViewControllerTypeApply) {
                self.deleteBtn.hidden = YES;
            }else{
                self.deleteBtn.hidden = [model.uid isEqualToString:[BogoNetwork shareInstance].uid];
            }
        }else{
            self.deleteBtn.hidden = YES;
        }
    }else{
        if ([self.familyModel.user_id isEqualToString:[BogoNetwork shareInstance].uid]) {
            self.deleteBtn.hidden = self.type == GuildMemberSubViewControllerTypeApply;
        }else{
            self.deleteBtn.hidden = YES;
        }
    }
    self.sexImageView.image = kBogoGuildKitBundleImageNamed(model.sex.integerValue == 1 ? @"guild_男" : @"guild_女");
    NSString *rankImageName = [NSString stringWithFormat:@"level%@",model.user_level];
    self.rankImageView.image = kBogoGuildKitBundleImageNamed(rankImageName);
}

- (void)setType:(GuildMemberSubViewControllerType)type{
    _type = type;
    self.agreeBtn.hidden = type == GuildMemberSubViewControllerTypeMember;
    self.refuseBtn.hidden = type == GuildMemberSubViewControllerTypeMember;
}

- (IBAction)agreeBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickAgreeBtn:)]) {
        [self.delegate listCell:self didClickAgreeBtn:sender];
    }
}

- (IBAction)refuseBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickRefuseBtn:)]) {
        [self.delegate listCell:self didClickRefuseBtn:sender];
    }
}

- (IBAction)deleteBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickDeleteBtn:)]) {
        [self.delegate listCell:self didClickDeleteBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
