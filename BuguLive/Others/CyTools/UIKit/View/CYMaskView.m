//
//  CYMaskView.m
//  BuguLive
//
//  Created by 志刚杨 on 2021/1/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "CYMaskView.h"

@implementation CYMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kRedColor;
        self.hidden = YES;
    }
    return self;
}

-(void)addTo:(UIView *)supperView withView:(UIView *)view
{
    self.frame = supperView.bounds;
    [supperView addSubview:self];
    
    [self addSubview:view];
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTapGestureRecognizer {
    self.hidden = YES;
}

@end
