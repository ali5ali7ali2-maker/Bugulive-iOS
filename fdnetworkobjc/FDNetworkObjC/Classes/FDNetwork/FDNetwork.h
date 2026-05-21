//
//  FDNetwork.h
//  AFNetworking
//
//  Created by fandongtongxue on 2020/2/27.
//

#import <Foundation/Foundation.h>
@class FDNetworkResponseModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RequestContentType){
    RequestContentTypeJSON,
};

typedef NS_ENUM(NSInteger, ResponseContentType){
    ResponseContentTypeJSON,
    ResponseContentTypeText,
};

@interface FDNetwork : NSObject

/**
 * 获取单例
 * @return BaseNetworking单例对象
 */
+ (FDNetwork *)shareInstance;

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
- (void)GET:(NSString *)URLString param:(nullable NSDictionary *)param success:(nullable void (^)(FDNetworkResponseModel *result))success failure:(nullable void (^)(NSString *error))failure;

/**
 *  POST请求
 *
 *  @param URLString 网络请求地址
 *  @param param      参数(可以是字典或者nil)
 *  @param success   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)POST:(NSString *)URLString param:(nullable NSDictionary *)param success:(nullable void (^)(FDNetworkResponseModel *result))success failure:(nullable void (^)(NSString *error))failure;

@end

NS_ASSUME_NONNULL_END
