//
//  SHomeNavView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/4/26.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "SHomeNavView.h"

@implementation SHomeNavView

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"ac_auction_back"] forState:UIControlStateNormal];
        _backBtn.tag = 10;
        [_backBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //直播
        _rightBtn.tag = 11;
        [_rightBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        _rightBtn.hidden = YES;
        [_rightBtn setTitle:@"" forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"主页_更多"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.frame = CGRectMake(kScreenW - 80,kStatusBarHeight,80,44);
    }
    return _rightBtn;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}


-(void)setUpView{
    [self addSubview:self.backBtn];
//    [self addSubview:self.rightBtn];
    
    self.backBtn.frame = CGRectMake(kRealValue(10), kStatusBarHeight, kRealValue(30), kRealValue(30));
//    self.rightBtn.frame = CGRectMake(kScreenW - kRealValue(60) - kRealValue(10), kStatusBarHeight, kRealValue(60), kRealValue(30));
}


-(void)buttonClick:(UIButton *)sender{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(sender.tag);
    }
}

@end
