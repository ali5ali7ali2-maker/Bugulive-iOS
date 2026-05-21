//
//  BogoCartCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "FDTableViewCell.h"
@class BogoCartListModel;
@class BogoCartCell;
@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCartCellDelegate <NSObject>

- (void)cartCell:(BogoCartCell *)cartCell didClickSelectBtn:(UIButton *)sender;
- (void)cartCell:(BogoCartCell *)cartCell didInputValue:(NSInteger)num;

@end

typedef NS_ENUM(NSInteger, BogoCartCellType) {
    BogoCartCellTypeNormal,
    BogoCartCellTypeOrderSubmit,
    BogoCartCellTypeConfirmOrder,//确认订单
};

@interface BogoCartCell : FDTableViewCell

@property(nonatomic, strong) BogoCartListModel *listModel;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, weak) id<BogoCartCellDelegate>delegate;

@property(nonatomic, assign) BogoCartCellType type;

@end

NS_ASSUME_NONNULL_END
