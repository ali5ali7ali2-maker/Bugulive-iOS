//
//  PublishLivestViewController.m
//  BuguLive
//
//  Created by xgh on 2017/8/25.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <objc/runtime.h>
#import "PublishVoiceViewController.h"
#import "PublishLiveShareView.h"
#import "PublishLiveViewModel.h"
#import "BGOtherPushViewController.h"
#import "PublishLivestViewController.h"
@interface PublishVoiceViewController ()<publishViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,OssUploadImageDelegate, UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) BGOssManager                *ossManager;
@property (nonatomic, strong)NSString                     *timeString;//时间戳的字符串
@property (nonatomic, strong)NSString                     *uploadFilePath;
@property (nonatomic, strong)NSString                     *imageString;
@property (nonatomic, strong)PublishLiveShareView         *shareView;
@property (nonatomic, strong)VideoClassifiedModel         *videoClassmodel;

@property(nonatomic, strong) UITextField *textField;

@end

@implementation PublishVoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden =YES;
    [GlobalVariables sharedInstance].isShop = NO;
}

- (void)initFWUI
{
    [super initFWUI];
    
    UIImageView *_preViewContainer = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _preViewContainer.image = [UIImage imageNamed:@"背景"];
    [self.view insertSubview:_preViewContainer atIndex:0];
    
    self.liveView = [[VoiceLiveView alloc]initWithFrame:self.view.bounds];
    self.liveView.delegate = self;
//    self.liveView.textView.delegate = self;
    [self.view addSubview:self.liveView];
    self.shareView = [[PublishLiveShareView alloc]initWithFrame:CGRectMake(0, self.view.height - 190 - kRealValue(40), self.view.width, 50)];
    self.shareView.hidden = YES;
    
    
    [self.liveView.liveBtn addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchUpInside];

    
    self.liveView.shareView = self.shareView;
    [self.liveView addSubview:self.shareView];
}

- (void)voiceClick {
    [self dismissViewControllerAnimated:NO completion:^{
        PublishLivestViewController *vc = [PublishLivestViewController new];
        [[AppDelegate sharedAppDelegate]presentViewController:vc animated:NO completion:nil];
    }];
}

- (void)initFWData
{
    [super initFWData];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"get_video_cover_image" forKey:@"act"];
    [dict setValue:@"1" forKey:@"is_voice"];
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSString *live_image = responseJson[@"data"][@"live_image"];
        if(live_image.length > 0)
        {
            _imageString = live_image;
            [self.liveView.selectedImageView sd_setImageWithURL:[NSURL URLWithString:live_image]];
            
        }
        
    } FailureBlock:^(NSError *error) {
    }];
    
}

- (void)initFWVariables
{
    [super initFWVariables];
    if (self.BuguLive.appModel.open_sts == 1)
    {
        _ossManager = [[BGOssManager alloc]initWithDelegate:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.liveView.videoCamera startCameraCapture];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.BuguLive.liveState.isInPubViewController = YES;
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:15]
    } forState:UIControlStateNormal];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [super viewWillDisappear:animated];
//    [self.liveView.videoCamera stopCameraCapture];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.BuguLive.liveState.isInPubViewController = NO;
//    [self.liveView.tiSDKManager destroy];
}

#pragma mark ----------- publishViewDelegate---------

- (void)closeThestartLiveViewDelegate
{
    [self.view endEditing:YES];

    if (self.navigationController.viewControllers.count >1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

- (void)selectedTheImageDelegate
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)selectedTheClassifyDelegate
{
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:ASLocalizedString(@"选择分类")message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:alterVC.title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:kAppMainColor range:NSMakeRange(0, alertControllerStr.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, alertControllerStr.length)];
    Ivar m_currentTitleColor = NULL;
    unsigned int count = 0;
    Ivar *members = class_copyIvarList([UIAlertController class], &count);
    for (int i = 0 ; i < count; i++)
    {
        Ivar var = members[i];
        const char *memberName = ivar_getName(var);
        if (strcmp(memberName, "attributedTitle") == 0)
        {
            m_currentTitleColor = var;
        }
        object_setIvar(alterVC, m_currentTitleColor, alertControllerStr);
    }
    
    for (int i = 0; i < self.BuguLive.appModel.video_classified.count; i++)
    {
        VideoClassifiedModel * model = self.BuguLive.appModel.video_classified[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:model.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.liveView.topView.classifyBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"直播分类：%@"),model.title] forState:UIControlStateNormal];
            self.videoClassmodel = model;
        }];
        
        Ivar m_currentColor = NULL;
        unsigned int num = 0;
        Ivar *actions = class_copyIvarList([UIAlertAction class], &num);
        for (int i = 0 ; i < num; i++)
        {
            Ivar var = actions[i];
            const char *memberName = ivar_getName(var);
            if (strcmp(memberName, "_titleTextColor") == 0)
            {
                m_currentColor = var;
            }
            object_setIvar(action, m_currentColor, kAppMainColor);
        }
        [alterVC addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消 ")style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alterVC addAction:action];
    
    [self presentViewController:alterVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (mediaType)
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image)
        {
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (self.BuguLive.appModel.open_sts == 1)
        {
            if ([_ossManager isSetRightParameter])
            {
                [self saveImage:image withName:@"1.png"];
                _timeString = [_ossManager getObjectKeyString];
                [_ossManager asyncPutImage:_timeString localFilePath:_uploadFilePath];
            }
        }
        else
        {
            NSData *data=UIImageJPEGRepresentation(image, 1.0);
            [self saveImage:[UIImage imageWithData:data] withName:@"currentImage6.png"];
            
            [self performSelector:@selector(uploadAvatar) withObject:nil afterDelay:0.8];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIView animateWithDuration:0.1 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenH - self.tabBarController.tabBar.frame.size.height , kScreenW, self.tabBarController.tabBar.frame.size.height);
    } completion:^(BOOL finished) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    _uploadFilePath = fullPath;
    NSLog(@"uploadFilePath : %@", _uploadFilePath);
}

#pragma mark 代理回调
- (void)uploadImageWithUrlStr:(NSString *)imageUrlStr withUploadStateCount:(int)stateCount
{
    if (stateCount == 0)
    {
        NSString *imgString= [NSString stringWithFormat:@"%@%@",_ossManager.oss_domain,_timeString];
        _imageString=[NSString stringWithFormat:@"./%@",_timeString];
        [self.liveView.selectedImageView sd_setImageWithURL:[NSURL URLWithString:imgString]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark 使用流文件上传头像
- (void)uploadAvatar
{
    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *photoName;
    photoName=[imageFile stringByAppendingPathComponent:@"currentImage6.png"];
    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",photoName]];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"avatar" forKey:@"ctl"];
    [parmDict setObject:@"uploadImage" forKey:@"act"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithDict:parmDict andFileUrl:fileUrl SuccessBlock:^(NSDictionary *responseJson){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            _imageString=[responseJson toString:@"path"];
            [self.liveView.selectedImageView sd_setImageWithURL:[NSURL URLWithString:[responseJson toString:@"server_full_path"]]];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
        
    }];
}
#pragma mark ---- 开始直播------
#pragma mark 点击事件

- (void)startThePublishLiveDelegate
{
    if (self.liveView.otherPushBtn.isSelected) {
        [self showHostLiveBtn];
    }else{
        [self avAuthorizationCamera];
    }
}

#pragma mark 相机权限
- (void)avAuthorizationCamera
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted)
                {
                    //第一次用户接受
                    [self avAuthorizationMic];
                }
                else
                {
                    //第一次用户接受
                    NSLog(ASLocalizedString(@"第一次用户拒绝"));
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            // 已经开启授权，可继续
            [self avAuthorizationMic];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            [self showAlertViewCAndMessageStr:ASLocalizedString(@"请前往设置'隐私-麦克风'开启应用权限")];
            break;
        default:
            break;
    }
}

#pragma mark 麦克风权限
- (void)avAuthorizationMic
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                
                if (granted)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //第一次用户接受
                        [self showHostLiveBtn];
                    });
                }
                else
                {
                    //第一次用户接受
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            // 已经开启授权，可继续
            NSLog(ASLocalizedString(@"已经开启授权，可继续"));
            [self showHostLiveBtn];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            [self showAlertViewCAndMessageStr:ASLocalizedString(@"请前往设置'隐私-麦克风'打开应用权限")];
            break;
        default:
            break;
    }
}

- (void)showAlertViewCAndMessageStr:(NSString *)messageStr
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ASLocalizedString(@"温馨提示")message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"确定")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(ASLocalizedString(@"点击确认"));
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)clickPasswordActionDelegate:(BOOL)password{
    
    if (password == NO) {
        
        self.liveView.topView.password = @"";
        return;
    }
    
    WeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"请设置房间密码")preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.liveView.topView.password;
        textField.placeholder = ASLocalizedString(@"请设置一个数字密码");
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField = textField;
    }];
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.liveView.topView.passwordBtn.selected = NO;
    }];
    [alertController addAction:actionCacel];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:ASLocalizedString(@"确定")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.textField.text.length < 1) {
            self.liveView.topView.passwordBtn.selected = NO;
        }else{
            weakSelf.liveView.topView.password = weakSelf.textField.text;
        }
        
        [_textField resignFirstResponder];
    }];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    self.liveView.topView.password = textField.text;
    NSLog(@"%@",textField.text);
    
}

-(void)clickShopActionDelegate:(BOOL)shop{
    
}

#pragma mark 开始直播
- (void)showHostLiveBtn
{
    // 网络判断
    if (![BGUtils isNetConnected])
    {
        return;
    }
    
    [BGUtils closeKeyboard];
    
//    if (!self.liveView.topView.pravicy)
//    {
//        if (!self.videoClassmodel)
//        {
//            if (self.BuguLive.appModel.is_classify == 1)
//            {
//                [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请选择分类")];
//                return;
//            }
//        }
//    }
    
    if (self.liveView.cid == nil)
    {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请选择分类")];
        return;
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    [mDict setObject:@"voice" forKey:@"ctl"];
    [mDict setObject:@"add_voice" forKey:@"act"];
    
//    if ([BGUtils isBlankString:_imageString])
//    {
//        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请选择封面")];
//        return;
//    }
        [mDict setObject:SafeStr([_imageString stringByUrlEncoding]) forKey:@"live_image"];
    // 房间标题
    if (self.liveView.textView.text.length > 0)
    {
        if ([self.liveView.textView.text isEqualToString:ASLocalizedString(@"#添加标题上热门更轻松")]) {
            self.liveView.textView.text = [GlobalVariables sharedInstance].userModel.nick_name;
        }
        [mDict setObject:self.liveView.textView.text forKey:@"title"];
    }else{
        [mDict setObject:[GlobalVariables sharedInstance].userModel.nick_name forKey:@"title"];
    }
    
//    if (self.liveView.otherPushBtn.isSelected) {
//
//        [mDict setObject:@"2" forKey:@"push_type"];
//    }else{
//        [mDict setObject:@"1" forKey:@"push_type"];
//    }
    
    
//    // 是否私密
//    if (self.liveView.topView.pravicy)
//    {
//        [mDict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"is_private"];
//    }
//    else
//    {
//        [mDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"is_private"];
//        [mDict setObject:self.shareView.shareStr forKey:@"share_type"];
//    }
    
   
    
    // 地理位置
//    if (self.liveView.topView.provinceSrting.length && self.liveView.topView.locationCityString.length && self.liveView.topView.isCanLocation)
//    {
//        [mDict setObject:self.liveView.topView.locationCityString forKey:@"city"];
//        [mDict setObject:self.liveView.topView.provinceSrting forKey:@"province"];
//    }
//    else
//    {
//        [mDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"location_switch"];
//    }
    
    if (self.liveView.cid)
    {
        [mDict setObject:self.liveView.cid forKey:@"video_classified"];
    }
    
    [mDict setObject:SafeStr(self.liveView.people_count) forKey:@"people_count"];

    if(self.liveView.topView.announcement_str.length > 0)
    {
        [mDict setObject:self.liveView.topView.announcement_str forKey:@"announcement"];
    }
    else
    {
        [mDict setObject:@" " forKey:@"announcement"];
    }
    
    //购物车
//    [mDict setObject:[GlobalVariables sharedInstance].isShop ? @"1" : @"0" forKey:@"is_shop"];
    
//    if (![BGUtils isBlankString:self.liveView.topView.password]) {
//
////        if (self.liveView.topView.password.length != 4) {
////            [FanweMessage alertHUD:ASLocalizedString(@"房间密码应为四位数！")];
////            return;
////        }else{
//            [mDict setObject:self.liveView.topView.password forKey:@"password"];
////        }
//    }
    
    __weak UIButton *btn = self.liveView.startButton;
    
    self.liveView.startButton.userInteractionEnabled = NO;
    
//    if (self.liveView.otherPushBtn.isSelected) {
//        [GlobalVariables sharedInstance].isOtherPush = YES;
//        [[LiveCenterAPIManager sharedInstance] liveCenterAPIOfShowHostLiveOfDic:mDict block:^(NSDictionary *responseJson, BOOL finished, NSError *error) {
//            btn.userInteractionEnabled = YES;
//            [btn setTitle:ASLocalizedString(@"开始直播")forState:UIControlStateNormal];
//            BGOtherPushViewController *otherVC = [[BGOtherPushViewController alloc]init];
//            NSString *room_id = [NSString stringWithFormat:@"%@",responseJson[@"room_id"]];
//            otherVC.room_id = room_id;
//            [self.navigationController pushViewController:otherVC animated:YES];
//        }];
//    }else{
//        [GlobalVariables sharedInstance].isOtherPush = NO;
    
    [PublishLiveViewModel beginVoiceLive:mDict vc:self block:^(AppBlockModel *blockModel) {
        btn.userInteractionEnabled = YES;
        [btn setTitle:ASLocalizedString(@"开始直播")forState:UIControlStateNormal];
    }];
    
//    }
    
    
}

#pragma mark - 点击美颜按钮
-(void)selectedTheBeautyDelegate{
    
    
    
}

#pragma mark API请求拿到直播类型，开始启动直播

- (void)closePublishViewCWith:(NSInteger )roomID
{
    __weak PublishVoiceViewController *weak_Self = self;
    UIViewController *rootVC = weak_Self.presentingViewController;
    while (rootVC.presentingViewController)
    {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:^{
        //开启直播
        LIVE_CENTER_MANAGER.stSuspensionWindow.hidden = NO;//为了加载
        
        IMAHost *host = [IMAPlatform sharedInstance].host;
        if (!host)
        {
            [[BGIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
            return;
        }
        //配置信息
        TCShowUser *user = [[TCShowUser alloc] init];
        user.avatar = [host imUserIconUrl];
        user.uid = [host imUserId];
        user.username = [host imUserName];
        
        TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
        liveRoom.host = user;
        liveRoom.avRoomId = (int)roomID;
        liveRoom.title = [NSString stringWithFormat:@"%d",liveRoom.avRoomId];
        liveRoom.vagueImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict toString:@"head_image"];
        
        [LIVE_CENTER_MANAGER showLiveOfTCShowLiveListItem:liveRoom andLiveWindowType:liveWindowTypeOfSusOfFullSize andLiveType:FW_LIVE_TYPE_HOST andLiveSDKType:FW_LIVESDK_TYPE_VOICE andCompleteBlock:^(BOOL finished) {
            
        }];
    }];
}

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
}

@end
