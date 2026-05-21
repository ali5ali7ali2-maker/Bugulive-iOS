//
//  BogoShopSelectedButtonCell.h
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import <UIKit/UIKit.h>
@class BogoShopSelectedButtonCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoShopSelectedButtonCellDelegate <NSObject>

- (void)buttonCell:(BogoShopSelectedButtonCell *)buttonCell didClickTimeBtn:(UIButton *)sender;
- (void)buttonCell:(BogoShopSelectedButtonCell *)buttonCell didClickGoodBtn:(UIButton *)sender;
- (void)buttonCell:(BogoShopSelectedButtonCell *)buttonCell didClickTopBtn:(UIButton *)sender;

@end

@interface BogoShopSelectedButtonCell : UICollectionViewCell

@property(nonatomic, weak) id<BogoShopSelectedButtonCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
