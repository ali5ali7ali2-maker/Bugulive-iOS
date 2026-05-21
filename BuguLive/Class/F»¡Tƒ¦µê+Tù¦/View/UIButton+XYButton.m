//
//  UIButton+XYButton.m
//  MiAiApp
//
//  Created by voidcat on 2017/6/1.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import "UIButton+XYButton.h"

@implementation UIButton (XYButton)

-(void)setBlock:(void(^)(UIButton*))block

{
    
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
    
}

-(void(^)(UIButton*))block

{
    
    return objc_getAssociatedObject(self,@selector(block));
    
}

-(void)addTapBlock:(void(^)(UIButton*))block

{
    
    self.block= block;
    
    [self addTarget:self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)click:(UIButton*)btn

{
    
    if(self.block) {
        
        self.block(btn);
        
    }
    
}

- (void)setBadge:(NSString *)number andFont:(int)font{
    if (!number.integerValue) {
        UIView *view = [self viewWithTag:110];
        [view removeFromSuperview];
        return;
    }
    CGFloat width = self.bounds.size.width;
    
    CGSize size = [number textSizeIn:CGSizeMake(99, 99) font:[UIFont systemFontOfSize:font]];
    
    UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(width*2/3, -width/4, width/2+(number.length-1)*size.width, width/2)];
    
    badge.text = number;
    
    badge.textAlignment = NSTextAlignmentCenter;
    
    badge.font = [UIFont systemFontOfSize:font];
    
    badge.backgroundColor = [UIColor redColor];
    
    badge.textColor = [UIColor whiteColor];
    
    badge.layer.cornerRadius = width/4;
    
    badge.layer.masksToBounds = YES;
    
    badge.tag = 110;
    
    [self addSubview:badge];
    
}

@end
