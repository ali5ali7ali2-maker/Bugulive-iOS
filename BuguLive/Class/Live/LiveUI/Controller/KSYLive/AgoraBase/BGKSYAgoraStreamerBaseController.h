//
//  BGKSYAgoraStreamerBaseController.h
//  FanweLive
//
//  Created by yiqian on 10/15/15.
//  Copyright (c) 2015 qyvideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import <libksygpulive/KSYGPUStreamerKit.h>
#import "KSYRTCStreamerKit.h"
#import "KSYAgoraStreamerKit.h"

#define SEL_VALUE(SEL_NAME) [NSValue valueWithPointer:@selector(SEL_NAME)]

@class BGKSYAgoraStreamerBaseController;

@protocol FWKSYAgoraStreamerBaseControllerDelegate <NSObject>
@required

// 首帧回调
- (void)firstAgoraFrame:(BGKSYAgoraStreamerBaseController *)publishVC;

// 网络断连,且经多次重连抢救无效后退出直播
- (void)exitAgoraPublish:(BGKSYAgoraStreamerBaseController *)publishVC;

/*
 *  声网连麦/断开连麦
 *  isLinked：YES：连麦  NO：断开连麦
 *  applicantId：申请连麦者ID
 */
- (void)linkOrBreakMick:(BOOL)isLinked applicantId:(NSString *)applicantId;

@end


@interface BGKSYAgoraStreamerBaseController : UIViewController
{

}

@property (nonatomic, weak) id<FWKSYAgoraStreamerBaseControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger             liveType;               // 视频类型，对应枚举FW_LIVE_TYPE

#if TARGET_IPHONE_SIMULATOR
@property (nonatomic, strong) KSYGPUStreamerKit   *gPUStreamerKit;        // 直播推流工具类
#else
@property (nonatomic, strong) KSYAgoraStreamerKit   *gPUStreamerKit;        // 直播推流工具类
#endif

@property (nonatomic, strong) UIView                *videoContrainerView;   // 视频容器视图
@property (nonatomic, strong) NSURL                 *pushUrl;               // 推流地址
@property (nonatomic, copy) NSString                *applicantId;           // 申请连麦者的ID
@property (nonatomic, assign) BOOL                  isApplicant;            // YES：申请连麦者 NO：接收连麦者

/*
 @abstract start call的回调函数
 */
@property (nonatomic, copy)void (^onMyCallStart)(int status);
/*
 @abstract stop call的回调函数
 */
@property (nonatomic, copy)void (^onMyCallStop)(int status);
/*
 @abstract 加入channel回调
 */
@property (nonatomic, copy)void (^onMyChannelJoin)(int status);

// 开始推流
- (void)startRtmp;
// 停止推流
- (void)stopRtmp;

/*
 *  开始连麦
 *  applicantId：申请连麦者ID
 *  responderId：接收连麦者ID
 *  roomId：房间ID
 */
- (void)startLinkMic:(NSString *)applicantId andResponderId:(NSString *)responderId roomId:(NSString *)roomId;
/*
 *  停止连麦
 *  applicantId：申请连麦者ID
 */
- (void)stopLinkMic:(NSString *)applicantId;
-(void)PkWithRoomId:(NSString *)roomid;
//重新加载推流
-(void)reloadRtmp;
@end
