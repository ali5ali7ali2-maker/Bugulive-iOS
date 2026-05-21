//
//  BogoSharePopView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/10/22.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "BogoSharePopView.h"

static CGFloat const KShareContaintHeight = 250;

@implementation BogoSharePopView

-(BogoPosterImgView *)topSmView{
    if (!_topSmView) {
        _topSmView = [[BogoPosterImgView alloc]initWithFrame:CGRectMake(70, kRealValue(131), kRealValue(250), kRealValue(280))];
        _topSmView.centerX = kScreenW / 2;
        _topSmView.is_Small=YES;
        _topSmView.backgroundColor = kWhiteColor;
    }
    return _topSmView;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.15];

        
        self.frame = [UIScreen mainScreen].bounds;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        _container = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenH, kScreenW - 20, KShareContaintHeight)];
        _container.backgroundColor = kWhiteColor;
        _container.clipsToBounds = YES;
        _container.layer.cornerRadius = 5;
        [self addSubview:_container];
        
        _posterContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenH, kScreenW - 20, kRealValue(117))];
        _posterContainerView.backgroundColor = kWhiteColor;
        _posterContainerView.clipsToBounds = YES;
        _posterContainerView.layer.cornerRadius = 5;
        _posterContainerView.hidden = YES;
        [self addSubview:_posterContainerView];
        
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, _container.width, 22)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = NSLocalizedString(ASLocalizedString(@"分享到"), nil);
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:14];
        
        [_container addSubview:label];
        NSArray *Arr = @[@[ASLocalizedString(@"微信好友"),ASLocalizedString(@"微信朋友圈"),ASLocalizedString(@"QQ好友"),ASLocalizedString(@"QQ空间")],@[ASLocalizedString(@"复制链接"),ASLocalizedString(@"生成海报"),ASLocalizedString(@"FaceBook")]];
        NSArray *imageArrImage = @[@[@"微信好友",@"微信朋友圈",@"QQ好友",@"QQ空间"],@[@"复制链接",@"生成海报",@"FaceBook"]];
        
        
        //主分享View
        for (int j=0; j<Arr.count; j++) {
                NSArray *rowArr=Arr[j];
            
                CGFloat viewWidth = _container.width / 4;
                NSArray *rowImageArr=imageArrImage[j];

                for (int i=0; i<[rowArr count]; i++) {
                    
                    CGFloat viewTop = j*kRealValue(85)+kRealValue(35);
                    
                    ShareItem *item = [[ShareItem alloc] initWithFrame:CGRectMake(i * viewWidth, viewTop, viewWidth, kRealValue(80))];
                    item.icon.image = [UIImage imageNamed:rowImageArr[i]];
                    item.label.text = rowArr[i];
                    item.tag = j*10+i;;
                    [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTap:)]];
                    [_container addSubview:item];
                }
        }
        //海报分享View
        
        NSArray *posterImgArr = @[ASLocalizedString(@"微信好友"),ASLocalizedString(@"微信朋友圈"),ASLocalizedString(@"QQ好友"),ASLocalizedString(@"QQ空间"),ASLocalizedString(@"保存到相册")];
        for (int i=0; i < posterImgArr.count; i++) {
                
            
            CGFloat viewWidth = _container.width / 5;
                
            CGFloat viewTop = kRealValue(15);
            
            ShareItem *item = [[ShareItem alloc] initWithFrame:CGRectMake(i * viewWidth, viewTop, viewWidth, kRealValue(80))];
            item.icon.image = [UIImage imageNamed:posterImgArr[i]];
            item.label.text = posterImgArr[i];
            item.tag = i;
            
            if (i == 4) {
                item.tag = 100 + 4;
            }
            
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTap:)]];
            [_posterContainerView addSubview:item];
                
        }
        
        
        _cancel = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenH-44-49-20, kScreenW - 20, 44 )];
//        [_cancel setTitleEdgeInsets:UIEdgeInsetsMake(-SafeAreaBottomHeight, 0, 0, 0)];
        [_cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_cancel setTitle:NSLocalizedString(ASLocalizedString(@"取消"), nil) forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:15];

        _cancel.backgroundColor = kWhiteColor;
        _cancel.clipsToBounds = YES;
        _cancel.layer.cornerRadius = 5;

        [self addSubview:_cancel];
        
    }
    return self;
}



- (void)onItemTap:(UITapGestureRecognizer *)sender{
    
    if (sender.view.tag == 100 + 4) {
        [self clickSaveAlbum];
        return;
    }
    
    if (sender.view.tag >3 && sender.view.tag != 12) {
        [self onActionItemTap:sender];
    } else {
        [self onShareItemTap:sender.view.tag];
    }
}

//保存海报到相册
-(void)clickSaveAlbum{
//    [[HUDHelper sharedInstance]syncLoading:ASLocalizedString(@"正在保存中")];
 
    UIImage *image = [self convertViewToImage:self.topSmView.backImageView];
    
    [self loadImageFinished:image];
}

- (UIImage *)convertViewToImage:(UIView *)view {

    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageRet;

}

- (void)loadImageFinished:(UIImage *)image{
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}



- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    [[HUDHelper sharedInstance]syncStopLoading];
//    [self.shareView hide];
//    self.topBgView.imageStr=[UIImage new];
//    self.topBgView.hidden=YES;
//    [self.topBgView removeFromSuperview];
    if (!error) {
        [FanweMessage alert:ASLocalizedString(@"成功保存，请到相册中查看")];
    }else{
        [FanweMessage alert:error.description];
        
    }
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
- (void)onActionItemTap:(UITapGestureRecognizer *)sender {
    
        
    if (sender.view.tag == 10) {
        UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
               
        pasteboard.string = self.shareContent;
       
        [BGHUDHelper alert:ASLocalizedString(@"已复制到粘贴板")];
    }else if (sender.view.tag == 11){
        
        //两个shareView
        _container.hidden = YES;
        _posterContainerView.hidden = NO;
        
        _posterContainerView.bottom = self.cancel.top - kRealValue(10);
        ShareModel *model = [ShareModel new];
        model.share_url = self.shareContent;
        self.topSmView.model = model;
        self.topSmView.is_Small = YES;
        [self addSubview:self.topSmView];
        [self bringSubviewToFront:self.topSmView];

    }

}

- (void)onShareItemTap:(NSInteger)sender {

    UMSocialPlatformType socialPlatformType;
    switch (sender) {
        case 0:
            socialPlatformType = UMSocialPlatformType_WechatSession;
            break;
        case 1:
            socialPlatformType = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2:
            socialPlatformType = UMSocialPlatformType_QQ;
            break;
        case 3:
            socialPlatformType = UMSocialPlatformType_Qzone;
            break;
        case 12:
            socialPlatformType = UMSocialPlatformType_Facebook;
            break;
        default:
            break;
    }
    
    ShareModel *SModel = [ShareModel new];
    SModel.share_title = ASLocalizedString(@"好友邀请您一起看直播！");
    SModel.share_content = ASLocalizedString(@"新鲜、有趣、好玩、精彩......你想要的都在这里！");
    SModel.share_url = self.shareContent;
    SModel.share_imageUrl = [GlobalVariables sharedInstance].appModel.app_logo;
    [[BGUMengShareManager sharedInstance] shareTo:[AppDelegate sharedAppDelegate].topViewController platformType:socialPlatformType shareModel:SModel succ:nil failed:nil];

    [self dismiss];
    
}



- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    point = [sender locationInView:_cancel];
    if([_cancel.layer containsPoint:point]) {
        [self dismiss];
    }
}


- (void)show {
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y - frame.size.height;
        self.container.frame = CGRectMake(10, kScreenH-(KShareContaintHeight+10+44+49+20 + 40) + 32.5, kScreenW- 20, KShareContaintHeight);
        self.cancel.frame =CGRectMake(10, kScreenH-44-49-20 + 15, kScreenW-20, 44 );
        
    }
                     completion:^(BOOL finished) {
    }];
}



- (void)dismiss {
    [UIView animateWithDuration:0.01f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        self.container.frame = CGRectMake(10, kScreenH, kScreenW-20, KShareContaintHeight);
        self.cancel.frame = CGRectMake(10, kScreenH, kScreenW-20, 44);                     }
                     completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end



#pragma Item view

@implementation ShareItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"iconHomeAllshareCopylink"];
        _icon.contentMode = UIViewContentModeScaleToFill;
        _icon.userInteractionEnabled = YES;
        [self addSubview:_icon];
        
        _label = [[UILabel alloc] init];
        _label.text = @"TEXT";
        _label.textColor = [UIColor colorWithHexString:@"#666666"];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
-(void)startAnimation:(NSTimeInterval)delayTime {
    CGRect originalFrame = self.frame;
    self.frame = CGRectMake(CGRectGetMinX(originalFrame), 35, originalFrame.size.width, originalFrame.size.height);
    [UIView animateWithDuration:0.9f
                          delay:delayTime
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = originalFrame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(48);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.icon.mas_bottom).offset(10);
    }];
}



@end
