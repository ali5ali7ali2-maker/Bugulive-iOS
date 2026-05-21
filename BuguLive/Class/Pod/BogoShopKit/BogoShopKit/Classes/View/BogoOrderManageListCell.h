//
//  BogoOrderManageListCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "FDTableViewCell.h"
#import "BogoShopKit.h"
@class BogoOrderManageListCell;
@class BogoOrderManageListModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoOrderManageListCellDeleghate <NSObject>

- (void)listCell:(BogoOrderManageListCell *)listCell didClickBtn:(UIButton *)sender;

@end

@interface BogoOrderManageListCell : FDTableViewCell

@property(nonatomic, weak) id<BogoOrderManageListCellDeleghate>delegate;

@property(nonatomic, strong) BogoOrderManageListModel *model;

@property(nonatomic, assign) BogoOrderManageViewControllerType listType;

@end

NS_ASSUME_NONNULL_END
