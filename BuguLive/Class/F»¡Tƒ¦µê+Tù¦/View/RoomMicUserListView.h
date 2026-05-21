//
//  RoomMicUserListView.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/8.
//  Copyright © 2019 voidcat. All rights reserved.
//

@class RoomMicUserListView;
@class RoomMicManageCell;
@class RoomModel;
#import "BGRoomMicManageCell.h"
#import "VoiceHTTPManger.h"
NS_ASSUME_NONNULL_BEGIN

@protocol RoomMicUserListViewDelegate <NSObject>

- (void)userListView:(RoomMicUserListView *)userListView manageCell:(BGRoomMicManageCell *)messageCell didClickManageBtn:(UIButton *)sender;

@end

@interface RoomMicUserListView : UIView

@property(nonatomic, weak) id<RoomMicUserListViewDelegate>delegate;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *dataArray2;
@property(nonatomic, strong) RoomModel *model;
@property(nonatomic, assign) RoomMicManageCellType type;

@property(nonatomic, strong) UIViewController *vc;
- (void)show:(UIView *)superView;
- (void)hide;
@property(nonatomic, strong) VoiceHTTPManger *voiceApi;

@end

NS_ASSUME_NONNULL_END
