//
//  WardViewTopCell.m
//  BuguLive
//
//  Created by 范东 on 2019/1/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "WardViewTopCell.h"
#import "WardPopViewModel.h"

@interface WardViewTopCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconBackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topBGImgView;

@end

@implementation WardViewTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topBGImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.topBGImgView.clipsToBounds = YES;
    self.backgroundColor = kClearColor;
    self.contentView.backgroundColor = kClearColor;
}

- (void)setModel:(WardPopViewModel *)model{
    _model = model;
    self.moneyLabel.hidden = NO;
    if (!model) {
//        self.nameLabel.text = @"";
        
        self.nameLabel.text = ASLocalizedString(@"虚位以待");
        self.nameLabel.textColor = kWhiteColor;
        self.moneyLabel.text = ASLocalizedString(@"贡献钻石最多的守护者为守护之星");
        self.sexImageView.hidden = self.rankImageView.hidden = YES;
        self.iconBackImageView.hidden = NO;

        [self.guardImgView setImage:[UIImage imageNamed:ASLocalizedString(@"lr_img_back_ward_Head_Star")]];

        return;
    }
    
//    if ([model.uid isEqualToString:@"0"]) {
//        self.iconImageView.hidden = self.nameLabel.hidden = self.sexImageView.hidden = self.rankImageView.hidden = self.moneyLabel.hidden = YES;
//        return;
//    }
    
    if (model.total_diamonds.integerValue) {
        self.iconBackImageView.hidden = NO;
        self.nameLabel.hidden = NO;
        self.sexImageView.hidden = NO;
        [self.iconImageView setHidden:NO];
        [self.rankImageView setHidden:NO];
        [self.moneyLabel setHidden:NO];
        self.nameLabel.text = model.nick_name;
        self. sexImageView.image = [model.sex isEqualToString:@"1"] ? [UIImage imageNamed:@"com_male_selected"] : [UIImage imageNamed:@"com_female_selected"];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
        [self.rankImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%@",model.user_level]]];
        self.iconBackImageView.image = [UIImage imageNamed:@"lr_img_back_ward_no"];
        if (model.total_diamonds.integerValue) {
            [self.moneyLabel setText:[NSString stringWithFormat:ASLocalizedString(@"消费%@%@"),model.total_diamonds,ASLocalizedString(@"钻石")]];
        }else{
            [self.moneyLabel setText:[NSString stringWithFormat:ASLocalizedString(@"消费%@%@"),@"0",ASLocalizedString(@"钻石")]];
        }
    }else{
       
        self.nameLabel.text = ASLocalizedString(@"虚位以待");
        self.nameLabel.textColor = kWhiteColor;
        self.moneyLabel.text = ASLocalizedString(@"贡献钻石最多的守护者为守护之星");
        self.sexImageView.hidden = self.rankImageView.hidden = YES;
        self.iconBackImageView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
