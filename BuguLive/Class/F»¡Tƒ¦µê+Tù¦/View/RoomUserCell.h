//
//  RoomUserCell.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/1.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomUserInfo;
@class RoomWheatTypeModel;
@class RoomUserCell;

NS_ASSUME_NONNULL_BEGIN

@protocol RoomUserCellDelegate <NSObject>

- (void)userCell:(RoomUserCell *)userCell didClickGiftView:(UIView *)giftView;

@end

@interface RoomUserCell : UICollectionViewCell
@property(nonatomic, assign) BOOL is_open_guest;

@property(nonatomic, strong) RoomUserInfo *model;

@property(nonatomic, strong) Wheat_Type_List *wheatModel;

@property(nonatomic, weak) id<RoomUserCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
