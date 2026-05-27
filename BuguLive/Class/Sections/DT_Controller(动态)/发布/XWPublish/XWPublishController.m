//
//  XWPublishController.m
//  XWPublishDemo
//
//  Created by é‚±å­¦ä¼Ÿ on 16/4/15.
//  Copyright Â© 2016å¹´ é‚±å­¦ä¼Ÿ. All rights reserved.
//

#import "XWPublishController.h"
#import "BzoneLogic.h"
//é»˜è®¤æœ€å¤§è¾“å…¥å­—æ•°ä¸º  kMaxTextCount  300
#define kMaxTextCount 300
#import "CWVoiceView.h"
#import "UIView+CWChat.h"
#import "CWRecordModel.h"
#import "BGOssManager.h"

#import "HJAudioBubble.h"
#import <ZQPlayer/ZQPlayer.h>
#import <AVFoundation/AVFoundation.h>
    
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//èŽ·å–è®¾å¤‡é«˜åº¦
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//èŽ·å–è®¾å¤‡å®½åº¦

@interface XWPublishController ()<UITextViewDelegate,UIScrollViewDelegate,OssUploadImageDelegate>{
    
    //å¤‡æ³¨æ–‡æœ¬Viewé«˜åº¦
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
    
}



/**å½•åˆ¶éŸ³é¢‘
 *  ä¸»è§†å›¾-
 */
@property (weak, nonatomic) IBOutlet UIScrollView *mianScrollView;
@property(nonatomic, strong) CWVoiceView *voiceView;
@property(nonatomic, strong) BzoneLogic *bzoneLogic;

@property (nonatomic, strong) BGOssManager            *ossManager;              //oss ç±»

/** éŸ³é¢‘æ°”æ³¡ */
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
    
    //æ”¶èµ·é”®ç›˜
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
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KRecordingEnd object:nil];
}

- (void)onRciverRecordingEnd:(NSNotification *)notification{
    [_submitBtn setTitle:ASLocalizedString(@"åˆ é™¤éŸ³é¢‘")forState:UIControlStateNormal];
    self.playAudio.hidden = NO;
    //    [CWRecordModel shareInstance].path = nil;
    [_voiceView removeFromSuperview];
}

/**
 *  å–æ¶ˆè¾“å…¥
 */
- (void)viewTapped{
    [self.view endEditing:YES];
}

/**
 *  åˆå§‹åŒ–è§†å›¾
 */
- (void)initViews{
    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //æ–‡æœ¬è¾“å…¥æ¡†
    _noteTextView = [[UITextView alloc]init];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //æ–‡å­—æ ·å¼
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
    //    _explainLabel.text = ASLocalizedString(@"æ·»åŠ å›¾ç‰‡ä¸è¶…è¿‡9å¼ ï¼Œæ–‡å­—å¤‡æ³¨ä¸è¶…è¿‡300å­—");
    _explainLabel.text = [NSString stringWithFormat:ASLocalizedString(@"æ·»åŠ å›¾ç‰‡ä¸è¶…è¿‡9å¼ ï¼Œæ–‡å­—å¤‡æ³¨ä¸è¶…è¿‡%då­—"),kMaxTextCount];
    //å‘å¸ƒæŒ‰é’®é¢œè‰²
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    //å‘å¸ƒæŒ‰é’®æ ·å¼->å¯è‡ªå®šä¹‰!
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:ASLocalizedString(@"å½•åˆ¶éŸ³é¢‘")forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor colorWithHexString:@"ff4181"]];
    _submitBtn.hidden = YES;
    
    //å‘å¸ƒæŒ‰é’®æ ·å¼->å¯è‡ªå®šä¹‰!
    _delAudio = [[UIButton alloc]init];
    [_delAudio setTitle:ASLocalizedString(@"åˆ é™¤éŸ³é¢‘")forState:UIControlStateNormal];
    [_delAudio setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_delAudio setBackgroundColor:[UIColor colorWithHexString:@"ff4181"]];
    
    //åœ†è§’
    //è®¾ç½®åœ†è§’
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
 *  ç•Œé¢å¸ƒå±€ frame
 */
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, self.labelTopConstraint.constant, SCREENWIDTH, noteTextHeight);
    
    //æ–‡æœ¬ç¼–è¾‘æ¡†
    _noteTextView.frame = CGRectMake(15, self.labelTopConstraint.constant, SCREENWIDTH - 30, noteTextHeight);
    
    //æ–‡å­—ä¸ªæ•°æç¤ºLabel
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
    
    
    //photoPicker
    [self updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    
    //è¯´æ˜Žæ–‡å­—
    _explainLabel.frame = CGRectMake(0, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+10, SCREENWIDTH, 20);
    
    
    //å‘å¸ƒæŒ‰é’®
    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    
    self.playAudio.frame = CGRectMake((kScreenW - 250) / 2 , _submitBtn.bottom + 20, 250, 50);
    
    
    _delAudio.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30 + 60, SCREENWIDTH -20, 40);
    _delAudio.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30 + 60, SCREENWIDTH -20, 40);
    
    allViewHeight = noteTextHeight + [self getPickerViewFrame].size.height + 30 + 100;
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,allViewHeight);
}

/**
 *  æ¢å¤åŽŸå§‹ç•Œé¢å¸ƒå±€
 */
-(void)resumeOriginalFrame{
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    //æ–‡æœ¬ç¼–è¾‘æ¡†
    _noteTextView.frame = CGRectMake(15, 0, SCREENWIDTH - 30, noteTextHeight);
    //æ–‡å­—ä¸ªæ•°æç¤ºLabel
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSLog(ASLocalizedString(@"å½“å‰è¾“å…¥æ¡†æ–‡å­—ä¸ªæ•°:%ld"),_noteTextView.text.length);
    //å½“å‰è¾“å…¥å­—æ•°
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    
    [self textChanged];
    return YES;
}

//æ–‡æœ¬æ¡†æ¯æ¬¡è¾“å…¥æ–‡å­—éƒ½ä¼šè°ƒç”¨  -> æ›´æ”¹æ–‡å­—ä¸ªæ•°æç¤ºæ¡†
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSLog(ASLocalizedString(@"å½“å‰è¾“å…¥æ¡†æ–‡å­—ä¸ªæ•°:%ld"),_noteTextView.text.length);
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
 *  æ–‡æœ¬é«˜åº¦è‡ªé€‚åº”
 */
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//èŽ·å–åŽŸå§‹UITextViewçš„frame
    
    //èŽ·å–å°ºå¯¸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//èŽ·å–è‡ªé€‚åº”æ–‡æœ¬å†…å®¹é«˜åº¦
    
    
    //å¦‚æžœæ–‡æœ¬æ¡†æ²¡å­—äº†æ¢å¤åˆå§‹å°ºå¯¸
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 100;
    }
    
    [self updateViewsFrame];
}

/**
 *  å‘å¸ƒæŒ‰é’®ç‚¹å‡»äº‹ä»¶
 */
- (void)submitBtnClicked{
    
    if([_submitBtn.titleLabel.text isEqualToString:ASLocalizedString(@"åˆ é™¤éŸ³é¢‘")])
    {
        [CWRecordModel shareInstance].path = nil;
        [_submitBtn setTitle:ASLocalizedString(@"å½•åˆ¶éŸ³é¢‘")forState:UIControlStateNormal];
        self.playAudio.hidden = YES;
    }
    else
    {
        _voiceView = [[CWVoiceView alloc] initWithFrame:CGRectMake(0, self.view.cw_height - 252, self.view.cw_width, 252)];
        [self.view addSubview:_voiceView];
    }
    
    
    //æ£€æŸ¥è¾“å…¥
    //    if (![self checkInput]) {
    //        return;
    //    }
    //    //è¾“å…¥æ­£ç¡®å°†æ•°æ®ä¸Šä¼ æœåŠ¡å™¨->
    //    [self submitToServer];
}

#pragma maek - æ£€æŸ¥è¾“å…¥

- (BOOL)checkInput{
    //æ–‡æœ¬æ¡†æ²¡å­—
    //    if (_noteTextView.text.length == 0) {
    //        NSLog(ASLocalizedString(@"æ–‡æœ¬æ¡†æ²¡å­—"));
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"è¯·è¾“å…¥æ–‡å­—")preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    //        [alertController addAction:actionCacel];
    //        [self presentViewController:alertController animated:YES completion:nil];
    //
    //        return NO;
    //    }
    
    //æ–‡æœ¬æ¡†å­—æ•°è¶…è¿‡300
    if (_noteTextView.text.length > kMaxTextCount) {
        NSLog(ASLocalizedString(@"æ–‡æœ¬æ¡†å­—æ•°è¶…è¿‡300"));
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"è¶…å‡ºæ–‡å­—é™åˆ¶")preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCacel];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (IBAction)postData:(id)sender {
    //æ£€æŸ¥è¾“å…¥
    if (![self checkInput]) {
        return;
    }
    //è¾“å…¥æ­£ç¡®å°†æ•°æ®ä¸Šä¼ æœåŠ¡å™¨->
    [self submitToServer];
}

-(void)postData
{
    
}

#pragma mark - ä¸Šä¼ æ•°æ®åˆ°æœåŠ¡å™¨å‰å°†å›¾ç‰‡è½¬dataï¼ˆä¸Šä¼ æœåŠ¡å™¨ç”¨formè¡¨å•ï¼šæœªå†™ï¼‰
- (void)submitToServer{
    
    [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"æ­£åœ¨ä¸Šä¼ ")];
    __weak __typeof(self)weakSelf = self;

    if (self.arrSelected.count > 0)
    {        
        [self PhassetgetBigImageArray:self.arrSelected isSubmit:YES callBack:^(NSArray *ary, bool isImg) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            if (strongSelf.arrSelected.count == ary.count)
            {
                NSMutableArray *smallImageDataArray = [ary mutableCopy];
                [strongSelf submitToserverWith:smallImageDataArray isImg:isImg];
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
        //å¦‚æžœæœ‰éŸ³é¢‘
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
    
    //ä¸Šä¼ ç…§ç‰‡
    
    [[BGHUDHelper sharedInstance]syncLoading:ASLocalizedString(@"æ­£åœ¨ä¸Šä¼ æ•°æ®ä¸­...")];
    
    //ä¸Šä¼ éŸ³é¢‘ï¼Œæ²¡æœ‰å›¾ç‰‡æ—¶
     __weak __typeof(self)weakSelf = self;
    if ([type isEqualToString:@"1"]) {
        //ä¸Šä¼ è§†é¢‘
        
        //è§†é¢‘ç±»åž‹çš„åŠ¨æ€
        UIImage *coverimg =self.imageArray[0];
        NSData *imageData = UIImagePNGRepresentation(coverimg);
//        dispatch_group_t group = dispatch_group_create();
        __block NSString *coverUrl;
//        __block NSString *videoUrl;
//        __block NSString *audioUrl = @"";
//        
        NSArray *coverArr  = [NSArray arrayWithObjects:imageData, nil];
        
        [_ossManager showUploadOfOssServiceOfDataMarray:coverArr andSTDynamicSelectType:STDynamicSelectPhoto andComplete:^(BOOL finished, NSMutableArray<NSString *> *urlStrMArray) {
            NSLog(@"%@",urlStrMArray);
            
            coverUrl = urlStrMArray.firstObject;
            
            [[BGHUDHelper sharedInstance]syncStopLoading];
            
            NSString *audioPath = @"";
            //å¦‚æžœæœ‰éŸ³é¢‘
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
                                                            
                                                            //å¦‚æžœæœ‰éŸ³é¢‘
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
                //å¦‚æžœæœ‰éŸ³é¢‘
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
//    //å¾ªçŽ¯ä¸Šä¼ å›¾ç‰‡
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
//                //è¯·æ±‚1
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
//            [[BGHUDHelper sharedInstance]tipMessage:ASLocalizedString(@"æ­£åœ¨ä¸Šä¼ ")delay:1];
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
    
//    [[HUDHelper sharedInstance] syncLoading:ASLocalizedString(@"ä¸Šä¼ ä¸­")];
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
//    //å¾ªçŽ¯ä¸Šä¼ å›¾ç‰‡
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
//                //è¯·æ±‚1
//                NSLog(@"Request_%d",i);
//            }
//
//        });
//    }
//
//    //ä¸ƒç‰›ä¸Šä¼ è§†é¢‘èŽ·å–è¿žæŽ¥
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
//                    //å›¾ç‰‡å†…å®¹çš„åŠ¨æ€
//                    [_bzoneLogic addDynamicContent:_noteTextView.text WithImage:imageMuarr andVideoPaht:audioUrl audio_seconds:audio_seconds Success:^{
//                        [CWRecordModel shareInstance].path = nil;
//                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"å‘å¸ƒæˆåŠŸ!")preferredStyle:UIAlertControllerStyleAlert];
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
//                //å›¾ç‰‡å†…å®¹çš„åŠ¨æ€
//                [_bzoneLogic addDynamicContent:_noteTextView.text WithImage:imageMuarr andVideoPaht:[CWRecordModel shareInstance].path audio_seconds:audio_seconds Success:^{
//                    [CWRecordModel shareInstance].path = nil;
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"å‘å¸ƒæˆåŠŸ!")preferredStyle:UIAlertControllerStyleAlert];
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
//            //è§†é¢‘ç±»åž‹çš„åŠ¨æ€
//            UIImage *coverimg =self.imageArray[0];
//            dispatch_group_t group = dispatch_group_create();
//            __block NSString *coverUrl;
//            __block NSString *videoUrl;
//            __block NSString *audioUrl = @"";
////            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                //è¯·æ±‚1
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
//                //è¯·æ±‚1
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
//                //è¯·æ±‚1
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
//                    //è¯·æ±‚1
//                    NSLog(@"Request_2");
//                });
//            }
//
//            //ä¸ƒç‰›ä¸Šä¼ è§†é¢‘èŽ·å–è¿žæŽ¥
//            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//                NSDictionary *dic =@{@"cover_url":coverUrl,@"video_url":videoUrl};
//                [_bzoneLogic addDynamicContent:_noteTextView.text WithVideo:dic andaudio:audioUrl Success:^{
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"å‘å¸ƒæˆåŠŸ!")preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                    }];
//                    [[HUDHelper sharedInstance] syncStopLoading];
//                    [alertController addAction:actionCacel];
//                    [weakSelf presentViewController:alertController animated:YES completion:nil];
//                }];
//            });
//            //å›žè°ƒåŽæ¸…ç©ºimagedataæ•°ç»„
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
    NSLog(ASLocalizedString(@"å†…å­˜è­¦å‘Š..."));
}

- (IBAction)cancelClick:(UIButton *)sender {
    NSLog(ASLocalizedString(@"å–æ¶ˆ"));
    @autoreleasepool {
        __weak typeof(self)weakself =self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"å–æ¶ˆ")style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *actionGiveUpPublish = [UIAlertAction actionWithTitle:ASLocalizedString(@"æ”¾å¼ƒä¸Šä¼ ")style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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



#pragma mark- éŸ³ä¹æ’­æ”¾ç›¸å…³
//æ’­æ”¾éŸ³ä¹
-(void)playWithUrl
{
    NSURL *sourceMovieUrl = [NSURL fileURLWithPath:[CWRecordModel shareInstance].path];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithAsset:movieAsset];

    
    //æ›¿æ¢å½“å‰éŸ³ä¹èµ„æº
    [self.player replaceCurrentItemWithPlayerItem:item];
    //å¼€å§‹æ’­æ”¾
    
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
        //åˆå§‹åŒ–_player
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
//ç”¨æˆ·å‘ä¸Šåç§»åˆ°é¡¶ç«¯å–æ¶ˆè¾“å…¥,å¢žå¼ºç”¨æˆ·ä½“éªŒ
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(ASLocalizedString(@"åç§»é‡ scrollView.contentOffset.y:%f"),scrollView.contentOffset.y);
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





