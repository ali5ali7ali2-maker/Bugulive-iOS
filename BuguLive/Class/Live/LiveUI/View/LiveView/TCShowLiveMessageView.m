//
//  TCShowLiveMessageView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveMessageView.h"

#define LIVE_MESSAGEVIEW_Margin 10

@implementation TCShowLiveMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kClearColor;
        
        _type = @"0";
        _myFont = [UIFont systemFontOfSize:16.0];
        
        //聊天背景框
        _msgBgImgView = [[UIImageView alloc]init];
        _msgBgImgView.layer.cornerRadius = 7;
        _msgBgImgView.layer.borderColor = kClearColor.CGColor;
//        kBlueColor.CGColor;
        _msgBgImgView.layer.masksToBounds = YES;
        _msgBgImgView.layer.borderWidth = 1.0f;
//        _msgBgImgView.hidden = YES;
        [self.contentView addSubview:_msgBgImgView];
        
        //聊天背景view
        _msgBack = [[UIImageView alloc] init];
//        _msgBack.image = [UIImage imageNamed:@"bogo_liveroom_livemessviewBGimg_Normal"];
        _msgBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _msgBack.layer.cornerRadius = 6;
        _msgBack.layer.masksToBounds = YES;
//
//        [UIColor colorWithWhite:0 alpha:0.2];
        
        
//        [UIColor colorWithWhite:0 alpha:0.2];
        
//
        
//        kBlueColor;
//
        _msgBack.layer.cornerRadius = 6;
        _msgBack.layer.masksToBounds = YES;
        [self.contentView addSubview:_msgBack];
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _msgLabel.numberOfLines = 0;
        _msgLabel.font = _myFont;
//        _msgLabel.delegate = self;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        _msgLabel.disableThreeCommon = YES; //禁用电话，邮箱，连接三者
//        _msgLabel.disableEmoji = NO; //禁用表情
        [_msgBack addSubview:_msgLabel];
        
        _rankImgView = [[UIImageView alloc]init];
//        [_msgBack addSubview:_rankImgView];
        _rankImgView.hidden = YES;
        
        //vipView
        _vipView = [[UIImageView alloc]init];
        [_vipView setImage:[UIImage imageNamed:@"vip_icon_s"]];
//        [_msgBack addSubview:_vipView];
        _vipView.hidden = YES;
        
        _stealthView = [UIImageView new];
//        [_msgBack addSubview:_stealthView];
        _stealthView.hidden = YES;
        
        //守护View
        _guardianView = [[UIImageView alloc]init];
//        [_guardianView setImage:[UIImage imageNamed:@"lr_img_corner_ward"]];
//        [_msgBack addSubview:_guardianView];
        _guardianView.hidden = YES;
        
        //贵族View
        _nobleVipView = [[UIImageView alloc]init];
//        _nobleVipView.backgroundColor = k;
//        [_nobleVipView setImage:[UIImage imageNamed:@"lr_img_corner_ward"]];
        _nobleVipView.contentMode = UIViewContentModeScaleAspectFit;
//        [_msgBack addSubview:_nobleVipView];
        _nobleVipView.hidden = YES;
    }
    return self;
}

- (CAGradientLayer*)gradientLayerWithColor1:(UIColor*)color1 AtColor2:(UIColor*)color2 view:(UIView *)view
{
    CAGradientLayer* layer = [CAGradientLayer new];
    layer.colors = @[ (__bridge id)color1.CGColor, (__bridge id)color2.CGColor];
    layer.startPoint = CGPointMake(0.5f, -0.5);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = view.bounds;
    return layer;
}

- (BOOL)isHostLive:(NSString *)currentUserId
{
    return [[IMAPlatform sharedInstance].host.profile.identifier isEqualToString:currentUserId];
}

#pragma mark 设置聊天列表信息
- (void)config:(CustomMessageModel *)item block:(FWVoidBlock)block
{
    CustomMessageModel *customMessageModel = (CustomMessageModel *)item;
    
    NSString *iconImgWidthStr = @"     ";
    
    if (customMessageModel.sender.is_guardian == 1) {
          //如果是守护,守护view显示
          _guardianView.hidden = NO;
//        iconImgWidthStr = [NSString stringWithFormat:@"%@%@"];
    }else{
        _guardianView.hidden = YES;
    }
//
    if (customMessageModel.sender.noble_vip_type.intValue == 1) {
        _nobleVipView.hidden = NO;
        [_nobleVipView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.sender.noble_icon]];
//        CAGradientLayer *layer = [self gradientLayerWithColor1:[UIColor colorWithHexString:@"#BC7B02"] AtColor2:[UIColor colorWithHexString:@"#E9BD15"] view:_msgBack];

//        [_msgBack.layer addSublayer:layer];
    }else{
        _nobleVipView.hidden = YES;
//        CAGradientLayer* layer = nil;
//        [_msgBack.layer addSublayer:layer];
    }
    
    if (customMessageModel.sender.is_vip.integerValue == 1) {
          //如果是Vip,vipView显示
          _vipView.hidden = NO;
    }else{
          _vipView.hidden = YES;
    }

    
    FWWeakify(self)
    if(customMessageModel.text.length == 0 && customMessageModel.desc.length == 0 && customMessageModel.desc2.length == 0 && customMessageModel.msg.length)
    {
        return;
    }
    
    _customMessageModel = customMessageModel;
    
    GlobalVariables *BuguLive = [GlobalVariables sharedInstance];
    
    if ([customMessageModel.sender.user_id isEqualToString:[[IMAPlatform sharedInstance].host imUserId]] && [[IMAPlatform sharedInstance].host getUserRank] < customMessageModel.sender.user_level)
    {
        [[IMAPlatform sharedInstance].host setUserRank:[NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level]];
    }
    
    NSInteger type = customMessageModel.type;
    
    __block UIColor *messageLabelColor;
    
    // 设置颜色
    if (customMessageModel.fonts_color.length>0)
    {
        NSMutableString *statusbar_color = [NSMutableString stringWithString:customMessageModel.fonts_color];
        if ([statusbar_color hasPrefix:@"#"])
        {
            [statusbar_color deleteCharactersInRange:NSMakeRange(0,1)];
        }
        unsigned int hexValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:statusbar_color];
        [scanner setScanLocation:0]; // depends on your exact string format you may have to use location 1
        [scanner scanHexInt:&hexValue];
        
        messageLabelColor = RGBOF(hexValue);;
    }
    else
    {
        if (type == MSG_TEXT || type == MSG_POP_MSG)
        {
            messageLabelColor = myTextColorCommonMessage;
        }
        else if(type == MSG_SEND_GIFT_SUCCESS)
        {
            messageLabelColor = myTextColorSendGift;
        }
        else if(type == MSG_LIGHT)
        {
            messageLabelColor = kTextColorSendLight;
        }
        else if (type == MSG_RED_PACKET)
        {
            messageLabelColor = myTextColorRedPackage;
        }
        else if (type == MSG_VIEWER_JOIN)
        {
            messageLabelColor = myTextColorLivingMessage;
            
        }
        else if (type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS || type == MSG_RELEASE_SUCCESS || type == MSG_STARGOODS_SUCCESS)
        {
            messageLabelColor = kAppSecondaryColor;
        }
        else
        {
            messageLabelColor = myTextColorLivingMessage;
        }
    }
    
    // 整条消息
    NSString *messageStr = @"";
    
    // 设置消息的前半部分显示的内容，当前只有两种形式：1、直播消息 2、等级图标+vip+守护+用户名
    NSString *nameStr = @""; //消息的名���（直播消息或者是用户名字）
    NSString *nickName = customMessageModel.sender.nick_name;
    if ([BGUtils isBlankString:nickName])
    {
        nickName = customMessageModel.user.nick_name;
        if ([BGUtils isBlankString:nickName])
        {
            nickName = @" ";
        }
    }
    
    if(type == MSG_FORBID_SEND_MSG || type == MSG_VIEWER_JOIN || type == MSG_LIVING_MESSAGE || type == MSG_ANCHOR_LEAVE || type == MSG_ANCHOR_BACK || type == MSG_STARGOODS_SUCCESS || type == MSG_RELEASE_SUCCESS)
    {
        //直播消息
        _rankImgView.hidden = YES;
        nameStr = ASLocalizedString(@"直播消息:");
        _vipView.hidden = YES;
        _stealthView.hidden = YES;
        _guardianView.hidden = YES;
        _nobleVipView.hidden = YES;
    }
    else if( type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS || type == MSG_BUYGOODS_SUCCESS || type == MSG_RELEASE_SUCCESS)
    {
           //4-15 苹果昵称和vip标签，vip标签把昵称挡住了。
          //竞拍消息 观众购物支付成功消息
          messageStr = [NSString stringWithFormat:@"%@",messageStr];
          _rankImgView.hidden = NO;

         //5-7 礼物的等级
          if (customMessageModel.sender.user_level)
          {
              [_rankImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%ld",(long)customMessageModel.sender.user_level]]];
          }
          else
          {
              [_rankImgView setImage:[UIImage imageNamed:@"rank_1"]];
          }
        
        if (customMessageModel.sender.is_guardian == 1) {
              //如果是守护,守护view显示
              _guardianView.hidden = NO;
          }else{
              _guardianView.hidden = YES;
          }
        
        [_guardianView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.sender.guardian_img]];
        
        if (customMessageModel.sender.is_vip.integerValue == 1) {
              //如果是Vip,vipView显示
              _vipView.hidden = NO;
          }else{
              _vipView.hidden = YES;
          }
        
//        if (customMessageModel.sender.noble_vip_type.intValue == 1) {
//            _nobleVipView.hidden = NO;
//            [_nobleVipView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.sender.noble_icon]];
//        }else{
//            _nobleVipView.hidden = YES;
//        }
        
        
          if (!_guardianView.hidden && !_vipView.hidden) {
              messageStr = [NSString stringWithFormat:@"%@",messageStr];
          }else if (!_guardianView.hidden || !_vipView.hidden){
              messageStr = [NSString stringWithFormat:@"%@",messageStr];
          }
        
          nameStr = [NSString stringWithFormat:@"%@:", nickName];
      }
    else
    {
        
//        messageStr = [NSString stringWithFormat:@"           %@",messageStr];
        
        NSInteger space = 0;
        
        if (customMessageModel.sender.user_level)
        {
            [_rankImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%ld",(long)customMessageModel.sender.user_level]]];
        }
        else
        {
            [_rankImgView setImage:[UIImage imageNamed:@"rank_1"]];
        }
        _rankImgView.hidden = NO;
    
        if (customMessageModel.sender.is_vip.integerValue == 1) {
            //如果是Vip,vipView显示
            _vipView.hidden = NO;
        }else{
            _vipView.hidden = YES;
        }
        
        nameStr = [NSString stringWithFormat:@"%@:", nickName];

    }
    
    
    
    
    // 拼接消息的前半部分
    messageStr = [messageStr stringByAppendingString:nameStr];
    
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
            contentStr = [NSString stringWithFormat:ASLocalizedString(@"金光一闪，%@ 加入了..."),nickName];
        }
        else
        {
            contentStr = [NSString stringWithFormat:ASLocalizedString(@"%@ 来了"),nickName];
        }
        
        if ([[GlobalVariables sharedInstance].appModel.open_noble isEqualToString:@"1"]){
            if ([customMessageModel.sender.is_noble_mysterious isEqualToString:@"1"]) {
                contentStr = ASLocalizedString(@"神秘人加入了房间");
            }else{
//                messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", contentStr]];
            }
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
    
    NSLog(@"%@333333%@",messageStr,contentStr);
    
    if ([[GlobalVariables sharedInstance].appModel.open_noble isEqualToString:@"1"]){
        if ([customMessageModel.sender.is_noble_mysterious isEqualToString:@"1"]) {
            NSLog(ASLocalizedString(@"是隐身了"));
            nameStr = @"";
            messageStr = [NSString stringWithFormat:@"%@",contentStr];
            
            _nobleVipView.hidden = _rankImgView.hidden = _vipView.hidden = _guardianView.hidden = YES;
            _stealthView.hidden = NO;
            [_stealthView setImage:[UIImage imageNamed:@"live_noble_Img"]];
            [_msgBgImgView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.sender.star_box]];
            
//            _msgBgImgView.hidden = NO;
        }else{
            messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", contentStr]];
        }
    }else{
        _stealthView.hidden = YES;
        // 整条消息拼接，message不可能为空，如果为空就意味着判断出错了
           if (contentStr && ![contentStr isEqualToString:@""])
           {
               messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", contentStr]];
           }
    }
    
    

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:messageStr];
    self.imageCount = (_nobleVipView.isHidden ? 0 : 1)*2+(_rankImgView.isHidden ? 0 : 2)*2+(_guardianView.isHidden ? 0 : 1)*2+(_stealthView.isHidden ? 0 : 1)*2+(_vipView.isHidden ? 0 : 1)*2;
    
    if (!_stealthView.isHidden) {
        NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
        NSTextAttachment *text = [[NSTextAttachment alloc]init];
        text.image = [UIImage imageNamed:@"live_noble_Img"];
        text.bounds = CGRectMake(0, -3.5, 50, 18);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:text];
        [attr insertAttributedString:spaceAttr atIndex:0];
        [attr insertAttributedString:imageAttr atIndex:0];
    }
    
    if(!_vipView.isHidden)
    {
        UIImage *image = _vipView.image;
        
        NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
        NSTextAttachment *text = [[NSTextAttachment alloc]init];
        if (image) {
            text.image = image;
            text.bounds = CGRectMake(0, -3.5, image.size.width * 18 / image.size.height, 18);
        }else{
            text.image = [[UIImage alloc]init];
            text.bounds = CGRectMake(0, -3.5, 1, 1);
        }
        
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:text];
        [attr insertAttributedString:spaceAttr atIndex:0];
        [attr insertAttributedString:imageAttr atIndex:0];

    }
    
    if (!_nobleVipView.isHidden) {
        
        UIImage *nobleImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:customMessageModel.sender.noble_icon];
        
        NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
        NSTextAttachment *text = [[NSTextAttachment alloc]init];
        if (nobleImage) {
            text.image = nobleImage;
            text.bounds = CGRectMake(0, -3.5, nobleImage.size.width * 18 / nobleImage.size.height, 18);
        }else{
            text.image = [[UIImage alloc]init];
            text.bounds = CGRectMake(0, -3.5, 1, 1);
        }
        
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:text];
        [attr insertAttributedString:spaceAttr atIndex:0];
        [attr insertAttributedString:imageAttr atIndex:0];
        if (!nobleImage) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:customMessageModel.sender.noble_icon] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                NSTextAttachment *nText = [[NSTextAttachment alloc]init];
                nText.image = image;
                nText.bounds = CGRectMake(0, -3.5, image.size.width * 18 / image.size.height, 18);
                NSAttributedString *nImageAttr = [NSAttributedString attributedStringWithAttachment:nText];
                NSMutableAttributedString *nAttr = [[NSMutableAttributedString alloc]initWithAttributedString:self.msgLabel.attributedText];
                [nAttr replaceCharactersInRange:NSMakeRange(self.imageCount - 1, 1) withAttributedString:nImageAttr];
                self.msgLabel.attributedText = nAttr;
            }];
        }
    }
    
    if (!_guardianView.isHidden) {
        
        
        
        NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
        NSTextAttachment *text = [[NSTextAttachment alloc]init];
        text.image = [UIImage imageNamed:@"lr_img_corner_ward"];
        text.bounds = CGRectMake(0, -3.5, 50, 18);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:text];
        [attr insertAttributedString:spaceAttr atIndex:0];
        [attr insertAttributedString:imageAttr atIndex:0];
      
//        [_guardianView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.sender.guardianModel.guardian_img]];
        [_guardianView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.sender.guardian_img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                text.image = image;
            }
            
        }];
    }
    
    if (!_rankImgView.isHidden) {
        
        
        NSAttributedString *spaceAttr1 = [[NSAttributedString alloc]initWithString:@"  "];
        
        
        
        
        
        NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
        
        
        
        NSTextAttachment *text = [[NSTextAttachment alloc]init];
        text.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%d",customMessageModel.sender.user_level]];
        text.bounds = CGRectMake(0, -3.5, 38, 18);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:text];
        
        
        [attr insertAttributedString:spaceAttr atIndex:0];
        [attr insertAttributedString:imageAttr atIndex:0];
        [attr insertAttributedString:spaceAttr1 atIndex:0];
    }
    
    if (customMessageModel.icon.length) {
        
        UIImage *iconImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:customMessageModel.icon];
        
        
        NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
        NSTextAttachment *text = [[NSTextAttachment alloc]init];
        if (iconImage) {
            text.image = iconImage;
            text.bounds = CGRectMake(0, -3.5, 18, 18);
            NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:text];
            [attr appendAttributedString:spaceAttr];
            [attr appendAttributedString:imageAttr];
        }else{
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:customMessageModel.icon] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                NSTextAttachment *nText = [[NSTextAttachment alloc]init];
                nText.image = image;
                nText.bounds = CGRectMake(0, -3.5, 18, 18);
                NSAttributedString *nImageAttr = [NSAttributedString attributedStringWithAttachment:nText];
                NSMutableAttributedString *nAttr = [[NSMutableAttributedString alloc]initWithAttributedString:self.msgLabel.attributedText];
                [nAttr appendAttributedString:nImageAttr];
                self.msgLabel.attributedText = nAttr;
            }];
        }
    }
    
    if (customMessageModel.imageName.length) {
        NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
        NSTextAttachment *text = [[NSTextAttachment alloc]init];
        text.image = [UIImage imageNamed:customMessageModel.imageName];
        text.bounds = CGRectMake(0, -3.5, 18, 18);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:text];
        [attr appendAttributedString:spaceAttr];
        [attr appendAttributedString:imageAttr];
    }
    
    __weak __typeof(self) ws = self;
    
    if (messageStr.length)
    {
        
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(3, 3);
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowBlurRadius = 5;
        [attr addAttributes:@{NSFontAttributeName : ws.myFont, NSForegroundColorAttributeName : messageLabelColor, NSVerticalGlyphFormAttributeName : @(0)} range:NSMakeRange(self.imageCount, messageStr.length)];

        if ([nameStr isEqualToString:ASLocalizedString(@"直播消息:")]) {
            [attr addAttributes:@{NSFontAttributeName : ws.myFont, NSForegroundColorAttributeName : myTextColorCommonMessageUser} range:NSMakeRange(self.imageCount, nameStr.length)]; //设置直播消息的字体颜色
        }else{
            
        }
        
        //设置用户名称的点击
        NSDictionary *attributes = @{NSFontAttributeName : _myFont,
                                     NSForegroundColorAttributeName : myTextColorUser,
                                     NSBackgroundColorAttributeName : kClearColor,
                                     NSStrokeColorAttributeName : myTextColorUser,
                                     };
        if (type == MSG_TEXT || type == MSG_SEND_GIFT_SUCCESS || type == MSG_LIGHT || type == MSG_RED_PACKET)
        {
            [attr addAttributes:attributes range:NSMakeRange(self.imageCount, nameStr.length)];
        }
        [self.msgLabel setAttributedText:attr];
//        [self.msgLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:NSMakeRange(self.imageCount, nameStr.length)] attributes:@{NSForegroundColorAttributeName:myTextColorUser}];
//            [_msgLabel setText:attr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//
//                // http://blog.csdn.net/ys410900285/article/details/25976179
            
//                return mutableAttributedString;
//            }];
    }
    else
    {
        NSLog(@"==========消息设置出错了");
    }
    
    //设置红包的点击
    NSDictionary *redPackageAttributes = @{NSFontAttributeName : _myFont,
                                           NSForegroundColorAttributeName : messageLabelColor,
                                           NSBackgroundColorAttributeName : kClearColor,
                                           NSStrokeColorAttributeName : messageLabelColor,
                                           };
    if (type == MSG_RED_PACKET)
    {
        _type = @"0";
//            [_msgLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:[messageStr rangeOfString:contentStr]] attributes:redPackageAttributes];
    }
    
    //设置用户名称的点击
    NSDictionary *attributes = @{NSFontAttributeName : _myFont,
                                 NSForegroundColorAttributeName : myTextColorUser,
                                 NSBackgroundColorAttributeName : kClearColor,
                                 NSStrokeColorAttributeName : myTextColorUser,
                                 };
    if (type == MSG_TEXT || type == MSG_SEND_GIFT_SUCCESS || type == MSG_LIGHT || type == MSG_RED_PACKET)
    {
        _type = @"0";
//            [_msgLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:[messageStr rangeOfString:nameStr]] attributes:attributes];
    }
    if (type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS)
    {
        _type = @"2";
//            [_msgLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:[messageStr rangeOfString:nameStr]] attributes:attributes];
    }
    
    _msgLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _msgLabel.shadowOffset = CGSizeMake(1, 1);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CALayer *gl = _msgBack.layer.sublayers[0];
    for (CALayer *sublayer in _msgBack.layer.sublayers) {
        if ([gl isKindOfClass:[CAGradientLayer class]]) {
            [gl removeFromSuperlayer];
            break;
        }
    }
    CGRect frame = self.contentView.frame;
    frame.size.width = COMMENT_TABLEVIEW_HEIGHT;
    
    CGSize size = _customMessageModel.avimMsgShowSize;
    
    CGRect rect = frame;
    rect.size.height = size.height;
    rect.size.width = size.width;
    _msgBack.frame = rect;
    _msgBack.frame = CGRectMake(CGRectGetMinX(_msgBack.frame), (self.frame.size.height-CGRectGetHeight(_msgBack.frame))/2, CGRectGetWidth(_msgBack.frame), CGRectGetHeight(_msgBack.frame));
    
    rect = _msgBack.bounds;
    
    if (rect.size.height)
    {
        _msgLabel.frame = CGRectMake(_msgBack.left + 8, _msgBack.top + 10, _msgBack.width - 5, _msgBack.height );
        _msgLabel.backgroundColor = kClearColor;
        _msgLabel.top = 5;
        
        _msgBack.frame = CGRectMake(_msgLabel.left - 5, _msgLabel.top - 5, _msgLabel.width + 5, _msgLabel.height + 10);
        _msgBgImgView.frame = _msgBack.frame;
//        _msgBack.backgroundColor = kClearColor;

        
        _msgBgImgView.backgroundColor = kClearColor;

    }
    
    CGFloat rankImgViewY = 0;
    if ((_customMessageModel && _customMessageModel.icon) || (_customMessageModel && _customMessageModel.imageName))
    {
        if ([_customMessageModel.icon length] || [_customMessageModel.imageName length])
        {
            rankImgViewY = 8;
        }
        else
        {
            rankImgViewY = 4;
        }
    }
    else
    {
        rankImgViewY = 4;
    }
    
    CGSize messageLabelSize = _customMessageModel.avimMsgShowSize;
    
    if (messageLabelSize.height >= 26 && messageLabelSize.height < 30)
    {
        rankImgViewY = 8;
    }else if (messageLabelSize.height >= 30)
    {
        rankImgViewY = 4;
    }
    rankImgViewY = 6;
    
    
    //_rankImgView的Y值
    if (_rankImgView.isHidden == NO)
    {
        _stealthView.hidden = YES;
       CGFloat rankImgViewY = 4;
        _msgLabel.left = rect.origin.x;
        if ((_customMessageModel && _customMessageModel.icon) || (_customMessageModel && _customMessageModel.imageName))
        {
            if ([_customMessageModel.icon length] || [_customMessageModel.imageName length])
            {
                rankImgViewY = 8;
            }
            else
            {
                rankImgViewY = 4;
            }
        }
        else
        {
            rankImgViewY = 6;
        }
        
        CGSize messageLabelSize = _customMessageModel.avimMsgShowSize;
        
        if (messageLabelSize.height >= 26 && messageLabelSize.height < 30)
        {
            rankImgViewY = 8;
        }else if (messageLabelSize.height >= 30)
        {
            rankImgViewY = 6;
        }else{
            rankImgViewY = 6;
        }
        
        _rankImgView.frame = CGRectMake(15, rankImgViewY, 38, 18);
        CGFloat rankRight = _rankImgView.right + 2.5;
        
        if (!_nobleVipView.hidden) {
            _nobleVipView.frame = CGRectMake(rankRight, rankImgViewY, 18, 18);
            rankRight = _nobleVipView.right + 2.5;
        }
        
        if (!_vipView.hidden) {
            _vipView.frame = CGRectMake(rankRight, rankImgViewY, 50, 18);
            rankRight = _vipView.right + 2.5;
        }
        
        if (!_guardianView.hidden) {
            _guardianView.frame = CGRectMake(rankRight, rankImgViewY, 50, 18);
            rankRight = _guardianView.right + 2.5;
        }

        CALayer *gl = _msgBack.layer.sublayers[0];
        if ([gl isKindOfClass:[CAGradientLayer class]]) {
            [gl removeFromSuperlayer];
        }
        //贵族背景颜色
        if (_guardianView.hidden && !_nobleVipView.hidden && _stealthView.hidden && _customMessageModel.type != MSG_VIEWER_JOIN && _customMessageModel.type != MSG_LIVING_MESSAGE) {

            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = _msgBack.bounds;
            gl.startPoint = CGPointMake(0, 0.5);
            gl.endPoint = CGPointMake(1, 0.5);
            gl.colors = @[(__bridge id)[[UIColor colorWithHexString:@"#BC7B02"] colorWithAlphaComponent:0.6].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#E9BD15"] colorWithAlphaComponent:0.6].CGColor];
            gl.locations = @[@(0.0),@(1.0f)];
            [_msgBack.layer insertSublayer:gl atIndex:0];
        }

        
        if (!_guardianView.hidden&& _customMessageModel.type != MSG_VIEWER_JOIN && _customMessageModel.type != MSG_LIVING_MESSAGE) {
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = _msgBack.bounds;
            gl.startPoint = CGPointMake(0, 0.5);
            gl.endPoint = CGPointMake(1, 0.5);
            gl.colors = @[(__bridge id)[[UIColor colorWithHexString:@"#9E64FF"] colorWithAlphaComponent:0.6].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#EF60F6"] colorWithAlphaComponent:0.5].CGColor];
            gl.locations = @[@(0.0),@(1.0f)];
            [_msgBack.layer insertSublayer:gl atIndex:0];
//            _msgBack.backgroundColor = [UIColor colorWithHexString:@"#9B00E0"];
        }
        
    }else{
        
        CALayer *gl = _msgBack.layer.sublayers[0];
        if ([gl isKindOfClass:[CAGradientLayer class]]) {
            [gl removeFromSuperlayer];
        }
        
        if (messageLabelSize.height >= 25 && messageLabelSize.height < 30)
        {
            rankImgViewY = 8;
        }else if (messageLabelSize.height >= 30)
        {
            rankImgViewY = 6;
        }else{
            rankImgViewY = 8;
        }
        
        _stealthView.frame = CGRectMake(5, rankImgViewY, 48, 16);
        _msgLabel.left = _msgBack.left;
    }
}



- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    if ([_type isEqualToString:@"2"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(clickCellUserInfo:)]) {
            [_delegate clickCellUserInfo:self];
        }
    }else
    {
        if (result.range.location == 7 || result.range.length == self.customMessageModel.sender.nick_name.length)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(clickCellNameRange:)])
            {
                [_delegate clickCellNameRange:self];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(clickCellMessageRange:)])
            {
                [_delegate clickCellMessageRange:self];
            }
        }
    }
}

@end


//============================================================================================================================================================================

#pragma mark - TCShowLiveMessageView
@interface TCShowLiveMessageView ()
{
    BOOL _isScrolling;
}

@end

@implementation TCShowLiveMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        _canScrollToBottom = YES;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, COMMENT_TABLEVIEW_WIDTH, COMMENT_TABLEVIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.backgroundColor = kClearColor;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_tableView];
        
        _liveMessages = [[NSMutableArray alloc] init];
        
        // 观众首次进入直播室显示的消息
        for (CustomMessageModel *customMessageModel in [GlobalVariables sharedInstance].listMsgMArray)
        {
            [self insertMsg:customMessageModel];
        }
    }
    return self;
}


#pragma mark - ----------------------- 插入消息 -----------------------
#pragma mark 直接显示
- (void)insertMsg:(id<AVIMMsgAble>)item
{
    if (item && [item isKindOfClass:[CustomMessageModel class]])
    {
        @synchronized(_liveMessages)
        {
            CustomMessageModel *customMessageModel = (CustomMessageModel *)item;
            if (!customMessageModel.avimMsgShowSize.height)
            {
                [customMessageModel prepareForRender];
            }
            
            _msgCount++;
            
            [_tableView beginUpdates];
            
            if (_liveMessages.count >= kMaxMsgCount)
            {
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
                [_liveMessages removeObjectAtIndex:0];
            }
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:_liveMessages.count inSection:0];
            [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
            [_liveMessages addObject:item];
            
            [_tableView endUpdates];
            
            if (_canScrollToBottom)
            {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_liveMessages.count - 1  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
}

#pragma mark 延迟显示
- (void)insertCachedMsg:(AVIMCache *)msgCache
{
    NSInteger msgCacheCount = [msgCache count];
    if (msgCacheCount == 0) {
        return;
    }
    
    @synchronized(_liveMessages)
    {
        _msgCount += msgCacheCount;
        
        while (msgCache.count > 0)
        {
            CustomMessageModel *customMessageModel = [msgCache deCache];
            if (!customMessageModel.avimMsgShowSize.height)
            {
                [customMessageModel prepareForRender];
            }
            
            if (customMessageModel && customMessageModel.type != UPDATE_PK_TICKET)
            {
                //当收到更新PK收益时不添加消息
                [_liveMessages addObject:customMessageModel];
                if (_liveMessages.count > kMaxMsgCount)
                {
                    [_liveMessages removeObjectAtIndex:0];
                }
            }
        }
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadMyTableView) object:nil];
        
        [self reloadMyTableView];
        
        if (_canScrollToBottom)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_liveMessages.count - 1  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

- (void)reloadMyTableView
{
    //    NSLog(@"==============load count:%d",++_testIndex);
    [_tableView reloadData];
}

#pragma mark - ----------------------- tableView的相关操作 -----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _liveMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomMessageModel *customMessageModel = [_liveMessages objectAtIndex:indexPath.row];
    return customMessageModel.avimMsgShowSize.height + LIVE_MESSAGEVIEW_Margin * 2 + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCShowLiveMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCShowLiveMsgTableViewCell"];
    if (!cell)
    {
        cell = [[TCShowLiveMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TCShowLiveMsgTableViewCell"];
        cell.delegate = self;
    }
    
    CustomMessageModel *customMessageModel = [_liveMessages objectAtIndex:indexPath.row];
    [cell config:customMessageModel block:^{
        
        [self performSelector:@selector(reloadMyTableView) withObject:nil afterDelay:1];
        
    }];
    
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    
    _canScrollToBottom = NO;
    
    if ([_contentOffsetTimer isValid])
    {
        [_contentOffsetTimer invalidate];
        _contentOffsetTimer = nil;
    }
    
    _contentOffsetTimer = [NSTimer scheduledTimerWithTimeInterval:kLiveMessageContentOffsetTime target:self selector:@selector(changeScrollToBottomState) userInfo:nil repeats:NO];
}

- (void)changeScrollToBottomState
{
    _canScrollToBottom = !_canScrollToBottom;
}

#pragma mark 点击消息列表中的用户名称
- (void)clickCellNameRange:(TCShowLiveMsgTableViewCell *) cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickNameRange:)])
    {
        [_delegate clickNameRange:cell.customMessageModel];
    }
}

#pragma mark 点击消息列表中的具体消息内容（目前会响应点击事件的是：红包）
- (void)clickCellMessageRange:(TCShowLiveMsgTableViewCell *) cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickMessageRange:)])
    {
        [_delegate clickMessageRange:cell.customMessageModel];
    }
}

- (void)clickCellUserInfo:(TCShowLiveMsgTableViewCell *)cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickUserInfo:)])
    {
        [_delegate clickUserInfo:cell.customMessageModel.user];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomMessageModel *customMessageModel = [_liveMessages objectAtIndex:indexPath.row];
    
    if (customMessageModel.type== MSG_STARGOODS_SUCCESS)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(clickGoodsMessage:)])
        {
            [_delegate clickGoodsMessage:customMessageModel];
        }
    }else{
        if (customMessageModel.type != MSG_VIEWER_JOIN && customMessageModel.type != MSG_LIVING_MESSAGE) {
            if (_delegate && [_delegate respondsToSelector:@selector(clickNameRange:)])
            {
                [_delegate clickNameRange:customMessageModel];
            }
        }
        
    }
}



- (void)dealloc
{
    if ([_contentOffsetTimer isValid])
    {
        [_contentOffsetTimer invalidate];
        _contentOffsetTimer = nil;
    }
}

@end

