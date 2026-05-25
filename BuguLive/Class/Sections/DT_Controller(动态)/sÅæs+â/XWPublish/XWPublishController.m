//
//  XWPublishController.m
//  XWPublishDemo
//
//  Created by 邱学伟 on 16/4/15.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWPublishController.h"
#import "BzoneLogic.h"
//默认最大输入字数为  kMaxTextCount  300
#define kMaxTextCount 300
#import "CWVoiceView.h"
#import "UIView+CWChat.h"
#import "CWRecordModel.h"
#import "BGOssManager.h"

#import "HJAudioBubble.h"
#import <ZQPlayer/ZQPlayer.h>
#import <AVFoundation/AVFoundation.h>
    
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度

@interface XWPublishController ()<UITextViewDelegate,UIScrollViewDelegate,OssUploadImageDelegate>{
    
    //备注文本View高度
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
    
}



/**录制音频
 *  主视图-
 */
@property (weak, nonatomic) IBOutlet UIScrollView *mianScrollView;
@property(nonatomic, strong) CWVoiceView *voiceView;
@property(nonatomic, strong) BzoneLogic *bzoneLogic;

@property (nonatomic, strong) BGOssManager            *ossManager;              //oss 类

/** 音频气泡 */
@property (nonatomic, strong) HJAudioBubble *playAudio;
@property(nonatomic,strong) AVPlayer *player;

@end

@implementation XWPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     _ossManager = [[BGOssManager alloc]initWithDelegate:self];
    
    if (isIPhoneX()) {
        self.labelTopConstraint.constant = 20;
    }
    
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [_mianScrollView setDelegate:self];
    self.showInView = _mianScrollView;
    
    [self initPickerView];
    
    [self initViews];
    
    _bzoneLogic = [BzoneLogic new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRciverRecordingEnd:) name:KRecordingEnd object:nil];
    __block typeof(self)blockself =self;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KRecordingEnd object:nil];
}

- (void)onRciverRecordingEnd:(NSNotification *)notification{
    [_submitBtn setTitle:ASLocalizedString(@"删除音频")forState:UIControlStateNormal];
    self.playAudio.hidden = NO;
    //    [CWRecordModel shareInstance].path = nil;
    [_voiceView removeFromSuperview];
}

/**
 *  取消输入
 */
- (void)viewTapped{
    [self.view endEditing:YES];
}

/**
 *  初始化视图
 */
- (void)initViews{
    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //文本输入框
    _noteTextView = [[UITextView alloc]init];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    [_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:15.5]];
    //    _noteTextView.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:15.5];
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",kMaxTextCount];
    
    _explainLabel = [[UILabel alloc]init];
    //    _explainLabel.text = ASLocalizedString(@"添加图片不超过9张，文字备注不超过300字");
    _explainLabel.text = [NSString stringWithFormat:ASLocalizedString(@"添加图片不超过9张，文字备注不超过%d字"),kMaxTextCount];
    //发布按钮颜色
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    //发布按钮样式->可自定义!
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:ASLocalizedString(@"录制音频")forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor colorWithHexString:@"ff4181"]];
    _submitBtn.hidden = YES;
    
    //发布按钮样式->可自定义!
    _delAudio = [[UIButton alloc]init];
    [_delAudio setTitle:ASLocalizedString(@"删除音频")forState:UIControlStateNormal];
    [_delAudio setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_delAudio setBackgroundColor:[UIColor colorWithHexString:@"ff4181"]];
    
    //圆角
    //设置圆角
    [_submitBtn.layer setCornerRadius:4.0f];
    [_submitBtn.layer setMasksToBounds:YES];
    [_submitBtn.layer setShouldRasterize:YES];
    [_submitBtn.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
    //    [_delAudio addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_delAudio.layer setCornerRadius:4.0f];
    [_delAudio.layer setMasksToBounds:YES];
    [_delAudio.layer setShouldRasterize:YES];
    [_delAudio.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.playAudio = [[HJAudioBubble alloc] init];
    self.playAudio.hidden = YES;
    __weak __typeof(self)weakSelf = self;
    self.playAudio.bubbleClickBlock = ^(BOOL isAnimating) {
        if (isAnimating) {
            [weakSelf playWithUrl];
        }else{
            [weakSelf.player pause];
        }
        
    };
    
    [_mianScrollView addSubview:self.playAudio];
    
    
    
    [_mianScrollView addSubview:_noteTextBackgroudView];
    [_mianScrollView addSubview:_noteTextView];
    [_mianScrollView addSubview:_textNumberLabel];
    [_mianScrollView addSubview:_explainLabel];
    [_mianScrollView addSubview:_submitBtn];
    //    [_mianScrollView addSubview:_delAudio];
    
    
    [self updateViewsFrame];
}
/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, self.labelTopConstraint.constant, SCREENWIDTH, noteTextHeight);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, self.labelTopConstraint.constant, SCREENWIDTH - 30, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
    
    
    //photoPicker
    [self updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    
    //说明文字
    _explainLabel.frame = CGRectMake(0, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+10, SCREENWIDTH, 20);
    
    
    //发布按钮
    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    
    self.playAudio.frame = CGRectMake((kScreenW - 250) / 2 , _submitBtn.bottom + 20, 250, 50);
    
    
    _delAudio.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30 + 60, SCREENWIDTH -20, 40);
    _delAudio.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30 + 60, SCREENWIDTH -20, 40);
    
    allViewHeight = noteTextHeight + [self getPickerViewFrame].size.height + 30 + 100;
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,allViewHeight);
}

/**
 *  恢复原始界面布局
 */
-(void)resumeOriginalFrame{
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 0, SCREENWIDTH - 30, noteTextHeight);
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSLog(ASLocalizedString(@"当前输入框文字个数:%ld"),_noteTextView.text.length);
    //当前输入字数
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    
    [self textChanged];
    return YES;
}

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSLog(ASLocalizedString(@"当前输入框文字个数:%ld"),_noteTextView.text.length);
    //
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 100;
    }
    
    [self updateViewsFrame];
}

/**
 *  发布按钮点击事件
 */
- (void)submitBtnClicked{
    
    if([_submitBtn.titleLabel.text isEqualToString:ASLocalizedString(@"删除音频")])
    {
        [CWRecordModel shareInstance].path = nil;
        [_submitBtn setTitle:ASLocalizedString(@"录制音频")forState:UIControlStateNormal];
        self.playAudio.hidden = YES;
    }
    else
    {
        _voiceView = [[CWVoiceView alloc] initWithFrame:CGRectMake(0, self.view.cw_height - 252, self.view.cw_width, 252)];
        [self.view addSubview:_voiceView];
    }
    
    
    //检查输入
    //    if (![self checkInput]) {
    //        return;
    //    }
    //    //输入正确将数据上传服务器->
    //    [self submitToServer];
}

#pragma maek - 检查输入

- (BOOL)checkInput{
    //文本框没字
    //    if (_noteTextView.text.length == 0) {
    //        NSLog(ASLocalizedString(@"文本框没字"));
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"请输入文字")preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    //        [alertController addAction:actionCacel];
    //        [self presentViewController:alertController animated:YES completion:nil];
    //
    //        return NO;
    //    }
    
    //文本框字数超过300
    if (_noteTextView.text.length > kMaxTextCount) {
        NSLog(ASLocalizedString(@"文本框字数超过300"));
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"超出文字限制")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCacel];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (IBAction)postData:(id)sender {
    //检查输入
    if (![self checkInput]) {
        return;
    }
    //输入正确将数据上传服务器->
    [self submitToServer];
}

-(void)postData
{
    
}

#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    
    [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传")];

    if (self.arrSelected >0)
    {
        __block typeof(self)blockself =self;
        
        [self PhassetgetBigImageArray:self.arrSelected isSubmit:YES callBack:^(NSArray *ary, bool isImg) {
            if (self.arrSelected.count == ary.count)
            {
                NSMutableArray *smallImageDataArray = [ary copy];
                [blockself submitToserverWith:smallImageDataArray isImg:isImg];
            }
        }];
    }else
    {
        [self submitToserverWith:@[] isImg:NO];
    }
}



- (void)submitToserverWith:(NSArray * )imgary isImg:(BOOL)isImg
{
    
    if (imgary.count == 0 ) {
        //如果有音频
        NSString *audioPath = @"";
        if ([CWRecordModel shareInstance].path){
            audioPath = [CWRecordModel shareInstance].path;
        }
        __weak __typeof(self)weakSelf = self;
        [self.bzoneLogic addDynamicContent:_noteTextView.text WithImage:@[] andVideoPaht:@"" cover_url:@"" audio:audioPath audio_seconds:@"" Success:^(BOOL isFinished) {
            if (isFinished) {
                if (weakSelf.postFinishBlock) {
                    weakSelf.postFinishBlock(isFinished);
                }
                [[BGHUDHelper sharedInstance]syncStopLoading];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];

        return;
    }
    
    NSString *type = @"0";
    if (isImg) {
        type = @"0";
    }else{
        type = @"1";
    }
//    PHAsset *videoSet;
//    if (imgary.count >0)
//    {
//        id asset =imgary[0];
//
//
//        if ([asset isKindOfClass:[PHAsset class]])
//        {
//            type =@"1";
//            videoSet = asset;
//        }else
//        {
//            type =@"0";
//        }
//    }
//
//    id sssss = self.bigImageArray.firstObject;
    
    //上传照片
    
    [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在上传数据中...")];
    
    //上传音频，没有图片时
     __weak __typeof(self)weakSelf = self;
    if ([type isEqualToString:@"1"]) {
        //上传视频
        
        //视频类型的动态
        UIImage *coverimg =self.imageArray[0];
        NSData *imageData = UIImagePNGRepresentation(coverimg);
//        dispatch_group_t group = dispatch_group_create();
        __block NSString *coverUrl;
//        __block NSString *videoUrl;
//        __block NSString *audioUrl = @"";
//        __block typeof(self)blockself =self;
        
        NSArray *coverArr  = [NSArray arrayWithObjects:imageData, nil];
        
        [_ossManager showUploadOfOssServiceOfDataMarray:coverArr andSTDynamicSelectType:STDynamicSelectPhoto andComplete:^(BOOL finished, NSMutableArray<NSString *> *urlStrMArray) {
            NSLog(@"%@",urlStrMArray);
            
            coverUrl = urlStrMArray.firstObject;
            
            [[BGHUDHelper sharedInstance]syncStopLoading];
            
            NSString *audioPath = @"";
            //如果有音频
            if ([CWRecordModel shareInstance].path){
                audioPath = [CWRecordModel shareInstance].path;
            }
            
            [self.ossManager showUploadOfOssServiceOfDataMarray:self.bigImageArray
                                         andSTDynamicSelectType:STDynamicSelectVideo
                                                    andComplete:^(BOOL finished,
                                                                  NSMutableArray<NSString *> *urlStrMArray) {
                                                        
                                                        if(urlStrMArray.count>0)
                                                        {
                                                            
                                                            
                                                            
                                                            NSString *audioPath = @"";
                                                            
                                                            //如果有音频
                                                            if ([CWRecordModel shareInstance].path){
                                                                audioPath = [CWRecordModel shareInstance].path;
                                                            }
                                                            
                                                            [weakSelf.bzoneLogic addDynamicContent:_noteTextView.text WithImage:@[] andVideoPaht:urlStrMArray.firstObject cover_url:coverUrl audio:audioPath audio_seconds:@"" Success:^(BOOL isFinished) {
                                                                if (isFinished) {
                                                                    if (weakSelf.postFinishBlock) {
                                                                        weakSelf.postFinishBlock(isFinished);
                                                                    }
                                                                    [[BGHUDHelper sharedInstance]syncStopLoading];
                                                                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                                }}];
                                                                
                                                        }
                                                    }];
        }];
    }else{

            [_ossManager showUploadOfOssServiceOfDataMarray:self.bigImageArray andSTDynamicSelectType:STDynamicSelectPhoto andComplete:^(BOOL finished, NSMutableArray<NSString *> *urlStrMArray) {
                NSLog(@"%@",urlStrMArray);
                [[BGHUDHelper sharedInstance]syncStopLoading];
                
                NSString *audioPath = @"";
                //如果有音频
                if ([CWRecordModel shareInstance].path){
                    audioPath = [CWRecordModel shareInstance].path;
                }
                [weakSelf.bzoneLogic addDynamicContent:_noteTextView.text WithImage:urlStrMArray andVideoPaht:@"" cover_url:@"" audio:audioPath audio_seconds:@"" Success:^(BOOL isFinished) {
                    if (isFinished) {
                        if (weakSelf.postFinishBlock) {
                            weakSelf.postFinishBlock(isFinished);
                        }
                        [[BGHUDHelper sharedInstance]syncStopLoading];
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }];
    }
    
//    NSMutableArray *imageMuarr = [NSMutableArray array];
//
//    dispatch_group_t groupOne = dispatch_group_create();
//
//    //循环上传图片
//    for (int i = 0;i<self.bigImageArray.count;i++) {
//        dispatch_group_async(groupOne, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            dispatch_group_enter(groupOne);
//
//            if([type isEqualToString:@"0"])
//            {
//                NSString *timeString = [_ossManager getObjectKeyString];
//                NSString *uploadPath = [self saveImage:imgary[i] withName:[NSString stringWithFormat:@"%d",i]];
//
//                [_ossManager showUploadOfOssServiceOfDataMarray:self.bigImageArray andSTDynamicSelectType:STDynamicSelectPhoto andComplete:^(BOOL finished, NSMutableArray<NSString *> *urlStrMArray) {
//                    <#code#>
//                }];
////                [_ossManager asyncPutImage:timeString localFilePath:uploadPath];
//
//                //请求1
//                NSLog(@"Request_%d",i);
//            }
//
//        });
//    }
    
    
   
    
//    if ([GlobalVariables sharedInstance].appModel.open_sts == 1)
//    {
//        if ([_ossManager isSetRightParameter])
//        {
//            [self saveImage:imgary.firstObject withName:@"1.png"];
//            [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"正在上传")delay:1];
//            _timeString = [_ossManager getObjectKeyString];
//            [_ossManager asyncPutImage:_timeString localFilePath:_uploadFilePath];
//        }
//    }else
//    {
//        NSLog(@"image.size.height==%f,image.size.height==%f",image.size.height,image.size.height);
//        NSData *data=UIImageJPEGRepresentation(image, 1);
////        self.headImgView.image = [UIImage imageWithData:data];
//
//        [self saveImage:self.headImgView.image withName:@"image_head.jpg"];
//        [self performSelector:@selector(uploadAvatar) withObject:nil afterDelay:0.8];
//    }
    
//    self.bzoneLogic addDynamicContent:_noteTextView.text WithImage:<#(nonnull NSArray *)#> andVideoPaht:(nonnull NSString *) audio_seconds:<#(nonnull NSString *)#> Success:<#^(void)block#>
    
//    [[HUDHelper sharedInstance] syncLoading:ASLocalizedString(@"上传中")];
//    __weak __typeof(self)weakSelf = self;
//    NSString *type = @"0";
//    PHAsset *videoSet;
//    if (imgary.count >0)
//    {
//        id asset =imgary[0];
//        if ([asset isKindOfClass:[PHAsset class]])
//        {
//            type =@"1";
//            videoSet =asset;
//        }else
//        {
//            type =@"0";
//        }
//    }
//
//    NSMutableArray *imageMuarr = [NSMutableArray array];
//
//    dispatch_group_t groupOne = dispatch_group_create();
//    //循环上传图片
//    for (int i = 0;i<self.bigImageArray.count;i++) {
//        dispatch_group_async(groupOne, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            dispatch_group_enter(groupOne);
//
//            if([type isEqualToString:@"0"])
//            {
////                [QiNiuLogic QiNiuUplaodData:imgary[i] WithQiuNiuInfo:_qiniuInfo Block:^(id selfPtr) {
////                    NSString *imageItemUrl  = [NSString  stringWithFormat:@"%@/%@",((QiNiuInfoModel *)selfPtr).domain,((QiNiuInfoModel *)selfPtr).fileKey];
////                    [imageMuarr addObject:imageItemUrl];
////                    dispatch_group_leave(groupOne);
////                }];
//
//                //请求1
//                NSLog(@"Request_%d",i);
//            }
//
//        });
//    }
//
//    //七牛上传视频获取连接
//    dispatch_group_notify(groupOne, dispatch_get_main_queue(), ^{
//        if ([type isEqualToString:@"0"])
//        {
//
//            NSString *audio_seconds = StringFromInteger([CWRecordModel shareInstance].duration);
//
//            if ([CWRecordModel shareInstance].path) {
//                if (!_qiniuInfo)
//                {
//                    return;
//                }
//                __block NSString *audioUrl;
//
//                [QiNiuLogic QiNiuUplaodAudio:[CWRecordModel shareInstance].path WithQiuNiuInfo:_qiniuInfo Block:^(id selfPtr) {
//
//                    audioUrl  = [NSString  stringWithFormat:@"%@/%@",((QiNiuInfoModel *)selfPtr).domain,((QiNiuInfoModel *)selfPtr).fileKey];
//
//                    //图片内容的动态
//                    [_bzoneLogic addDynamicContent:_noteTextView.text WithImage:imageMuarr andVideoPaht:audioUrl audio_seconds:audio_seconds Success:^{
//                        [CWRecordModel shareInstance].path = nil;
//                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"发布成功!")preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                        }];
//                        [[HUDHelper sharedInstance] syncStopLoading];
//                        [alertController addAction:actionCacel];
//                        [weakSelf presentViewController:alertController animated:YES completion:nil];
//                    }];
//
//                }];
//            }else{
//                //图片内容的动态
//                [_bzoneLogic addDynamicContent:_noteTextView.text WithImage:imageMuarr andVideoPaht:[CWRecordModel shareInstance].path audio_seconds:audio_seconds Success:^{
//                    [CWRecordModel shareInstance].path = nil;
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"发布成功!")preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                    }];
//                    [[HUDHelper sharedInstance] syncStopLoading];
//                    [alertController addAction:actionCacel];
//                    [weakSelf presentViewController:alertController animated:YES completion:nil];
//                }];
//            }
//        }else
//        {
//            if (!_qiniuInfo)
//            {
//                return;
//            }
//            //视频类型的动态
//            UIImage *coverimg =self.imageArray[0];
//            dispatch_group_t group = dispatch_group_create();
//            __block NSString *coverUrl;
//            __block NSString *videoUrl;
//            __block NSString *audioUrl = @"";
//            __block typeof(self)blockself =self;
//            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                //请求1
//                dispatch_group_enter(group);
//                [QiNiuLogic QiNiuUplaodImage:coverimg WithQiuNiuInfo:blockself->_qiniuInfo Block:^(id selfPtr) {
//                    coverUrl = [NSString  stringWithFormat:@"%@/%@",((QiNiuInfoModel *)selfPtr).domain,((QiNiuInfoModel *)selfPtr).fileKey];
//                    dispatch_group_leave(group);
//                    NSLog(@"Request_1");
//                }];
//
//            });
//
//            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                dispatch_group_enter(group);
//
//                [QiNiuLogic QiNiuUploadPHAsset:videoSet withQiniuInfo:_qiniuInfo Block:^(id selfPtr) {
//                    videoUrl  = [NSString  stringWithFormat:@"%@/%@",((QiNiuInfoModel *)selfPtr).domain,((QiNiuInfoModel *)selfPtr).fileKey];
//                    dispatch_group_leave(group);
//                }];
//                //请求1
//                NSLog(@"Request_2");
//            });
//
//            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                dispatch_group_enter(group);
//
//                [QiNiuLogic QiNiuUploadPHAsset:videoSet withQiniuInfo:_qiniuInfo Block:^(id selfPtr) {
//                    videoUrl  = [NSString  stringWithFormat:@"%@/%@",((QiNiuInfoModel *)selfPtr).domain,((QiNiuInfoModel *)selfPtr).fileKey];
//                    dispatch_group_leave(group);
//                }];
//                //请求1
//                NSLog(@"Request_2");
//            });
//
//            if ([CWRecordModel shareInstance].path) {
//
//                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                    dispatch_group_enter(group);
//
//                    [QiNiuLogic QiNiuUplaodAudio:[CWRecordModel shareInstance].path WithQiuNiuInfo:_qiniuInfo Block:^(id selfPtr) {
//                        audioUrl  = [NSString  stringWithFormat:@"%@/%@",((QiNiuInfoModel *)selfPtr).domain,((QiNiuInfoModel *)selfPtr).fileKey];
//                        dispatch_group_leave(group);
//                    }];
//
//                    //请求1
//                    NSLog(@"Request_2");
//                });
//            }
//
//            //七牛上传视频获取连接
//            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//                NSDictionary *dic =@{@"cover_url":coverUrl,@"video_url":videoUrl};
//                [_bzoneLogic addDynamicContent:_noteTextView.text WithVideo:dic andaudio:audioUrl Success:^{
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"发布成功!")preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                    }];
//                    [[HUDHelper sharedInstance] syncStopLoading];
//                    [alertController addAction:actionCacel];
//                    [weakSelf presentViewController:alertController animated:YES completion:nil];
//                }];
//            });
//            //回调后清空imagedata数组
//        }
//    });
}

- (NSString *)saveImage:(NSData *)imageData withName:(NSString *)imageName
{
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    
    return fullPath;
    //    _uploadFilePath = fullPath;
    //    NSLog(@"uploadFilePath : %@", _uploadFilePath);
}


//- (NSString *)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
//{
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    [imageData writeToFile:fullPath atomically:NO];
//
//    return fullPath;
////    _uploadFilePath = fullPath;
////    NSLog(@"uploadFilePath : %@", _uploadFilePath);
//}


- (IBAction)pushContent:(id)sender {


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(ASLocalizedString(@"内存警告..."));
}

- (IBAction)cancelClick:(UIButton *)sender {
    NSLog(ASLocalizedString(@"取消"));
    @autoreleasepool {
        __weak typeof(self)weakself =self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *actionGiveUpPublish = [UIAlertAction actionWithTitle:ASLocalizedString(@"放弃上传")style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:actionCacel];
        [alertController addAction:actionGiveUpPublish];
        [self presentViewController:alertController animated:YES completion:nil];
        actionCacel =nil;
        actionGiveUpPublish =nil;
        alertController =nil;
    }
}



#pragma mark- 音乐播放相关
//播放音乐
-(void)playWithUrl
{
    NSURL *sourceMovieUrl = [NSURL fileURLWithPath:[CWRecordModel shareInstance].path];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];

    AVPlayerItem *item = [[AVPlayerItem alloc]initWithAsset:movieAsset];

    
    //替换当前音乐资源
    [self.player replaceCurrentItemWithPlayerItem:item];
    //开始播放
    
    __weak __typeof(self)weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([weakSelf.player.currentItem duration]);
        if (current == total) {
            [weakSelf.playAudio stopAnimating];
        }
    }];
    
    [self.player play];
    
}

-(AVPlayer *)player
{
    if (_player == nil) {
        //初始化_player
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@""]];
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
        
    }
    
    return _player;
}

#pragma mark - UIScrollViewDelegate
//用户向上偏移到顶端取消输入,增强用户体验
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(ASLocalizedString(@"偏移量 scrollView.contentOffset.y:%f"),scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 0) {
        [self.view endEditing:YES];
    }
    //NSLog(@"scrollViewDidScroll");
}

- (void)dealloc
{
    NSLog(@"dealloc");
    _mianScrollView.delegate =nil;
    while (_mianScrollView.subviews.count) {
        [_mianScrollView.subviews.lastObject removeFromSuperview];
    }
    
    [_mianScrollView removeFromSuperview];
    
    
    _mianScrollView =nil;
    _noteTextView.delegate =nil;
    [_noteTextView removeFromSuperview];
    _noteTextView =nil;
}

@end
