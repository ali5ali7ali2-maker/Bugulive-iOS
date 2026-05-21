//
//  BogoLimitedTimeSpikeTopCell.h
//  BogoShopKit
//
//  Created by Mac on 2021/7/8.
//

#import <UIKit/UIKit.h>
#import "BogoLimitedTimeSpikeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BogoLimitedTimeSpikeTopCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;

@property(nonatomic, strong) BogoLimitedTimeSpikeModel *model;

@property(nonatomic, copy) void (^returnTimeBlock)(BogoLimitedTimeSpikeModel *model);

@end

NS_ASSUME_NONNULL_END
