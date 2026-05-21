//
//  BogoWithDrawBindAlipayPopView.m
//  UniversalApp
//
//  Created by Mac on 2021/6/12.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoWithDrawBindAlipayPopView.h"
#import "FDUIKitObjC.h"

@interface BogoWithDrawBindAlipayPopView ()

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation BogoWithDrawBindAlipayPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake((FD_ScreenWidth - 290 ) / 2, FD_ScreenHeight, 290, 254);
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.submitBtn.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:158/255.0 green:100/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:239/255.0 green:96/255.0 blue:246/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.submitBtn.layer insertSublayer:gl atIndex:0];
}

- (IBAction)submitBtnAction:(UIButton *)sender {
    if (!self.nameTextField.text.length) {
//        [self.nameTextField shake];
        return;
    }
    if (!self.accountTextField.text.length) {
//        [self.accountTextField shake];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bindPopView:didClickSubmitBtn:)]) {
        [self.delegate bindPopView:self didClickSubmitBtn:sender];
    }
}

@end
