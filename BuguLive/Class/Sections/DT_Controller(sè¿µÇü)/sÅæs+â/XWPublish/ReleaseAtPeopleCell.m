//
//  ReleaseAtPeopleCell.m
//  BuguLive
//
//  Created by bugu on 2019/11/28.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "ReleaseAtPeopleCell.h"

@implementation ReleaseAtPeopleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 17.5;
    
    self.nickNameLabel = [[UILabel alloc]init];
    self.nickNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.nickNameLabel.font = [UIFont systemFontOfSize:14];
    
    self.iconImageView.image = [UIImage imageNamed:@"dynamic（动态 前缀：dn）"];
    self.nickNameLabel.text = @"xxxxxxx";
    
    [self.contentView addSubview: self.iconImageView];
    [self.contentView addSubview: self.nickNameLabel];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(35);
    }];
    
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
}

- (void)setUser:(PersonCenterUserModel *)user{
    
    self.nickNameLabel.text = user.nick_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.head_image] placeholderImage:kDefaultPreloadHeadImg];

}


@end
