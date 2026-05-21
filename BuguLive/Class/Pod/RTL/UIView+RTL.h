//
//  UIView+RTL.h
//  BuguLive
//
//  Created by voidcat on 2024/9/12.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RTL)
- (CGFloat)leading;
- (void)setLeading:(CGFloat)leading;
- (CGFloat)trailing;
- (void)setTrailing:(CGFloat)trailing;
-(BOOL)isRTL;
- (void)checkOverturn;
//overturned
@property (nonatomic, assign) BOOL rtlOverturned;

@end
NS_ASSUME_NONNULL_END
