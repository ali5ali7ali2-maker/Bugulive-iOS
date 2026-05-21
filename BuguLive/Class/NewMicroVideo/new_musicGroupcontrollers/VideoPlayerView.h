//
//  VideoPlayerView.h
//  扩展Demo
//
//  Created by Hello on 2018/4/19.
//  Copyright © 2018年 Hello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoPlayerView : UIView

@property (strong, nonatomic)AVPlayer *videoPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *playerItem;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）
+(instancetype)sharedVideoViewWithFrame:(CGRect)frame;

@end
