//
//  BGTCUploadHelp.m
//  BuguLive
//
//  Created by 志刚杨 on 2020/9/3.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "BGTCUploadHelp.h"
#import "TXUGCPublish.h"

@interface BGTCUploadHelp()<TXVideoPublishListener>
@property(nonatomic, strong) TXUGCPublish *ugcPublish;
@property(nonatomic, strong) NSString *signature;
@property(nonatomic, strong)  NSString *videoPath;
@end
@implementation BGTCUploadHelp
{
    
}

BogoSingletonM(BGTCUploadHelp);


-(void)uploadVideoWithVideoPath:(NSString *)videoPath
{
    _videoPath = videoPath;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"app" forKey:@"ctl"];
    [dict setValue:@"app_request_get_upload_sign" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            _signature = [responseJson toString:@"signature"];
            TXPublishParam * param = [[TXPublishParam alloc] init];
            param.signature = _signature;
            param.videoPath = _videoPath;
            _ugcPublish = [[TXUGCPublish alloc] init];
            _ugcPublish.delegate = self;
            [_ugcPublish publishVideo:param];
        }else{
            
        }
    } FailureBlock:^(NSError *error) {
    }];
    
    

    
}


-(void) onPublishProgress:(uint64_t)uploadBytes totalBytes: (uint64_t)totalBytes;
{
    NSLog(ASLocalizedString(@"腾讯云视频进度 %llu"),totalBytes);
}

-(void) onPublishComplete:(TXPublishResult*)result;
{
    if (!result.retCode) {
        self.publishResult(YES,result.videoURL,ASLocalizedString(@"上传成功"));
    } else {
        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"TCVideoPublish.PublishingFailedFmt", nil), result.retCode];
        self.publishResult(NO,@"",msg);
        return;
    }
}
@end
