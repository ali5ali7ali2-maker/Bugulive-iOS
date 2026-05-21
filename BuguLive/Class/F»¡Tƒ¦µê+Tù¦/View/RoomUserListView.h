//
//  RoomUserListView.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/16.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomPopView.h"
@class RoomModel;
@class RoomUserListView;
@class RoomUserInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol RoomUserListViewDelegate <NSObject>

- (void)listView:(RoomUserListView *)listView didSelectUser:(RoomUserInfo *)user;

@end

@interface RoomUserListView : RoomPopView

@property(nonatomic, strong) RoomModel *model;

@property(nonatomic, weak) id<RoomUserListViewDelegate>delegate;
@property(nonatomic, strong) NSString *room_id;
@end

NS_ASSUME_NONNULL_END
