//
//  BogoOrderDetailCommodityCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/19.
//

#import "FDTableViewCell.h"
@class BogoOrderManageListModel;

typedef NS_ENUM(NSInteger, BogoOrderDetailCommodityCellType) {
    BogoOrderDetailCellTypeApplyRefund,
    BogoOrderDetailCellTypeOrderDetail,
};

NS_ASSUME_NONNULL_BEGIN

@interface BogoOrderDetailCommodityCell : FDTableViewCell

@property(nonatomic, strong) BogoOrderManageListModel *model;

@property(nonatomic, assign) BogoOrderDetailCommodityCellType type;

@end

NS_ASSUME_NONNULL_END
