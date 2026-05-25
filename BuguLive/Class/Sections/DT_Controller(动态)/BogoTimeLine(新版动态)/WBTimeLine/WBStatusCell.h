//
//  WBFeedCell.h
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "WBStatusLayout.h"
#import "YYTableViewCell.h"

#import "CommonStatusView.h"
//#import "CommonLocationView.h"
#import "CommonLevelView.h"
#import "CommonSexView.h"
//#import "clp"
#import <CLPlayer/CLPlayerView.h>

@class BogoDynamicAudioButton;
@class WBStatusCell;
@protocol WBStatusCellDelegate;
@class SpectrumView;


@interface WBStatusProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) YYLabel *addressLabel;//地址信息
@property (nonatomic, strong) YYLabel *timeLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, weak) WBStatusCell *cell;

@property(nonatomic, strong) CommonSexView *sexView;
//@property(nonatomic, strong) CommonLevelView *levelView;

//@property(nonatomic, strong) CommonLocationView *locationView;
@property(nonatomic, strong) CommonStatusView *statusView;

@property(nonatomic, strong) UIButton *moreBtn;
//@property (nonatomic, strong) UIButton *deleteBtn;           // 删除按钮

//置顶按钮
@property (nonatomic, strong) UIButton *topBtn;
@end

@interface WBStatusTimeView : UIView

@property (nonatomic, strong) YYLabel *timeLabel;
@end


@interface WBStatusCardView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) WBStatusCell *cell;

@property (nonatomic, strong) CLPlayerView *playerView;

@end

@interface WBStatusLocationView : UIView

@property (nonatomic, weak) WBStatusCell *cell;

- (void)setWithLayout:(WBStatusLayout *)layout;

@end

@interface WBStatusCommentBtn : UIControl

@end


@interface WBStatusToolbarView : UIView

@property(nonatomic, strong) NSMutableArray *likeSubviews;

@property(nonatomic, strong) QMUIButton *praiseBtn;
@property(nonatomic, strong) QMUIButton *commentBtn;
@property (nonatomic, weak) WBStatusCell *cell;

- (void)setWithLayout:(WBStatusLayout *)layout;
// set both "liked" and "likeCount"
- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation;
@end




@interface WBStatusView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) WBStatusProfileView *profileView; // 用户资料
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片
@property (nonatomic, strong) UIView *retweetBackgroundView;    //转发容器
@property (nonatomic, strong) YYLabel *retweetTextLabel;        // 转发文本
@property(nonatomic, strong) WBStatusLocationView *locationView;
@property (nonatomic, strong) WBStatusCardView *cardView;       // 卡片
@property (nonatomic, strong) WBStatusTimeView *timeView; // 时间
@property (nonatomic, strong) WBStatusToolbarView *toolbarView; // 工具栏
@property(nonatomic, strong) WBStatusCommentBtn *commentBtn;//评论框
@property (nonatomic, strong) UIImageView *vipBackgroundView;   // VIP 自定义背景
@property (nonatomic, strong) UIButton *menuButton;             // 菜单按钮
@property (nonatomic, strong) UIButton *followButton;           // 关注按钮

@property (nonatomic, strong) UIButton *deleteBtn;           // 删除按钮
@property (nonatomic, strong) UIView *lineView;           // 删除按钮

@property (nonatomic, strong) WBStatusLayout *layout;
@property (nonatomic, weak) WBStatusCell *cell;

//@property(nonatomic, strong) BogoDynamicAudioButton *audioBtn;//音频按钮
@property(nonatomic, strong) SpectrumView *trumView;

@property(nonatomic, assign) BOOL isfollow;

@end



@protocol WBStatusCellDelegate;
@interface WBStatusCell : YYTableViewCell

@property (nonatomic, weak) id<WBStatusCellDelegate> delegate;
@property (nonatomic, strong) WBStatusView *statusView;
@property(nonatomic, assign) BOOL isShowMore;
@property(nonatomic, strong) WBStatusLayout *layout;
- (void)setLayout:(WBStatusLayout *)layout;
@property(nonatomic, assign) BOOL isfollow;

@property(nonatomic, assign) NSInteger indexRows;

@end



@protocol WBStatusCellDelegate <NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(WBStatusCell *)cell;
/// 点击了 Card
- (void)cellDidClickCard:(WBStatusCell *)cell;
/// 点击了转发内容
- (void)cellDidClickRetweet:(WBStatusCell *)cell;
/// 点击了Cell菜单
- (void)cellDidClickMenu:(WBStatusCell *)cell;
/// 点击了关注
- (void)cellDidClickFollow:(WBStatusCell *)cell;
/// 点击了转发
- (void)cellDidClickRepost:(WBStatusCell *)cell;
/// 点击了下方 Tag
- (void)cellDidClickTag:(WBStatusCell *)cell;
/// 点击了评论
- (void)cellDidClickComment:(WBStatusCell *)cell;
/// 点击了赞
- (void)cellDidClickLike:(WBStatusCell *)cell;
/// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBModel *)user;
/// 点击了图片
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index;
/// 点击了 Label 的链接
- (void)cell:(WBStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
/// 点击了视频
- (void)cell:(WBStatusCell *)cell didClickVideo:(NSString *)url;
//点击了话题
- (void)cell:(WBStatusCell *)cell didClickTopic:(NSString *)topic;
//点击了更多
- (void)cell:(WBStatusCell *)cell didClickMore:(UIButton *)sender;

//点击了删除
- (void)cell:(WBStatusCell *)cell didClickDeleteBtn:(UIButton *)sender;

//点击了音频
- (void)cell:(WBStatusView *)cell didClickAudio:(UIButton *)sender;

@end
