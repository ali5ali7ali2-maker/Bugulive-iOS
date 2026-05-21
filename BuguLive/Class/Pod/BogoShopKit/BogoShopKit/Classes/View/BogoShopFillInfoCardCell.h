//
//  BogoShopFillInfoCardCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import <UIKit/UIKit.h>
@class BogoShopFillInfoCardCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoShopFillInfoCardCellDelegate <NSObject>

- (void)cardCell:(BogoShopFillInfoCardCell *)cardCell didClickHandImageBtn:(UITapGestureRecognizer *)sender;
- (void)cardCell:(BogoShopFillInfoCardCell *)cardCell didClickLogoImageBtn:(UITapGestureRecognizer *)sender;

@end

@interface BogoShopFillInfoCardCell : UITableViewCell

@property(nonatomic, weak) id<BogoShopFillInfoCardCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property(nonatomic, assign) BOOL isSee;

@end

NS_ASSUME_NONNULL_END
