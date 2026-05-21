//
//  BogoGoodDetailCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "FDTableViewCell.h"
@class BogoCommodityDetailModel;
@class BogoGoodDetailCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoGoodDetailCellDelegate <NSObject>

- (void)detailCell:(BogoGoodDetailCell *)detailCell didFinishLoad:(CGFloat)height;
- (void)detailCell:(BogoGoodDetailCell *)detailCell didClickInfoImage:(NSInteger)index;

@end

@interface BogoGoodDetailCell : FDTableViewCell

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, weak) id<BogoGoodDetailCellDelegate>delegate;

@property(nonatomic, strong) NSMutableArray *imageViewArray;

@end

NS_ASSUME_NONNULL_END
