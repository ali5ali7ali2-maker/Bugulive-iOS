//
//  BGRoomManagerCell.h
//  UniversalApp
//
//  Created by bugu on 2020/3/24.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomUserInfo;

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RoomManagerCellType) {
    RoomManagerCellTypeAdd,
    RoomManagerCellTypeCancel,
    
};
@interface BGRoomManagerCell : UITableViewCell

@property(nonatomic, assign) RoomManagerCellType cellType;

@property(nonatomic, copy) void (^addActionBlock)(void);
@property(nonatomic, copy) void (^cancelActionBlock)(void);

@property(nonatomic, strong) RoomUserInfo *info;

@end

NS_ASSUME_NONNULL_END
