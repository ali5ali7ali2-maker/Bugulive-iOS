//
//  BogoAddressDetailCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "FDTableViewCell.h"
@class QMUITextView;
@class BogoAddressDetailCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoAddressDetailCellDelegate <NSObject>

- (void)detailCell:(BogoAddressDetailCell *)detailCell didTextChange:(QMUITextView *)textView;

@end

@interface BogoAddressDetailCell : FDTableViewCell

@property(nonatomic, copy) NSString *detailText;

@property(nonatomic, weak) id<BogoAddressDetailCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
