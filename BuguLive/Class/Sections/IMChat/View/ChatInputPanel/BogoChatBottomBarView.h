//
//  BogoChatBottomBarView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/28.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatEmojiView.h"
#import "ChatMoreView.h"
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>

static CGFloat const kBogoChatBarViewHeight = 234.0f;

//kRealValue(358) + MG_BOTTOM_MARGIN;
//KGiftViewHeight;
static CGFloat const kBogoChatBarBottomOffset = 8.f;
static CGFloat const kBogoChatBarTextViewBottomOffset = 6;
static CGFloat const kBogoChatBarTextViewFrameMinHeight = 37.f;
static CGFloat const kBogoChatBarTextViewFrameMaxHeight = 82.f;
static CGFloat const kBogoChatBarMaxHeight = kBogoChatBarTextViewFrameMaxHeight + 2 * kBogoChatBarTextViewBottomOffset;
static CGFloat const kBogoChatBarMinHeight = kBogoChatBarTextViewFrameMinHeight + 2 * kBogoChatBarTextViewBottomOffset;

/**
 *  chatBar显示类型
 */
typedef NS_ENUM(NSUInteger, BOGOChatBarShowType) {
    BOGOChatBarShowTypeNothing /**不显示chatbar */,
    BOGOChatBarShowTypeFace /**显示表情View */,
    BOGOChatBarShowTypeVoice /**显示录音view */,
    BOGOChatBarShowTypeMore /**显示更多view */,
    BOGOChatBarShowTypeKeyboard /**显示键盘 */,
};

@protocol ChatBottomBarDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface BogoChatBottomBarView : UIView


@property (nonatomic, strong) UIView *inputBarBackgroundView; //输入栏目背景视图
@property (nonatomic, strong) UIView *maskView; //无私信权限
@property (strong, nonatomic) UIButton *voiceButton;          //切换录音模式按钮
@property (strong, nonatomic) UIButton *voiceRecordButton;    //录音按钮
@property (strong, nonatomic) UIButton *faceButton;           //表情按钮
@property (strong, nonatomic) UIButton *moreButton;           //更多按钮
@property (strong, nonatomic) ChatBarTextView *textView;      //输入框
@property (strong, nonatomic) ChatEmojiView *emojiView;
@property (nonatomic, assign) BOGOChatBarShowType showType;
@property (nonatomic, assign) BOOL mbhalf;
//@property (weak, nonatomic) ChatFaceView *faceView;
@property (weak, nonatomic) UIView *faceView;
@property (weak, nonatomic) ChatMoreView *moreView;
@property (weak, nonatomic) id<ChatBottomBarDelegate> delegate;

@property (assign, nonatomic) CGSize keyboardSize;
@property (assign, nonatomic) CGFloat oldTextViewHeight;
@property (assign, nonatomic) CGFloat animationDuration;
@property (nonatomic, assign, getter=isClosed) BOOL close;
@property (nonatomic, assign, getter=shouldAllowTextViewContentOffset) BOOL allowTextViewContentOffset;

@property(nonatomic, assign) BOOL isShowKeyBoard;

@property(nonatomic, assign) CGFloat chatBarViewHeight;

- (void)hideChatBottomBar;

- (void)updateChatBarConstraintsIfNeededShouldCacheText:(BOOL)shouldCacheText;


@end


@protocol ChatBottomBarDelegate <NSObject>

@optional

/**
 改变聊天界面tableView 高度
 @param chatBar 底部菜单
 */
- (void)chatBarFrameDidChange:(ChatBottomBarView *)chatBar shouldScrollToBottom:(CGFloat)keyBoardHeight showType:(BOGOChatBarShowType)showType showAnimationTime:(CGFloat)showAnimationTime;

/**
 发送普通的文字信息,可能带有表情
 @param chatBar chatBar
 @param message 发送的消息
 */
- (void)chatBar:(ChatBottomBarView *)chatBar sendMessage:(NSString *)message;

/**
 *  输入了 @ 的时候
 *
 */
- (void)didInputAtSign:(ChatBottomBarView *)chatBar;

- (NSArray *)regulationForBatchDeleteText;

@end


NS_ASSUME_NONNULL_END
