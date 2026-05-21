//
//  BogoGoodDetailWebCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/4/30.
//

#import "FDTableViewCell.h"
@class BogoCommodityDetailModel;
@class BogoGoodDetailWebCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoGoodDetailWebCellDelegate <NSObject>

- (void)detailCell:(BogoGoodDetailWebCell *)detailCell didFinishLoad:(CGFloat)height;

@end

@interface BogoGoodDetailWebCell : FDTableViewCell

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, weak) id<BogoGoodDetailWebCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
