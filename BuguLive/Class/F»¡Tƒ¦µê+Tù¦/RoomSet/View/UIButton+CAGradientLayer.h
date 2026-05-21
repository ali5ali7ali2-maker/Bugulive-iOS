//
//  UIButton+CAGradientLayer.h
//  BuGuDY
//
//  Created by bugu on 2020/3/14.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CAGradientLayer)


+ (instancetype)buttonGradientFrame:(CGRect)frame Title:(NSString *)title    target:(id)vc
action:(SEL)action;



+ (instancetype)buttonPinkLayerFrame:(CGRect)frame Title:(NSString *)title    target:(id)vc
action:(SEL)action;


+ (instancetype)buttonLayerColor:(UIColor *)color Frame:(CGRect)frame Title:(NSString *)title    target:(id)vc
                              action:(SEL)action;


@end

NS_ASSUME_NONNULL_END
