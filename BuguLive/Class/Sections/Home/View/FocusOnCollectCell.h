//
//  FocusOnCollectCell.h
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHotItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FocusOnCollectCell : UICollectionViewCell
@property(nonatomic, strong) HMHotItemModel *user;
@property (nonatomic, copy) dispatch_block_t followBlock;
@property(nonatomic, copy) void(^clickImgBlock)(NSString *str);

@end

NS_ASSUME_NONNULL_END
