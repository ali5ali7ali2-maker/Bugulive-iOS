//
//  BogoDeductionCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/8/29.
//

#import "FDTableViewCell.h"
@class BogoDeductionCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoDeductionCellDelegate <NSObject>

- (void)deductionCell:(BogoDeductionCell *)deductionCell didClickSelectBtn:(UIButton *)sender;

@end

@interface BogoDeductionCell : FDTableViewCell

@property(nonatomic, weak) id<BogoDeductionCellDelegate>delegate;

- (void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
