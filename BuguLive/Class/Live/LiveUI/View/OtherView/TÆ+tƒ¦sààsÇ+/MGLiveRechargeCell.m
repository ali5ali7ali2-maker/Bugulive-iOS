//
//  MGLiveRechargeCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/8/5.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGLiveRechargeCell.h"

@implementation MGLiveRechargeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = kRandomFlatColor;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.control.layer.cornerRadius = 4;
    self.control.layer.masksToBounds = YES;
    self.control.layer.borderColor = kBlueColor.CGColor;
    self.control.layer.borderWidth = 0.5f;
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, kRealValue(5), self.width, kRealValue(20))];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = kBlueColor;
    _titleL = titleL;
    UILabel *subtitleL = [[UILabel alloc]initWithFrame:CGRectMake(0, titleL.bottom + kRealValue(5), self.width, kRealValue(20))];
    subtitleL.textAlignment = NSTextAlignmentCenter;
    subtitleL.font = [UIFont systemFontOfSize:13];
    subtitleL.textColor = kGrayColor;
    _subTitleL = subtitleL;
    
    [self.control addSubview:self.titleL];
    [self.control addSubview:self.subTitleL];
    [self.contentView addSubview:self.control];
}

-(void)resetViewWithModel:(PayMoneyModel *)model{
    self.titleL.text = [NSString stringWithFormat:ASLocalizedString(@"%ld钻石"),model.diamonds];
    self.subTitleL.text = [NSString stringWithFormat:ASLocalizedString(@"售价:%@"),model.money_name];
}

@end
