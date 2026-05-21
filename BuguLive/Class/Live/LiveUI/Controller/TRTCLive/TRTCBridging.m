//
//  TRTCBridging.m
//  BuguLive
//
//  Created by 志刚杨 on 2020/12/14.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "TRTCBridging.h"

@implementation TRTCBridging
{
    //todo --- tillusory start ---
    CGFloat _imageOnPreviewScale;
    CGFloat _previewImageWidth;
    CGFloat _previewImageHeight;
    //todo --- tillusory end ---
}

- (instancetype)init
{
    
    self = [super init];
//    [[TiUIManager shareManager] destroy];
    
    if (self) {
        NSString* key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;

//        
//        [TiSDK init:key CallBack:^(InitStatus initStatus) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"TiSDKInitStatusNotification" object:nil];
//        }];
    }
    return self;
}


-(void)tiInit
{
    //todo --- tillusory start ---
     [TiUIManager shareManager].showsDefaultUI = YES;
     [[TiUIManager shareManager]loadToWindowDelegate:nil];
    // 启用视频自定义采集模式
    [[TRTCCloud sharedInstance]  enableCustomVideoCapture:YES];
    [self startAVCapture];

    //todo --- tillusory end ---
}


-(void)deInit
{
    [self.session stopRunning];
    [[TiSDKManager shareManager] destroy];
}

//todo --- tillusory start ---
// 视频帧回调函数
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    TRTCVideoFrame* videoFrame = [TRTCVideoFrame new];
    videoFrame.bufferType = TRTCVideoBufferType_PixelBuffer;
    videoFrame.pixelFormat = TRTCVideoPixelFormat_32BGRA;
    videoFrame.pixelBuffer = pixelBuffer;
//    [self nv12ToI420:videoFrame.pixelBuffer dest:pixelBuffer];
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    unsigned char *pixels = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    int imageWidth = (int)CVPixelBufferGetBytesPerRow(pixelBuffer) / 4;
    int imageHeight = (int)CVPixelBufferGetHeightOfPlane(pixelBuffer , 0);
    
    [[TiSDKManager shareManager] renderPixels:pixels Format:BGRA Width:imageWidth Height:imageHeight Rotation:CLOCKWISE_0 Mirror:TRUE];
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    [[TRTCCloud sharedInstance] sendCustomVideoData:videoFrame];
    
}
//todo --- tillusory end ---

///////////////// IOS原生方法 AVFoundation 获取视频帧 开始 /////////////////
- (void)startAVCapture
{
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AV_CAPTURE_SESSION_PRESET; // 设置视频帧尺寸
    
    
    // 设置摄像头采集位置（前置/后置）
    // 默认为前置摄像头
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
           for (AVCaptureDevice *device in devices) {
               if ([device position] == AVCaptureDevicePositionFront)
               {
                   self.cameraPosition = device;
               }
           }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: self.cameraPosition error:&error];
    if (!input) {
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    
    AVCaptureVideoDataOutput * dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames: true];
    [dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey: @(CV_PIXEL_FORMAT_TYPE)}]; // 设置视频帧格式
    dispatch_queue_t queue = dispatch_queue_create("dataOutputQueue", NULL);
    [dataOutput setSampleBufferDelegate:self queue:queue];
    
    [self.session beginConfiguration];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:dataOutput]) {
        [self.session addOutput:dataOutput];
    }
    
    // 获取输入与输出之间的连接
    AVCaptureConnection *connection = [dataOutput connectionWithMediaType:AVMediaTypeVideo];
//              设置采集数据的方向
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    connection.videoMirrored = true;
    
    [self.session commitConfiguration];
    [self.session startRunning];
}

//通过 libyuv 转换 yuv 格式
- (void)nv12ToI420:(CVPixelBufferRef)src dest:(CVPixelBufferRef)dst {
    
    //图像宽度（像素）
    int pixelWidth = (int)CVPixelBufferGetWidth(src);
    //图像高度（像素）
    int pixelHeight = (int)CVPixelBufferGetHeight(src);
    
    uint8_t *src_y = NULL;
    uint8_t *src_uv = NULL;
    uint8_t *dst_y = NULL;
    uint8_t *dst_u = NULL;
    uint8_t *dst_v = NULL;
    CVPixelBufferLockBaseAddress(src, 0);
    src_y = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(src, 0);
    src_uv = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(src, 1);
    int src_ystride = (int)CVPixelBufferGetBytesPerRowOfPlane(src, 0);
    int src_uvstride = (int)CVPixelBufferGetBytesPerRowOfPlane(src, 1);
    CVPixelBufferLockBaseAddress(dst, 0);
    dst_y = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(dst, 0);
    dst_u = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(dst, 1);
    dst_v = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(dst, 2);
    int dst_ystride = (int)CVPixelBufferGetBytesPerRowOfPlane(dst, 0);
    int dst_ustride = (int)CVPixelBufferGetBytesPerRowOfPlane(dst, 1);
    int dst_vstride = (int)CVPixelBufferGetBytesPerRowOfPlane(dst, 2);
    
    NV12ToI420(src_y, src_ystride, src_uv, src_uvstride, dst_y, dst_ystride, dst_u, dst_ustride, dst_v, dst_vstride, pixelWidth, pixelHeight);
    
    CVPixelBufferUnlockBaseAddress(src, 0);
    CVPixelBufferUnlockBaseAddress(dst, 0);
}


@end
