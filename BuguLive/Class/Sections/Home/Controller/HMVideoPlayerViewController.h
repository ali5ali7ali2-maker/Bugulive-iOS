//
//  HMRecomendViewController.h
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//  首页的推荐页面

#import "BGBaseViewController.h"
#import "HMVideoView.h"

#import "MGLiveRechargeView.h"

@class SmallVideoListModel;

NS_ASSUME_NONNULL_BEGIN

@interface HMVideoPlayerViewController : BGBaseViewController

@property(nonatomic, strong) HMVideoView *videoView;


//充值界面
@property(nonatomic, strong) MGLiveRechargeView *mgRechargeView;

@property(nonatomic, assign) BOOL isViewAppear;


// 播放单个视频
- (instancetype)initWithVideoModel:(SmallVideoListModel *)model;

// 播放一组视频，并指定播放位置
- (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index IsPushed:(BOOL)isPushed requestDict:(NSDictionary *)dict;

- (void)pausePlay;

- (void)resumePlay;

@property(nonatomic, copy) void (^isRefreshVideoBlock)(BOOL isRefresh);

@end

NS_ASSUME_NONNULL_END
