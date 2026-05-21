//
//  FDNetwork.m
//  AFNetworking
//
//  Created by fandongtongxue on 2020/2/27.
//

#import "FDNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import "FDNetworkResponseModel.h"
#import <MJExtension/MJExtension.h>

@implementation FDNetwork

+ (FDNetwork *)shareInstance{
    static FDNetwork *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
        shareInstance.manager = [AFHTTPSessionManager manager];
        shareInstance.manager.responseSerializer.acceptableContentTypes = 
            [NSSet setWithObjects:@"application/json", @"text/html", 
             @"text/json", @"image/jpeg", @"audio/mp3", nil];
    });
    shareInstance.requestContentType = RequestContentTypeJSON;
    shareInstance.timeoutInterval = 30;
    [shareInstance setUpCookies];
    return shareInstance;
}

- (void)GET:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    self.manager.requestSerializer = [self requestSerializerWithType:
        [FDNetwork shareInstance].requestContentType];
    self.manager.responseSerializer = [self responseSerializerWithType:
        [FDNetwork shareInstance].responseContentType];
    self.manager.responseSerializer.acceptableContentTypes = 
        [self acceptableContentTypes];
    self.manager.requestSerializer.timeoutInterval = 
        [FDNetwork shareInstance].timeoutInterval;
    [self.manager GET:URLString parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FDNetworkResponseModel *model = [FDNetworkResponseModel mj_objectWithKeyValues:responseObject];
        if (model.code.intValue == 1) {
            success(model);
        }else{
            failure(model.msg);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}

- (void)POST:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
   self.manager.requestSerializer = [self requestSerializerWithType:
        [FDNetwork shareInstance].requestContentType];
    self.manager.responseSerializer = [self responseSerializerWithType:
        [FDNetwork shareInstance].responseContentType];
    self.manager.responseSerializer.acceptableContentTypes = 
        [self acceptableContentTypes];
    self.manager.requestSerializer.timeoutInterval = 
        [FDNetwork shareInstance].timeoutInterval;
    [self.manager POST:URLString parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        FDNetworkResponseModel *model = [FDNetworkResponseModel mj_objectWithKeyValues:responseObject];
        if (model.code.intValue == 1) {
            success(model);
        }else{
            failure(model.msg);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}

- (AFHTTPRequestSerializer *)requestSerializerWithType:(RequestContentType)type{
    switch (type) {
        case RequestContentTypeJSON:
            return [AFJSONRequestSerializer serializer];
            break;
            
        default:
            break;
    }
}

- (AFHTTPResponseSerializer *)responseSerializerWithType:(ResponseContentType)type{
    switch (type) {
        case ResponseContentTypeJSON:
            return [AFJSONResponseSerializer serializer];
            break;
            
        default:
            return [AFHTTPResponseSerializer serializer];
            break;
    }
}

- (NSSet *)acceptableContentTypes{
    return [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"image/jpeg",@"audio/mp3",nil];
}

- (void)setUpCookies{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@", @"PHPSESSID", @"3mhscdjmhmegpiio0ugha0hgt4"] forHTTPHeaderField:@"Cookie"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@", @"PHPSESSID2", @"r5tv7t820ets6sddouqlb4nln0"] forHTTPHeaderField:@"Cookie"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@", @"client_ip", @"222.132.157.159"] forHTTPHeaderField:@"Cookie"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@", @"user_id", @"100513"] forHTTPHeaderField:@"Cookie"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@", @"nick_name", @"100513"] forHTTPHeaderField:@"Cookie"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@", @"user_pwd", @"6d5f0276bf24654556932cab6b697923"] forHTTPHeaderField:@"Cookie"];
    // NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    // [cookieProperties setObject:@"3mhscdjmhmegpiio0ugha0hgt4"forKey:@"PHPSESSID"];
    // [cookieProperties setObject:@"r5tv7t820ets6sddouqlb4nln0"forKey:@"PHPSESSID2"];
    // [cookieProperties setObject:@"222.132.157.159"forKey:@"client_ip"];
    // [cookieProperties setObject:@"100513"forKey:@"user_id"];
    // [cookieProperties setObject:@"100513"forKey:@"nick_name"];
    // [cookieProperties setObject:@"6d5f0276bf24654556932cab6b697923"forKey:@"user_pwd"];
    // NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    // [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

- (AFSecurityPolicy *)customSecurityPolicy{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"证书" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}

@end
