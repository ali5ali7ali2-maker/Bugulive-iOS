//
//  HMVideoPlayer.h
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TXLiteAVSDK_Professional/TXVodPlayer.h>
#import <TXLiteAVSDK_Professional/TXLiveBase.h>
#import <TXLiteAVSDK_Professional/TXVodPlayListener.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HMVideoPlayerStatus) {
    HMVideoPlayerStatusUnload,      // 未加载
    HMVideoPlayerStatusPrepared,    // 准备播放
    HMVideoPlayerStatusLoading,     // 加载中
    HMVideoPlayerStatusPlaying,     // 播放中
    HMVideoPlayerStatusPaused,      // 暂停
    HMVideoPlayerStatusEnded,       // 播放完成
    HMVideoPlayerStatusError        // 错误
};

@class HMVideoPlayer;

@protocol HMVideoPlayerDelegate <NSObject>

- (void)player:(HMVideoPlayer *)player statusChanged:(HMVideoPlayerStatus)status;

- (void)player:(HMVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress;

@end

@interface HMVideoPlayer : NSObject

@property (nonatomic, weak) id<HMVideoPlayerDelegate>     delegate;

@property (nonatomic, assign) HMVideoPlayerStatus         status;

@property (nonatomic, assign) BOOL                          isPlaying;
@property (nonatomic, strong) TXVodPlayer   *player;


/**
 根据指定url在指定视图上播放视频
 
 @param playView 播放视图
 @param url 播放地址
 */
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url;

/**
 停止播放并移除播放视图
 */
- (void)removeVideo;

/**
 暂停播放
 */
- (void)pausePlay;

/**
 恢复播放
 */
- (void)resumePlay;

/**
 重新播放
 */
- (void)resetPlay;

@end

NS_ASSUME_NONNULL_END
