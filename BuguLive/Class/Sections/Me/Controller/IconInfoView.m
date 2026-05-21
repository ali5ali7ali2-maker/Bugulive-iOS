//
//  IconInfoView.m
//  BuguLive
//
//  Created by voidcat on 2024/9/12.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "IconInfoView.h"

@implementation IconInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // 初始化子视图
    self.ageView = [[UIView alloc] init];
    self.levelView = [[UIImageView alloc] init];
    self.levelView.contentMode = UIViewContentModeScaleAspectFit;
    self.nobleView = [[UIImageView alloc] init];
    self.vipView = [[UIImageView alloc] init];
    self.vipView.image = [UIImage imageNamed:@"mg_new_vip_icon"];
    self.vipView.contentMode = UIViewContentModeScaleAspectFit;
    self.certificationView = [[UIImageView alloc] init];
    self.certificationView.image = [UIImage imageNamed:@"mg_zhifu_certication_en"];
    self.certificationView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 设置子视图的背景色
    self.ageView.backgroundColor = [UIColor clearColor];
    self.levelView.backgroundColor = [UIColor clearColor];
    self.nobleView.backgroundColor = [UIColor clearColor];
    self.vipView.backgroundColor = [UIColor clearColor];
    self.certificationView.backgroundColor = [UIColor clearColor];

    // 添加子视图到父视图
    [self addSubview:self.ageView];
    [self addSubview:self.levelView];
    [self addSubview:self.nobleView];
    [self addSubview:self.vipView];
    [self addSubview:self.certificationView];
    
    // 初始化约束
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraintsIfNeeded {
    [super updateConstraintsIfNeeded];
    
    CGFloat margin = 10;
    UIView *previousView = nil;
    
    // 所有视图先设置基础约束
    for (UIView *view in @[self.ageView, self.levelView, self.nobleView, self.vipView, self.certificationView]) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@0);
        }];
    }
    
    // 更新年龄视图约束
    if (!self.ageView.hidden) {
        [self.ageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(margin);
            make.width.equalTo(@50);
        }];
        previousView = self.ageView;
    }
    
    // 更新等级视图约束
    if (!self.levelView.hidden) {
        [self.levelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousView ? previousView.mas_right : self.mas_left).offset(margin);
            make.width.equalTo(@39);
        }];
        previousView = self.levelView;
    }
    
    // 更新贵族视图约束
    if (!self.nobleView.hidden) {
        [self.nobleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousView ? previousView.mas_right : self.mas_left).offset(margin);
            make.width.equalTo(@43);
        }];
        previousView = self.nobleView;
    }
    
    // 更新VIP视图约束
    if (!self.vipView.hidden) {
        [self.vipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousView ? previousView.mas_right : self.mas_left).offset(margin);
            make.width.equalTo(@16);
        }];
        previousView = self.vipView;
    }
    
    // 更新认证视图约束
    if (!self.certificationView.hidden) {
        [self.certificationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousView ? previousView.mas_right : self.mas_left).offset(margin);
            make.width.equalTo(@60);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-margin);
        }];
    }

    [self layoutIfNeeded];
}

@end
