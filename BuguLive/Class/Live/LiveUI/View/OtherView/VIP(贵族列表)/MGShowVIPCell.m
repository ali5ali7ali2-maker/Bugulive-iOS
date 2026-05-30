//
//  MGShowVIPCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/19.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGShowVIPCell.h"

@implementation MGShowVIPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
        [self resetView];
    }
    return self;
}

-(void)setUpView{
    
    UIImageView *headImgView = [UIImageView new];
    [headImgView setImage:[UIImage imageNamed:@"live_wish_gift_addBGView"]];
    _headImgView = headImgView;
    
    UILabel *nickNameL = [UILabel new];
    nickNameL.textColor = kBlackColor;
    nickNameL.font = [UIFont systemFontOfSize:14];
    _nickNameL = nickNameL;
    
    UIImageView *sexImgView = [UIImageView new];
    [sexImgView setImage:[UIImage imageNamed:@"live_wish_gift_addBGView"]];
    _sexImgView = sexImgView;
    
    UIImageView *levelImgView = [UIImageView new];
    [levelImgView setImage:[UIImage imageNamed:@"live_wish_gift_addBGView"]];
    _levelImgView = levelImgView;
    
    [self.contentView addSubview:headImgView];
    [self.contentView addSubview:nickNameL];
    [self.contentView addSubview:sexImgView];
    [self.contentView addSubview:levelImgView];
}



-(void)resetView{
    
    self.headImgView.frame = CGRectMake(kRealValue(11), kRealValue(7), kRealValue(40), kRealValue(40));
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = kRealValue(40 / 2);
    [self.nickNameL sizeToFit];
    self.nickNameL.left = self.headImgView.right + kRealValue(15);
    self.nickNameL.centerY = self.headImgView.centerY;
    
    self.sexImgView.frame = CGRectMake(self.nickNameL.right + kRealValue(5), 0, kRealValue(10), kRealValue(10));
    
    self.levelImgView.frame = CGRectMake(kScreenW - kRealValue(43) - kRealValue(10), 0, kRealValue(43), kRealValue(20));
    
    self.levelImgView.centerY = self.sexImgView.centerY = self.nickNameL.centerY;
}



-(void)resetModel:(MGShowVipModel *)model{
    
    if (model.is_noble_stealth.intValue == 1) {
        [self.headImgView sd_setImageWithURL:nil placeholderImage:kDefaultNobleMysteriousHeadImg];
        self.nickNameL.text = ASLocalizedString(@"神秘人");
        self.sexImgView.hidden = YES;
        
        [self.levelImgView sd_setImageWithURL:[NSURL URLWithString:model.noble_icon] placeholderImage:nil];
        
    }else{
        self.sexImgView.hidden = NO;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
        self.nickNameL.text = model.nick_name;
        self.sexImgView.image = [model.sex isEqualToString:@"1"] ? [UIImage imageNamed:@"dy_sex_male"] : [UIImage imageNamed:@"dy_sex_female"];
        
        [self.levelImgView sd_setImageWithURL:[NSURL URLWithString:model.noble_icon] placeholderImage:nil];
    }
    
    
    
    [self resetView];
}

@end
