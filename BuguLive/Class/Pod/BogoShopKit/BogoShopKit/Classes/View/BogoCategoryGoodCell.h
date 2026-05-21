//
//  BogoCategoryGoodCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/4/15.
//

#import "FDTableViewCell.h"
@class BogoCommodityDetailModel;
@class BogoCategoryGoodCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCategoryGoodCellDelegate <NSObject>

- (void)goodCell:(BogoCategoryGoodCell *)goodCell didClickBuyBtn:(UIButton *)sender;

@end

@interface BogoCategoryGoodCell : FDTableViewCell

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, weak) id<BogoCategoryGoodCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
