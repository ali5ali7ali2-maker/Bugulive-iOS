//
//  BogoShopFillInfoExtCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import <UIKit/UIKit.h>
@class BogoShopFillInfoExtCell;
@class BogoShopInfoModel;
@class BogoRefundDetailModel;

#define kBogoShopFillInfoExtCellBaseTag 300

NS_ASSUME_NONNULL_BEGIN

@protocol BogoShopFillInfoExtCellDelegate <NSObject>

- (void)extCell:(BogoShopFillInfoExtCell *)extCell didClickImageBtn:(UIButton *)sender;
- (void)extCell:(BogoShopFillInfoExtCell *)extCell didClickImageDelBtn:(UIButton *)sender;

@end

@interface BogoShopFillInfoExtCell : UITableViewCell

@property(nonatomic, weak) id<BogoShopFillInfoExtCellDelegate>delegate;

- (void)addButton;

- (void)addDeleteBtnToSuperView:(UIButton *)sender;

@property(nonatomic, strong) NSMutableArray *btnListArr;

@property(nonatomic, strong) BogoShopInfoModel *model;

@property(nonatomic, strong) BogoRefundDetailModel *refundModel;

@property(nonatomic, assign) BOOL isSee;

@property(nonatomic, assign) BOOL isMax;

@end

NS_ASSUME_NONNULL_END
