//
//  PublishLiveViewModel.h
//  BuguLive
//
//  Created by xfg on 2017/6/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseViewModel.h"

@interface PublishLiveViewModel : BGBaseViewModel

/**
 开始直播

 @param dict 开播参数
 @param vc 需要dismiss的VC，如果不需要做dismiss操作，传nil就可以了
 */
+ (void)beginLive:(NSMutableDictionary *)dict vc:(UIViewController *)vc block:(AppCommonBlock)block;

+ (void)beginLiveCenter:(NSDictionary *)dict;

//语音直播开播
+ (void)beginVoiceLive:(NSMutableDictionary *)dict vc:(UIViewController *)vc block:(AppCommonBlock)block;
@end
