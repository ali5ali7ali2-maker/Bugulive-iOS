//
//  FDQiniuManager.h
//  FDNetworkObjC
//
//  Created by fandongtongxue on 2020/2/29.
//

#import <Foundation/Foundation.h>
@class FDQiniuResponseModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^fd_qiniuProgressHandler)(float percent);

typedef void(^fd_qiniuCompleteHandler)(FDQiniuResponseModel *response);

@interface FDQiniuManager : NSObject

+ (FDQiniuManager *)defaultManager;

/// 上传(常用参数)
/// @param fileData 二进制数据
/// @param token token
/// @param progressHandler 进度回调
/// @param completeHandler 完成回调
- (void)UPLOAD:(NSData *)fileData
         token:(NSString *)token progressHandler:(fd_qiniuProgressHandler)progressHandler completeHandler:(fd_qiniuCompleteHandler)completeHandler;

/// 上传(常用参数自定义key)
/// @param fileData 二进制数据
/// @param token token
/// @param key key
/// @param progressHandler 进度回调
/// @param completeHandler 完成回调
- (void)UPLOAD:(NSData *)fileData
         token:(NSString *)token
           key:(NSString *)key
progressHandler:(fd_qiniuProgressHandler)progressHandler
completeHandler:(fd_qiniuCompleteHandler)completeHandler;


/// 上传(所有参数)
/// @param fileData 二进制数据
/// @param param 参数
/// @param token token
/// @param key key
/// @param mime mime
/// @param progressHandler 进度回调
/// @param completeHandler 完成回调
- (void)UPLOAD:(NSData *)fileData token:(NSString *)token key:(NSString *)key params:(NSDictionary *)param mime:(NSString *)mime progressHandler:(fd_qiniuProgressHandler)progressHandler completeHandler:(fd_qiniuCompleteHandler)completeHandler;

@end

NS_ASSUME_NONNULL_END
