//
//  UIView+addVideoToView.m
//  扩展Demo
//
//  Created by Hello on 2018/4/19.
//  Copyright © 2018年 Hello. All rights reserved.
//

#import "UIView+addVideoToView.h"
#import "VideoPlayerView.h"

@implementation UIView (addVideoToView)

-(void)addVideoWithPlayerLayerFrame:(CGRect)frame withPlayerItemUrlString:(NSString *)url complete:(void (^)(AVPlayer *))block{

    VideoPlayerView *playerView = [VideoPlayerView sharedVideoViewWithFrame:frame];
    [playerView.playerLayer removeFromSuperlayer];
    [playerView removeFromSuperview];
    NSURL *mediaURL = [NSURL URLWithString:url];
    playerView.playerItem = [AVPlayerItem playerItemWithURL:mediaURL];
    playerView.videoPlayer = [[AVPlayer alloc] initWithPlayerItem:playerView.playerItem];
    playerView.playerLayer = [AVPlayerLayer playerLayerWithPlayer:playerView.videoPlayer];
    playerView.playerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [playerView.layer addSublayer:playerView.playerLayer];
    [playerView.videoPlayer pause];
    [self addSubview:playerView];
    
    block(playerView.videoPlayer);
}
@end
