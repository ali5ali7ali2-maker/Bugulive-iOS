//
//  BogoNewsViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/12.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BaseViewController.h"

#import <UIKit/UIKit.h>

#import "BGConversationSegmentController.h"

NS_ASSUME_NONNULL_BEGIN

@class SFriendObj;

@protocol ConversationListViewDelegate <NSObject>

@optional

- (void)clickFriendItem:(SFriendObj *)obj; //点击某行

- (void)reloadChatBadge:(int)selectItem; //删除对话时修改角标

- (void)updateChatFriendBadge:(int)unReadNum; //修改角标

@end

@interface BogoNewsViewController :BGConversationSegmentController

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *conversationArr;

@property (nonatomic, assign) BOOL isHaveLive; //只有一半的情况

@property (nonatomic, weak) id<ConversationListViewDelegate> delegate;

- (void)updateTableViewFrame;


@end

NS_ASSUME_NONNULL_END
