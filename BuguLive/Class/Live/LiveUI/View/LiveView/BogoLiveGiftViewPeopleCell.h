//
//  BogoLiveGiftViewPeopleCell.h
//  UniversalApp
//
//  Created by bogokj on 2020/1/14.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomUserInfo;
@class RoomUsers;

NS_ASSUME_NONNULL_BEGIN

@interface BogoLiveGiftViewPeopleCell : UICollectionViewCell

@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) RoomUserInfo *user;

@end

NS_ASSUME_NONNULL_END
