//
//  BogoPayResponseModel.h
//  BogoPayModuleObjC
//
//  Created by 范东 on 2020/3/14.
//

#import "FDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoPayResponseModel : FDModel

@property (nonatomic, assign) BOOL isSuccess;

#pragma mark - 支付宝
@property (nonatomic, copy) NSString *resultStatus;

@end

NS_ASSUME_NONNULL_END
