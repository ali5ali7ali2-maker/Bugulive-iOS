//
//  VideoDynamicViewC.m
//  BuguLive
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoDynamicViewC.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+STCommon.h"
#import "VideoCoverViewC.h"
#import "STVideoCoverLayout.h"

#import "VideoCateVC.h"
#import "DTTopicModel.h"
#import "BGTCUploadHelp.h"

#import "BogoShopKit.h"

#import "BogoNetwork.h"

#import "BogoVideoShopAddViewController.h"

@interface VideoDynamicViewC ()

{
    NSTimer             *_imageTimer;        //上传视频的定时器
    int                 _timeCount;          //上传视频的时间超过三分钟就报超时
    
    NSString            *imageUrl;
    NSString            *videoUrl;
}

@property(nonatomic, strong) NSString *audioTime;

@property(nonatomic, strong) NSString *selectedTopicID;

@property(nonatomic, strong) BogoCommodityDetailShopModel *shopModel;

@property(nonatomic, strong) NSMutableArray *cateArray;

@property(nonatomic, assign) CGSize videoSize;

@end

@implementation VideoDynamicViewC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ossManager];
    _timeCount = 180000;
    self.selectedTopicID = @"";

    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kClearColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:20.0]
    } forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"com_arrow_vc_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];

    [self requestCateData];
}

- (void)backBtnAction{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.view.backgroundColor = kRedColor;
    self.navigationController.navigationBar.hidden = NO;
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.title = ASLocalizedString(@"发布短视频");
    self.navigationController.navigationBar.tintColor =kAppGrayColor1;
    
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kClearColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:20.0]
    } forState:UIControlStateNormal];
 
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.title = ASLocalizedString(@"发布短视频");
    self.navigationController.navigationBar.tintColor =kAppGrayColor1;
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kClearColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:20.0]
    } forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.title = ASLocalizedString(@"发布短视频");
    self.navigationController.navigationBar.tintColor =kAppGrayColor1;
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:15]
    } forState:UIControlStateNormal];
}

-(VideoDynamicView *)videoDynamicView{
    if (!_videoDynamicView) {
        _videoDynamicView = (VideoDynamicView *)[VideoDynamicView showSTBaseViewOnSuperView:self.view
                                                                            loadNibNamedStr:@"VideoDynamicView"
                                                                               andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                                                andComplete:^(BOOL finished,
                                                                                              STBaseView *stBaseView) {
                                                                                }];
        [_videoDynamicView setBaseDelegate:self];
        [_videoDynamicView setDelegate:self];
//        _videoDynamicView.tableView.tableFooterView = [UIView new];
        _videoDynamicView.tableView.mj_footer.hidden = YES;
    }
    return _videoDynamicView;
}

- (void)requestCateData{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"dynamic" forKey:@"ctl"];
    [parmDict setObject:@"dynamic_cate" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        NSArray * array = responseJson[@"data"];
        [self.cateArray removeAllObjects];
        for (id obj in array)
        {
            DTTopicModel *model =[DTTopicModel mj_objectWithKeyValues:obj];
            [self.cateArray addObject:model];
        }
//        [self.tableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}


-(void)upLoadVideoUrl:(NSString *)urls{
    
    NSURL *url = [NSURL fileURLWithPath:urls];
    
    
    AVURLAsset *asset1 = [AVURLAsset assetWithURL:url];
    CMTime  time = [asset1 duration];
    int seconds = ceil(time.value/time.timescale);
    self.audioTime = [NSString stringWithFormat:@"%d",seconds];
    
#pragma mark - 帧图数据
    NSMutableArray *tempImageMArray =@[].mutableCopy;
    
    
    NSLog(@"VideoDynamicView1111");
    
    FWWeakify(self)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"VideoDynamicView2222");
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //数组 专门存
        //GCD 快速遍历
        NSLog(@"-----------se-----%d",seconds);
        if(!self.videoMArray)
        {
            self.videoMArray = @[].mutableCopy;
        }
        //只保留一个视频
        [self.videoMArray removeAllObjects];
        NSLog(@"VideoDynamicView3333");
        @autoreleasepool {
            //            [self movFileTransformToMP4WithSourceUrl:url completion:^(NSURL *Mp4FilePath) {
            NSData *videoData = [NSData dataWithContentsOfURL:url];
            [self.videoMArray addObject:videoData];
            
            NSLog(@"videoMArray%ld",self.videoMArray.count);
            NSLog(@"VideoDynamicView4444");
            //            for (int i = 0;i< seconds;i++) {
            UIImage *thumbnailImage = [UIImage st_thumbnailImageForVideo:url atTime:0];
            [tempImageMArray addObject:thumbnailImage];
            //            }
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"VideoDynamicView5555");
                //下发 帧图数组
                FWStrongify(self)
                [self showSelectedMAray:tempImageMArray];
                self.videoDynamicView.videoURL = url;
                //                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    });
}

#pragma ********************************* 子重写父 方法区域 *************************
#pragma mark -  系统 -完成照片选择回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取 选择的类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //这里只选择 视频
    if ([mediaType isEqualToString:@"public.movie"]) {
        //获取视图的url
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        AVURLAsset * asset1 = [AVURLAsset assetWithURL:url];
        CMTime   time = [asset1 duration];
        int seconds = ceil(time.value/time.timescale);
        //多帧图
//        MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//        moviePlayer.shouldAutoplay = NO;
        if ((int)seconds <3) {
            [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"选取视频时长太小")];
            //关闭当前的模态视图
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            return;
        }else if((int)seconds >=[[GlobalVariables sharedInstance].appModel.sts_video_limit floatValue]) {
            [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"选取视频时长太大")];
            //关闭当前的模态视图
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }];
            return;
        }else{
            
        }
        self.videoSize = [[[asset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
#pragma mark - 帧图数据
        NSMutableArray *tempImageMArray =@[].mutableCopy;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //数组 专门存
            //GCD 快速遍历
            NSLog(@"-----------se-----%d",seconds);
            if(!self.videoMArray)
            {
                self.videoMArray = @[].mutableCopy;
            }
            //只保留一个视频
            [self.videoMArray removeAllObjects];

            @autoreleasepool {
                [self movFileTransformToMP4WithSourceUrl:url completion:^(NSURL *Mp4FilePath) {
                    NSData *videoData = [NSData dataWithContentsOfURL:Mp4FilePath];
                    self.videoDynamicView.videoURL = Mp4FilePath;
                    [self.videoMArray addObject:videoData];
                    
                    for (int i = 0;i< seconds;i++) {
                        UIImage *thumbnailImage = [UIImage st_thumbnailImageForVideo:Mp4FilePath atTime:i];
                        [tempImageMArray addObject:thumbnailImage];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //下发 帧图数组
                        [self showSelectedMAray:tempImageMArray];
                        //关闭当前的模态视图
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                            [self popoverPresentationController];
                        }];
                        
                    });
                    
                }];
            }
        });
        
    }
}
#pragma - 系统imgPickerC - 取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
    if (self.videoDynamicView.dataSoureMArray.count == 0) {
        [[AppDelegate sharedAppDelegate]  popViewController];
    }
}
#pragma mark -----IPC数据下发（子重写）
-(void)showSelectedMAray:(NSMutableArray *)selectedMArray{
    NSLog(@"-----3131------%lu----------",(unsigned long)selectedMArray.count);
    [self videoDynamicView];
    self.videoDynamicView.dataSoureMArray = selectedMArray;
    NSLog(@"-----------------%@",NSStringFromClass([selectedMArray[0] class]));
    
    
    //本地服务器缩略图
//    if([GlobalVariables sharedInstance].appModel.open_sts != 1 || ([[GlobalVariables sharedInstance].appModel.short_video_store isEqualToString:@"1"]))
//    {
        NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
         NSString*filePath = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"demo.png"]];// 保存文件的名称

         BOOL result =[UIImagePNGRepresentation(selectedMArray[0]) writeToFile:filePath atomically:YES];// 保存成功会返回YES

         if(result ==YES) {

            NSLog(ASLocalizedString(@"保存成功"));
             
             
             NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];

             [parmDict setObject:@"upload_file" forKey:@"ctl"];
             [parmDict setObject:@"upload_video_file" forKey:@"act"];
             
             [[NetHttpsManager manager] POSTWithDict:parmDict andFileUrl:[NSURL fileURLWithPath:filePath]  SuccessBlock:^(NSDictionary *responseJson) {

                 self.recordVideoCoverURLStr = responseJson[@"server_full_path"];
                 
                 
             } FailureBlock:^(NSError *error) {
                 
             }];
             
         }
         else
         {
             [BGHUDHelper alert:ASLocalizedString(@"图片保存失败")];
         }
//    }
    
    [self.videoDynamicView.tableView reloadData];
}

#pragma ********************************* Delegate 代理  *************************
#pragma -------------- <STTableViewBaseViewDelegate>
-(void)showTableViewDidSelectIndexpath:(NSIndexPath *)indexPath andSTTableBaseView:(STTableBaseView *)stTableBaseView{
    if (indexPath.section == 3 && indexPath.row == 0)
    {
        [self showPublishDynamic];
    }
    //百度地图定位
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        //加载地图
        [self showSTBMKViewC];
    }
}
#pragma *************************  地图部分 *************************
/*
 //百度地图定位
 if(indexPath.section == 2 && indexPath.row == 0){
 //加载地图
 [self showSTBMKViewC];
 }
 }*/
#pragma -------------刷新 地图选择
// 因为父层去拿子层的View，好难 那就重写
-(void)showUpdateLoactionInfoOfIndexPath
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    [self.videoDynamicView.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]
                                           withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark ---------- 发布（子重写）
//(为了统一，所有发布方法一致)
-(void)showPublishDynamic
{
    //
    [self videoDynamicView];
    //1区0行 -动态文本
    if(!self.videoDynamicView.recordTextViewStr
       ||self.videoDynamicView.recordTextViewStr.length<1
       ||[self.videoDynamicView.recordTextViewStr isEqualToString:ASLocalizedString(@"这一刻你的想法")]){
        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"请编辑这一刻你的想法")];
        return;
    }
    //位置
    
    //帧图要存在
    
    //视频是否存在
    if (self.videoMArray.count == 0)
    {
        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"视频数据不小心丢失了，请重新选择")];
        return;
    }
    
    // 数据预处理
    NSMutableArray <NSData *>*tempImgDataMArray = @[].mutableCopy;
    
    //处理帧图数据
    UIImage *image = self.videoDynamicView.dataSoureMArray[self.videoDynamicView.recordSelectIndex];
    [tempImgDataMArray addObject:UIImagePNGRepresentation(image)];
    //帧图存在
    if(tempImgDataMArray.count== 0)
    {
        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"帧图数据不小心丢失了，请重新选择")];
        return;
    }
    //开启上传
    if (![self.ossManager isSetRightParameter])
    {
        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"图片参数配置失败")];
        return;
    }
    FWWeakify(self);
    if (!_imageTimer)
    {
        _imageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(imageTimeGo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_imageTimer forMode:NSDefaultRunLoopMode];
    }
    [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传数据中...")];
    
    //这个地方之前写错了
    
    
    /** 本地  **/
    if([[GlobalVariables sharedInstance].appModel.short_video_store isEqualToString:@"2"])
    {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];

        [parmDict setObject:@"upload_file" forKey:@"ctl"];
        [parmDict setObject:@"upload_video_file" forKey:@"act"];
        
        [[NetHttpsManager manager] POSTWithDict:parmDict andFileUrl:self.videoDynamicView.videoURL SuccessBlock:^(NSDictionary *responseJson) {
            self.recordVideoURLStr = responseJson[@"server_full_path"];
            [[BGHUDHelper sharedInstance]syncStopLoading];
            [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在发布中...")];
            [self showHttpServiceublishDynamic];
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    /** 阿里云  **/
    else if([[GlobalVariables sharedInstance].appModel.short_video_store isEqualToString:@"0"])
    {
        [self.ossManager showUploadOfOssServiceOfDataMarray:tempImgDataMArray
                                              andSTDynamicSelectType:STDynamicSelectPhoto
                                                         andComplete:^(BOOL finished,
                                                                       NSMutableArray<NSString *> *urlStrMArray) {
                                                             FWStrongify(self)
                                                             if (urlStrMArray.count>0)
                                                             {
                                                                 //图片url  str
                                                                 self.recordVideoCoverURLStr = urlStrMArray[0];
                                                                 //任务2：上传 视频 MOC 格式
        //                                                         [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传数据中...")];
                                                                 
                                                                     [self.ossManager showUploadOfOssServiceOfDataMarray:self.videoMArray
                                                                                                       andSTDynamicSelectType:STDynamicSelectVideo
                                                                                                                  andComplete:^(BOOL finished,
                                                                                                                                NSMutableArray<NSString *> *urlStrMArray) {
                                                                                                                      [[BGHUDHelper sharedInstance]syncStopLoading];
                                                                                                                      if(urlStrMArray.count>0)
                                                                                                                      {
                                                                                                                          self.recordVideoURLStr = urlStrMArray[0];
                                                                                                                          [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在发布中...")];
                                                                                                                          [self showHttpServiceublishDynamic];
                                                                                                                      }
                                                                                                                  }];
                                                                 
                                                                 
                                                                 

                                                             }
                                                             
                                                         }];
    }
        /** 腾讯云  **/
    else if([[GlobalVariables sharedInstance].appModel.short_video_store isEqualToString:@"1"])
    {
        
        
        @weakify(self)
        
        [[BGTCUploadHelp sharedBGTCUploadHelp] uploadVideoWithVideoPath:self.videoDynamicView.videoURL.path];
        [BGTCUploadHelp sharedBGTCUploadHelp].publishResult = ^(BOOL success, NSString * _Nonnull recordVideoURLStr, NSString * _Nonnull msg) {
            [[BGHUDHelper sharedInstance]syncStopLoading];

            if(success)
            {
                
                
                                                                                                                                      weak_self.recordVideoURLStr = recordVideoURLStr;
                                                                                                                                      [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在发布中...")];
                                                                                                                                       [weak_self showHttpServiceublishDynamic];
            }
            
                                                                                              
        };
    }
    
    
}

- (void)imageTimeGo
{
    _timeCount --;
    NSLog(@"timeCount===%d",_timeCount);
    if (_timeCount == 0)
    {
        [_imageTimer invalidate];
        _imageTimer = nil;
        [[BGHUDHelper sharedInstance]syncStopLoading];
        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"视频上传超时")];
    }
}

#pragma----正式提交服务器 发布
-(void)showHttpServiceublishDynamic{
    
    if(self.recordVideoCoverURLStr == nil)
    {
        [BGHUDHelper alert:ASLocalizedString(@"封面图未上传完")];
        return;
    }
    
    if(self.recordVideoURLStr == nil)
    {
        [BGHUDHelper alert:ASLocalizedString(@"视频未上传完")];
        return;
    }
    
    
    //地图管理类
    STBMKCenter *stBMKCenter = [STBMKCenter shareManager];
    //参数MDic
    
//    @"api/liveAddGoodsUrl" param:@{@"token":[BogoNetwork shareInstance].token
    
    
    
    
//    @"ctl":@"publish",@"act":@"do_publish"
    NSMutableDictionary *parametersMDic = @{@"ctl"             :@"weibo",
                                            @"act"             :@"release",
                                            @"itype"           :@"xr",
                                            @"type"    :@"video",
                                            @"cate"    :self.selectedTopicID,                                  // 发布商品
                                            @"content"         :self.videoDynamicView.recordTextViewStr,   // 动态文本
                                            @"photo_image"     :self.recordVideoCoverURLStr,               // OSS 封面图 URL
                                            @"video_url"       :self.recordVideoURLStr,                    // OSS 视频   URL
                                            @"latitude"        :@(stBMKCenter.latitudeValue),              // 纬度值
                                            @"longitude"       :@(stBMKCenter.longitudeValue),             // 经度值
                                            @"city"            :stBMKCenter.cityNameStr,                   // 城市名称
                                            @"province"        :stBMKCenter.provinceStr,                   // 省会
                                            @"address"         :stBMKCenter.detailAdressStr,               // 具体坐标地址
                                            @"shop_title":SafeStr(self.shopModel.shop_title),
                                            @"shop_id":SafeStr(self.shopModel.gid),
                                            @"width":@(self.videoSize.width),
                                            @"height":@(self.videoSize.height),
                                            @"video_direction":self.videoSize.width > self.videoSize.height ? @"1" : @"0"
                                            }.mutableCopy;
    FWWeakify(self)
              
              
    [[BogoNetwork shareInstance]GETV2:@"Weibo/release" param:parametersMDic success:^(BogoNetworkResponseModel * _Nonnull result) {
        
        
        [[BGHUDHelper sharedInstance]syncStopLoading];
        [_imageTimer invalidate];
        _imageTimer = nil;
        
          
//          NSInteger state = [NSString stringWithFormat:@"%@",result.status];
//          res
//          if(result.status.intValue == 1)
//          {
              //[[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"发布成功!")];
              [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"发布成功!")];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTableViewStatus" object:nil];
        FWStrongify(self)
        // 执行退出
        @autoreleasepool {
            self.recordSuperViewC = nil;
            self.recordTabBarC = nil;
            self.videoMArray = nil;
            self.photoMArray = nil;
            self.tzImagePickerController = nil;
            self.ossManager  = nil;
            self.videoDynamicView = nil;
            self.navigationController.hidesBottomBarWhenPushed = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
            Noti_Post_Param(@"DynamicCommitSuccess", nil);
        }
//          }
      } failure:^(NSString * _Nonnull error) {
          [[BGHUDHelper sharedInstance]syncStopLoading];
          [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"发布失败!")];
      }];
    
    return;
    
    [[NetHttpsManager manager]POSTWithParameters:parametersMDic
                                    SuccessBlock:^(NSDictionary *responseJson) {
                                        [[BGHUDHelper sharedInstance]syncStopLoading];
                                        [_imageTimer invalidate];
                                        _imageTimer = nil;
                                        if( [[responseJson allKeys] containsObject:@"status"]&&[responseJson[@"status"] intValue] == 1)
                                        {
                                            //[[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"发布成功!")];
                                            [BGHUDHelper alert:ASLocalizedString(@"发布成功!")action:^{
                                                FWStrongify(self)
                                                // 执行退出
                                                @autoreleasepool {
                                                    self.recordSuperViewC = nil;
                                                    self.recordTabBarC = nil;
                                                    self.videoMArray = nil;
                                                    self.photoMArray = nil;
                                                    self.tzImagePickerController = nil;
                                                    self.ossManager  = nil;
                                                    self.videoDynamicView = nil;
                                                    self.navigationController.hidesBottomBarWhenPushed = NO;
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                    Noti_Post_Param(@"DynamicCommitSuccess", nil);
                                                }
                                            }];
                                        }
                                    } FailureBlock:^(NSError *error) {
                                        [[BGHUDHelper sharedInstance]syncStopLoading];
                                        [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"发布失败!")];
                                        
                                    }];
}
#pragma --------------  <VideoDynamicViewDelegate>
#pragma mark --去选择视频
//父类已实现

#pragma mark --发布
- (void)submitData{
    [self showPublishDynamic];
}

#pragma mark --去封面编辑页面
-(void)showOnVideoDynamicView:(VideoDynamicView *)videoDynamicView
         STTableShowVideoCell:(STTableShowVideoCell *)stTableShowVideoCell
     andChangeVideoCoverClick:(UIButton *)changeVideoCoverClick{
    //
    
    if (self.videoDynamicView.dataSoureMArray.count == 0)
    {
        return;
    }
    VideoCoverViewC *videoCoverViewC = (VideoCoverViewC *)[VideoCoverViewC showSTBaseViewCOnSuperViewC:self
                                                                                          andFrameRect:CGRectMake(0, 0, kScreenW, kScreenH)
                                                                              andSTViewCTransitionType:STViewCTransitionTypeOfPush
                                                                                           andComplete:^(BOOL finished,
                                                                                                         STBaseViewC *stBaseViewC) {
                                                                                               
                                                                                           }];
    videoCoverViewC.title = ASLocalizedString(@"编辑视频封面");
    // 数组
    [videoCoverViewC videoCoverView];
    videoCoverViewC.videoCoverView.collectionView.backgroundColor = [UIColor whiteColor];
    videoCoverViewC.videoCoverView.collectionView.frame = CGRectMake(0,kScreenH-250, kScreenW, 150);
    //videoCoverViewC.videoCoverView.collectionView.backgroundColor = [UIColor redColor];
    //STVideoCoverLayout *layout = [STVideoCoverLayout new];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 2;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    videoCoverViewC.videoCoverView.collectionView.collectionViewLayout = layout;
    videoCoverViewC.videoCoverView.dataSourceMArray = self.videoDynamicView.dataSoureMArray;
    
    //设置首帧图
    [videoCoverViewC.videoCoverView.showSelectedImgView setImage:self.videoDynamicView.dataSoureMArray[0]];
    [videoCoverViewC.videoCoverView.collectionView reloadData];
    videoCoverViewC.navigationController.navigationBar.tintColor = kAppGrayColor1;
    [self.navigationController pushViewController:videoCoverViewC animated:YES];
    __weak typeof(self)weak_Self = self;
    videoCoverViewC.selectImgInMarrayblock = ^(NSInteger  selectMArrayIndex){
        weak_Self.videoDynamicView.recordSelectIndex = selectMArrayIndex;
        [stTableShowVideoCell.bgImgView setImage:[UIImage boxblurImage:weak_Self.videoDynamicView.dataSoureMArray[selectMArrayIndex] withBlurNumber:1]];
        [stTableShowVideoCell.videoCoverImgView  setImage:weak_Self.videoDynamicView.dataSoureMArray[selectMArrayIndex]];
        [stTableShowVideoCell.bgImgView setNeedsDisplay];
        [stTableShowVideoCell.videoCoverImgView setNeedsDisplay];
    };
}

- (void)goVCOnVideoDynamicView:(VideoDynamicView *)videoDynamicView STTableShowVideoCell:(STVideoCateCell *)cell andChooseCateClick:(QMUIButton *)btn{
    __weak __typeof(self)weakSelf = self;
    
    FDActionSheet *ac = [[FDActionSheet alloc]initWithTitle:ASLocalizedString(@"选择分类") message:nil];
    for (DTTopicModel *model in self.cateArray) {
        [ac addAction:[FDAction actionWithTitle:model.name type:FDActionTypeDefault CallBack:^{
            weakSelf.selectedTopicID = model.id;
            [btn setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
            CGSize btnSize = [self preferredSizeWithMaxWidth:kScreenW-130 view:btn];
            
            btn.frame = CGRectMake(kScreenW-btnSize.width-30, 12, btnSize.width, 30);
        }]];
    }
    [ac addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:nil]];
    [ac show:self.view];
    
    //进入分类页面
//    VideoCateVC *tmpController = [[VideoCateVC alloc]init];
//    tmpController.view.backgroundColor = kWhiteColor;
//     __weak __typeof(self)weakSelf = self;;
//     tmpController.releaseTopicBlock = ^(DTTopicModel * _Nonnull topic) {
//         btn.hidden = NO;
//         weakSelf.selectedTopicID = topic.id;
//         [btn setTitle:[NSString stringWithFormat:@"%@",topic.name] forState:UIControlStateNormal];
//         CGSize btnSize = [self preferredSizeWithMaxWidth:kScreenW-130 view:btn];
//
//         btn.frame = CGRectMake(kScreenW-btnSize.width-50, 12, btnSize.width, 30);
//     };
//     [self.navigationController pushViewController:tmpController animated:YES];
     //选择分类后，设置frame
    
    
    
}

-(void)dynamicView:(VideoDynamicView *)dynamicView didSelectGood:(STTableLeftRightCell *)cell{

    BogoVideoShopAddViewController *addVC = [[BogoVideoShopAddViewController alloc]init];
    
    addVC.isVideoSelect = YES;

    [addVC setSelectVideoGoodCallBack:^(BogoCommodityDetailModel * _Nonnull model) {
        
//        cell.rightLab.backgroundColor = kBlueColor;
        self.shopModel = model;
//        cell.backgroundColor = UIColor.redColor;
//        [cell.leftBtn setTitle:@"31312" forState:UIControlStateNormal];
//        cell.rightLab.text = model.shop_title;
        cell.rightLabel.text = model.shop_title;
//        if (!StrValid(model.shop_title)) {
//            model.shop_title = model.title;
//        }
        
        NSLog(@"%@",cell);
        NSLog(@"%@",cell.rightLab);
        NSLog(@"%@",cell.leftBtn);
        
        
    }];
    [self.navigationController pushViewController:addVC animated:YES];
}





- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth view:(QMUIButton *)btn
{
    CGSize  size = [btn sizeThatFits:CGSizeMake(maxWidth, 30)] ;
    return CGSizeMake(size.width +15, size.height);
}

#pragma mark mov格式转mp4格式
- (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSURL *Mp4FilePath))comepleteBlock
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                     
                     comepleteBlock(exportSession.outputURL);
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     
                     break;
             }
         }];
    }
}

- (NSMutableArray *)cateArray{
    if (!_cateArray) {
        _cateArray = [NSMutableArray array];
    }
    return _cateArray;
}
@end

