//
//  WinTipView.m
//  BuguLive
//
//  Created by bogokj on 2019/3/23.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "WinTipView.h"

@interface WinTipView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *rankImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *contentBgView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation WinTipView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    [self addSubview:self.iconImageView];
    [self addSubview:self.rankImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.contentLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right);
        make.top.equalTo(self.iconImageView).offset(5);
        make.size.mas_equalTo(CGSizeMake(28, 13));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rankImageView.mas_right).offset(5);
        make.centerY.equalTo(self.rankImageView);
    }];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right);
        make.bottom.equalTo(self.iconImageView).offset(-5);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentBgView);
        make.left.equalTo(self.contentBgView).offset(2.5);
        make.top.equalTo(self.contentBgView);
        make.right.equalTo(self.contentBgView).offset(-1.5);
    }];
}

- (void)setModel:(CustomMessageModel *)model{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.sender.head_image] placeholderImage:kDefaultPreloadHeadImg];
    [self.rankImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%d",model.sender.user_level]]];
    [self.nameLabel setText:model.sender.nick_name];
    [self.contentLabel setText:model.text];
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImageView.layer.cornerRadius = 22;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UIImageView *)rankImageView{
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _rankImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.textColor = kWhiteColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UIImageView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _contentBgView.image = [UIImage imageNamed:@"lr_win_content_bg"];
    }
    return _contentBgView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.textColor = kWhiteColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}

@end
