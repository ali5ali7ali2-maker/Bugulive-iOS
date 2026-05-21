//
//  ContributionLsitBottomView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "ContributionLsitBottomView.h"

@implementation ContributionLsitBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(12), 0, 20, 20)];
    self.titleL.text =ASLocalizedString( @"我的排名：");
    self.titleL.font = [UIFont systemFontOfSize:14];
    self.titleL.textColor = [UIColor colorWithHexString:@"#777777"];
    [self.titleL sizeToFit];
    [self addSubview:self.titleL];
    
    
    
    self.contentL = [[UILabel alloc]initWithFrame:CGRectMake(self.titleL.right + kRealValue(5), 0, kScreenW / 3, 30)];
    self.contentL.text =ASLocalizedString( @"未上榜");
    self.contentL.font = [UIFont systemFontOfSize:14];
    self.contentL.textColor = [UIColor colorWithHexString:@"#9F64FF"];
    
    self.contentL.centerY = self.titleL.centerY = self.height / 2;
    [self addSubview:self.contentL];
}


@end
