//
//  BogoRechargeRecordHeadView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargeRecordHeadView.h"

@implementation BogoRechargeRecordHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.timeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *currentTime = [formatter stringFromDate:date];
    NSArray *arr = [currentTime componentsSeparatedByString:@"-"];
    NSString *timeStr = [NSString stringWithFormat:ASLocalizedString(@"%@年%@月"), arr.firstObject, arr.lastObject];
    [self.timeBtn setTitle:timeStr forState:UIControlStateNormal];
    [self.timeBtn setImage:[UIImage imageNamed:@"bogo_recharge_down"] forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
    self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    self.timeBtn.spacingBetweenImageAndTitle = 5;
    self.timeBtn.imagePosition = QMUIButtonImagePositionRight;
	[self.timeBtn addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.timeBtn.frame = CGRectMake(kRealValue(15), 0, kScreenW - kRealValue(15), self.height);
    [self addSubview:self.timeBtn];
}

-(void)clickTimeBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolRecordHead:)]) {
        [self.delegate protocolRecordHead:self];
    }
}

@end
