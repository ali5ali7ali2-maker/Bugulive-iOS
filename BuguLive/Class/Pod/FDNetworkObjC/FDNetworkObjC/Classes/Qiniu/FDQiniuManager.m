//
//  FDQiniuManager.m
//  FDNetworkObjC
//
//  Created by fandongtongxue on 2020/2/29.
//

#import "FDQiniuManager.h"
#import <Qiniu/QiniuSDK.h>
#import "FDQiniuResponseModel.h"
#import "FDFoundationObjC.h"
#import <SDWebImage/NSData+ImageContentType.h>

@implementation FDQiniuManager

+ (FDQiniuManager *)defaultManager{
    static FDQiniuManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)UPLOAD:(NSData *)fileData token:(NSString *)token progressHandler:(fd_qiniuProgressHandler)progressHandler completeHandler:(fd_qiniuCompleteHandler)completeHandler{
    [self UPLOAD:fileData token:token key:nil params:nil mime:nil progressHandler:progressHandler completeHandler:completeHandler];
}

- (void)UPLOAD:(NSData *)fileData token:(NSString *)token key:(NSString *)key progressHandler:(fd_qiniuProgressHandler)progressHandler completeHandler:(fd_qiniuCompleteHandler)completeHandler{
    [self UPLOAD:fileData token:token key:key params:nil mime:nil progressHandler:progressHandler completeHandler:completeHandler];
}

- (void)UPLOAD:(NSData *)fileData token:(NSString *)token key:(NSString *)key params:(NSDictionary *)param mime:(NSString *)mime progressHandler:(fd_qiniuProgressHandler)progressHandler completeHandler:(fd_qiniuCompleteHandler)completeHandler{
    NSString *newKey = key;
    NSString *suffix = @"";
    if (!key.length) {
        SDImageFormat format = [NSData sd_imageFormatForImageData:fileData];
        switch (format) {
            case SDImageFormatPNG:
                suffix = @".png";
                break;
            case SDImageFormatGIF:
                suffix = @".gif";
                break;
            case SDImageFormatHEIC:
                suffix = @".heic";
                break;
            case SDImageFormatHEIF:
                suffix = @".heif";
                break;
            case SDImageFormatJPEG:
                suffix = @".jpg";
                break;
            case SDImageFormatTIFF:
                suffix = @".tiff";
                break;
            case SDImageFormatWebP:
                suffix = @".webp";
                break;
            default:
                break;
        }
    }
    newKey = [NSString stringWithFormat:@"%@%@",[[NSDate date] fd_currentTimestamp],suffix];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.useHttps = NO;
        builder.useConcurrentResumeUpload = YES;
        builder.concurrentTaskCount = 8;
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:mime progressHandler:^(NSString *key, float percent) {
        if (progressHandler) {
            progressHandler(percent);
        }
    } params:param checkCrc:NO cancellationSignal:nil];
    [upManager putData:fileData key:newKey token:token
    complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        FDQiniuResponseModel *model = [[FDQiniuResponseModel alloc]init];
        model.isSuccess = info.isOK;
        model.key = key;
        if (completeHandler) {
            completeHandler(model);
        }
    } option:opt];
}

@end
