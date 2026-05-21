//
//  new_bgmitemCell.m
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "new_bgmitemCell.h"

@implementation new_bgmitemCell
{
    UIButton *Collection;
    UIImageView *icon,*isplaying;
    UIButton *UseBTn;
    UILabel *music_nameLa,*music_author;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.layer.masksToBounds =YES;
    [self drawsubviews];
    return self;
}
- (void)setModel:(music_obj *)model
{
    _model =model;
    [icon sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    music_nameLa.text =model.music_name;
    music_author.text =model.music_author;
    if (model.is_collection == 1)
    {
        Collection.selected =YES;
    }else
    {
        Collection.selected =NO;
    }
    if (model.isselect)
    {
        isplaying.image =[UIImage imageNamed:@"new_bgm_stop"];
    }else
    {
        isplaying.image =[UIImage imageNamed:@"new_bgm_play"];
    }
}
- (void)sureuseAction
{
    if ([_delegate respondsToSelector:@selector(selectItem:)])
    {
        [_delegate selectItem:_model];
    }
}
- (void)docollection
{
    if ([_delegate respondsToSelector:@selector(doCollection:)])
    {
        [_delegate doCollection:_model];
    }
}
-(void)drawsubviews
{
    //未展开140
    if (!icon)
    {
        __weak typeof(self)weakself =self;
        icon =[[UIImageView alloc]init];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself).offset(30);
            make.top.equalTo(weakself).offset(14);
            make.width.height.equalTo(@(112 ));
        }];
        icon.contentMode =UIViewContentModeScaleAspectFill;
        isplaying=[[UIImageView alloc]init];
        [self addSubview:isplaying];
        [isplaying mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(icon);
            make.width.height.equalTo(icon).multipliedBy(0.4);
        }];
        isplaying.image =[UIImage imageNamed:@"new_bgm_play"];
        isplaying.contentMode =UIViewContentModeScaleAspectFit;
        music_nameLa =[UILabel new];
        [self addSubview:music_nameLa];
        [music_nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(30);
            make.bottom.equalTo(icon.mas_centerY);
            make.height.equalTo(@(42));
            make.right.equalTo(weakself).offset(-75);
        }];
        music_nameLa.font =[UIFont fontWithName:@"Helvetica-Bold" size:16.];
        music_nameLa.textColor =kBlackColor;
        
        music_author =[UILabel new];
        [self addSubview:music_author];
        [music_author mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(30);
            make.top.equalTo(icon.mas_centerY);
            make.height.equalTo(@(42));
            make.right.equalTo(weakself).offset(-75);
        }];
        music_author.font =[UIFont fontWithName:@"Helvetica" size:14.];
        music_author.textColor =kGrayColor;
        
        Collection =[[UIButton alloc]init];
        [self addSubview:Collection];
        [Collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself).offset(-30);
            make.centerY.equalTo(icon);
            make.width.height.equalTo(@(44 ));
        }];
        [Collection setImage:[UIImage imageNamed:@"new_bgm_collection"] forState:0];
        [Collection setImage:[UIImage imageNamed:@"new_bgm_collectionSelect"] forState:UIControlStateSelected];
        [Collection addTarget:self action:@selector(docollection) forControlEvents:UIControlEventTouchUpInside];
        UseBTn=[[UIButton alloc]init];
        [self addSubview:UseBTn];
        [UseBTn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself).offset(30);
            make.right.equalTo(weakself).offset(-30);
            make.top.equalTo(icon.mas_bottom).offset(24);
            make.height.equalTo(@(82 ));
        }];
        UseBTn.layer.cornerRadius =41;
        UseBTn.backgroundColor =UIColorFromRGB(0xe8465d);
        [UseBTn setTitle:ASLocalizedString(@"确认使用")forState:0];
        [UseBTn setTitleColor:kWhiteColor forState:0];
        UseBTn.titleLabel.font =[UIFont systemFontOfSize:15.];
        [UseBTn addTarget:self action:@selector(sureuseAction) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
