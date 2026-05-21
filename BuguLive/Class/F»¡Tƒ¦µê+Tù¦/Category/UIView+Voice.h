//
//  UIView+Voice.h
//  UniversalApp
//
//  Created by bogokj on 2019/12/16.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kTopCornerRadius  11


@interface UIView (Voice)

- (void)addRoundedCorners:(UIRectCorner)corners
withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;


- (void)addAppTopCornerRadius;

- (void)addTopCornerRadius:(CGFloat)TopRadius;





@end

NS_ASSUME_NONNULL_END
