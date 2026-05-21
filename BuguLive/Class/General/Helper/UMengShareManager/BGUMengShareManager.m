//
//  BGUMengShareManager.m
//  BuguLive
//
//  Created by xfg on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGUMengShareManager.h"
#import "GlobalVariables.h"

@interface BGUMengShareManager()<UMSocialShareMenuViewDelegate>
{
    UIViewController    *_showController;
    NSMutableArray      *_umengSnsArray;
}

@end

@implementation BGUMengShareManager

BogoSingletonM(Instance);

- (id)init
{
    @synchronized (self)
    {
        self = [super init];
        if (self)
        {
            _umengSnsArray = [NSMutableArray array];
            
            if (self.BuguLive.appModel.wx_app_api == 1)
            {
                [_umengSnsArray addObject:@(UMSocialPlatformType_WechatSession)];
                [_umengSnsArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
            }
            if (self.BuguLive.appModel.qq_app_api == 1)
            {
                [_umengSnsArray addObject:@(UMSocialPlatformType_QQ)];
                [_umengSnsArray addObject:@(UMSocialPlatformType_Qzone)];
            }
            if (self.BuguLive.appModel.sina_app_api == 1)
            {
                [_umengSnsArray addObject:@(UMSocialPlatformType_Sina)];
            }
            
            
            if(self.BuguLive.appModel.fb_app_api == 1)
            {
                [_umengSnsArray addObject:@(UMSocialPlatformType_Facebook)];

            }
            
            if ([_umengSnsArray count])
            {
                [UMSocialUIManager setPreDefinePlatforms:_umengSnsArray];
                
                //设置分享面板的显示和隐藏的代理回调
                [UMSocialUIManager setShareMenuViewDelegate:self];
            }
        }
        return self;
    }
}

/**
 *  分享
 *  多图分享，items里面直接放图片
 *  分享链接
 *  NSString *textToShare = @"mq分享";
 *  UIImage *imageToShare = [UIImage imageNamed:@"imageName"];
 *  NSURL *urlToShare = [NSURL URLWithString:@"https:www.baidu.com"];
 *  NSArray *items = @[urlToShare,textToShare,imageToShare];
 */
- (void)yoShare:(NSArray *)items success:(CommonBlock)successBlock fail:(CommonBlock)failBlock{
    if (0 == items.count) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {
        //UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    }else if (@available(iOS 9.0, *)){
        //UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks];
    }else{
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail];
    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            if (successBlock) {
//                NSNumber *codeNum = [NSNumber numberWithInteger:YoErrorCodeSuccess];
//                NSDictionary *result = @{RCODEKEY:codeNum, RMSGKEY:SuccessMsg, METHODKEY:SysShareMethod};
//                successBlock(result);
            }
        }else{
//            if (failBlock) {
//                NSNumber *codeNum = [NSNumber numberWithInteger:YoErrorCodeShareFail];
//                NSDictionary *result = @{RCODEKEY:codeNum, RMSGKEY:ShareFailMsg, METHODKEY:SysShareMethod};
//                failBlock(result);
//            }
        }
    };
    //这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height, 0, 0);
        [vc presentViewController:activityVC animated:YES completion:nil];
    }else{
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}


#pragma mark 弹出分享面板
- (void)showShareViewInControllr:(UIViewController *)vc shareModel:(ShareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed
{
    
    [[BGHUDHelper sharedInstance] syncLoading];
    //改为自带分享
    
    NSString *textToShare = [NSString stringWithFormat:@"%@ %@",shareModel.share_title,shareModel.share_url];
    UIImage *imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareModel.share_imageUrl]]];
//    NSURL *urlToShare = [NSURL URLWithString:@"https:www.baidu.com"];
    //imageToShare
    if(imageToShare == nil)
    {
        imageToShare = [UIImage new];
    }
    NSArray *items = @[textToShare,imageToShare];
    [self yoShare:items success:^(id selfPtr) {
        
    } fail:^(id selfPtr) {
        
    }];
    
    [[BGHUDHelper sharedInstance] syncStopLoading];
    
//    //设置文本
//    messageObject.text = [NSString stringWithFormat:@"%@,%@",shareModel.share_title,shareModel.share_url];
//
    //创建图片内容对象
//    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = shareModel.share_imageUrl;
//    [shareObject setShareImage:shareModel.share_imageUrl];
//
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
    
    return;
    if ([_umengSnsArray count] == 0)
    {
        if (failed)
        {
            failed(FWCode_Normal_Error, ASLocalizedString(@"分享失败"));
        }
        return;
    }
    
    _showController = vc;
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    __weak typeof(self) ws = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2)
        {
            NSLog(ASLocalizedString(@"点击演示添加Icon后该做的操作"));
        }
        else
        {
            [ws shareTo:vc platformType:platformType shareModel:shareModel succ:succ failed:failed];
        }
    }];
}

#pragma mark 根据分享类型进行分享
- (void)shareTo:(UIViewController *)vc platformType:(UMSocialPlatformType)platformType shareModel:(ShareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed
{
    if ([_umengSnsArray count] == 0)
    {
        if (failed)
        {
            failed(FWCode_Normal_Error, ASLocalizedString(@"分享失败"));
        }
        return;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (UMSocialPlatformType_Sina == platformType)
    {
        //设置文本
        messageObject.text = [NSString stringWithFormat:@"%@,%@",shareModel.share_title,shareModel.share_url];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = shareModel.share_imageUrl;
        [shareObject setShareImage:shareModel.share_imageUrl];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
    else
    {
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareModel.share_title descr:shareModel.share_content thumImage:shareModel.share_imageUrl];
        //设置网页地址
        shareObject.webpageUrl = shareModel.share_url;
        
        shareObject.thumbImage = shareModel.share_imageUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
    
    __weak typeof(self) ws = self;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
        if (error) {
            
            [BGHUDHelper alert:error.description];
            
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            if (failed)
            {
                failed(FWCode_Normal_Error, ASLocalizedString(@"分享失败"));
            }
        }
        else
        {
            if ([data isKindOfClass:[UMSocialShareResponse class]])
            {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                if (shareModel.isNotifiService)
                {
                    [ws didFinishGetUMSocialDataInViewController:resp shareModel:shareModel];
                }
                
                if (succ)
                {
                    succ(resp);
                }
            }
            else
            {
                UMSocialLogInfo(@"response data is %@",data);
                if (failed)
                {
                    failed(FWCode_Normal_Error, ASLocalizedString(@"分享失败"));
                }
            }
        }
    }];
}

#pragma mark 分享成功后通知服务端
- (void)didFinishGetUMSocialDataInViewController:(UMSocialShareResponse *)response shareModel:(ShareModel *)shareModel
{
    NSInteger platformName = response.platformType;
    NSString *platformNameStr;
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"share" forKey:@"act"];
    
    if (platformName == UMSocialPlatformType_WechatSession)
    { //微信好友
        [mDict setObject:@"WEIXIN" forKey:@"type"];
        platformNameStr = ASLocalizedString(@"微信");
    }
    else if (platformName == UMSocialPlatformType_WechatTimeLine)
    { //朋友圈
        [mDict setObject:@"WEIXIN_CIRCLE" forKey:@"type"];
        platformNameStr = ASLocalizedString(@"微信朋友圈");
    }
    else if (platformName == UMSocialPlatformType_QQ)
    { //QQ
        [mDict setObject:@"QQ" forKey:@"type"];
        platformNameStr = @"QQ";
    }
    else if (platformName == UMSocialPlatformType_Qzone)
    { //QQ空间
        [mDict setObject:@"QZONE" forKey:@"type"];
        platformNameStr = ASLocalizedString(@"QQ空间");
    }
    else if (platformName == UMSocialPlatformType_Sina)
    { //新浪微博
        [mDict setObject:@"SINA" forKey:@"type"];
        platformNameStr = ASLocalizedString(@"新浪微博");
    }
    
    [mDict setObject:shareModel.roomIDStr forKey:@"room_id"];
    
    NSString *livingMessage = [NSString stringWithFormat:ASLocalizedString(@"%@ 分享了直播"), [[IMAPlatform sharedInstance].host imUserName]];
    
    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
    sendCustomMsgModel.msgType = MSG_LIVING_MESSAGE;
    sendCustomMsgModel.msg = livingMessage;
    sendCustomMsgModel.chatGroupID = shareModel.imChatIDStr;
    [[BGIMMsgHandler sharedInstance] sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             if ([responseJson toInt:@"share_award"] > 0)
             {
                 [FanweMessage alertHUD:[responseJson toString:@"share_award_info"]];
             }
         }
     } FailureBlock:^(NSError *error) {
         
     }];
}

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return _showController.view;
}

@end
