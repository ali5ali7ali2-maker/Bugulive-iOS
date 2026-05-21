//
//  BogoOrderSubmitAddressCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "FDTableViewCell.h"
@class BogoAddressListModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoOrderSubmitAddressCell : FDTableViewCell

@property(nonatomic, strong) BogoAddressListModel *model;

@end

NS_ASSUME_NONNULL_END
