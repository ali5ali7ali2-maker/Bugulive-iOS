//
//  BogoNewsSystemViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/14.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGConversationSegmentController.h"
#import <UIKit/UIKit.h>
@class SFriendObj;

NS_ASSUME_NONNULL_BEGIN

@interface BogoNewsSystemViewController : BGConversationSegmentController


@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *conversationArr;

@property (nonatomic, assign) BOOL isHaveLive; //只有一半的情况

//@property (nonatomic, weak) id<ConversationListViewDelegate> delegate;

- (void)updateTableViewFrame;

@end

NS_ASSUME_NONNULL_END
