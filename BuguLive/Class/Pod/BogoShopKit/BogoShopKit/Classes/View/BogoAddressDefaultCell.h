//
//  BogoAddressDefaultCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "FDTableViewCell.h"
@class BogoAddressDefaultCell;
@class  BogoAddressListModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoAddressDefaultCellDelegate <NSObject>

-(void)defaultCell:(BogoAddressDefaultCell *)defaultCell didValueChanged:(UISwitch *)defaultSwitch;

@end

@interface BogoAddressDefaultCell : FDTableViewCell

@property(nonatomic, weak) id<BogoAddressDefaultCellDelegate>delegate;

@property(nonatomic, strong) BogoAddressListModel *model;

@end

NS_ASSUME_NONNULL_END
