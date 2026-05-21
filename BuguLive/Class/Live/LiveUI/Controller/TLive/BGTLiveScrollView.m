//
//  BGTLiveScrollView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/6/29.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "BGTLiveScrollView.h"

@implementation BGTLiveScrollView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
//    self.firstImgView = [UIImageView new];
//    self.secondImgView = [UIImageView new];
//    self.lastImgView = [UIImageView new];
//    
//    self.firstImgView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
//    self.secondImgView.frame = CGRectMake(0, kScreenH, kScreenW, kScreenH);
//    self.lastImgView.frame = CGRectMake(0, kScreenH * 2, kScreenW, kScreenH);
//    
//    self.firstImgView.backgroundColor = kClearColor;
//    self.secondImgView.backgroundColor = kClearColor;
//    self.lastImgView.backgroundColor = kClearColor;
//    
//    [self addSubview:self.firstImgView];
//    [self addSubview:self.secondImgView];
//    [self addSubview:self.lastImgView];
}

@end
