//
//  UIButton+XYButton.h
//  MiAiApp
//
//  Created by voidcat on 2017/6/1.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XYButton)

@property(nonatomic ,copy)void(^block)(UIButton*);

-(void)addTapBlock:(void(^)(UIButton*btn))block;

- (void)setBadge:(NSString *)number andFont:(int)font;

@end
