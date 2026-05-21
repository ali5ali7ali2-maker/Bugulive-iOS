//
//  BGRoomSetChannelCollectCell.h
//  UniversalApp
//
//  Created by bugu on 2020/3/23.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HallTypeModel;

NS_ASSUME_NONNULL_BEGIN

@interface BGRoomSetChannelCollectCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) VideoClassifiedModel *model;

@end

NS_ASSUME_NONNULL_END
