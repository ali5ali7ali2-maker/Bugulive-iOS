//
//  BGTCUploadHelp.h
//  BuguLive
//
//  Created by 志刚杨 on 2020/9/3.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
//腾讯小视频上传
NS_ASSUME_NONNULL_BEGIN
//typedef void (^publishResult)(BOOL success,NSString *recordVideoURLStr,NSString *msg);
@interface BGTCUploadHelp : NSObject
BogoSingletonH(BGTCUploadHelp);
-(void)uploadVideoWithVideoPath:(NSString *)videoPath;
@property(nonatomic, copy) void (^publishResult)(BOOL success,NSString *recordVideoURLStr,NSString *msg);
@end

NS_ASSUME_NONNULL_END
