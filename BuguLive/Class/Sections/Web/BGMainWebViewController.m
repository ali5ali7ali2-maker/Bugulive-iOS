//
//  BGMainWebViewController.m
//  BuguLive
//
//  Created by xfg on 2017/6/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGMainWebViewController.h"
#import "PublishLivestViewController.h"
#import "AccountRechargeVC.h"
#import "CarAnimationPlayer.h"

#import "BogoSharePopView.h"

@interface BGMainWebViewController ()
{
    CGSize            _imgSize;                   // 裁剪图片时的图片大小
    CarAnimationPlayer *play;
}

@end

@implementation BGMainWebViewController

- (void)initFWUI
{
    // 先加载当前的方法，再调用父类方法，这两个不能反了
    [self addUserContentC];
    
    [super initFWUI];
    
#if kSupportH5Shopping
    
    // 加载礼物列表
    [[GiftListManager sharedInstance] reloadGiftList];
    
    // 互踢退出
    FWWeakify(self)
    [self xw_addNotificationForName:@"H5qiut" block:^(NSNotification * _Nonnull notification) {
        
        FWStrongify(self)
        [self.webView evaluateJavaScript:@"js_web_shop_logout()" completionHandler:nil];
        
    }];
    
#endif

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxloginback:) name:kWXLoginBack object:nil];
    
}

- (void)addUserContentC
{
    self.userContentC = [[WKUserContentController alloc] init];
    
    [self.userContentC addScriptMessageHandler:self name:@"getClipBoardText"];
    [self.userContentC addScriptMessageHandler:self name:@"sdk_share"];
    [self.userContentC addScriptMessageHandler:self name:@"CutPhoto"];
    [self.userContentC addScriptMessageHandler:self name:@"open_type"];
    [self.userContentC addScriptMessageHandler:self name:@"pay_sdk"];
    [self.userContentC addScriptMessageHandler:self name:@"login_success"];
    [self.userContentC addScriptMessageHandler:self name:@"logout"];
    [self.userContentC addScriptMessageHandler:self name:@"apns"];
    [self.userContentC addScriptMessageHandler:self name:@"position"];
    [self.userContentC addScriptMessageHandler:self name:@"position2"];
    [self.userContentC addScriptMessageHandler:self name:@"qr_code_scan"];
    [self.userContentC addScriptMessageHandler:self name:@"restart"];
    [self.userContentC addScriptMessageHandler:self name:@"login_sdk"];
    [self.userContentC addScriptMessageHandler:self name:@"is_exist_installed"];
    [self.userContentC addScriptMessageHandler:self name:@"create_live"];
    [self.userContentC addScriptMessageHandler:self name:@"join_live"];
    [self.userContentC addScriptMessageHandler:self name:@"updateCookies"];
    [self.userContentC addScriptMessageHandler:self name:@"start_app_page"];
    
    [self.userContentC addScriptMessageHandler:self name:@"page_finsh"];
    [self.userContentC addScriptMessageHandler:self name:@"close_page"];
    
    [self.userContentC addScriptMessageHandler:self name:@"getuserinfo"];
    [self.userContentC addScriptMessageHandler:self name:@"js_getuserinfo"];
    
    [self.userContentC addScriptMessageHandler:self name:@"shopping_join_live"];
    [self.userContentC addScriptMessageHandler:self name:@"js_shopping_join_live"];
    [self.userContentC addScriptMessageHandler:self name:@"shopping_start_live_app"];
    [self.userContentC addScriptMessageHandler:self name:@"js_shopping_start_live_app"];
    [self.userContentC addScriptMessageHandler:self name:@"shopping_create_live"];
    [self.userContentC addScriptMessageHandler:self name:@"js_shopping_comeback_live_app"];
    
    [self.userContentC addScriptMessageHandler:self name:@"js_get_live_type"];
}

- (void)removeScriptMessageHandler
{
    [super removeScriptMessageHandler];
    
    [self.userContentC removeAllUserScripts];
    [self.userContentC removeScriptMessageHandlerForName:@"getClipBoardText"];
    [self.userContentC removeScriptMessageHandlerForName:@"sdk_share"];
    [self.userContentC removeScriptMessageHandlerForName:@"CutPhoto"];
    [self.userContentC removeScriptMessageHandlerForName:@"open_type"];
    [self.userContentC removeScriptMessageHandlerForName:@"pay_sdk"];
    [self.userContentC removeScriptMessageHandlerForName:@"login_success"];
    [self.userContentC removeScriptMessageHandlerForName:@"logout"];
    [self.userContentC removeScriptMessageHandlerForName:@"apns"];
    [self.userContentC removeScriptMessageHandlerForName:@"position"];
    [self.userContentC removeScriptMessageHandlerForName:@"position2"];
    [self.userContentC removeScriptMessageHandlerForName:@"qr_code_scan"];
    [self.userContentC removeScriptMessageHandlerForName:@"restart"];
    [self.userContentC removeScriptMessageHandlerForName:@"login_sdk"];
    [self.userContentC removeScriptMessageHandlerForName:@"is_exist_installed"];
    [self.userContentC removeScriptMessageHandlerForName:@"create_live"];
    [self.userContentC removeScriptMessageHandlerForName:@"join_live"];
    [self.userContentC removeScriptMessageHandlerForName:@"updateCookies"];
    [self.userContentC removeScriptMessageHandlerForName:@"start_app_page"];
    
    [self.userContentC removeScriptMessageHandlerForName:@"page_finsh"];
    [self.userContentC removeScriptMessageHandlerForName:@"close_page"];
    
    [self.userContentC removeScriptMessageHandlerForName:@"getuserinfo"];
    [self.userContentC removeScriptMessageHandlerForName:@"js_getuserinfo"];
    
    [self.userContentC removeScriptMessageHandlerForName:@"shopping_join_live"];
    [self.userContentC removeScriptMessageHandlerForName:@"js_shopping_join_live"];
    [self.userContentC removeScriptMessageHandlerForName:@"shopping_start_live_app"];
    [self.userContentC removeScriptMessageHandlerForName:@"js_shopping_start_live_app"];
    [self.userContentC removeScriptMessageHandlerForName:@"shopping_create_live"];
    [self.userContentC removeScriptMessageHandlerForName:@"js_shopping_comeback_live_app"];
    
    [self.userContentC removeScriptMessageHandlerForName:@"js_get_live_type"];
}

#pragma mark- JavaScript调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(ASLocalizedString(@"=========js调起的方法：%@"),message.name);
    
    if ([message.name isEqualToString:@"CutPhoto"])
    {
        // 裁剪图片
        [self cutPhoto:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"sdk_share"])
    {
        // 分享
        [self sdkShare:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"getClipBoardText"])
    {
        // 从剪切板获取信息
        [self copyString];
    }
    else if([message.name isEqualToString:@"open_type"])
    {
        // 打开心的webview
        [self openNewWebView:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"pay_sdk"])
    {
        // SDK支付
        [self sdkPay:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"login_success"])
    {
        // 登录成功
        [self loginSuccess:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"logout"])
    {
        // 退出登录
        [self loginLogout:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"apns"])
    {
        // 上传友盟推送设备号
        [self umengApns:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"position"])
    {
        // 上传地理信息1
        [self uploadPosition1:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"position2"])
    {
        // 上传地理信息2
        [self uploadPosition2:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"qr_code_scan"])
    {
        // 扫码
        [self qrCodeScan:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"restart"])
    {
        // 重新加载webview
        [self reLoadCurrentWKWebView];
    }
    else if([message.name isEqualToString:@"login_sdk"])
    {
        // SDK登录
        [self loginWithType:[NSString stringWithFormat:@"%@",message.body]];
    }
    else if([message.name isEqualToString:@"is_exist_installed"])
    {
        // 判断是否安装了某个应用
        [self isExistInstalledWithScheme:[NSString stringWithFormat:@"%@",message.body]];
    }
    else if ([message.name isEqualToString:@"updateCookies"])
    {
        // 更新Cookies
        [self updateCookies:message.body];
    }
    else if ([message.name isEqualToString:@"create_live"])
    {
        // 开始直播
        [self startLiving:[BGUtils jsonStrToDict:message.body]];
    }
    else if([message.name isEqualToString:@"join_live"])
    {
        // 加入直播
        [self joinLiving:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"start_app_page"])
    {
        // 跳转指定的页面
        [self goToNextController:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"page_finsh"] || [message.name isEqualToString:@"close_page"])
    {
        // 回退
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([message.name isEqualToString:@"getuserinfo"])
    {
        // 获取用户信息并通过js上传
        [self getuserinfo:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"shopping_join_live"])
    {
        // 呼出直播小屏,请求成功后直接进入直播界面
        [self joinLiveController:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"js_shopping_join_live"])
    {
        // 观众加入直播间回调
        [self getuserinfoWithStaute:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"shopping_start_live_app"])
    {
        // 呼出直播应用，请求成功后进入app的主页
        [self enterMianAppView:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"js_shopping_start_live_app"])
    {
        // 启动应用回调
        [self getuserinfoWithStaute:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"shopping_create_live"])
    {
        // 呼出发起直播,请求接口成功后进入发起直播的界面
        [self startLiving:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"js_shopping_comeback_live_app"])
    {
        // h5退回直播间
        [self comeBackLive:[BGUtils jsonStrToDict:message.body]];
    }
    else if ([message.name isEqualToString:@"js_get_live_type"])
    {
        // live_state  h5过来获取oc直播状态
        [self getLiveType:[BGUtils jsonStrToDict:message.body]];
    }
}


#pragma mark  - ----------------------- 裁剪图片 -----------------------
- (void)cutPhoto:(NSDictionary *)dict
{
    ShareModel *model = [ShareModel mj_objectWithKeyValues:dict];
    [self showControllerWithModel:model];
}

- (void)showControllerWithModel:(ShareModel *)model
{
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [sheet addButtonWithTitle:ASLocalizedString(@"取消")];
    [sheet addButtonWithTitle:ASLocalizedString(@"相机")];
    [sheet addButtonWithTitle:ASLocalizedString(@"相册")];
    [sheet showInView:self.view];
    
    FWWeakify(self)
    [sheet bk_setDidDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
        
        FWStrongify(self)
        if (buttonIndex == 1)
        {
            [self openCamera];
        }
        else if(buttonIndex == 2)
        {
            [self openAlbum];
        }
        
    }];
    
    CGSize size;
    if ([model.w intValue]>300)
    {
        size = CGSizeMake([model.w intValue]*0.6, [model.h intValue]*0.6);
    }
    else if([model.w intValue]>170)
    {
        size = CGSizeMake([model.w intValue], [model.h intValue]);
    }
    else if([model.w intValue]>110)
    {
        size = CGSizeMake([model.w intValue]*1.5, [model.h intValue]*1.5);
    }
    else
    {
        size = CGSizeMake([model.w intValue]*2, [model.h intValue]*2);
    }
    _imgSize = size;
}

#pragma mark 调用相机
- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark 打开图片
- (void)openAlbum
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 通过UIImagePickerControllerOriginalImage获取图片
//    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
//    cutPictureView *cutPicture = [cutPictureView cutPicture];
//    cutPicture.control = self;
//    cutPicture.size = _imgSize;
//    cutPicture.image = image;
//    cutPicture.delegate = self;
//    [self.view addSubview:cutPicture];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 裁剪图片回调js
- (void)imageDidCut:(UIImage *)image
{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    NSString *base64Data=[data base64EncodedStringWithOptions:0];
    NSLog(@"%@",base64Data);
    NSString *jsStr=[NSString stringWithFormat:@"CutCallBack(\"data:image/jpg;base64,%@\")",base64Data];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}

#pragma mark  - ----------------------- 分享 -----------------------
- (void)sdkShare:(NSDictionary *)dict
{
    ShareModel *model = [ShareModel mj_objectWithKeyValues:dict];
    [self shareWithModel:model];
}

- (void)shareWithModel:(ShareModel *)model
{
    NSString *share_content;
    if (![model.share_content isEqualToString:@""])
    {
        share_content = model.share_content;
    }
    else
    {
        share_content = model.share_title;
    }
    
    FWWeakify(self)
    [[BGUMengShareManager sharedInstance] showShareViewInControllr:self shareModel:model succ:^(UMSocialShareResponse *response) {
        
        FWStrongify(self)
        
        NSString *jsStr=[NSString stringWithFormat:@"share_compleate(\"%d\")",[model.share_key intValue]];
        [self.webView evaluateJavaScript:jsStr completionHandler:nil];
        
    } failed:^(int errId, NSString *errMsg) {
        
    }];
}


#pragma mark  - ----------------------- 获取剪切板回调js -----------------------
- (void)copyString
{
    UIPasteboard *pastedBoard=[UIPasteboard  generalPasteboard];
    NSString *jsStr=[NSString stringWithFormat:@"get_clip_board(\"%@\")",pastedBoard.string];
    
    [self.webView evaluateJavaScript:jsStr completionHandler:^(NSString *result, NSError *error)
     {
         NSLog(@"Error %@",error);
         NSLog(@"Result %@",result);
     }];
}


#pragma mark  - ----------------------- 打开新的webview -----------------------
- (void)openNewWebView:(NSDictionary *)dict
{
    if ([[dict toString:@"open_url_type"] isEqualToString:@"1"] )
    {
        NSURL *url=[NSURL URLWithString:dict[@"url"]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:dict[@"url"] isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        [self.navigationController pushViewController:tmpController animated:YES];
    }
}


#pragma mark  - ----------------------- sdk支付 -----------------------
- (void)sdkPay:(NSDictionary *)dict
{
    NSString *pay_sdk_type = [dict toString:@"pay_sdk_type"];
    NSDictionary *config = [dict objectForKey:@"config"];
    
    if([pay_sdk_type isEqualToString:@"wxpay"])
    { //微信sdk支付
        Mwxpay *wwxpay = [Mwxpay mj_objectWithKeyValues:config];
        [self payWithWxpay:wwxpay];
    }
    else
    {
        [FanweMessage alert:ASLocalizedString(@"当前版本不支持该支付方式")];
    }
}

#pragma mark 微信支付
- (void)payWithWxpay:(Mwxpay *)mwxpay
{
    if (mwxpay.appid == nil || [mwxpay.appid isEqualToString:@""])
    {
        [self js_pay_sdk:6];
        [FanweMessage alert:ASLocalizedString(@"appid为空")];
        return;
    }
    else if (mwxpay.partnerid == nil || [mwxpay.partnerid isEqualToString:@""])
    {
        [self js_pay_sdk:6];
        [FanweMessage alert:ASLocalizedString(@"partnerid为空")];
        return;
    }
    else if (mwxpay.prepayid == nil || [mwxpay.prepayid isEqualToString:@""])
    {
        [self js_pay_sdk:6];
        [FanweMessage alert:ASLocalizedString(@"prepayid为空")];
        return;
    }
    else if (mwxpay.noncestr == nil || [mwxpay.noncestr isEqualToString:@""])
    {
        [self js_pay_sdk:6];
        [FanweMessage alert:ASLocalizedString(@"noncestr为空")];
        return;
    }
    else if (mwxpay.timestamp == nil || [mwxpay.timestamp isEqualToString:@""])
    {
        [self js_pay_sdk:6];
        [FanweMessage alert:ASLocalizedString(@"timestamp为空")];
        return;
    }
    else if (mwxpay.package == nil || [mwxpay.package isEqualToString:@""])
    {
        [self js_pay_sdk:6];
        [FanweMessage alert:ASLocalizedString(@"packagevalue为空")];
        return;
    }
    else if (mwxpay.sign == nil || [mwxpay.sign isEqualToString:@""])
    {
        [self js_pay_sdk:6];
        [FanweMessage alert:ASLocalizedString(@"sign为空")];
        return;
    }
    
    PayReq* req = [[PayReq alloc] init];
    req.openID = mwxpay.appid;
    req.partnerId = mwxpay.partnerid;
    req.prepayId = mwxpay.prepayid;
    req.nonceStr = mwxpay.noncestr;
    req.timeStamp = [mwxpay.timestamp intValue];
    req.package = mwxpay.package;
    req.sign = mwxpay.sign;

    [WXApi sendReq:req completion:nil];

}

#pragma mark 各个sdk支付方式支付结果后调用js
- (void)js_pay_sdk:(NSInteger)resultStatus
{
    NSString *jsStr=[NSString stringWithFormat:@"js_pay_sdk(\"%ld\")",(long)resultStatus];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}


#pragma mark  - ----------------------- 登录成功 -----------------------
- (void)loginSuccess:(NSDictionary *)dic
{
    // 判断上一次是否退出
    if ([[TIMManager sharedInstance] getLoginUser])
    {
        
    }
}

#pragma mark  - ----------------------- 退出登录 -----------------------
/**
 1. IM 退出
 2. user——default  数据清空
 3.清空 cookieJar

 @param dict NSDictionary
 */
- (void)loginLogout:(NSDictionary *)dict
{
    // 如果有悬浮要先执行退出悬浮
    if ([AppDelegate sharedAppDelegate].sus_window.rootViewController)
    {
        FWWeakify(self)
        [SuspenionWindow exitSuswindowBlock:^(BOOL finished) {
            
            FWStrongify(self)
            
            if(finished)
            {
                [self goLoginOut:dict];
            }
            else
            {
                [FanweMessage alert:ASLocalizedString(@"直播退出异常")];
            }
        }];
    }
    else
    {
        [self goLoginOut:dict];
    }
}

#pragma mark 退出登录
- (void)goLoginOut:(NSDictionary *)dict
{
    [[IMAPlatform sharedInstance] logout:^{
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"退出成功")];
    } fail:^(int code, NSString *msg) {
    }];
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in cookieArray)
    {
        [cookieJar deleteCookie:obj];
    }
    
    [BGIMLoginManager sharedInstance].isIMSDKOK = NO;
}


#pragma mark  - ----------------------- 推送 -----------------------
- (void)umengApns:(NSDictionary *)dict
{
    NSString *jsStr=[NSString stringWithFormat:@"js_apns(\"ios\",\"%@\")",self.BuguLive.deviceToken];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}


#pragma mark  - ----------------------- 上传定位信息 -----------------------
- (void)uploadPosition1:(NSDictionary *)dict
{
    NSString *jsStr=[NSString stringWithFormat:@"js_position(\"%f\",\"%f\")",self.BuguLive.latitude,self.BuguLive.longitude];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id str, NSError * _Nullable error) {
        NSLog(@"%@",str);
        NSLog(@"%@",error);
    }];
}

- (void)uploadPosition2:(NSDictionary *)dict
{
    NSString *jsStr=[NSString stringWithFormat:@"js_position2(\"%f\",\"%f\",\'%@\')",self.BuguLive.latitude,self.BuguLive.longitude,self.BuguLive.addressJsonStr];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id str, NSError * _Nullable error) {
        NSLog(@"%@",str);
        NSLog(@"%@",error);
    }];
}


#pragma mark  - ----------------------- 扫码 -----------------------
- (void)qrCodeScan:(NSDictionary *)dict
{

}

- (void)getQRCodeResult:(NSString *)qr_result
{
    NSString *jsStr=[NSString stringWithFormat:@"js_qr_code_scan(\"%@\")",qr_result];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}


#pragma mark  - ----------------------- 第三方sdk登录 -----------------------
- (void)loginWithType:(NSString *)login_sdk_type
{
    if ([login_sdk_type isEqualToString:@"qqlogin"])
    { // QQ sdk登录
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
            
            UMSocialUserInfoResponse *resp = result;
            
            if (resp)
            {
                
            }
        }];
    }
    else if([login_sdk_type isEqualToString:@"wxlogin"])
    { // 微信sdk登录
        // 构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        // 第三方向微信终端发送一个SendAuthReq消息结构

        [WXApi sendReq:req completion:nil];

    }
}

#pragma mark 微信登录获取code后oc调用js把code等传上去
- (void)wxloginback:(NSNotification *)text
{
    NSString *jsStr=[NSString stringWithFormat:@"js_login_sdk('%@')",text.object];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}


#pragma mark  - ----------------------- 判断是否安装了某个应用 -----------------------
- (void)isExistInstalledWithScheme:(NSString *)scheme
{
    if (scheme && ![scheme isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:scheme];
        BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:url];
        
        NSString *jsStr;
        if (canOpenURL)
        {
            jsStr =[NSString stringWithFormat:@"js_is_exist_installed(\"%@\",\"%d\")",scheme,1];
        }
        else
        {
            jsStr =[NSString stringWithFormat:@"js_is_exist_installed(\"%@\",\"%d\")",scheme,0];
        }
        [self.webView evaluateJavaScript:jsStr completionHandler:nil];
    }
    else
    {
        [FanweMessage alert:ASLocalizedString(@"URL Schemes 为空")];
    }
}


#pragma mark  - ----------------------- 获取PHPSESSID -----------------------
- (void)updateCookies:(NSString *)cookieStr
{
    if (cookieStr && ![cookieStr isEqualToString:@""])
    {
        NSArray *arr = [cookieStr componentsSeparatedByString:@"="];
        if (arr)
        {
            if ([arr count]>1 && [arr[0] isEqualToString:@"PHPSESSID"])
            {
                
                NSURL *url = [NSURL URLWithString:self.BuguLive.currentDoMianUrlStr];
                // 設定 cookie
                NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [url host], NSHTTPCookieDomain,
                                          [url path], NSHTTPCookiePath,
                                          arr[0], NSHTTPCookieName,
                                          arr[1], NSHTTPCookieValue,
                                          nil]];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];
            }
        }
    }
}


#pragma mark  - ----------------------- 获取用户信息并通过js上传 -----------------------
- (void)getuserinfo:(NSDictionary *)dict
{
    NSString *jsonStr = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"nick_name\":\"%@\",\"head_image\":\"%@\"}",[[[IMAPlatform sharedInstance] host] imUserId],[[[IMAPlatform sharedInstance] host] imUserName],[[[IMAPlatform sharedInstance] host] imUserIconUrl]];
    NSString *jsStr = [NSString stringWithFormat:@"js_getuserinfo(\'%@\')",jsonStr];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id str, NSError * _Nullable error) {
        NSLog(@"%@",str);
        NSLog(@"%@",error);
    }];
}


#pragma mark  - ----------------------- 跳转主播,等级，收益，账户的界面 -----------------------
- (void)goToNextController:(NSDictionary *)dict
{
    NSString *string = [dict toString:@"ios_page"];
    if ([string isEqualToString:@"detailViewController"])
    {
        AuctionItemdetailsViewController *AutionVc = [[AuctionItemdetailsViewController alloc]init];
        AutionVc.productId=[[dict objectForKey:@"data"]toString:@"id"];
        AutionVc.type = [[dict objectForKey:@"data"]toInt:@"is_anchor"]? 1:0;
        AutionVc.isFromWebView=YES;
        
        [self.navigationController pushViewController:AutionVc animated:YES];
    }
    else if ([string isEqualToString:@"chargerViewController"])
    {
        AccountRechargeVC * rechargeVC = [[AccountRechargeVC alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:rechargeVC animated:YES];
    }
}


#pragma mark  - ----------------------- 直播相关 -----------------------
#pragma mark 保存session_id
- (void)saveString:(NSString *)string withName:(NSString *)nameString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *array = [NSArray arrayWithObject:string];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:nameString];
    [array writeToFile:fullPathToFile atomically:NO];
}

#pragma mark 创建直播间(呼出发起直播)
- (void)startLiving:(NSDictionary *)dict
{
    if ([AppDelegate sharedAppDelegate].sus_window.rootViewController)
    {
        // 如果有悬浮要先执行退出悬浮
        __weak __typeof(self)weak_Self = self;
        [SuspenionWindow exitSuswindowBlock:^(BOOL finished) {
            if (finished)
            {
                [weak_Self goLive:dict];
            }
        }];
    }
    else
    {
        [self goLive:dict];
    }
}

- (void)goLive:(NSDictionary *)dict
{
    if (dict)
    {
        [self saveString:[dict toString:@"session_id"] withName:@"session_id"];
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"shop" forKey:@"ctl"];
        [mDict setObject:@"openvideo" forKey:@"act"];
        [mDict setObject:[dict toString:@"session_id"] forKey:@"session_id"];
        
        FWWeakify(self)
        
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
         {
             FWStrongify(self)
             
             if ([responseJson toInt:@"status"] == 1)//请求成功跳转到pushViewController
             {
                 if ([BGIMLoginManager sharedInstance].isIMSDKOK)
                 {
                     PublishLivestViewController *pushVC = [[PublishLivestViewController alloc]init];
                     [self.navigationController presentViewController:pushVC animated:YES completion:nil];
                     self.BuguLive.isHaveDelete = NO;
                 }
                 else
                 {
                     [BGIMLoginManager sharedInstance].loginParam.identifier = [[responseJson objectForKey:@"user"] toString:@"user_id"];
                     
                     [[BGIMLoginManager sharedInstance] getUserSig:^{
                         
                         [self jumpWithType:CurrentJumpPublishLive enterLivingDict:responseJson];
                         
                         [self hideMyHud];
                         
                     } failed:^(int errId, NSString *errMsg) {
                         
                         [self hideMyHud];
                         
                     }];
                 }
             }
         } FailureBlock:^(NSError *error) {
             
         }];
    }
}

- (void)jumpWithType:(CurrentJump)type enterLivingDict:(NSDictionary *)enterLivingDict
{
    if (type == CurrentJumpLiveRoom)
    {
        [self enterAppLiveWithDict:enterLivingDict];
    }
    else if (type == CurrentJumpMainUI)
    {
        self.BuguLive.isHaveDelete = YES;
        [[AppDelegate sharedAppDelegate] entertabBar];
    }
    else if (type == CurrentJumpPublishLive)
    {
        PublishLivestViewController *pushVC = [[PublishLivestViewController alloc]init];
        self.BuguLive.isHaveDelete = NO;
        [self.navigationController presentViewController:pushVC animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 获取完整url并进行UTF-8转码
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([strRequest hasPrefix:@"live://"]) {
        // 拦截点击链接
        [self handleCustomAction:strRequest];
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([strRequest hasPrefix:@"bogogame://"])
    {
        [self handleCustomAction:strRequest];
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
}


/**
 url参数转字典
 
 @param urlStr 输入的url
 @return 转换好的字典
 */
-(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr
{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:urlStr];
    
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    
    return parm;
    
//    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
//        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
//        if (array && array.count == 2) {
//            NSString *paramsStr = array[1];
//            if (paramsStr.length) {
//                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
//                for (NSString *param in paramArray) {
//                    if (param && param.length) {
//                        NSArray *parArr = [param componentsSeparatedByString:@"="];
//                        if (parArr.count == 2) {
//                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
//                        }
//                    }
//                }
//                return paramsDict;
//            }else{
//                return nil;
//            }
//        }else{
//            return nil;
//        }
//    }else{
//        return nil;
//    }
}



- (void)handleCustomAction:(NSString *)URL
{
    // 判断跳转
    NSString *link_id = @"";
    NSString *copyPrefix = @"live://live?action=copy_share_url&copy=";
    if ([URL hasPrefix:copyPrefix]) {
        NSDictionary *dicP = [self dictionaryWithUrlString:URL];
        if (URL.length <= copyPrefix.length)
        {
            return;
        }

        NSString *shareText = [URL substringFromIndex:copyPrefix.length];
        

        ShareModel *model = [ShareModel new];
        NSString *share_content;
        if (![model.share_content isEqualToString:@""])
        {
            share_content = shareText;
        }
        else
        {
            share_content = shareText;
        }
        model.share_title = @"";
        model.share_url = shareText;
        model.isNotifiService = YES;
//        model.roomIDStr = _roomIDStr;
//        model.imChatIDStr = [_liveItem liveIMChatRoomId];
        [[BGUMengShareManager sharedInstance] showShareViewInControllr:self shareModel:model succ:nil failed:nil];

//        BogoSharePopView *shareView = [BogoSharePopView new];
//        shareView.shareContent = shareText;
//        [shareView show];
        return;
        
        
        
        UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = shareText;
        
        [BGHUDHelper alert:ASLocalizedString(@"已复制到粘贴板")];

        NSArray *activityItems = [[NSArray alloc] initWithObjects:shareText, nil];
        
        UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            NSLog(@"%@",activityType);
            if (completed) {
                NSLog(ASLocalizedString(@"分享成功"));
            } else {
                NSLog(ASLocalizedString(@"分享失败"));
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        
        vc.completionWithItemsHandler = myBlock;
        
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }
    else if([URL hasPrefix:@"live://open_native"])
    {
        NSDictionary *dicP = [self dictionaryWithUrlString:URL];
        [self carAnimationPlayerWith:[dicP valueForKey:@"svgaurl"]];
    }
    else if([URL containsString:@"bogogame://exit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



- (void)carAnimationPlayerWith:(NSString *)url {
    play = [[CarAnimationPlayer alloc] initWithFrame:self.view.bounds];
    play.titleView.hidden = YES;
    UserModel *user = [[UserModel alloc] init];
    user.nick_name  = [IMAPlatform sharedInstance].host.imUserName;
    user.noble_car_url = url;
    [play setContent:user];
    [self.view addSubview:play];
    play.delegate = self;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [play removeFromSuperview];
    //    });
    
}

- (void)CarAnimationHiddenPlayerDelegate
{
    [play removeFromSuperview];
}

- (void)enterAppLiveWithDict:(NSDictionary *)dict
{
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
    item.chatRoomId = [dict toString:@"groupId"];
    item.avRoomId = [dict toInt:@"roomId"];
    item.title = [dict toString:@"roomId"];
    TCShowUser *showUser = [[TCShowUser alloc]init];
    showUser.uid = [dict toString:@"createrId"];
    showUser.avatar = [dict toString:@"loadingVideoImageUrl"];
    item.host = showUser;
    IMAHost *new_Host = [IMAPlatform sharedInstance].host ;
    if ([IMAPlatform sharedInstance].host)
    {
        // 加载小屏幕悬浮直播
        [SVProgressHUD showWithStatus:ASLocalizedString(@"正在加载...")];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SuspenionWindow initSmallSusWindow:YES WithItem:item withRoomHost:[IMAPlatform sharedInstance].host withVagueImgeUrlStr:[dict toString:@"loadingVideoImageUrl"] withModelRoomIdStr: item.title];
            [SVProgressHUD dismiss];
            self.BuguLive.isHaveDelete = NO;
            
        });
    }
    else
    {
        //NSLog(@"--------------- identifier = %@        userSig = %@       appidAt3rd = %@     ,    sdkAppId = %d",new_Host.loginParm.identifier,new_Host.loginParm.userSig,new_Host.loginParm.appidAt3rd,new_Host.loginParm.sdkAppId);
        [FanweMessage alert:ASLocalizedString(@"加载异常")];
    }
}

#pragma mark 加入直播间
- (void)joinLiving:(NSDictionary *)dict
{
    if (dict)
    {
        [self joinOtherLiving:dict];
    }
}

#pragma mark 加入直播间
- (void)joinOtherLiving:(NSDictionary *)dict
{
    [self.BuguLive.newestLivingMArray removeAllObjects];
    NSArray *list = [dict objectForKey:@"list"];
    if (list && [list isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *tmpdict in list)
        {
            LivingModel *livingModel = [LivingModel mj_objectWithKeyValues:tmpdict];
            [self.BuguLive.newestLivingMArray addObject:livingModel];
        }
    }
    
    IMAHost *host = [IMAPlatform sharedInstance].host;
    if (host)
    {
        TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
        // videoType 视频类型 1：回播
//        if ([dict toInt:@"videoType"] == 1)
//        {
//            liveRoom.liveType = FW_LIVE_TYPE_RELIVE;
//        }
//        else
//        {
//            liveRoom.liveType = FW_LIVE_TYPE_AUDIENCE;
//        }
        liveRoom.liveType = FW_LIVE_TYPE_AUDIENCE;
        liveRoom.avRoomId = [dict toInt:@"roomId"];
        liveRoom.title = [dict toString:@"roomId"];
        liveRoom.vagueImgUrl = [dict toString:@"loadingVideoImageUrl"];
        liveRoom.chatRoomId = [dict toString:@"groupId"];
        //2020-1-7 小直播变大
        [LiveCenterManager sharedInstance].itemModel=liveRoom;
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:liveRoom modelArr:nil  isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
        }];
    }
}

#pragma mark 呼出直播小屏
- (void)joinLiveController:(NSDictionary *)dict
{
    if (dict)
    {
        [self saveString:[dict toString:@"session_id"] withName:@"session_id"];
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"shop" forKey:@"ctl"];
        [mDict setObject:@"getvideo" forKey:@"act"];
        [mDict setObject:[dict toString:@"podcast_id"] forKey:@"podcast_id"];
        if ([dict toInt:@"is_small_screen"])
        {
            [mDict setObject:[dict toString:@"is_small_screen"] forKey:@"is_small_screen"];
        }
        [mDict setObject:[dict toString:@"session_id"] forKey:@"session_id"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
         {
             FWStrongify(self)
             if ([responseJson toInt:@"status"] == 1)//请求成功跳转到pushViewController
             {
                 if ([BGIMLoginManager sharedInstance].isIMSDKOK)
                 {
                     [self enterAppLiveWithDict:responseJson];
                 }
                 else
                 {
                     [BGIMLoginManager sharedInstance].loginParam.identifier = [[responseJson objectForKey:@"user"] toString:@"user_id"];
                     
                     [[BGIMLoginManager sharedInstance] getUserSig:^{
                         
                         [self jumpWithType:CurrentJumpPublishLive enterLivingDict:responseJson];
                         
                         [self hideMyHud];
                         
                     } failed:^(int errId, NSString *errMsg) {
                         
                         [self hideMyHud];
                         
                     }];
                 }
             }
         } FailureBlock:^(NSError *error) {
             
         }];
    }
}

#pragma mark 进入app主页(呼出直播应用)
- (void)enterMianAppView:(NSDictionary *)dict
{
    // 如果有悬浮要先执行退出悬浮
    if ([AppDelegate sharedAppDelegate].sus_window.rootViewController)
    {
        FWWeakify(self)
        [SuspenionWindow exitSuswindowBlock:^(BOOL finished) {
            
            FWStrongify(self)
            if (finished)
            {
                [self goLiveApp:dict];
            }
        }];
    }
    else
    {
        [self goLiveApp:dict];
    }
}

#pragma mark 进入app原生直播的主页
- (void)goLiveApp:(NSDictionary *)dict
{
    if (dict)
    {
        [self saveString:[dict toString:@"session_id"] withName:@"session_id"];
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"shop" forKey:@"ctl"];
        [mDict setObject:@"getapp" forKey:@"act"];
        [mDict setObject:[dict toString:@"session_id"] forKey:@"session_id"];
        
        FWWeakify(self)
        
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
         {
             FWStrongify(self)
             if ([responseJson toInt:@"status"] == 1)
             {
                 if ([BGIMLoginManager sharedInstance].isIMSDKOK)
                 {
                     self.BuguLive.isHaveDelete = YES;
                     [[AppDelegate sharedAppDelegate] entertabBar];
                 }
                 else
                 {
                     [BGIMLoginManager sharedInstance].loginParam.identifier = [[responseJson objectForKey:@"user"] toString:@"user_id"];
                     
                     [[BGIMLoginManager sharedInstance] getUserSig:^{
                         
                         [self jumpWithType:CurrentJumpPublishLive enterLivingDict:responseJson];
                         
                         [self hideMyHud];
                         
                     } failed:^(int errId, NSString *errMsg) {
                         
                         [self hideMyHud];
                         
                     }];
                 }
             }
         } FailureBlock:^(NSError *error)
         {
             
         }];
    }
}




#pragma mark 创建房间或者进入房间的回调
- (void)getuserinfoWithStaute:(NSDictionary *)dict
{
    NSString *jsStr=[NSString stringWithFormat:@"js_getuserinfo(\"%@\")",@""];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id str, NSError * _Nullable error) {
        NSLog(@"%@",str);
        NSLog(@"%@",error);
    }];
}

#pragma mark h5回到直播间
- (void)comeBackLive:(NSDictionary *)dict
{
    [self backLiveVC];
}

- (void)backLiveVC
{
    [BGUtils closeKeyboard];
    
    if (!self.isSmallScreen || kSupportH5Shopping)
    {
        UIViewController *viewCtl;
        for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
        {
            viewCtl = [self.navigationController.viewControllers objectAtIndex:(i)];
            if ([viewCtl isKindOfClass:[BGLiveServiceController class]])
            {
                [self.navigationController popToViewController:viewCtl animated:YES];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:NO nextViewController:nil delegateWindowRCNameStr:@"BGTabBarController" complete:^(BOOL finished) {
            
        }];
    }
}

#pragma mark  需要上传直播类型
- (void)getLiveType:(NSDictionary *)dict
{
    if (SUS_WINDOW.recordFWTLiveController)
    {
        if (self.webView)
        {
            // control.webView 这个不存在。。需要延迟执行
            NSString *jsStr = [NSString stringWithFormat:@"js_live_state('%@')",@"1"];
            [self.webView evaluateJavaScript:jsStr completionHandler:nil];
        }
    }
    else
    {
        if (self.webView)
        {
            // control.webView 这个不存在。。需要延迟执行
            NSString *jsStr = [NSString stringWithFormat:@"js_live_state('%@')",@"0"];
            [self.webView evaluateJavaScript:jsStr completionHandler:nil];
        }
    }
}

@end
