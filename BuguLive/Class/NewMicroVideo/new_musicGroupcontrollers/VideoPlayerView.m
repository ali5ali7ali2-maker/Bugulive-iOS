//
//  VideoPlayerView.m
//  扩展Demo
//
//  Created by Hello on 2018/4/19.
//  Copyright © 2018年 Hello. All rights reserved.
//

#import "VideoPlayerView.h"
static VideoPlayerView *playerView = nil;
@implementation VideoPlayerView

+(instancetype)sharedVideoViewWithFrame:(CGRect)frame{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[VideoPlayerView alloc]initWithFrame:frame];
        playerView.backgroundColor = [UIColor clearColor];
    });
    return playerView;
}

@end
