//
//  BGConversationListController.h
//  BuguLive
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGConversationSegmentController.h"
#import <UIKit/UIKit.h>
@class SFriendObj;

@protocol ConversationListViewDelegate <NSObject>

@optional

- (void)clickFriendItem:(SFriendObj *)obj; //点击某行

- (void)reloadChatBadge:(int)selectItem; //删除对话时修改角标

- (void)updateChatFriendBadge:(int)unReadNum; //修改角标

@end

@interface BGConversationListController : BGConversationSegmentController

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *conversationArr;

@property (nonatomic, assign) BOOL isHaveLive; //只有一半的情况

@property (nonatomic, weak) id<ConversationListViewDelegate> delegate;

- (void)updateTableViewFrame;

@end
