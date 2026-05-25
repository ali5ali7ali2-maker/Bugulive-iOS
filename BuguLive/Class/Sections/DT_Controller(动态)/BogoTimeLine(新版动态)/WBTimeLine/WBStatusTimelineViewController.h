//
//  YYWeiboFeedListController.h
//  YYKitExample
//
//  Created by ibireme on 15/9/4.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "BogoBaseViewController.h"
#import "YYTableView.h"

typedef NS_ENUM(NSInteger, WBStatusTimelineViewControllerType) {
    WBStatusTimelineViewControllerTypeFocus,
    WBStatusTimelineViewControllerTypeGround,
    WBStatusTimelineViewControllerTypeNear,
    WBStatusTimelineViewControllerTypeUser,
    WBStatusTimelineViewControllerTypeFriend,
    WBStatusTimelineViewControllerTypeTopic
};

/// 动态列表
@interface WBStatusTimelineViewController : BogoBaseViewController

@property(nonatomic, assign) CGRect tableViewFrame;

@property(nonatomic, copy) NSString *to_user_id;

@property(nonatomic, assign) WBStatusTimelineViewControllerType type;

@property(nonatomic, copy) NSString *topic;

@property(nonatomic, assign) BOOL isFront;

- (void)refreshData;

- (void)refreshDataNew;

- (void)headerRefreshToTop:(BOOL)toTop;

@end
