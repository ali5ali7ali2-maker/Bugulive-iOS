//
//  RoomMasterCell.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/2.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomUserInfo;
@class RoomWheatTypeModel;
@class RoomMasterCell;
NS_ASSUME_NONNULL_BEGIN

@protocol RoomMasterCellDelegate <NSObject>

- (void)masterCell:(RoomMasterCell *)masterCell didClickGiftView:(UIView *)giftView;
- (void)masterCell:(RoomMasterCell *)masterCell didClickUser:(RoomUserInfo *)model;

@end

@interface RoomMasterCell : UICollectionViewCell
@property(nonatomic, assign) BOOL is_open_guest;

@property(nonatomic, strong) RoomUserInfo *model;

@property(nonatomic, strong) Wheat_Type_List *wheatModel;
@property(nonatomic, weak) id<RoomMasterCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
