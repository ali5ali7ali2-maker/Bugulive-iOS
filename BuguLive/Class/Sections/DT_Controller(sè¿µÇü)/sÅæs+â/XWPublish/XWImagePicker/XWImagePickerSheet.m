//
//  XWImagePickerSheet.m
//  XWPublishDemo
//
//  Created by 邱学伟 on 16/4/15.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWImagePickerSheet.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface XWImagePickerSheet ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@end

@implementation XWImagePickerSheet
{
    CYImagePickerViewController *imagePickerVc;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_arrSelected) {
            self.arrSelected = [NSMutableArray array];
        }
        if (!_thumbnailImgArr) {
            self.thumbnailImgArr = [NSMutableArray array];
        }
    }
    return self;
}

//显示选择照片提示Sheet
-(void)showImgPickerActionSheetInView:(UIViewController *)controller isPhoto:(BOOL)isPhoto{
    
    NSString *alertTitle   = isPhoto ? ASLocalizedString(@"选择照片"): ASLocalizedString(@"选择视频");
    NSString *alertCamera  = isPhoto ? ASLocalizedString(@"拍照"): ASLocalizedString(@"拍摄视频");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertTitle preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:alertCamera style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (!imaPic) {
            imaPic = [[UIImagePickerController alloc] init];
        }
        NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
        
        BOOL isShowVC = YES;
        
        if (isPhoto) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
                 imaPic.mediaTypes = [NSArray arrayWithObject:availableMedia[0]];//设置媒体类型为public.movie
                imaPic.delegate = self;
            }
            
            if (self.arrSelected.count > 0)
            {
                PHAsset *set = self.arrSelected.firstObject;
                if (set.mediaType == PHAssetMediaTypeVideo)
                {
//                    [MBProgressHUD showTopTipMessage:ASLocalizedString(@"选择视频不能再选择图片")];
                    [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"选择视频不能再选择图片")];

                    isShowVC = NO;
                }
                
            }
            
        }else{
            
            if (self.arrSelected.count > 0)
            {
                PHAsset *set = self.arrSelected.firstObject;
                if (set.mediaType == PHAssetMediaTypeImage)
                {
//                    [MBProgressHUD showTopTipMessage:ASLocalizedString(@"选择图片不能再选择视频")];
                    [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"选择图片不能再选择视频")];

                    isShowVC = NO;
                }
            
            }
            
            imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
            //    ipc.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            
            imaPic.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
            imaPic.videoMaximumDuration = 600.0f;//10分钟
            imaPic.delegate = self;//设置委托
        }
        if (isShowVC) [viewController presentViewController:imaPic animated:NO completion:nil];
        
    }];
    
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:ASLocalizedString(@"相册")] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self loadImgDataAndShowAllGroup];
        
        BOOL isShowVC = YES;
        
        if (isPhoto) {
            if (self.arrSelected.count > 0)
            {
                PHAsset *set = self.arrSelected.firstObject;
                if (set.mediaType == PHAssetMediaTypeVideo)
                {
//                    [MBProgressHUD showTopTipMessage:ASLocalizedString(@"选择视频不能再选择图片")];
                    [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"选择视频不能再选择图片")];

                    isShowVC = NO;
                }
                
            }
        }else{
            
            if (self.arrSelected.count > 0)
            {
                PHAsset *set = self.arrSelected.firstObject;
                if (set.mediaType == PHAssetMediaTypeImage)
                {
//                    [MBProgressHUD showTopTipMessage:ASLocalizedString(@"选择图片不能再选择视频")];
                    [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"选择图片不能再选择视频")];

                    isShowVC = NO;
                }
                
            }
            
        }
        
        
        
        [self newShowPhotosWithStatus:isPhoto isShowVC:isShowVC];
    
    }];
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
    [alertController addAction:actionAlbum];
    
    viewController = controller;
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)newShowPhotosWithStatus:(BOOL)status isShowVC:(BOOL)isShowVC
{
    imagePickerVc = [[CYImagePickerViewController alloc] initWithMaxImagesCount:_maxCount delegate:self];
    [imagePickerVc.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    imagePickerVc.naviBgColor = [UIColor blackColor];
    imagePickerVc.allowPickingImage = status;
    imagePickerVc.allowPickingVideo = !status;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __block typeof(self)blockself =self;
    

    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        BOOL ishaveVideo =NO,ishaveImage =NO;
        NSMutableArray *c_assets = [assets mutableCopy];
        NSMutableArray *c_phots = [photos mutableCopy];
        
        
        for (id c_set in assets)
        {
            if ([c_set isKindOfClass:[PHAsset class]])
            {
                PHAsset *set =(PHAsset *)c_set;
                if (set.mediaType == PHAssetMediaTypeVideo)
                {
                    ishaveVideo =YES;
                    //需要移除视频
                    NSInteger index =[assets indexOfObject:c_set];
                    [c_phots removeObjectAtIndex:index];
                    [c_assets removeObject:c_set];
                }
                if (set.mediaType == PHAssetMediaTypeImage)
                {
                    ishaveImage = YES;
                }
            }
        }
        
        blockself.arrSelected =[c_assets mutableCopy];
        blockself.thumbnailImgArr = [c_phots mutableCopy];
        if (blockself.delegate && [blockself.delegate respondsToSelector:@selector(getSelectImageWithALAssetArray:thumbnailImageArray:)]) {
            [blockself.delegate getSelectImageWithALAssetArray:blockself.arrSelected thumbnailImageArray:blockself.thumbnailImgArr];
        }
    }];
    
    //视频回调
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        blockself.arrSelected =[@[asset] mutableCopy];
        if (blockself.delegate && [blockself.delegate respondsToSelector:@selector(getSelectVideoWith:thumbImage:)]) {
            [blockself.delegate getSelectVideoWith:asset thumbImage:@[coverImage]];
        }
    }];
    
    imagePickerVc.naviTitleColor = [UIColor blackColor];
    imagePickerVc.barItemTextColor =  [UIColor blackColor];
    imagePickerVc.oKButtonTitleColorNormal = kAppNewMainColor;
//    [UIColor blackColor];
    imagePickerVc.showSelectBtn = status;
    if (_arrSelected)
    {
//        NSLog(@"%@",_arrSelected);
//        ALAsset *asset = _arrSelected.firstObject;
//        NSLog(@"%@",asset);
        imagePickerVc.selectedAssets =_arrSelected;
    }
    
    if (isShowVC) [viewController presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imaPic dismissViewControllerAnimated:NO completion:nil];
}

- (void)newFinishedChooseImage:(NSArray *)assets
{
    //正方形缩略图
    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
    
    for (ALAsset *set in _arrSelected) {
        CGImageRef cgImg = [set thumbnail];
        UIImage* image = [UIImage imageWithCGImage: cgImg];
        [thumbnailImgArr addObject:image];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImageWithALAssetArray:thumbnailImageArray:)]) {
        [self.delegate getSelectImageWithALAssetArray:_arrSelected thumbnailImageArray:thumbnailImgArr];
    }
    
}

#pragma mark - 加载照片数据

- (void)loadImgDataAndShowAllGroup{
    if (!_arrSelected) {
        self.arrSelected = [NSMutableArray array];
    }
    [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
        if (arrObj && arrObj.count > 0) {
            self.arrGroup = arrObj;
            if ( self.arrGroup.count > 0) {
                MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:self.arrGroup arrSelected:self.arrSelected];
                svc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
                if (_arrSelected) {
                    svc.arrSeleted = _arrSelected;
                    svc.mvc.arrSelected = _arrSelected;
                }
                svc.maxCout = _maxCount;
                [viewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //获取用户选择或拍摄的是照片还是视频
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (theImage) {
            //保存图片到相册中
            MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
            [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                
                } else {
                    
                    //获取图片路径
                    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
                    if (result) {
                        PHAsset *asset = [result lastObject];
                        if (asset) {
                            [_arrSelected addObject:asset];
//                            [_thumbnailImgArr removeAllObjects];
//                            [self finishSelectImg];
                            [self fetchImageWithAsset:asset imageBlock:^{
                                

                            }];
                            [picker dismissViewControllerAnimated:NO completion:nil];
                        }
                    }
                }
            }];
        }
    }else{

        
        NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
      
        __block typeof(self)blockself =self;
        
        //保存图片到相册中
        MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
        
        [imgLibTool.lib writeVideoAtPathToSavedPhotosAlbum:info[UIImagePickerControllerMediaURL] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
            
            } else {
                //获取视频路径
                PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
                if (result) {
                    PHAsset *asset = [result lastObject];
                    if (asset) {
                        
                        [_arrSelected removeAllObjects];
                        [_thumbnailImgArr removeAllObjects];
                        
                        [_arrSelected addObject:asset];
                        
                        [self fetchImageWithAsset:asset imageBlock:^{
                            
                        }];
                        [picker dismissViewControllerAnimated:NO completion:nil];
                    }
                }
                
//                //获取视频路径
//                [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//                    if (asset) {
//                        [_arrSelected addObject:asset];
//                        [self finishSelectImg];
//
//                        [imaPic dismissViewControllerAnimated:NO completion:nil];
//                    }else{
//
//                    }
//                } failureBlock:^(NSError *error) {
//
//                }];
            }
        }];;
        
   
    }
}

- (void)fetchImageWithAsset:(PHAsset*)mAsset imageBlock:(void(^)())imageBlock {
    
    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        UIImage* image = [UIImage imageWithData:imageData];
        
        if (orientation != UIImageOrientationUp) {
            
            // 尽然弯了,那就板正一下
            image = [image fixOrientation];
            
            
//            // 新的 数据信息 （不准确的）
//            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        
        
        [_thumbnailImgArr addObject:image];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImageWithALAssetArray:thumbnailImageArray:)]) {
            [self.delegate getSelectImageWithALAssetArray:_arrSelected thumbnailImageArray:_thumbnailImgArr];
        }
        
        
        // 直接得到最终的 NSData 数据
        if (imageBlock) {
            imageBlock();
        }
        
    }];
}

@end
