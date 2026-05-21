//
//  BogoSearchVideoListCell.h
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmallVideoListModel;
@class BogoSearchVideoListCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoSearchVideoListCellDelegate <NSObject>

- (void)videoListCell:(BogoSearchVideoListCell *)videoListCell didClickVideo:(SmallVideoListModel *)model;

@end

@interface BogoSearchVideoListCell : UITableViewCell

@property(nonatomic, strong) NSArray <SmallVideoListModel *> *dataArray;

@property(nonatomic, weak) id<BogoSearchVideoListCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
