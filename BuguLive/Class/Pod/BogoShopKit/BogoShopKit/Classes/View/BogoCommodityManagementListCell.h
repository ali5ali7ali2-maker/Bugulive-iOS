//
//  BogoCommodityManagementListCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/13.
//

#import <UIKit/UIKit.h>
#import "BogoShopKit.h"
@class BogoCommodityManagementListCell;
@class BogoCommodityManagementListModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCommodityManagementListCellDelegate <NSObject>

- (void)listCell:(BogoCommodityManagementListCell *)listCell didClickButton:(UIButton *)sender;

@end

@interface BogoCommodityManagementListCell : UITableViewCell

@property(nonatomic, weak) id<BogoCommodityManagementListCellDelegate>delegate;

@property(nonatomic, strong) BogoCommodityManagementListModel *model;

@end

NS_ASSUME_NONNULL_END
