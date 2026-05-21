//
//  UIView+addVideoToView.h
//  扩展Demo
//
//  Created by Hello on 2018/4/19.
//  Copyright © 2018年 Hello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface UIView (addVideoToView)


/**
 添加视频视图

 @param frame 视图大小位置
 @param url 视频网络链接
 @param block 返回AVPlayer,用于暂停、播放、获取播放进度、调节播放进度
 在block中需要主动开启AVPlayer播放
 */
-(void)addVideoWithPlayerLayerFrame:(CGRect)frame withPlayerItemUrlString:(NSString *)url complete:(void(^)(AVPlayer *player))block;

@end
