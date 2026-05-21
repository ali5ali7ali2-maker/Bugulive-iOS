//
//  BogoSearchHistoryItemCell.h
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BogoSearchHistoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoSearchHistoryItemCell : UICollectionViewCell

@property(nonatomic, strong) BogoSearchHistoryModel *model;

@end

NS_ASSUME_NONNULL_END
