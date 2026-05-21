//
//  TRTCBridging.h
//  BuguLive
//
//  Created by 志刚杨 on 2020/12/14.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

//todo --- tillusory start ---
#import "TiSDKInterface.h"
//#import <TiSDK/TiSDK.h>
#import "TiUIManager.h"
#import "libyuv.h"
#import <AVFoundation/AVFoundation.h>

//todo --- tillusory end ---

NS_ASSUME_NONNULL_BEGIN


//todo --- tillusory start ---
#define CV_PIXEL_FORMAT_TYPE kCVPixelFormatType_32BGRA
#define AV_CAPTURE_SESSION_PRESET AVCaptureSessionPreset1280x720
#define AV_CAPTURE_SESSION_PRESET_WIDTH 720
#define AV_CAPTURE_SESSION_PRESET_HEIGHT 1280
//todo --- tillusory end ---

@interface TRTCBridging : NSObject
///////////////// IOS原生方法 AVFoundation 获取视频帧 开始 /////////////////
//@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureDevice *cameraPosition;
@property (nonatomic, strong) AVCaptureSession *session;
///////////////// IOS原生方法 AVFoundation 获取视频帧 结束 /////////////////
-(void)tiInit;
-(void)deInit;
@end

NS_ASSUME_NONNULL_END
