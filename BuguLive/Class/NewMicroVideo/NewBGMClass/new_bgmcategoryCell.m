//
//  new_bgmcategoryCell.m
//  BuguLive
//
//  Created by bugu on 2019/5/25.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "new_bgmcategoryCell.h"

@implementation new_bgmcategoryModel

@end



@implementation new_bgmcategoryCell
{
    UIImageView *icon;
    UILabel *titleLa;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    [self drawsubviews];
    return self;
}

-(void)setModel:(new_bgmcategoryModel *)model
{
    _model =model;
    [icon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    titleLa.text =model.type_name;
}

- (void)drawsubviews
{
    if (!icon)
    {
        __weak typeof(self)weakself =self;
        icon =[[UIImageView alloc]init];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(weakself);
            make.height.equalTo(@(60));
            make.bottom.equalTo(weakself.mas_centerY);
        }];
        icon.contentMode =UIViewContentModeScaleAspectFit;
        titleLa =[[UILabel alloc]init];
        [self addSubview:titleLa];
        [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself.mas_centerY).offset(10);
            make.width.centerX.equalTo(weakself);
            make.height.equalTo(@16.);
        }];
        titleLa.font = [UIFont systemFontOfSize:14.];
        titleLa.textColor =kBlackColor;
        titleLa.textAlignment =1;
    }
}




@end
