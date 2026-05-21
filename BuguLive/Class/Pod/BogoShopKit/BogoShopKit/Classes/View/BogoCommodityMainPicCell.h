//
//  BogoCommodityMainPicCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import "FDTableViewCell.h"
@class BogoCommodityMainPicCell;
@class BogoCommodityDetailModel;

#define kBogoCommodityMainPicCellBaseTag 200

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCommodityMainPicCellDelegate <NSObject>

- (void)picCell:(BogoCommodityMainPicCell *)picCell didClickPicBtn:(UIButton *)sender;
- (void)picCell:(BogoCommodityMainPicCell *)picCell didClickPicDeleteBtn:(UIButton *)sender;

@end

@interface BogoCommodityMainPicCell : FDTableViewCell

@property(nonatomic, weak) id<BogoCommodityMainPicCellDelegate>delegate;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, assign) BOOL isSee;

- (void)addDeleteBtnToView:(UIButton *)superView;

@end

NS_ASSUME_NONNULL_END
