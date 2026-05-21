//
//  BogoCommodityAddCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/8/15.
//

#import <UIKit/UIKit.h>
@class BogoCommodityDetailModel;
@class BogoCommodityAddCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCommodityAddCellDelegate <NSObject>

- (void)addCell:(BogoCommodityAddCell *)addCell didClickOperateBtn:(UIButton *)sender;

@end

@interface BogoCommodityAddCell : UITableViewCell

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, weak) id<BogoCommodityAddCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
