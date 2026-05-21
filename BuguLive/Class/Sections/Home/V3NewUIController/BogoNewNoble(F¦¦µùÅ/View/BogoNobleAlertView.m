//
//  BogoNobleAlertView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoNobleAlertView.h"

@implementation BogoNobleAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.confirmBtn setLocalizedString];
//    self.confirmBtn.userInteractionEnabled = NO;
}

- (IBAction)clickConfirmBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolNobleAlertClickConfirm:)]) {
        [self.delegate protocolNobleAlertClickConfirm:sender];
    }
    [self hide];
}

#pragma mark - Lazy Load

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = kGrayTransparentColor4_1;
//        [kBlackColor colorWithAlphaComponent:0.3];
        _shadowView.alpha = 0;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (void)setSelectModel:(BogoNobleListSubTypeModel *)selectModel{
    
    self.titieL.text = selectModel.title;
    [self.iconimgView sd_setImageWithURL:[NSURL URLWithString:selectModel.instructions_img] completed:nil];
    self.contentL.text = selectModel.content;
    
    if ([selectModel.type isEqualToString:@"stealth"]) {
        self.height = kRealValue(261);
        self.bgImgView.image = [UIImage imageNamed:@"bogo_noble_AlertSmallBgImg"];
        self.labelConstraint.constant = kRealValue(30);
    }else{
        self.height = kRealValue(341);
        
        self.labelConstraint.constant = kRealValue(24);
        self.bgImgView.image = [UIImage imageNamed:@"bogo_noble_AlertBgImg"];
    }
    
}

- (void)show:(UIView *)superView{
//    [self requestWardData];
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        NSLog(@"%@",self);
//        self.bottom = kScreenHeight;
//        self.centerX = 185;
//        self.centerY = kScreenH / 2;
        self.shadowView.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.15 animations:^{
//        self.top = kScreenH;
//        self.frame = CGRectMake(0, kScreenHeight, self.width, self.height);
//        self.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.shadowView removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.center = CGPointMake(kScreenW / 2, kScreenH / 2);
}

@end
