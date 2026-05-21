//
//  BogoShopRefundCell.h
//  BogoShopKit
//
//  Created by 宋晨光 on 2021/9/2.
//

#import <UIKit/UIKit.h>
#import "BogoRefundReasonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BogoShopRefundCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleL;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *selectBtn;

@property(nonatomic, strong) BogoRefundReasonModel *model;

@property(nonatomic, copy) void (^clickSelectModelBlock)(BogoRefundReasonModel *model);

@end

NS_ASSUME_NONNULL_END
