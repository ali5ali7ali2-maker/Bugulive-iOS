//
//  FDNetworkResponseModel.h
//  FDNetworkObjC
//
//  Created by 范东 on 2020/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDNetworkResponseModel : NSObject

//"ret": 200,
//"data":
//"msg": "",

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) id data;
@property (nonatomic, copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
