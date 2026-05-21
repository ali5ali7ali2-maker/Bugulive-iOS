//
//  MGLiveRechargePayTypeView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/8/5.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGLiveRechargePayTypeView.h"

@implementation MGLiveRechargePayTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [NSArray array];
        [self setUpView];
        
    }
    return self;
}

-(void)setUpView{
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, kRealValue(5), kScreenW / 2, kRealValue(20))];
    titleL.text = ASLocalizedString(@"选择付款方式");
    titleL.font = [UIFont systemFontOfSize:17];
    titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"com_close_1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.scrollView = [UIScrollView new];
    self.scrollView.frame = CGRectMake(0, 40, kScreenW, kRealValue(150));
    self.scrollView.backgroundColor = kGrayColor;
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:ASLocalizedString(@"立即支付")forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self addSubview:titleL];
    [self addSubview:closeBtn];
    [self addSubview:payBtn];
       
}

-(void)resetScrollViewWithArr:(NSArray *)arr{
    
    for (int i = 0; i< arr.count; i ++) {
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(40))];
        UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(22), 0, kRealValue(21), kRealValue(21))];
        UILabel *label = [UILabel new];
        label.text = ASLocalizedString(@"微信支付");
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [control addSubview:iconImgView];
        [control addSubview:label];
        [control addSubview:selectBtn];
        [self.scrollView addSubview:control];
    }
    
}

-(void)clickClose:(UIButton *)sender{
    
}


#pragma mark - Show And Hide
- (void)show:(UIView *)superView{
    
    [superView addSubview:self];

    [UIView animateWithDuration:0.25 animations:^{
        
        self.y = kScreenH / 2;
    }];
}

- (void)hide{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}



@end
