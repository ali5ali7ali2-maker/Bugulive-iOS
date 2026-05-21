//
//  BogoInviteDetailTopView.m
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteDetailTopView.h"

@interface BogoInviteDetailTopView ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation BogoInviteDetailTopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(15, 15, kScreenW - 30, 98);
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, kScreenW - 30, 98);
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:168/255.0 blue:32/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:245/255.0 green:85/255.0 blue:14/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.layer insertSublayer:gl atIndex:0];
    
    self.logBtn.imagePosition = QMUIButtonImagePositionRight;
    self.logBtn.spacingBetweenImageAndTitle = 5;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upldateTopViewMoney:) name:@"upldateTopViewMoney" object:nil];
    
    for (UIView *subView in self.subviews) {
        [subView setLocalizedString];
    }
    
    
}

- (void)upldateTopViewMoney:(NSNotification *)noti{
    NSString *money = (NSString *)noti.object;
    self.moneyLabel.text = money;
}

- (IBAction)logBtnAction:(QMUIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:didClickLogBtn:)]) {
        [self.delegate topView:self didClickLogBtn:sender];
    }
}

- (IBAction)withDrawBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:didClickWithDrawBtn:)]) {
        [self.delegate topView:self didClickWithDrawBtn:sender];
    }
}

@end
