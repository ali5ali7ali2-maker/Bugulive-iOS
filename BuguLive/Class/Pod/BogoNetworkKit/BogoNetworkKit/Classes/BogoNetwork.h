//
//  BogoNetwork.h
//  BogoNetworkKit
//
//  Created by bogokj on 2020/3/13.
//

#import <Foundation/Foundation.h>
@class BogoNetworkResponseModel;
@class BogoNetworkInitModel;
#import "FDNetworkObjC.h"
#import "BogoAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoNetwork : NSObject

@property(nonatomic, strong) NSString *url_prefix;
@property(nonatomic, strong) NSString *urlV2_prefix;
@property(nonatomic, strong) NSString *urlV3_prefix;

@property(nonatomic, strong) BogoNetworkInitModel *indexModel;

@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) BogoAddressModel *addressModel;

/**
 * 获取单例
 * @return BaseNetworking单例对象
 */
+ (BogoNetwork *)shareInstance;

- (void)initCityData;

- (void)saveIndexModel:(BogoNetworkInitModel *)indexModel;

/*!
 *   @brief 超时时间,默认30秒
 */
@property (assign, nonatomic) NSTimeInterval timeoutInterval;

/*!
 *   @brief 请求内容类型，默认JSON
 */
@property (assign, nonatomic) RequestContentType requestContentType;

/*!
 *   @brief 返回数据内容类型，默认JSON
 */
@property (assign, nonatomic) ResponseContentType responseContentType;


/**
 *  GET请求
 *
 *  @param URLString 网络请求地址
 *  @param param      参数(可以是字典或者nil)
 *  @param success   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)GET:(NSString *)URLString param:(nullable NSDictionary *)param success:(nullable void (^)(BogoNetworkResponseModel *result))success failure:(nullable void (^)(NSString *error))failure;

- (void)GETV2:(NSString *)URLString param:(nullable NSDictionary *)param success:(nullable void (^)(BogoNetworkResponseModel *result))success failure:(nullable void (^)(NSString *error))failure;

/**
 *  POST请求
 *
 *  @param URLString 网络请求地址
 *  @param param      参数(可以是字典或者nil)
 *  @param success   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)POST:(NSString *)URLString param:(nullable NSDictionary *)param success:(nullable void (^)(BogoNetworkResponseModel *result))success failure:(nullable void (^)(NSString *error))failure;


- (void)POSTV2:(NSString *)URLString param:(nullable NSDictionary *)param success:(nullable void (^)(BogoNetworkResponseModel *result))success failure:(nullable void (^)(NSString *error))failure;

- (void)POSTV3:(NSString *)URLString param:(nullable NSDictionary *)param success:(nullable void (^)(BogoNetworkResponseModel *result))success failure:(nullable void (^)(NSString *error))failure;

- (void)POSTV4:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(id  _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure;

@end

NS_ASSUME_NONNULL_END

