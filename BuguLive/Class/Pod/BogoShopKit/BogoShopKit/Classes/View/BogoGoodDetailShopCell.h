//
//  BogoGoodDetailShopCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "FDTableViewCell.h"
@class BogoCommodityDetailModel;
@class BogoGoodDetailShopCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoGoodDetailShopCellDelegate <NSObject>

- (void)shopCell:(BogoGoodDetailShopCell *)shopCell didClickGood:(BogoCommodityDetailModel *)model;
- (void)shopCell:(BogoGoodDetailShopCell *)shopCell didClickShopBtn:(UIButton *)sender;

@end

@interface BogoGoodDetailShopCell : FDTableViewCell

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, weak) id<BogoGoodDetailShopCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
