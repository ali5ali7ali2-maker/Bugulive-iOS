//
//  RoomMicManageCell.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/7.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomMicManageCell;
@class RoomUserInfo;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RoomMicManageCellType) {
    RoomMicManageCellTypeManageView,
    RoomMicManageCellTypeUserList,
    RoomMicManageCellTypeBroadcaster,
    RoomMicManageCellTypeApplyList
};

@protocol RoomMicManageCellDelegate <NSObject>

- (void)manageCell:(RoomMicManageCell *)messageCell didClickManageBtn:(UIButton *)sender;
@optional
- (void)manageCell:(RoomMicManageCell *)messageCell didClickMicBtn:(UIButton *)sender;

@end

@interface RoomMicManageCell : UITableViewCell

@property(nonatomic, weak) id<RoomMicManageCellDelegate>delegate;

@property(nonatomic, strong) RoomUserInfo *model;

@property(nonatomic, assign) RoomMicManageCellType type;

@end

NS_ASSUME_NONNULL_END
