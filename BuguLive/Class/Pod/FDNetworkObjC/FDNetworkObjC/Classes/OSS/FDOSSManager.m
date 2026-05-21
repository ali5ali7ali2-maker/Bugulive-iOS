//
//  FDOSSManager.m
//  FDNetworkObjC
//
//  Created by bogokj on 2020/8/13.
//

#import "FDOSSManager.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import <MJExtension/MJExtension.h>
#import "FDOSSResponseModel.h"

#define OSS_STS_URL @"http://oss-cn-shanghai.aliyuncs.com/app-server/sts.php"

@interface FDOSSManager ()

@property(nonatomic, strong) OSSClient *client;
@property(nonatomic, strong) FDOSSResponseModel *model;
@property(nonatomic, copy) fd_ossSetUpHandler fd_ossSetUpHandler;

@end

@implementation FDOSSManager

+ (FDOSSManager *)defaultManager{
    static FDOSSManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)onRecieveNoti:(NSNotification *)noti{
    NSDictionary *dict = noti.object;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[kFDNetworkObjCBundle pathForResource:@"oss" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil];
    self.model = [FDOSSResponseModel mj_objectWithKeyValues:dict];
    id<OSSCredentialProvider>credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    self.client = [[OSSClient alloc] initWithEndpoint:self.model.endpoint credentialProvider:credential];
    if (self.fd_ossSetUpHandler) {
        self.fd_ossSetUpHandler();
    }
}

- (void)setup:(fd_ossSetUpHandler)finish{
    self.fd_ossSetUpHandler = finish;
    if (!self.model) {
    //    NSDictionary *dict = @{@"ctl":@"app",@"act":@"aliyun_sts",@"lat":@"117.089291",@"lng":@"36.184758",@"sdk_type":@"ios",@"sdk_version":@"2020042701",@"sdk_version_name":@"6.14.08",@"xpoint":@"117.089291",@"ypoint":@"36.184758",@"i_type":@"lib"};
    //    NSString *aesKey = @"1400406262000000";
    //    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString *paramAESStr = [data AES256EncryptWithKey:aesKey];
    //    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    //    [param setObject:paramAESStr forKey:@"requestData"];
    //    [[FDNetwork shareInstance] POST:@"http://kh.xyzc.anbig.com/mapi/index.php" param:param success:^(FDNetworkResponseModel * _Nonnull result) {
    //        NSLog(@"");
    //    } failure:^(NSString * _Nonnull error) {
    //        NSLog(@"");
    //    }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFDOSSManagerSendNoti object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRecieveNoti:) name:kFDOSSManagerRecieveNoti object:nil];
    }else{
        self.fd_ossSetUpHandler();
    }
}

- (OSSFederationToken *)getFederationToken
{
    NSURL * url = [NSURL URLWithString:OSS_STS_URL];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [tcs setError:error];
                                                        return;
                                                    }
                                                    [tcs setResult:data];
                                                }];
    [sessionTask resume];
    // 实现这个回调需要同步返回Token，所以要waitUntilFinished
    [tcs.task waitUntilFinished];
    if (tcs.task.error) {
        return nil;
    } else {
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = self.model.AccessKeyId;
        token.tSecretKey = self.model.AccessKeySecret;
        token.tToken = self.model.SecurityToken;
        token.expirationTimeInGMTFormat = self.model.Expiration;
        return token;
    }
}

- (void)UPLOAD:(NSData *)fileData progress:(fd_ossProgressHandler)progress success:(fd_ossSuccessHandler)success failure:(fd_ossFaliureHandler)faliure{
    OSSPutObjectRequest* put = [OSSPutObjectRequest new];
    put.bucketName = self.model.bucket;
    put.objectKey = [self getObjectKey];
    put.uploadingData = fileData; // Directly upload NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        if (progress) {
            progress((float)totalByteSent/(float)totalBytesExpectedToSend);
        }
    };
    if (self.model.callbackUrl) {
        put.callbackParam = @{@"callbackUrl": self.model.callbackUrl,@"callbackBody": @"filename=${object}"};
    }
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            if (success) {
                NSString *resultStr = [NSString stringWithFormat:@"%@%@",self.model.oss_domain,put.objectKey];
                success(resultStr);
            }
        } else {
            if (faliure) {
                faliure(task.error);
            }
        }
        return nil;
    }];
}

- (NSString *)getObjectKey
{
    NSDate *currentDate = [NSDate date];//获取当前时间日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *nameString = [NSString stringWithFormat:@"%@%d.png",dateString,arc4random()%10000/1000];
    NSString *objectKey = [NSString stringWithFormat:@"%@%@",self.model.dir,nameString];
    return objectKey;
}


@end
