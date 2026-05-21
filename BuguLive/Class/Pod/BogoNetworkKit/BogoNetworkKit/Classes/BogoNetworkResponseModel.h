//
//  BogoNetworkResponseModel.h
//  BogoNetworkKit
//
//  Created by bogokj on 2020/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoNetworkResponseModel : NSObject

//"status": 200,
//"data": {},
//"msg": "订单创建成功!"

@property(nonatomic, copy) NSString *status;
@property(nonatomic, strong) id data;
@property(nonatomic, copy) NSString *msg;
@property(nonatomic, copy) NSString *error;

@end

NS_ASSUME_NONNULL_END
