//
//  TLVoiceListSectionHeaderView.m
//  BuguLive
//
//  Created by voidcat on 2024/9/21.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "TLVoiceListSectionHeaderView.h"

@implementation TLVoiceListSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    
    // 创建headerLabel
    self.headerLabel = [[UILabel alloc] init];
    self.headerLabel.text = @"Hot room";
    self.headerLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    self.headerLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.headerLabel];
    
    // 使用Masonry布局headerLabel
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
    }];
}

@end
