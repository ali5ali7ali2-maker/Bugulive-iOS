//
//  HMVideoView.h
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//  包含三个视频的View

#import "BGBaseView.h"
#import "HMVideoViewModel.h"
#import "HMVideoControlView.h"
#import "HMCommentView.h"
#import "HMVideoPlayer.h"
@class HMVideoView;

NS_ASSUME_NONNULL_BEGIN

@protocol HMVideoViewDelegate <NSObject>

- (void)videoViewDidClickOneOnOne:(HMVideoView *)videoView;
- (void)controlViewDidClickSelf:(HMVideoView *)videoView;
- (void)videoViewDidClickRecharge:(HMVideoView *)videoView;
- (void)videoViewDidClickReport:(HMVideoView *)videoView;
- (void)deleteVideoWithView:(HMVideoView *)videoView;

@end

@interface HMVideoView : BGBaseView

@property (nonatomic, weak) id<HMVideoViewDelegate>delegate;

@property (nonatomic, strong) HMVideoViewModel    *viewModel;

@property (nonatomic, strong) HMVideoControlView      *currentPlayView; //当前播放的View

@property (nonatomic, strong) HMCommentView *commentView; //评论列表

@property (nonatomic, strong) HMVideoPlayer              *player;

@property (nonatomic, strong) GiftView *giftView;

@property(nonatomic, assign) BOOL isRecommend;

@property (nonatomic, strong) UIScrollView              *scrollView;

@property(nonatomic, copy) void (^isRefreshVideoBlock)(BOOL isRefresh);

@property(nonatomic, copy) void (^clickHeadBlock)(NSString *userID);

- (instancetype)initWithVC:(UIViewController *)vc isPushed:(BOOL)isPushed requestDict:(NSDictionary *)dict;

- (void)setModels:(NSArray *)models index:(NSInteger)index;

-(void)deleteViewModel;

- (void)pause;
- (void)resume;
- (void)destoryPlayer;
- (void)playVideoFrom:(HMVideoControlView *)fromView;

- (void)clickShareViewReportBtn;

-(void)hiddenGiftView;
@end

NS_ASSUME_NONNULL_END
