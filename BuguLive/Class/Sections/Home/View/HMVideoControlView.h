//
//  HMVideoControlView.h
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//

#import "BGBaseView.h"
#import "SmallVideoListModel.h"
@class HMVideoControlView;

NS_ASSUME_NONNULL_BEGIN

@protocol HMVideoControlViewDelegate <NSObject>

- (void)controlViewDidClickSelf:(HMVideoControlView *)controlView;

- (void)controlViewDidClickIcon:(HMVideoControlView *)controlView;


- (void)controlViewDidClickMoreBtn:(HMVideoControlView *)controlView;

- (void)controlViewDidClickPriase:(HMVideoControlView *)controlView;

- (void)controlViewDidClickComment:(HMVideoControlView *)controlView DataArray:(NSMutableArray *)dataArray;

- (void)controlViewDidClickShare:(HMVideoControlView *)controlView ShareDict:(NSMutableDictionary *)shareDict;
//赠送礼物
- (void)controlViewDidClickGift:(HMVideoControlView *)controlView;

- (void)controlViewDidClickOneOnOne:(HMVideoControlView *)controlView;

- (void)controlViewDidClickBottomComment:(HMVideoControlView *)controlView;

- (void)controlViewDidClickFocus:(HMVideoControlView *)controlView;

- (void)controlViewDidClickGood:(HMVideoControlView *)controlView;

@end

@interface HMVideoItemButton : UIButton

@end

@interface HMVideoControlView : BGBaseView

@property (nonatomic, weak) id<HMVideoControlViewDelegate> delegate;

// 视频封面图:显示封面并播放视频
@property (nonatomic, strong) UIImageView       *coverImgView;

@property (nonatomic, strong) SmallVideoListModel    *model;

@property (nonatomic, strong) HMVideoItemButton   *commentBtn;

@property (nonatomic, strong) UIButton *commentButton;

@property(nonatomic, strong) UIButton *moreBtn;

@property(nonatomic, assign) BOOL isPushed;

- (instancetype)initWithIsPushed:(BOOL)isPushed;

- (void)setProgress:(float)progress;

- (void)startLoading;
- (void)stopLoading;

- (void)showPlayBtn;
- (void)hidePlayBtn;

- (void)setiIsPraise:(BOOL)isPraise diggcount:(NSString *)diggcount;

- (void)commentBtnClick:(id)sender;

-(void)loadNetDataWithPage:(int)page;

@end

NS_ASSUME_NONNULL_END
