//
//  BogoAddressListCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "FDTableViewCell.h"
@class BogoAddressListModel;
@class BogoAddressListCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoAddressListCellDelegate <NSObject>

- (void)listCell:(BogoAddressListCell *)listCell didClickEditBtn:(UIButton *)sender;

@end

@interface BogoAddressListCell : FDTableViewCell

@property(nonatomic, strong) BogoAddressListModel *model;

@property(nonatomic, weak) id<BogoAddressListCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
