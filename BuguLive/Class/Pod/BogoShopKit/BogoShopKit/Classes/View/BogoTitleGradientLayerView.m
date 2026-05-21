//
//  BogoLiveMessageCoupleView.m
//  UniversalApp
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "BogoTitleGradientLayerView.h"
#import "FDFoundationObjC.h"
#import "FDUIKitObjC.h"

@implementation BogoTitleGradientLayerView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, 40, 20);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,40,20);
    gl.startPoint = CGPointMake(0, 1.0);
    gl.endPoint = CGPointMake(1.0, 0);
    gl.colors = gl.colors = @[(__bridge id)[UIColor colorWithRed:243/255.0 green:65/255.0 blue:21/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:252/255.0 green:125/255.0 blue:56/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.layer insertSublayer:gl atIndex:0];
    
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.frame = self.bounds;
    
}

- (UIImage*)convertViewToImage{
    CGSize s = self.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
