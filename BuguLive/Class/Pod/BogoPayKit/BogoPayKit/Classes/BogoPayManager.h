//
//  BogoPayModuleObjCManager.h
//  BogoPayModuleObjC
//
//  Created by 范东 on 2020/3/14.
//

#import <Foundation/Foundation.h>
@class BogoPayOrderModel;
@class BogoPayResponseModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^bogo_payResponseCallBack)(BogoPayResponseModel *responseModel);

typedef NS_ENUM(NSInteger, BogoPayType) {
    BogoPayTypeAliPay,
    BogoPayTypeWeChat
};

@interface BogoPayManager : NSObject

@property (nonatomic, copy) bogo_payResponseCallBack bogo_payResponseCallBack;

+ (BogoPayManager *)defaultManager;

- (void)pay:(BogoPayType)payType orderModel:(BogoPayOrderModel *)orderModel;

- (void)handlePayURL:(NSURL *)url callBack:(bogo_payResponseCallBack)bogo_payResponseCallBack;

@end

NS_ASSUME_NONNULL_END
