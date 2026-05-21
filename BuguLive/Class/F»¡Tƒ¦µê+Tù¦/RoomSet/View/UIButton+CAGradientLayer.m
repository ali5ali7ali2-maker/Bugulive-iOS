//
//  UIButton+CAGradientLayer.m
//  BuGuDY
//
//  Created by bugu on 2020/3/14.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "UIButton+CAGradientLayer.h"
#import "UIFont+Ext.h"


@implementation UIButton (CAGradientLayer)


+ (instancetype)buttonGradientFrame:(CGRect)frame Title:(NSString *)title    target:(id)vc
                             action:(SEL)action{
    
    return ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (title) {
            [button setTitle:title forState:UIControlStateNormal];
        }
        button.frame = frame;
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:16];

        
        if (action) {
            [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
        }
        //非常重要   设置  button.layer.masksToBounds = YES时阴影 就不能实现。所以把masksToBounds设置在 渐变层
//        button.layer.masksToBounds = YES;
//        button.layer.cornerRadius  = frame.size.height/2;
        
        
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = button.bounds;
        gl.cornerRadius  = frame.size.height/2;
        gl.masksToBounds = YES;

        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 0);
        gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#AE2CF1"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#AE2CF1"].CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        
        [button.layer insertSublayer:gl atIndex:0];
        button;
    });
    
}

+ (instancetype)buttonPinkLayerFrame:(CGRect)frame Title:(NSString *)title    target:(id)vc
                              action:(SEL)action{
    
    
    
    return ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (title) {
            [button setTitle:title forState:UIControlStateNormal];
        }
        button.frame = frame;
//        button.backgroundColor = kRandomColor;
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
        button.titleLabel.font = UIFont.bg_mediumFont16;
        
        
        if (action) {
            [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
        }
        
        button.layer.cornerRadius  = frame.size.height/2;
        
        button.layer.borderColor  = kWhiteColor.CGColor;

        button.layer.borderWidth  = 1;

        
        
        button;
    });
    
    
}


+ (instancetype)buttonLayerColor:(UIColor *)color Frame:(CGRect)frame Title:(NSString *)title    target:(id)vc
                          action:(SEL)action{
      return ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (title) {
                [button setTitle:title forState:UIControlStateNormal];
            }
            button.frame = frame;
    //        button.backgroundColor = kRandomColor;
            [button setTitleColor:color forState:UIControlStateNormal];
            
            button.titleLabel.font = UIFont.bg_mediumFont16;
            
            
            if (action) {
                [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
            }
            
            button.layer.cornerRadius  = frame.size.height/2;
            
            button.layer.borderColor  = color.CGColor;

            button.layer.borderWidth  = 1;

            
            
            button;
        });
        
    
}



@end
