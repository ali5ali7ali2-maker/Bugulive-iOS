//
//  BGRoomSetChannelCell.h
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HallTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGRoomSetChannelCell : UITableViewCell
@property(nonatomic, strong) NSArray *channelDataArray;
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, copy) void (^selectedChannel)(VideoClassifiedModel * model);

@property(nonatomic, strong) NSString *voice_type;
//半透明背景
@property(nonatomic, strong) UIImageView *bgImageView;

@end

NS_ASSUME_NONNULL_END
