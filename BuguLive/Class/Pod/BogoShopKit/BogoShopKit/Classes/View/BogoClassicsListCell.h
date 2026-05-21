//
//  BogoClassicsListCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/25.
//

#import "FDTableViewCell.h"
@class BogoCommodityDetailModel;
@class BogoClassicsListCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoClassicsListCellDelegate <NSObject>

- (void)listCell:(BogoClassicsListCell *)listCell didClickOnlineBtn:(UIButton *)sender;
- (void)listCell:(BogoClassicsListCell *)listCell didClickShareBtn:(UIButton *)sender;

@end

@interface BogoClassicsListCell : FDTableViewCell

@property(nonatomic, strong) BogoCommodityDetailModel *model;
@property(nonatomic, weak) id<BogoClassicsListCellDelegate>delegate;

@property(nonatomic, copy) NSString *marketing_type;

@end

NS_ASSUME_NONNULL_END
