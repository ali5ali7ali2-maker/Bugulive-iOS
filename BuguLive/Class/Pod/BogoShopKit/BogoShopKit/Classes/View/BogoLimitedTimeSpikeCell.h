//
//  BogoLimitedTimeSpikeCell.h
//  BogoShopKit
//
//  Created by Mac on 2021/7/8.
//

#import <UIKit/UIKit.h>
@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoLimitedTimeSpikeCell : UICollectionViewCell

@property(nonatomic, strong) BogoCommodityDetailModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *percentLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressConstraintWidth;

@property(nonatomic, copy) void (^clickBuyBtnBlock)(BogoCommodityDetailModel *model);

@end

NS_ASSUME_NONNULL_END
