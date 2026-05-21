//
//  AudienceEnteringTipView.m
//  BuguLive
//
//  Created by xfg on 16/6/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AudienceEnteringTipView.h"

@implementation AudienceEnteringTipView

- (id)initWithMyFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AudienceEnteringTipView" owner:self options:nil] lastObject];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
    }
    return self;
}

- (void)setContent:(UserModel *) userModel
{
    [self.rankImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%@",userModel.user_level]]];
    self.userNameLabel.text = userModel.nick_name;
    self.joinText.text = ASLocalizedString(self.joinText.text);
    //等级、守护、VIP、贵族
    //1.是神秘人时，只显示贵族（神秘人图标），其他都隐藏
    //2.不是神秘人时，等级图标一定显示
    //3.等级-守护-VIP-贵族
    if ([userModel.is_noble_mysterious isEqualToString:@"1"]) {
        self.vipImgView.hidden = self.guardianImageView.hidden = self.rankImgView.hidden = YES;
         self.rankWidthConstraint.constant = self.vipWidthConstraint.constant = self.guardWidthConstraint.constant = 0;
//        self.nobleLeftConstraint.constant = 5;
//        self.nameLeftConstraint.constant = 20;
        self.userNameLabel.text = @"";
        self.iconImageView.image = kDefaultNobleMysteriousHeadImg;
        [self.nobleImgView setImage:[UIImage imageNamed:@"live_noble_Img"]];
        
        if (userModel.noble_vip_type.intValue == 1) {
            self.bgView.image = [UIImage imageNamed:@"bogo_liverooom_enter_Noble"];
        }
        
//        if (userModel.is_guardian == 1) {
//            self.bgView.image = [UIImage imageNamed:@"bogo_liverooom_enter_Guard"];
//        }
    }else{
        [self.nobleImgView sd_setImageWithURL:[NSURL URLWithString:userModel.noble_icon]];
        self.guardianImageView.hidden = userModel.is_guardian == 0;
        self.vipImgView.hidden = ![userModel.is_vip isEqualToString:@"1"];
        self.nobleImgView.hidden = [BGUtils isBlankString:userModel.noble_icon];
        
        
        
        if (userModel.noble_vip_type.intValue == 1) {
            self.bgView.image = [UIImage imageNamed:@"bogo_liverooom_enter_Noble"];
        }
        
        if (userModel.is_guardian == 1) {
            self.bgView.image = [UIImage imageNamed:@"bogo_liverooom_enter_Guard"];
            [self.guardianImageView sd_setImageWithURL:[NSURL URLWithString:userModel.guardian_img]];
            self.rankImgView.hidden = YES;
            self.rankWidthConstraint.constant = 0;
        }
        
        
        
        if (self.guardianImageView.hidden) {
            self.guardWidthConstraint.constant = 0;
        }
        if (self.vipImgView.hidden) {
            self.vipWidthConstraint.constant = 0;
        }
        if (self.nobleImgView.hidden) {
            self.nobleWidthConstraint.constant = 0;
        }
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.head_image] placeholderImage:kDefaultPreloadHeadImg];
    }
    
}

- (void)setType:(AudienceEnteringTipViewType)type{
    switch (type) {
        case AudienceEnteringTipViewTypeHighLevel:
        {
            //高等级观众进入
            self.guardianImageView.hidden = YES;
            [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.rankImgView.mas_right).offset(5);
                make.centerY.equalTo(self.rankImgView);
            }];
            [self.rankImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.guardianImageView.mas_left).offset(-5);
                make.centerY.equalTo(self.iconImageView);
                make.size.mas_equalTo(CGSizeMake(35, 18));
            }];
        }
            break;
        case AudienceEnteringTipViewTypeGuard:
        {
            //主播的守护进入
            self.guardianImageView.hidden = NO;
            [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.guardianImageView.mas_right).offset(5);
                make.centerY.equalTo(self.guardianImageView);
            }];
            [self.guardianImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.rankImgView.mas_right).offset(5);
                make.centerY.equalTo(self.rankImgView);
                make.size.mas_equalTo(CGSizeMake(50, 18));
            }];
            [self.rankImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.guardianImageView.mas_left).offset(-5);
                make.centerY.equalTo(self.iconImageView);
                make.size.mas_equalTo(CGSizeMake(35, 18));
            }];
        }
            break;
        default:
            break;
    }
}

@end
