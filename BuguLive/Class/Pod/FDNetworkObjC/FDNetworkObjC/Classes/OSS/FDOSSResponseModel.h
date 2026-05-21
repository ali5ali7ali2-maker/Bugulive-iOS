//
//  FDOSSResponseModel.h
//  FDNetworkObjC
//
//  Created by bogokj on 2020/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDOSSResponseModel : NSObject

//"status": 1,
//"sts_video_limit": 600,
//"AccessKeyId": "STS.NULRNQKqtzpMh8vkgGXNWrLrG",
//"AccessKeySecret": "FRAuxFPpZtWBSaegJSURVj5H7KnwkJbNNaStTshVUSKq",
//"Expiration": "2020-08-13T08:52:23Z",
//"SecurityToken": "CAIS1QJ1q6Ft5B2yfSjIr5b5GfTlpq5VzbKmah7Hj2cSVMF7nYnZpTz2IHFFeHdqBeAbsP8\/mGhY7vsSlqJ4T55IQ1Dza8J148zGRP9xtcyT1fau5Jko1bdrcAr6Umwzta2\/SuH9S8ynU5XJQlvYlyh17KLnfDG5JTKMOoGIjpgVL7ZyWRKjPwJbGPBcJAZptK1qMmDKZ9+nNQT2p3fUEEtwsxBgtHt77q2zuPH+jCDTl1rn0OQYip3sK5y\/FalWMYx4Ts2+0Z4mFNnI2zUC7ANRpuUkzv5U+DHNudWcHVRK4xKedKi2g9RkN11+fbNoWfwG\/uj9k\/d\/vu3Nmp\/3zA5vRbgKDnWOFN\/wkJCcRr31bo8DGOylayiX4LemLYLotg4oW3UfOT5RdsApQn0KUk19Fm+Adv\/6pguaPl\/zE\/XVyscm0JxkxlPs\/MSHPFiIW6VQMZ+U42HEBBqAARLauoGtME0VUND6KDbUWHdA7MDC7TX\/PaJvWyNA6pZtt6zIJxBRORVB5IJ1PH2xxrbMzdHI6+gnbsQDpd1Du6KNLwid7Ny+7EoImFLcJvCUd5gSmKV2yOBsvd8+0scVtkRoTA+dHbvrZDv\/R2ZoY5Gr+\/pbuoLQBI0deH09EA0m",
//"bucket": "xinboliveshop",
//"oss_domain": "http:\/\/xinboliveshop.oss-cn-beijing.aliyuncs.com\/",
//"imgendpoint": "http:\/\/img-cn-beijing.aliyuncs.com",
//"endpoint": "http:\/\/oss-cn-beijing.aliyuncs.com",
//"RequestId": "",
//"Code": "",
//"Message": "",
//"callbackUrl": "",
//"callbackBody": "",
//"dir": "public\/attachment\/202008\/100513\/",
//"act": "aliyun_sts",
//"ctl": "app"

@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *sts_video_limit;
@property(nonatomic, copy) NSString *AccessKeyId;
@property(nonatomic, copy) NSString *AccessKeySecret;
@property(nonatomic, copy) NSString *Expiration;
@property(nonatomic, copy) NSString *SecurityToken;
@property(nonatomic, copy) NSString *bucket;
@property(nonatomic, copy) NSString *oss_domain;
@property(nonatomic, copy) NSString *imgendpoint;
@property(nonatomic, copy) NSString *endpoint;
@property(nonatomic, copy) NSString *RequestId;
@property(nonatomic, copy) NSString *Code;
@property(nonatomic, copy) NSString *Message;
@property(nonatomic, copy) NSString *callbackUrl;
@property(nonatomic, copy) NSString *callbackBody;
@property(nonatomic, copy) NSString *dir;
@property(nonatomic, copy) NSString *act;
@property(nonatomic, copy) NSString *ctl;

@end

NS_ASSUME_NONNULL_END
