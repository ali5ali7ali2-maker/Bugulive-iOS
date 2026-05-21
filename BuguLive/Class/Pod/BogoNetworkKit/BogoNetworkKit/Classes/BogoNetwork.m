//
//  BogoNetwork.m
//  BogoNetworkKit
//
//  Created by bogokj on 2020/3/13.
//

#import "BogoNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import "BogoNetworkResponseModel.h"
#import <MJExtension/MJExtension.h>
#import "BogoNetworkInitModel.h"

#define AESKey @"1400031571000000"
#define sdk_version_name @"6.14.08"
#define sdk_type @"ios"
#define sdk_version @"2020042701"

#import "NSData+AES.h"

#define cookiesKey @"mycookies"

@implementation BogoNetwork

+ (BogoNetwork *)shareInstance{
    static BogoNetwork *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    shareInstance.requestContentType = RequestContentTypeJSON;
    shareInstance.timeoutInterval = 30;
    shareInstance.indexModel = [[BogoNetworkInitModel alloc] init];
//    shareInstance.url_prefix = @"http://intl.live.bogokj.com/shopapi/";
    shareInstance.url_prefix = [NSString stringWithFormat:@"%@/shopapi/",ADMIN_API_URL];
//    shareInstance.urlV2_prefix = @"http://intl.live.bogokj.com/mapi/";
    shareInstance.urlV2_prefix = [NSString stringWithFormat:@"%@/mapi/",ADMIN_API_URL];
//    shareInstance.urlV3_prefix = @"http://intl.liveapi.bogokj.com/mapi/index.php";
    shareInstance.urlV3_prefix = [NSString stringWithFormat:@"%@/mapi/index.php",AppDoMainUrlArray[0]];


    
    shareInstance.token = @"";
    return shareInstance;
}

- (void)cookieSave{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:[BogoNetwork shareInstance].url_prefix]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:cookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cookieLoad{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:cookiesKey];
    if (data) {
        NSArray<NSHTTPCookie *> *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStorage setCookie:cookie];
        }
        
    }
}

- (void)setToken:(NSString *)token{
    if (token.length) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"BogoNetworkToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)token{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"BogoNetworkToken"];
    return token.length ? token : @"";
}

- (void)saveIndexModel:(BogoNetworkInitModel *)indexModel{
    if (indexModel) {
        NSLog(@"设置初始化model完成:%@",indexModel.mj_keyValues);
        [[NSUserDefaults standardUserDefaults] setObject:indexModel.mj_keyValues forKey:@"BogoNetworkIndexModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BogoNetworkInitModel *)indexModel{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"BogoNetworkIndexModel"];
    if (dict) {
        BogoNetworkInitModel *model = [BogoNetworkInitModel mj_objectWithKeyValues:dict];
        return model;
    }
    return nil;
}

- (void)GET:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer = [self requestSerializerWithType:[BogoNetwork shareInstance].requestContentType];
    //申明返回的结果是json类型
    manager.responseSerializer = [self responseSerializerWithType:[BogoNetwork shareInstance].responseContentType];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [self acceptableContentTypes];
    //超时时间
    manager.requestSerializer.timeoutInterval = [BogoNetwork shareInstance].timeoutInterval;
    //证书
    //    manager.securityPolicy = [self customSecurityPolicy];
    //发送网络请求(请求方式为GET)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [newParam setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [manager GET:[NSString stringWithFormat:@"%@%@",[BogoNetwork shareInstance].url_prefix,URLString] parameters:newParam headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BogoNetworkResponseModel *model = [BogoNetworkResponseModel mj_objectWithKeyValues:responseObject];
        if (model.status.intValue == 101) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"enterLoginUI" object:nil];
        }
        if (model.status.intValue == 200 || model.status.intValue == 1) {
            success(model);
        }else{
            failure(model.msg);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([NSString stringWithFormat:@"网络请求失败 code:%ld msg:%@",error.code,error.localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}

- (void)GETV2:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(BogoNetworkResponseModel * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    param = [NetWorkManager tryAddLangParamDict2:param];

    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer = [self requestSerializerWithType:[BogoNetwork shareInstance].requestContentType];
    //申明返回的结果是json类型
    manager.responseSerializer = [self responseSerializerWithType:[BogoNetwork shareInstance].responseContentType];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [self acceptableContentTypes];
    //超时时间
    manager.requestSerializer.timeoutInterval = [BogoNetwork shareInstance].timeoutInterval;
    //证书
    //    manager.securityPolicy = [self customSecurityPolicy];
    //发送网络请求(请求方式为GET)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [newParam setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [manager GET:[NSString stringWithFormat:@"%@%@",[BogoNetwork shareInstance].urlV2_prefix,URLString] parameters:newParam headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BogoNetworkResponseModel *model = [BogoNetworkResponseModel mj_objectWithKeyValues:responseObject];
        if (model.status.intValue == 101) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"enterLoginUI" object:nil];
        }
        if (model.status.intValue == 1 || model.status.intValue == 200) {
            success(model);
        }else{
            failure(model.msg);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([NSString stringWithFormat:@"网络请求失败 code:%ld msg:%@",error.code,error.localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}

- (void)POSTV3:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(BogoNetworkResponseModel * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    param = [NetWorkManager tryAddLangParamDict2:param];
    [self cookieLoad];
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer = [self requestSerializerWithType:[BogoNetwork shareInstance].requestContentType];
    //申明返回的结果是json类型
    manager.responseSerializer = [self responseSerializerWithType:[BogoNetwork shareInstance].responseContentType];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [self acceptableContentTypes];
    //超时时间
    manager.requestSerializer.timeoutInterval = [BogoNetwork shareInstance].timeoutInterval;
    //证书
    //    manager.securityPolicy = [self customSecurityPolicy];
    //发送网络请求(请求方式为GET)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:param];
        [tempDict setObject:sdk_version_name forKey:@"sdk_version_name"];
        [tempDict setObject:sdk_type forKey:@"sdk_type"];
        [tempDict setObject:sdk_version forKey:@"sdk_version"];
        // AES加密
        NSData *data = [NSJSONSerialization dataWithJSONObject:tempDict options:NSJSONWritingPrettyPrinted error:nil];
        if (data)
        {
            NSString *parmStr = [data AES256EncryptWithKey:AESKey];
            [tempDict setObject:@"lib" forKey:@"itype"];
            [tempDict setObject:sdk_version_name forKey:@"sdk_version_name"];
            [tempDict setObject:parmStr forKey:@"requestData"];
            [tempDict setObject:@"lib" forKey:@"i_type"];
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            if (uid) {
                [tempDict setObject:uid forKey:@"uid"];
            }
        }
    
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:tempDict];
    [newParam setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [manager POST:[NSString stringWithFormat:@"%@%@",[BogoNetwork shareInstance].urlV3_prefix,URLString] parameters:newParam headers:nil constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self cookieSave];
        BogoNetworkResponseModel *model = [BogoNetworkResponseModel mj_objectWithKeyValues:responseObject];
        if (model.status.intValue == 1) {
            if (success) {
                success(model);
            }
        }else{
            if (failure) {
                if(model.error.length > 0)
                {
                    failure(model.error);
                }
                else
                {
                    failure(model.msg);
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure([NSString stringWithFormat:@"网络请求失败 code:%ld msg:%@",error.code,error.localizedDescription]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}

- (void)POSTV4:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(id  _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    param = [NetWorkManager tryAddLangParamDict2:param];

    [self cookieLoad];
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer = [self requestSerializerWithType:[BogoNetwork shareInstance].requestContentType];
    //申明返回的结果是json类型
    manager.responseSerializer = [self responseSerializerWithType:[BogoNetwork shareInstance].responseContentType];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [self acceptableContentTypes];
    //超时时间
    manager.requestSerializer.timeoutInterval = [BogoNetwork shareInstance].timeoutInterval;
    //证书
    //    manager.securityPolicy = [self customSecurityPolicy];
    //发送网络请求(请求方式为GET)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:param];
        [tempDict setObject:sdk_version_name forKey:@"sdk_version_name"];
        [tempDict setObject:sdk_type forKey:@"sdk_type"];
        [tempDict setObject:sdk_version forKey:@"sdk_version"];
        // AES加密
        NSData *data = [NSJSONSerialization dataWithJSONObject:tempDict options:NSJSONWritingPrettyPrinted error:nil];
        if (data)
        {
            NSString *parmStr = [data AES256EncryptWithKey:AESKey];
            [tempDict setObject:@"lib" forKey:@"itype"];
            [tempDict setObject:sdk_version_name forKey:@"sdk_version_name"];
            [tempDict setObject:parmStr forKey:@"requestData"];
            [tempDict setObject:@"lib" forKey:@"i_type"];
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            if (uid) {
                [tempDict setObject:uid forKey:@"uid"];
            }
        }
    
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:tempDict];
    [newParam setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [manager POST:[NSString stringWithFormat:@"%@%@",[BogoNetwork shareInstance].urlV3_prefix,URLString] parameters:newParam headers:nil constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self cookieSave];
        BogoNetworkResponseModel *model = [BogoNetworkResponseModel mj_objectWithKeyValues:responseObject];
        if (model.status.intValue == 1) {
            if (success) {
                success(responseObject);
            }
        }else{
            if (failure) {
                failure(model.error);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure([NSString stringWithFormat:@"网络请求失败 code:%ld msg:%@",error.code,error.localizedDescription]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}

- (void)POST:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    param = [NetWorkManager tryAddLangParamDict2:param];

    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [self responseSerializerWithType:[BogoNetwork shareInstance].responseContentType];
    //申明请求的数据是json类型
    manager.requestSerializer = [self requestSerializerWithType:[BogoNetwork shareInstance].requestContentType];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [self acceptableContentTypes];
    //超时时间
    manager.requestSerializer.timeoutInterval = [BogoNetwork shareInstance].timeoutInterval;
    //证书
    //    manager.securityPolicy = [self customSecurityPolicy];
    //发送网络请求(请求方式为POST)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [newParam setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    [manager POST:[NSString stringWithFormat:@"%@%@",[BogoNetwork shareInstance].url_prefix,URLString] parameters:newParam headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BogoNetworkResponseModel *model = [BogoNetworkResponseModel mj_objectWithKeyValues:responseObject];
        if (model.status.intValue == 101) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"enterLoginUI" object:nil];
        }
        if (model.status.intValue == 200 || model.status.intValue == 1) {
            success(model);
        }else{
            failure(model.msg);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([NSString stringWithFormat:@"网络请求失败 code:%ld msg:%@",error.code,error.localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}

- (void)POSTV2:(NSString *)URLString param:(NSDictionary *)param success:(void (^)(id _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    param = [NetWorkManager tryAddLangParamDict2:param];

    
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [self responseSerializerWithType:[BogoNetwork shareInstance].responseContentType];
    //申明请求的数据是json类型
    manager.requestSerializer = [self requestSerializerWithType:[BogoNetwork shareInstance].requestContentType];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [self acceptableContentTypes];
    //超时时间
    manager.requestSerializer.timeoutInterval = [BogoNetwork shareInstance].timeoutInterval;
    //证书
    //    manager.securityPolicy = [self customSecurityPolicy];
    //发送网络请求(请求方式为POST)
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [newParam setObject:[BogoNetwork shareInstance].token forKey:@"token"];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",[BogoNetwork shareInstance].urlV2_prefix,URLString] parameters:newParam headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BogoNetworkResponseModel *model = [BogoNetworkResponseModel mj_objectWithKeyValues:responseObject];
        if (model.status.intValue == 101) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"enterLoginUI" object:nil];
        }
        if (model.status.intValue == 200 || model.status.intValue == 1) {
            success(model);
        }else{
            failure(model.msg);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([NSString stringWithFormat:@"网络请求失败 code:%ld msg:%@",error.code,error.localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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


- (void)initCityData{
    if (!self.addressModel) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[BogoNetwork shareInstance] GET:@"api/cityJsonUrl" param:@{@"token":[BogoNetwork shareInstance].token} success:^(BogoNetworkResponseModel * _Nonnull result) {
                BogoAddressModel *model = [BogoAddressModel mj_objectWithKeyValues:result.data];
                for (BogoProvinceModel *provinceModel in model.province_list) {
                    NSMutableArray *tempCityArray = [NSMutableArray array];
                    for (BogoCityModel *cityModel in model.city_list) {
                        NSMutableArray *tempAreaArray = [NSMutableArray array];
                        for (BogoAreaModel *areaModel in model.county_list) {
                            if ([areaModel.pid isEqualToString:cityModel.id]) {
                                [tempAreaArray addObject:areaModel];
                            }
                        }
                        if ([cityModel.pid isEqualToString:provinceModel.id]) {
                            [tempCityArray addObject:cityModel];
                        }
                        cityModel.arealist = tempAreaArray;
                    }
                    provinceModel.citylist = tempCityArray;
                }
                self.addressModel = model;
            } failure:^(NSString * _Nonnull error) {
                NSLog(@"初始化城市数据失败");
            }];
        });
    }
}

@end
