//
//  XWPublishBaseController.m
//  XWPublishDemo
//
//  Created by 邱学伟 on 16/4/15.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWPublishBaseController.h"

#import "JZVideoPlayerView.h"

#define column 3
#define itemWidth ([UIScreen mainScreen].bounds.size.width-10*4) /3

@interface XWPublishBaseController ()<UICollectionViewDelegate,UICollectionViewDataSource,JJPhotoDelegate,XWImagePickerSheetDelegate,JZPlayerViewDelegate>{
    
    
    JZVideoPlayerView *_jzPlayer;
//    UIView *loadView;
    UIActivityIndicatorView *activityIndicatorView;
    
    NSString *pushImageName;
    //添加图片提示
    UILabel *addImageStrLabel;
}

@property (nonatomic, strong) XWImagePickerSheet *imgPickerActionSheet;

@property (nonatomic, strong) UIView  *playBGView;
@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, assign) BOOL playerIsBuffering;
@property(nonatomic, strong) UIButton *playBtn;

@end

@implementation XWPublishBaseController{
    /**播放器*/
   AVPlayer                *_player;
   /**playerLayer*/
   AVPlayerLayer           *_playerLayer;
   /**播放器item*/
   AVPlayerItem            *_playerItem;
}

static NSString * const reuseIdentifier = @"XWPhotoCell";

-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_showActionSheetViewController) {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//初始化collectionView
-(void)initPickerView{
    _showActionSheetViewController = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    if (_showInView) {
        [_showInView addSubview:self.pickerCollectionView];
    }else{
        [self.view addSubview:self.pickerCollectionView];
    }
    
    self.pickerCollectionView.delegate=self;
    self.pickerCollectionView.dataSource=self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    
    if(_imageArray.count == 0)
    {
        _imageArray = [NSMutableArray array];
    }
    if(_bigImageArray.count == 0)
    {
        _bigImageArray = [NSMutableArray array];
    }
    pushImageName = @"plus";
    
    _pickerCollectionView.scrollEnabled = NO;
    
    //添加图片提示
    addImageStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 120, 20)];
    addImageStrLabel.text = ASLocalizedString(@"添加图片/视频");
    addImageStrLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    //    [self.pickerCollectionView addSubview:addImageStrLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_imageArray.count >= self.maxCount) {
        return _imageArray.count;
    }
    return _imageArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Register nib file for the cell
    UINib *nib = [UINib nibWithNibName:@"XWPhotoCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"XWPhotoCell"];
    // Set up the reuse identifier
    XWPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"XWPhotoCell" forIndexPath:indexPath];
    
    if (indexPath.row == _imageArray.count) {
        //        [cell.profilePhoto setImage:[UIImage imageNamed:pushImageName]];
        cell.profilePhoto.image = [UIImage imageNamed:@"mine_edit_addPhoto"];
        //        IMAGE_NAMED(@"mine_edit_addPhoto");
        cell.closeButton.hidden = YES;
        
        //没有任何图片
        if (_imageArray.count == 0) {
            addImageStrLabel.hidden = NO;
        }
        else{
            addImageStrLabel.hidden = YES;
        }
    }
    else{
        [cell.profilePhoto setImage:_imageArray[indexPath.item]];
        cell.closeButton.hidden = NO;
    }
    [cell setBigImgViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemWidth ,itemWidth);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - 图片cell点击事件
//点击图片看大图
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
    
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (_imageArray.count)) {
        [self.view endEditing:YES];
        //添加新图片
        [self addNewImg];
    }
    else{
        //点击放大查看
        XWPhotoCell *cell = (XWPhotoCell*)[_pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if (!cell.BigImgView || !cell.BigImgView.image) {
            
            [self getBigIamgeWithPhasset:_arrSelected[index] isSubmit:NO callbackImg:^(id img, bool isImg, id videoStr) {
                if (isImg) {
                    [cell setBigImgViewWithImage:[UIImage imageWithData:img]];
                    JJPhotoManeger *mg = [JJPhotoManeger maneger];
                    mg.delegate = self;
                    [mg showLocalPhotoViewer:@[cell.BigImgView] selecImageindex:0];
                }else{
//                    if (videoStr) {
//                        NSURL *url = videoStr;
//                        [self setPlayerWithUrl:url];
//                    }
                    
                }
            }];
        }else
        {
            JJPhotoManeger *mg = [JJPhotoManeger maneger];
            mg.delegate = self;
            [mg showLocalPhotoViewer:@[cell.BigImgView] selecImageindex:0];
        }
    }
}

-(void)showBigVideo{
    
    if (!_playBGView) {
        _playBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _playBGView.backgroundColor = kBlackColor;
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 35, kRealValue(40), kRealValue(40))];
        [backBtn setImage:[UIImage imageNamed:@"me_society_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(clickHiddeVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_playBGView addSubview:backBtn];
        [_playBGView addSubview:self.playBtn];
        [self.view addSubview:_playBGView];
    }
    
    
   
   activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
   [activityIndicatorView setCenter:_playBGView.center];
   [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
   [activityIndicatorView startAnimating];
   [_playBGView addSubview:activityIndicatorView];
}

-(void)clickHiddeVideo:(UIButton *)sender{
    [self removePlayerView];
}

-(void)tapImg:(UIGestureRecognizer *)sender{
//    [self.view endEditing:YES];
//    if (!_playBGView) {
//        [self setPlayerWithUrl:_url];
//    }
    [_player play];
    self.playBtn.hidden = YES;
}

-(void)setPlayerWithUrl:(AVURLAsset *)asset{
    
    [_player pause];
    
    _isPlaying = YES;
    
    if (!_player) {
        _playerItem               = [AVPlayerItem playerItemWithAsset:asset];
//                                     playerItemWithURL:url];
        _player                   = [AVPlayer playerWithPlayerItem:_playerItem];
        _playerLayer              = [AVPlayerLayer playerLayerWithPlayer:_player];

        _playerLayer.frame        = CGRectMake(0, 0, kScreenW,kScreenH);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self addObserverToPlayerItem:_playerItem];
        
        [_playBGView.layer addSublayer:_playerLayer];
    }
    
    
    
    //拖动
//    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGuestre:)];
//    [_playBGView addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    [_playBGView addGestureRecognizer:tap];
}

-(void)playbackFinished:(NSNotification *)notification{
    NSLog(ASLocalizedString(@"视频播放完成"));
    [_player play];
}

-(void)removePlayerView{
    if (_playBGView) {
        [_player pause];
        
        [_playBGView removeAllSubViews];
        [_playBGView.layer removeAllSublayers];
        [_playBGView removeFromSuperview];
        _playBGView = nil;
        
        _player = nil;
        _playerLayer = nil;
        [self removeObserverToPlayerItem:_playerItem];
        _playerItem = nil;
    }
}

- (UIImage*)getBigIamgeWithALAsset:(ALAsset*)set{
    //压缩
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                       scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    [_bigImgDataArray addObject:imageData];
    
    return [UIImage imageWithData:imageData];
}
- (void)getBigIamgeWithPhasset:(PHAsset*)set isSubmit:(bool)isSubmit callbackImg:(void(^)(id img,bool isImg,id videoStr))imageBlock
{
    
    if (set.mediaType == PHAssetMediaTypeVideo)
    {
        if (!isSubmit) [self showBigVideo];
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        
       PHImageManager *manager = [PHImageManager defaultManager];
       [manager requestAVAssetForVideo:set options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
           AVURLAsset *urlAsset = (AVURLAsset *)asset;
           
           NSURL *url = urlAsset.URL;
        
           if (!isSubmit) [self setPlayerWithUrl:urlAsset];
           NSLog(@"%@",url);
           imageBlock(nil,NO,url);
       }];
        
    }else
    {
        [[PHImageManager defaultManager]requestImageDataForAsset:set options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage* image = [UIImage imageWithData:imageData];
            image =[XWPublishBaseController fixOrientation:image];
            imageBlock(UIImageJPEGRepresentation(image, 0.5),YES,nil);
        }];
    }
}

//-(void)initJZPlayerWithUrl:(NSURL *)url{
//    [_jzPlayer resetContentViewWithContentURL:url];
//
//    [_jzPlayer play];
//}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监控缓冲区大小
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];//监控缓冲区大小
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
//    [self performSelectorInBackground:@selector(initPlayTime) withObject:nil];
}

#pragma mark - 观察视频播放各个监听触发
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {//播放状态
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusFailed:
                NSLog(ASLocalizedString(@"播放失败"));
//                [loadView setHidden:NO];
                activityIndicatorView.hidden = YES;
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(ASLocalizedString(@"正在播放...视频中长度为：%f"),CMTimeGetSeconds(_playerItem.duration));
//                [loadView setHidden:YES];
//                [_player play];
                
                activityIndicatorView.hidden = YES;
                break;
            default:
                NSLog(@"default:");
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){//缓冲
        NSArray *array = _playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        
        float durationTime = CMTimeGetSeconds([[_player currentItem] duration]);//总时间
        NSLog(ASLocalizedString(@"共缓冲：%.2f，总时长为:%f"),totalBuffer,durationTime);
//        [self.loadProgressView setProgress:totalBuffer/durationTime animated:YES];
        
//        if (self.playerIsBuffering && self.isPlaying) {
//            [_player play];
//            self.playerIsBuffering = NO;
//        }
        
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        if(_player.currentItem.playbackBufferEmpty){
            NSLog(ASLocalizedString(@"缓冲区为空"));
            self.playerIsBuffering = YES;
        }else{
            NSLog(ASLocalizedString(@"缓冲区不为空======"));
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        if (!_playerItem.playbackLikelyToKeepUp) {
            _playerIsBuffering = YES;
//            [_player play];
        }else {
            _playerIsBuffering = NO;
        }
        
        
    }else{
        NSLog(@"++++++++++");
    }
}


-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int hours = mins / 60.0f;
    int secs = fmodf(currentSeconds, 60.0);
    mins = fmodf(mins, 60.0f);
    
    NSString *hoursString = hours < 10 ? [NSString stringWithFormat:@"0%d", hours] : [NSString stringWithFormat:@"%d", hours];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    
    
    return [NSString stringWithFormat:@"%@:%@:%@", hoursString,minsString, secsString];
}

//处理图片旋转的问题
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 选择图片

- (void)addNewImg{
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[XWImagePickerSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (_arrSelected) {
        _imgPickerActionSheet.arrSelected = _arrSelected;
    }
    _imgPickerActionSheet.maxCount = _maxCount;
    [_imgPickerActionSheet showImgPickerActionSheetInView:_showActionSheetViewController isPhoto:YES];
}

-(void)addNewVideo{
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[XWImagePickerSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (_arrSelected) {
        _imgPickerActionSheet.arrSelected = _arrSelected;
    }
    //    HXPhotoManagerSelectedTypeVideo
    _imgPickerActionSheet.maxCount = _maxCount;
    
    
    
    [_imgPickerActionSheet showImgPickerActionSheetInView:_showActionSheetViewController isPhoto:NO];
    
}
#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
    
    if ([self collectionView:self.pickerCollectionView numberOfItemsInSection:0] <= _arrSelected.count) {
        
        [_imageArray removeObjectAtIndex:sender.tag];
        [_arrSelected removeObjectAtIndex:sender.tag];
        
        [self.pickerCollectionView reloadData];
        [self changeCollectionViewHeight];
        
        return;
    }
    
    [_imageArray removeObjectAtIndex:sender.tag];
    [_arrSelected removeObjectAtIndex:sender.tag];
    
    [_pickerCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_pickerCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    } completion:^(BOOL finished) {
        [self->_pickerCollectionView reloadData];
        [self changeCollectionViewHeight];
        
    }];
    
}

#pragma mark - 改变view，collectionView高度

- (void)changeCollectionViewHeight{
    
  int a =(int)(_arrSelected.count)/column+1;
       if (_arrSelected.count == self.maxCount + 1) {
           a =(int)(_arrSelected.count)/column;
       }
       if (_collectionFrameY) {
           _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width, a* (10 + itemWidth)+10);
           
       } else {
           _pickerCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, a* (10 + itemWidth)+10);
           
       }
    
    [self pickerViewFrameChanged];
    
}

/**
 *  相册完成选择得到图片
 */
-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray{
    //（ALAsset）类型 Array
    _arrSelected = [NSMutableArray arrayWithArray:ALAssetArray];
    //正方形缩略图 Array
    _imageArray = [NSMutableArray arrayWithArray:thumbnailImgArray] ;
    
    [self.pickerCollectionView reloadData];
    
    [self changeCollectionViewHeight];
}

- (void)getSelectVideoWith:(PHAsset *)asset thumbImage:(NSArray *)thumbimages
{
    _arrSelected = [@[asset] mutableCopy];
    _imageArray = [NSMutableArray arrayWithArray:thumbimages] ;
    [self.pickerCollectionView reloadData];
    
    [self changeCollectionViewHeight];
}

- (void)pickerViewFrameChanged{

}

- (void)updatePickerViewFrameY:(CGFloat)Y{
    
    _collectionFrameY = Y;
    
    if (_arrSelected.count == 0) {
        _pickerCollectionView.frame = CGRectMake(0, Y, [UIScreen mainScreen].bounds.size.width, 0);
    }else{
        
        int a =(int)(_arrSelected.count)/column+1;
        if (_arrSelected.count == self.maxCount) {
            a =(int)(_arrSelected.count)/column;
        }
        _pickerCollectionView.frame = CGRectMake(0, Y, [UIScreen mainScreen].bounds.size.width, a* (10 + itemWidth)+10);
    }
}

#pragma mark - 防止奔溃处理
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    NSLog(ASLocalizedString(@"最后一张观看的图片的index是:%zd"),selecedImageViewIndex);
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

//获得大图
- (NSArray*)getBigImageArrayWithALAssetArray:(NSArray*)ALAssetArray{
    _bigImgDataArray = [NSMutableArray array];
    NSMutableArray *bigImgArr = [NSMutableArray array];
    for (id set in ALAssetArray) {
        if ([set isKindOfClass:[ALAsset class]])
        {
            [bigImgArr addObject:[self getBigIamgeWithALAsset:set]];
        }
    }
    _bigImageArray = bigImgArr;
    return _bigImgDataArray;
}


-(void)PhassetgetBigImageArray:(NSArray *)PHssets isSubmit:(bool)isSubmit callBack:(void (^)(NSArray *, bool))PHassetBlock
{
    __block typeof(self)blockself =self;
    _bigImageArray =[NSMutableArray array];
    int i =0;
    for (id set in PHssets)
    {
        if ([set isKindOfClass:[PHAsset class]])
        {
            i++;
            [self getBigIamgeWithPhasset:set isSubmit:isSubmit callbackImg:^(id img, bool isImg, id videoStr) {
                
//                if (isImg) {
                    if (img) {
                        [blockself.bigImageArray addObject:img];
                    }else{
                        NSURL *url = videoStr;
                        if (url) {
                            [blockself.bigImageArray addObject:[NSData dataWithContentsOfURL:url]];
                        }
                    }
                
                NSLog(@"%@",blockself.bigImageArray);
                
                    
                    if (blockself.bigImageArray.count >= i)
                    {
                        PHassetBlock(blockself.bigImageArray,isImg);
                    }
//                }
            }];
        
        }
    }
}




-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"aio_record_play_nor"] forState:UIControlStateNormal];
        _playBtn.frame = CGRectMake(0, 0, kRealValue(50), kRealValue(50));
        _playBtn.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        [_playBtn addTarget:self action:@selector(tapImg:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}



#pragma mark - 获得选中图片各个尺寸
    
    
- (NSArray*)getALAssetArray{
    return _arrSelected;
}

- (NSArray*)getBigImageArray{
    if (_bigImageArray.count>0) {
        return _bigImageArray;
    }
    
    return [self getBigImageArrayWithALAssetArray:_arrSelected];
}

- (NSArray*)getSmallImageArray{
    return _imageArray;
}

- (CGRect)getPickerViewFrame{
    return self.pickerCollectionView.frame;
}
- (void)dealloc
{
    _imgPickerActionSheet.delegate =nil;
    _imgPickerActionSheet =nil;
    _showActionSheetViewController =nil;

    
    
    [self removeObserverToPlayerItem:_playerItem];
//    [_player removeTimeObserver:playbackObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  移除KVO观察
 */
-(void)removeObserverToPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
