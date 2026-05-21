//
//  LoginRecomHeaderCollectReusView.m
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "LoginRecomHeaderCollectReusView.h"

@implementation LoginRecomHeaderCollectReusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel= ({
           UILabel * label = [[UILabel alloc]init];
           label.textColor = [UIColor colorWithHexString:@"#999999"];
           label.font = [UIFont systemFontOfSize:14];
           label.text = ASLocalizedString(@"—— 热门主播 ——");
           label;
       });
    [self addSubview:_titleLabel];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

@end
