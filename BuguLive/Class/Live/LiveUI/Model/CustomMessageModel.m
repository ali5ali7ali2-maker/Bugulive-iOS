//
//  CustomMessageModel.m
//  BuguLive
//
//  Created by xfg on 16/5/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CustomMessageModel.h"

#define redPackageDisappearTime 6 // 红包自动消失时间

@interface CustomMessageModel()
{
    NSTimer     *_redPackageTimer;
    NSInteger   _timeIndex;
}

@end

@implementation CustomMessageModel

- (BOOL)isEquals:(CustomMessageModel *)customMessageModel
{
    if ([self.sender.user_id isEqualToString:customMessageModel.sender.user_id] && [self.prop_id isEqualToString:customMessageModel.prop_id])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"anim_cfg" : @"AnimateConfigModel",
             };
}

- (void)startRedPackageTimer
{
    _redPackageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAdd) userInfo:nil repeats:YES];
}

- (void)timerAdd
{
    if (_timeIndex >= redPackageDisappearTime)
    {
        [_redPackageTimer invalidate];
        _redPackageTimer = nil;
        if (_delegate && [_delegate respondsToSelector:@selector(redPackageDisappear:)])
        {
            [_delegate redPackageDisappear:self];
        }
    }
    else
    {
        _timeIndex++;
    }
}

- (void)stopRedPackageTimer
{
    if (_redPackageTimer)
    {
        [_redPackageTimer invalidate];
        _redPackageTimer = nil;
    }
}

- (void)prepareForRender
{
    CustomMessageModel *customMessageModel = self;
    
    if(customMessageModel.text.length == 0 && customMessageModel.desc.length == 0 && customMessageModel.desc2.length == 0 && customMessageModel.msg.length)
    {
        return;
    }
    
    GlobalVariables *BuguLive = [GlobalVariables sharedInstance];
    NSInteger type = customMessageModel.type;
    
    // 整条消息
    NSString *messageStr = @"";
    // 设置消息的前半部分显示的内容，目前只有两种形式：1、直播消息 2、等级图标+用户名
    NSString *nameStr = @""; //消息的名字（直播消息或者是用户名字）
    
    if(type == MSG_FORBID_SEND_MSG || type == MSG_VIEWER_JOIN || type == MSG_LIVING_MESSAGE || type == MSG_ANCHOR_LEAVE || type == MSG_ANCHOR_BACK || type == MSG_STARGOODS_SUCCESS || type == MSG_RELEASE_SUCCESS)
    { //直播消息
        nameStr = ASLocalizedString(@"直播消息:");
    }
    else if(type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS || type == MSG_BUYGOODS_SUCCESS /*|| type == MSG_RELEASE_SUCCESS*/)
    { //竞拍消息 观众购物支付成功消息
        //4-15 苹果昵称和vip标签，vip标签把昵称挡住了。
        messageStr = [NSString stringWithFormat:@"             %@",messageStr];
        nameStr = [NSString stringWithFormat:@" %@:", customMessageModel.user.nick_name];
        if (customMessageModel.sender.is_vip.integerValue && customMessageModel.sender.is_guardian) {
            messageStr = [NSString stringWithFormat:@"                            %@",messageStr];
        }else if (customMessageModel.sender.is_vip.integerValue || customMessageModel.sender.is_guardian){
            messageStr = [NSString stringWithFormat:@"                 %@",messageStr];
        }else{
            
        }
    }
    else
    {
//        messageStr = [NSString stringWithFormat:@"             %@",messageStr];
        nameStr = [NSString stringWithFormat:@" %@:", customMessageModel.sender.nick_name];
        
        //一个space一个空格  这里要比model里的大3
        NSInteger space = 15;
        
        if (customMessageModel.sender.is_vip.integerValue == 1) {
//            messageStr = [NSString stringWithFormat:@"                          %@",messageStr];
            space = space + 12;
        }
        if (customMessageModel.sender.is_guardian == 1) {
            space = space + 12;
        }
        if (customMessageModel.sender.noble_vip_type.integerValue == 1) {
            space = space + 12;
        }
        
        if (customMessageModel.sender.is_vip.integerValue == 1) {
            space = space + 24;
        }
        
        for (int i = 0; i < space; i++) {
            messageStr = [NSString stringWithFormat:@"%@%@",@" ",messageStr];
        }
        
        NSLog(@"空格几个%@",messageStr);
        
//        messageStr = [NSString stringWithFormat:@"                          %@",messageStr];
        
//        if (customMessageModel.sender.is_vip.integerValue == 1) {
//            messageStr = [NSString stringWithFormat:@"                          %@",messageStr];
//            space = space + 4;
//        }
        
        
//        if (customMessageModel.sender.is_vip.integerValue && customMessageModel.sender.is_guardian) {
//            messageStr = [NSString stringWithFormat:@"                          %@",messageStr];
//        }else if (customMessageModel.sender.is_vip.integerValue || customMessageModel.sender.is_guardian){
//            messageStr = [NSString stringWithFormat:@"                  %@",messageStr];
//        }else{
//
//        }
    }
    
    // 拼接消息的前半部分
    messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@",nameStr]];
    
    // 设置消息的后半部分显示的内容
    NSString *contentStr = @"";
    if (type == MSG_TEXT)
    {
        contentStr = customMessageModel.text;
    }
    else if (type == MSG_POP_MSG)
    {
        contentStr = customMessageModel.desc;
    }
    else if (type == MSG_SEND_GIFT_SUCCESS || type == MSG_RED_PACKET)
    {
        if ([self isHostLive:customMessageModel.sender.imUserId])
        {
            contentStr = customMessageModel.desc2;
        }
        else
        {
            contentStr = customMessageModel.desc;
        }
    }
    else if (type == MSG_ANCHOR_LEAVE || type == MSG_ANCHOR_BACK)
    {
        contentStr = customMessageModel.text;
    }
    else if (type == MSG_LIGHT)
    {
        contentStr = ASLocalizedString(@"我点亮了");
    }
    else if (type == MSG_VIEWER_JOIN)
    {
        if (customMessageModel.sender.user_level >= BuguLive.appModel.jr_user_level)
        {
            contentStr = [NSString stringWithFormat:ASLocalizedString(@"金光一闪，%@ 加入了..."),customMessageModel.sender.nick_name];
        }else{
            contentStr = [NSString stringWithFormat:ASLocalizedString(@"%@ 来了"),customMessageModel.sender.nick_name];
        }
        
        if ([customMessageModel.sender.is_noble_mysterious isEqualToString:@"1"]) {
            contentStr = ASLocalizedString(@"神秘人加入了房间");
        }
    }
    else if (type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS )
    {
        if (customMessageModel.desc)
        {
            contentStr = customMessageModel.desc;
        }
    }
    else
    {
        if (customMessageModel.desc)
        {
            contentStr = customMessageModel.desc;
        }
        else if (customMessageModel.text)
        {
            contentStr = customMessageModel.text;
        }
        else
        {
            contentStr = @"";
        }
    }
    //如果开启贵族
    if ([[GlobalVariables sharedInstance].appModel.open_noble isEqualToString:@"1"]){
        if ([customMessageModel.sender.is_noble_mysterious isEqualToString:@"1"]) {
                NSLog(ASLocalizedString(@"是隐身了"));
            nameStr = @"";

            messageStr = [NSString stringWithFormat:@"               %@",contentStr];
        }else{
            messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", contentStr]];
        }
    }else{
        // 整条消息拼接，message不可能为空，如果为空就意味着判断出错了
           if (contentStr && ![contentStr isEqualToString:@""])
           {
               messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", contentStr]];
           }
    }
    
    
    
    
    //消息后面跟的图片
    NSString *typeImgStr = LIVE_MSG_TAG;
    if (customMessageModel.icon && [customMessageModel.icon isKindOfClass:[NSString class]])
    {
        if (customMessageModel.icon.length)
        {
            messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", typeImgStr]];
        }
    }
    
    NSString *typeImgStr2 = LIVE_MSG_TAG2;
    if (customMessageModel.imageName && [customMessageModel.imageName isKindOfClass:[NSString class]])
    {
        if (customMessageModel.imageName.length)
        {
            messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", typeImgStr2]];
        }
    }
    
    
    NSLog(@"%@============%@",messageStr,contentStr);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MLEmojiLabel *messageLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:16.0f];
        messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.isNeedAtAndPoundSign = YES;
        messageLabel.lineBreakMode = NSLineBreakByCharWrapping;

        //设置属性文字
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:messageStr];
        
        if (messageStr.length)
        {
            [messageLabel setText:attr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
             {
                 
                 [mutableAttributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0] , NSForegroundColorAttributeName : myTextColorSendGift} range:NSMakeRange(0, messageStr.length)];
                 [mutableAttributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0] , NSForegroundColorAttributeName : myTextColorUser} range:[messageStr rangeOfString:nameStr]]; //设置会员名称的字体颜色
                 return mutableAttributedString;
             }];
        }
        else
        {
            NSLog(ASLocalizedString(@"==========消息设置出错了"));
        }
        
        CGSize tmpSize = [messageLabel preferredSizeWithMaxWidth:COMMENT_TABLEVIEW_WIDTH];
        
        self.avimMsgShowSize = tmpSize;
//        CGSizeMake(tmpSize.width + 10, tmpSize.height + 20);
        
    });
}

- (NSInteger)msgType
{
    return _type;
}

- (BOOL)isHostLive:(NSString *)currentUserId
{
    return [[IMAPlatform sharedInstance].host.profile.identifier isEqualToString:currentUserId];
}

@end
