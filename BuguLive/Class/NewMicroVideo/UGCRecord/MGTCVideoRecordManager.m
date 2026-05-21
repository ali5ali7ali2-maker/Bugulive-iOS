//
//  MGTCVideoRecordManager.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/7/4.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "MGTCVideoRecordManager.h"

@implementation MGTCVideoRecordManager

/** 截取视频的背景音乐 */
+ (void)dM_VideoManager_getBackgroundMiusicWithVideoUrl:(NSURL*)videoUrl newFile:(NSString*)newFile completion:(void(^)(NSString*data))completionHandle{
    
//    newFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_compressedVideo.m4a",time(NULL)]];
//    1562308959
//    1562309212
//    创建输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    newFile =  [documentsDirectory stringByAppendingPathComponent:
                [NSString stringWithFormat:@"mergeAudio%ld.m4a",time(NULL)]];
//                              arc4random() % 1000]];
    NSData *data = [NSData dataWithContentsOfURL:videoUrl];
    if (data) {
        NSLog(ASLocalizedString(@"视频data存在"));
    }
//    /var/mobile/Containers/Data/Application/10443AD4-5FB7-43B8-A506-A870B9B01B13/Documents/mergeAudio-295.m4a
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    NSArray *keys = @[@"duration",@"tracks"];
    
    [videoAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{

        NSError*error =nil;
        AVKeyValueStatus status = [videoAsset statusOfValueForKey:@"tracks"error:&error];
    
        if(status ==AVKeyValueStatusLoaded) {//数据加载完成
            
            // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
            //创建一个AVMutableComposition实例
            AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
            
            // 2 - Video track
            //创建一个轨道,类型是AVMediaTypeAudio
            AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                preferredTrackID:kCMPersistentTrackID_Invalid];
            
            //获取videoAsset中的音频,插入轨道
            //    NSLog(@"%f",videoAsset);
            // 视频时间范围
            
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            
            //创建输出对象
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
            //输出为M4A音频
            
            NSURL *a = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];

            NSURL *url = [a URLByAppendingPathComponent:@"filename.m4a"];

            NSString *filePath = [url absoluteString];
//            file:///var/mobile/Containers/Data/Application/C92D2683-EEC2-4287-B475-A2D11E27E6A2/Documents/filename.m4a
//            file:///var/mobile/Containers/Data/Application/C92D2683-EEC2-4287-B475-A2D11E27E6A2/Documents/filename.m4a
            NSLog(@"filePath%@",filePath);
            
            if ([[NSFileManager defaultManager]
                 fileExistsAtPath:filePath]){
                [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
                NSLog(@"filePath123456%@",filePath);
            }
            
            exporter.outputURL = [NSURL URLWithString:newFile];
//            url;
            //    [NSURL URLWithString:newFile];
            
            exporter.outputFileType = @"com.apple.m4a-audio";
//            AVFileTypeAppleM4A;
            exporter.shouldOptimizeForNetworkUse = YES;
            
            [exporter exportAsynchronouslyWithCompletionHandler:^(void){    dispatch_async(dispatch_get_main_queue(), ^{
                switch (exporter.status) {
                    case AVAssetExportSessionStatusCompleted:{
                        completionHandle(newFile);
                    }
                        break;
                    case AVAssetExportSessionStatusFailed:
                        NSLog(ASLocalizedString(@"导出失败：Failed:%@"),exporter.error);
                        completionHandle(@"");
                        break;
                        
                    case AVAssetExportSessionStatusCancelled:
                        NSLog(ASLocalizedString(@"导出取消：Canceled:%@"),exporter.error);
                        completionHandle(@"");
                        break;
                    default:
                        break;
                }
                
            });
                
            }];
        }else{
            NSLog(ASLocalizedString(@"音轨提取失败"));
            completionHandle(@"");
        }
    }];
}

/** 截取视频的无声音视频 */
+ (void)dM_VideoManager_RemoveVideoWithVideoUrl:(NSURL*)videoUrl newFile:(NSString*)newFile completion:(void(^)(NSString*data))completionHandle{
    
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *videoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    AVURLAsset* asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    CGFloat _sound = 0;
    
    if([asset tracksWithMediaType:AVMediaTypeVideo].count!=0){
        videoTrack  = [[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    }
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    if(videoTrack!=nil){
        [compositionVideoTrack insertTimeRange:timeRange ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    }
    
    //测试改变原声
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    if (assetAudioTrack != nil) {
        AVMutableCompositionTrack *compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, assetAudioTrack.timeRange.duration) ofTrack:assetAudioTrack atTime:kCMTimeZero error:nil];
        AVMutableAudioMixInputParameters *mixParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTrack];
        [mixParameters setVolumeRampFromStartVolume:_sound toEndVolume:_sound timeRange:CMTimeRangeMake(kCMTimeZero,assetAudioTrack.timeRange.duration)];
        AVMutableAudioMix *mutableAudioMix = [AVMutableAudioMix audioMix];
        mutableAudioMix.inputParameters = @[mixParameters];
    }
    
    
    
    //创建输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    newFile =  [documentsDirectory stringByAppendingPathComponent:
                [NSString stringWithFormat:@"mergeVideos-%ld.mov",time(NULL)]];
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    NSArray *keys = @[@"duration",@"tracks"];
    
    
    
    
    //导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:[mutableComposition
                                                                                  copy]  presetName:AVAssetExportPreset1280x720];
    //    }
//    exporter.videoComposition = mutableVideoComposition;
    exporter.audioMix = [AVMutableAudioMix audioMix];
    exporter.outputURL = [NSURL fileURLWithPath:newFile];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        switch (exporter.status) {
            case AVAssetExportSessionStatusCompleted:{
                NSLog(@"AVAssetExportSessionStatusCompleted%@",newFile);
                completionHandle(newFile);
            }
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(ASLocalizedString(@"导出失败：Failed:%@"),exporter.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(ASLocalizedString(@"导出取消：Canceled:%@"),exporter.error);
                break;
            default:
                break;
        }
    }];

    
    [videoAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        
        NSError*error =nil;
        AVKeyValueStatus status = [videoAsset statusOfValueForKey:@"tracks"error:&error];
        
        if(status ==AVKeyValueStatusLoaded) {//数据加载完成
            
            // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
            //创建一个AVMutableComposition实例
            AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
            
            // 2 - Video track
            //创建一个轨道,类型是AVMediaTypeVideo
            AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                preferredTrackID:kCMPersistentTrackID_Invalid];
            
            //获取videoAsset中的音频,插入轨道
            //    NSLog(@"%f",videoAsset);
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            
            //创建输出对象
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];//输出为M4A音频
            
            exporter.outputURL = [NSURL fileURLWithPath:newFile];
            //    [NSURL URLWithString:newFile];
            
            exporter.outputFileType = @"com.apple.m4a-audio";
            //    AVFileTypeAppleM4A;
            exporter.shouldOptimizeForNetworkUse = YES;
            
            [exporter exportAsynchronouslyWithCompletionHandler:^{     dispatch_async(dispatch_get_main_queue(), ^{
                switch (exporter.status) {
                    case AVAssetExportSessionStatusCompleted:{
                        completionHandle(newFile);
                    }
                        break;
                    case AVAssetExportSessionStatusFailed:
                        NSLog(ASLocalizedString(@"导出失败：Failed:%@"),exporter.error);
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        NSLog(ASLocalizedString(@"导出取消：Canceled:%@"),exporter.error);
                        break;
                    default:
                        break;
                }
                
            });
            }];
        }
    }];
}


///使用AVfoundation添加水印
+ (void)AVsaveVideoPath:(NSURL*)videoPath WithWaterImg:(UIImage*)img WithCoverImage:(UIImage*)coverImg WithQustion:(NSString*)question WithFileName:(NSString*)fileName completion:(void(^)(NSString*data))completionHandle;
{
    if (!videoPath) {
        return;
    }
    
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    
    //封面图片
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoPath options:opts];     //初始化视频媒体文件
    NSData *data = [NSData dataWithContentsOfURL:videoPath];
    
    
    CMTime startTime = CMTimeMakeWithSeconds(0.2, 600);
    CMTime endTime = CMTimeMakeWithSeconds(videoAsset.duration.value/videoAsset.duration.timescale-0.2, videoAsset.duration.timescale);
    
    //声音采集
    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:videoPath options:opts];

    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    //音频通道
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    //    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
    //        videoAssetOrientation_ =  UIImageOrientationUp;
    //    }
    //    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
    //        videoAssetOrientation_ = UIImageOrientationDown;
    //    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    [self applyVideoEffectsToComposition:mainCompositionInst WithWaterImg:img WithCoverImage:coverImg WithQustion:question size:CGSizeMake(renderWidth, renderHeight)];
    
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
//    CADisplayLink *dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
//    [dlink setFrameInterval:15];
//    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [dlink setPaused:NO];
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
//            [MGTCVideoRecordManager exportDidFinish:exporter];
            completionHandle(myPathDocs);
        });
    }];
    
}
+ (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition WithWaterImg:(UIImage*)img WithCoverImage:(UIImage*)coverImg WithQustion:(NSString*)question  size:(CGSize)size {
    
    NSArray *strArr = [question componentsSeparatedByString:@","];
    NSString *titleLeft = strArr.firstObject;
    NSString *weiboID = [NSString stringWithFormat:ASLocalizedString(@"唯播ID:%@"),strArr.lastObject];
    
    UIFont *font = [UIFont systemFontOfSize:30.0];
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFontSize:30];
    [subtitle1Text setString:titleLeft];
    [subtitle1Text setAlignmentMode:kCAAlignmentLeft];
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
    subtitle1Text.masksToBounds = YES;
    subtitle1Text.cornerRadius = 23.0f;
//    [subtitle1Text setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    CGSize textSize = [titleLeft sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [subtitle1Text setFrame:CGRectMake(50, size.height - textSize.height - 100, textSize.width+20, textSize.height+15)];
    
    CATextLayer *subtitle1Text2 = [[CATextLayer alloc] init];
    [subtitle1Text2 setFontSize:30];
    [subtitle1Text2 setString:weiboID];
    [subtitle1Text2 setAlignmentMode:kCAAlignmentRight];
    [subtitle1Text2 setForegroundColor:[[UIColor whiteColor] CGColor]];
    subtitle1Text2.masksToBounds = YES;
    subtitle1Text2.cornerRadius = 23.0f;
//    [subtitle1Text2 setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    CGSize textSize2 = [weiboID sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [subtitle1Text2 setFrame:CGRectMake(size.width - textSize2.width - 20 , textSize2.height + 10, textSize2.width , textSize2.height + 10)];
    
    //水印
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (id)img.CGImage;
    //    imgLayer.bounds = CGRectMake(0, 0, size.width, size.height);
//    imgLayer.bounds = CGRectMake(0, 0, 210, 50);
//    imgLayer.position = CGPointMake(size.width/2.0, size.height/2.0);
    
    //第二个水印
    CALayer *coverImgLayer = [CALayer layer];
    coverImgLayer.contents = (id)coverImg.CGImage;
    //    [coverImgLayer setContentsGravity:@"resizeAspect"];
//    coverImgLayer.bounds =  CGRectMake(50, 200,210, 50);
//    coverImgLayer.position = CGPointMake(size.width/4.0, size.height/4.0);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    [overlayLayer addSublayer:imgLayer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
//    [overlayLayer setMasksToBounds:YES];
    
    
    // 3 -
    CALayer *overlayLayer2 = [CALayer layer];
    [overlayLayer2 addSublayer:subtitle1Text2];
//    [overlayLayer2 addSublayer:imgLayer];
    overlayLayer2.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer2 setMasksToBounds:YES];
    
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    [parentLayer addSublayer:coverImgLayer];
    [parentLayer addSublayer:overlayLayer2];
    
    //设置封面
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:1.0f];
    anima.toValue = [NSNumber numberWithFloat:0.0f];
    anima.repeatCount = 0;
    anima.duration = 5.0f;  //5s之后消失
    [anima setRemovedOnCompletion:NO];
    [anima setFillMode:kCAFillModeForwards];
    anima.beginTime = AVCoreAnimationBeginTimeAtZero;
    [coverImgLayer addAnimation:anima forKey:@"opacityAniamtion"];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}
//
//更新生成进度
+ (void)updateProgress {
//    [SVProgressHUD showProgress:exporter.progress status:NSLocalizedString(ASLocalizedString(@"生成中..."), nil)];
//    if (exporter.progress>=1.0) {
//        [dlink setPaused:true];
//        [dlink invalidate];
//        //        [SVProgressHUD dismiss];
//    }
}







@end
