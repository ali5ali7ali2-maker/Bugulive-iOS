//
//  BogoPayOrderModel.h
//  BogoPayModuleObjC
//
//  Created by 范东 on 2020/3/14.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoPayOrderModel : FDModel

#pragma mark - 支付宝

/**订单字符串*/
@property (nonatomic, copy) NSString *pay_info;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
