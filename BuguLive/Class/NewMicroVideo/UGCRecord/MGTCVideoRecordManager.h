//
//  MGTCVideoRecordManager.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/7/4.
//  Copyright © 2019年 xfg. All rights reserved.
//

//音视频分离

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGTCVideoRecordManager : NSObject

/** 截取视频的背景音乐 */
+ (void)dM_VideoManager_getBackgroundMiusicWithVideoUrl:(NSURL*)videoUrl newFile:(NSString*)newFile completion:(void(^)(NSString*data))completionHandle;

/** 截取视频的无声音视频 */
+ (void)dM_VideoManager_RemoveVideoWithVideoUrl:(NSURL*)videoUrl newFile:(NSString*)newFile completion:(void(^)(NSString*data))completionHandle;

/** 给视频添加水印 */
///使用AVfoundation添加水印
+ (void)AVsaveVideoPath:(NSURL*)videoPath WithWaterImg:(UIImage*)img WithCoverImage:(UIImage*)coverImg WithQustion:(NSString*)question WithFileName:(NSString*)fileName completion:(void(^)(NSString*data))completionHandle;;

@end

NS_ASSUME_NONNULL_END
