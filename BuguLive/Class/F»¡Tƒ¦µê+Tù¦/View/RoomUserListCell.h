//
//  RoomUserListCell.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/16.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomUserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface RoomUserListCell : UITableViewCell

@property(nonatomic, strong) RoomUserInfo *model;

@end

NS_ASSUME_NONNULL_END
