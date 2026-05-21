//
//  AgoraPushUtils.h
//  BuguLive
//
//  Created by 志刚杨 on 2022/6/25.
//  Copyright © 2022 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgoraPushUtils : NSObject
+(AgoraLiveTranscoding *)getLiveHostTranscoding:(NSString *)uid;
+(void)setLianMaiTranscodingUser:(AgoraLiveTranscoding *)transcoding nowNum:(int)nowNum uid:(NSString *)uid;
+(AgoraLiveTranscoding *)getPKLiveTranscodingLeftUid:(NSString *)leftUid rightUid:(NSString *)rightUid;
@end

NS_ASSUME_NONNULL_END
