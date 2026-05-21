//
//  UIImageView+RTL.m
//  BuguLive
//
//  Created by voidcat on 2024/9/12.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "UIImageView+RTL.h"
#import "UIView+RTL.h"
@implementation UIImage (RTL)
- (UIImage *_Nonnull)checkOverturn {
    if ([UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft) {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        CGContextRef bitmap = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(bitmap, self.size.width / 2, self.size.height / 2);
        CGContextScaleCTM(bitmap, -1.0, -1.0);
        CGContextTranslateCTM(bitmap, -self.size.width / 2, -self.size.height / 2);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        return image;
    }
    return self;
}
@end
