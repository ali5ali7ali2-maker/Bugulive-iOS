//
//  TCShowLiveBottomView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowVoiceBottomView.h"
#import "UIView+CustomAutoLayout.h"

@implementation TCShowVoiceBottomView

#pragma mark - ----------------------- 直播生命周期 -----------------------
- (void)releaseAll
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.bjsbadge removeFromSuperview];
    [self.jsbadge removeFromSuperview];
}

- (void)dealloc
{
    [self releaseAll];
}

#pragma mark 开始直播
- (void)startLive
{
    
}

#pragma mark 暂停直播
- (void)pauseLive
{
    
}

#pragma mark 重新开始直播
- (void)resumeLive
{
    
}

#pragma mark 结束直播
- (void)endLive
{
    [self releaseAll];
}


#pragma mark - ----------------------- 其他 -----------------------
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
#if kSupportIMMsgCache
        
        // 创建点赞消息缓存
        self.praiseImageCache = [NSMutableArray array];
        
        // 预先缓存点赞动画图片，主要是防止在收到大量点赞消息时，因加载资源的耗时
        /**
         UIImage *img = [UIImage imageNamed:@"img_like"];
         [self.praiseImageCache addObject:[img imageWithTintColor:[UIColor flatRedColor]]];
         [self.praiseImageCache addObject:[img imageWithTintColor:[UIColor flatDarkRedColor]]];
         */
        
        [self.praiseImageCache addObject:[UIImage imageNamed:@"heart0"]];
        [self.praiseImageCache addObject:[UIImage imageNamed:@"heart1"]];
        [self.praiseImageCache addObject:[UIImage imageNamed:@"heart2"]];
        [self.praiseImageCache addObject:[UIImage imageNamed:@"heart3"]];
        [self.praiseImageCache addObject:[UIImage imageNamed:@"heart4"]];
        [self.praiseImageCache addObject:[UIImage imageNamed:@"heart5"]];
        [self.praiseImageCache addObject:[UIImage imageNamed:@"heart6"]];
        
        self.praiseAnimationCache = [NSMutableArray array];
        
#endif
        
        _canSendLightMsg = YES;
        
        _showFuncs = [NSMutableArray array];
        
        _menusBottomView = [[UIView alloc]init];
        _menusBottomView.backgroundColor = kClearColor;
        [self addSubview:_menusBottomView];
        
        //发送消息按钮
        
        FWWeakify(self)
        
//        _msgMenuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"lr_bottom_comment"] action:^(id<MenuAbleItem> menu) {
//            FWStrongify(self)
//            [self menuButtonAction:menu];
//        }];
        
        _msgMenuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"lr_bottom_comment"] action:^(id<MenuAbleItem> menu){
            NSLog(@"tag _ %d",menu.tag);
            FWStrongify(self)
            [self menuButtonAction:menu];
        }];
        [_msgMenuBtn setImage:nil forState:UIControlStateNormal];
        _msgMenuBtn.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
        [_msgMenuBtn setTitle:ASLocalizedString(@"一起聊聊") forState:UIControlStateNormal];
        _msgMenuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_msgMenuBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF andAlpha:0.6] forState:UIControlStateNormal];
        _msgMenuBtn.tag = EFunc_VOICE_INPUT;
//        [_msgMenuBtn setImage:[UIImage imageNamed:@"lr_bottom_comment"] forState:UIControlStateHighlighted];
        
        /**
         // 购物
         if ([self.BuguLive.appModel.shopping_goods integerValue] == 1 || self.BuguLive.appModel.open_podcast_goods == 1) {
         _starShopBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"fw_liveRoom_tools"] action:^(id<MenuAbleItem> menu) {
         [ws menuButtonAction:menu];
         }];
         _starShopBtn.tag = EFunc_STARSHOP  ;
         _starShopBtn.hidden = YES;
         [_starShopBtn setImage:[UIImage imageNamed:@"fw_liveRoom_tools"] forState:UIControlStateHighlighted];
         }
         */
        
        // 更多功能
        if ([self.BuguLive.appModel.shopping_goods integerValue] == 1 || self.BuguLive.appModel.open_podcast_goods == 1)
        {
            _moreToolsBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"lr_bottom_tools"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            _moreToolsBtn.tag = EFunc_MORETOOLS;
            _moreToolsBtn.hidden = YES;
            [_moreToolsBtn  setImage:[UIImage imageNamed:@"lr_bottom_tools"] forState:UIControlStateHighlighted];
        }
        // 插件中心
        _gamesBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"lr_bottom_tools"] action:^(id<MenuAbleItem> menu) {
            
            FWStrongify(self)
            [self menuButtonAction:menu];
            
        }];
        _gamesBtn.tag = EFunc_GAMES   ;
        [_gamesBtn setImage:[UIImage imageNamed:@"lr_bottom_tools"] forState:UIControlStateHighlighted];
        _gamesBtn.hidden = YES;
        // 开始游戏
        _beginGameBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"gm_game_licensing"] action:^(id<MenuAbleItem> menu) {

            FWStrongify(self)
            [self menuButtonAction:menu];
            
        }];
        _beginGameBtn.tag = EFunc_BEGINGAMES;
        _beginGameBtn.hidden = YES;
        [_beginGameBtn setImage:[UIImage imageNamed:@"gm_game_licensing"] forState:UIControlStateHighlighted];
        //游戏视图显示与隐藏开关
        _switchGameViewBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"gm_game_closeView"] action:^(id<MenuAbleItem> menu) {
            
            FWStrongify(self)
            [self menuButtonAction:menu];
            
        }];
        _switchGameViewBtn.tag = EFunc_SWITCHGAMEVIEW;
        _switchGameViewBtn.hidden = YES;
        [_switchGameViewBtn setImage:[UIImage imageNamed:@"gm_game_closeView"] forState:UIControlStateHighlighted];
        
        if(self.BuguLive.appModel.open_banker_module == 1)
        {
            _switchBankerBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"gm_open_banker"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            _switchBankerBtn.tag = EFunc_SWITCH_BANNER;
            _switchBankerBtn.hidden = YES;
            [_switchBankerBtn setImage:[UIImage imageNamed:@"gm_open_banker"] forState:UIControlStateHighlighted];
            
            _grabBankerBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"gm_grab_banker"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            _grabBankerBtn.tag = EFunc_GRAB_BANNER;
            _grabBankerBtn.hidden = YES;
            [_grabBankerBtn setImage:[UIImage imageNamed:@"gm_grab_banker"] forState:UIControlStateHighlighted];
        }
        
        //这个后期  统一处理 不写成通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgNotification:) name:@"reloadunread" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgNotification:) name:g_notif_chatmsg object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgNotification:) name:@"imRemoveNeedUpdate" object:nil];
    }
    return self;
}

- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveInfo = liveInfo;
    
    [self addLiveFunc:[liveItem liveType]];
}

#pragma mark 主播需要添加的按钮
- (void)hostAddFunc
{
    [self addFunc:EFunc_VOICE_FACE];
    [self addFunc:EFunc_VOICE_MUSIC];
    [self addFunc:EFunc_VOICE_CONNECT_MIKE];
    [self addFunc:EFunc_VOICE_MORE];
    [self addFunc:EFunc_VOICE_CHART];
    [self addFunc:EFunc_VOICE_GIFT];
    [self addFunc:EFunc_VOICE_GAME];
}

#pragma mark 观众需要添加的按钮
- (void)audienceAddFunc
{
    [self addFunc:EFunc_VOICE_FACE];
    [self addFunc:EFunc_VOICE_MUSIC];
    [self addFunc:EFunc_VOICE_CHART];
    [self addFunc:EFunc_VOICE_GIFT];
    [self addFunc:EFunc_VOICE_GAME];

}

#pragma mark 添加菜单
- (void)addLiveFunc:(NSInteger)liveType
{
    if (_menusBottomView)
    {
        [_menusBottomView removeFromSuperview];
        _menusBottomView = nil;
        
        _menusBottomView = [[UIView alloc]init];
        _menusBottomView.backgroundColor = kClearColor;
        [self addSubview:_menusBottomView];
        
        [_showFuncs removeAllObjects];
    }
    
    // 视频类型，对应的枚举：FW_LIVE_TYPE
    if (liveType == FW_LIVE_TYPE_RELIVE)
    {
        [_switchGameViewBtn removeFromSuperview];
        _switchGameViewBtn = nil;
        [_grabBankerBtn removeFromSuperview];
        _grabBankerBtn = nil;
        _gamesBtn.hidden = YES;
        
        if (_liveInfo.create_type == 1)
        {
            [self addFunc:EFunc_FULL_SCREEN];
        }
        [self addFunc:EFunc_CHART];
        [self addFunc:EFunc_GIFT];
        [self addFunc:EFunc_SHARE];
        [self addFunc:EFunc_CLOSE];
        _moreToolsBtn.hidden = NO;
        //        if ([VersionNum isEqualToString: self.BuguLive.appModel.ios_check_version])
        //        {
        //            _moreToolsBtn.hidden = NO;
        //        }
        //        else
        //        {
        //            [_moreToolsBtn removeFromSuperview];
        //            _moreToolsBtn = nil;
        //        }
    }
    else if (liveType == FW_LIVE_TYPE_HOST)
    {
        [_moreToolsBtn removeFromSuperview];
        _moreToolsBtn = nil;
        _gamesBtn.hidden = YES;
        [self hostAddFunc];
    }
    else if (liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        _moreToolsBtn.hidden = NO;
        _gamesBtn.hidden = YES;
        [self audienceAddFunc];
    }
    
    [self relayoutFrameOfSubViews];
}

- (void)addFunc:(NSInteger)funcid
{
    MenuButton *menuBtn = nil;
    
    FWWeakify(self)
    switch (funcid)
    {
        case EFunc_VOICE_MUSIC:
        {
            menuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"lr_bottom_music"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            [menuBtn setImage:[UIImage imageNamed:@"lr_bottom_gift_list"] forState:UIControlStateSelected];
        }
            break;
        case EFunc_VOICE_FACE:
        {
            menuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"lr_bottom_full_face"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            [menuBtn setImage:[UIImage imageNamed:@"lr_bottom_gift_list"] forState:UIControlStateSelected];
        }
            break;
            
        case EFunc_VOICE_GIFT:
        {
            menuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"语音房间底部_礼物"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            [menuBtn setImage:[UIImage imageNamed:@"lr_bottom_gift_list"] forState:UIControlStateSelected];
        }
            break;
            
        case EFunc_VOICE_GAME:
        {
            menuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"更多 (4)"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            [menuBtn setImage:[UIImage imageNamed:@"lr_bottom_gift_list"] forState:UIControlStateSelected];
        }
            break;
        case EFunc_VOICE_CONNECT_MIKE:
        {
            menuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"语音房间底部_麦位管理"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            [menuBtn setImage:[UIImage imageNamed:@"lr_bottom_gift_list"] forState:UIControlStateSelected];
        }
            break;
            
        case EFunc_VOICE_CHART:
        {
            menuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"语音房间底部_消息"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            [menuBtn setImage:[UIImage imageNamed:@"lr_bottom_gift_list"] forState:UIControlStateSelected];
            
            [self performSelector:@selector(addMsgBadge:) withObject:menuBtn afterDelay:2];

            
        }
            break;
        case EFunc_VOICE_MORE:
        {
            menuBtn = [[MenuButton alloc] initWithTitle:nil icon:[UIImage imageNamed:@"more3"] action:^(id<MenuAbleItem> menu) {
                
                FWStrongify(self)
                [self menuButtonAction:menu];
                
            }];
            [menuBtn setImage:[UIImage imageNamed:@"more3"] forState:UIControlStateSelected];
        }
            break;
        default:
            break;
    }
    
    if (menuBtn)
    {
        menuBtn.tag = funcid;
        [_menusBottomView addSubview:menuBtn];
        [_showFuncs addObject:menuBtn];
    }
}

- (void)addMsgBadge:(MenuButton *)menuBtn
{
    FWWeakify(self)
    [SFriendObj getAllUnReadCountComplete:^(int num) {
        
        FWStrongify(self)
        int jj = num;
        self.jsbadge = [[JSBadgeView alloc]initWithParentView:menuBtn alignment:JSBadgeViewAlignmentTopRight];
        
        if(jj)
        {
            if(jj > 98)
            {
                self.jsbadge.badgeText = @"99+";
            }
            else
            {
                self.jsbadge.badgeText = [NSString stringWithFormat:@"%d",jj];
            }
        }
        else
        {
            self.jsbadge.badgeText = nil;
        }
        
        FWWeakify(self)
        [self xw_addNotificationForName:@"clearJsbadge" block:^(NSNotification * _Nonnull notification) {
            
            FWStrongify(self)
            self.jsbadge.badgeText = nil;
            
        }];
        
    }];
}

- (void)newMsgNotification:(NSNotification*)notifiation
{
    [SFriendObj getAllUnReadCountComplete:^(int num) {
        
        if(num)
        {
            if(num >98)
            {
                self.jsbadge.badgeText = @"99+";
            }
            else
            {
                self.jsbadge.badgeText = [NSString stringWithFormat:@"%d",num];
            }
        }
        else
        {
            self.jsbadge.badgeText = nil;
        }
        
    }];
}


#pragma mark 设置视图frame
- (void)relayoutFrameOfSubViews
{
    CGFloat multiple;
    if (kScreenW <375 && _showFuncs.count > 4)
    {
        multiple = 0.3;//间距要缩小要不然 320 显示不下
    }
    else
    {
        multiple = 1.0;
    }
    
    CGFloat tmpWidth = _showFuncs.count * self.bounds.size.height + multiple*kDefaultMargin * (_showFuncs.count-1);
    _menusBottomView.frame = CGRectMake(CGRectGetWidth(self.frame)-tmpWidth-kDefaultMargin, 0, tmpWidth, self.bounds.size.height);
    
    CGRect rect = _menusBottomView.bounds;
    rect = CGRectInset(rect, 0, 0);
    
    if (_showFuncs.count)
    {
        [_menusBottomView alignSubviews:_showFuncs horizontallyWithPadding:kDefaultMargin*multiple margin:0 inRect:rect];
    }
    
    //发送消息按钮
    _msgMenuBtn.frame = CGRectMake(kDefaultMargin, 0, 80, self.bounds.size.height);
    ViewRadius(_msgMenuBtn, self.bounds.size.height/2);
    [self addSubview:_msgMenuBtn];
    
    if ([self.BuguLive.appModel.shopping_goods integerValue] == 1 || self.BuguLive.appModel.open_podcast_goods == 1 )
    {
        //添加观众端更多工具按钮
        [self addSubview:_moreToolsBtn];
        _moreToolsBtn.frame = CGRectMake(CGRectGetMaxX(_msgMenuBtn.frame)+kDefaultMargin, 0, self.bounds.size.height, self.bounds.size.height);
    }
#if kSupportH5Shopping
    
    _starShopBtn.frame = CGRectMake(2*kDefaultMargin+self.bounds.size.height, 0, 2*self.bounds.size.height, self.bounds.size.height);
    [self addSubview:_starShopBtn];
    
#endif
    
    if (_isHost)
    {
//        _gamesBtn.frame = CGRectMake(CGRectGetMaxX(_msgMenuBtn.frame)+kDefaultMargin, 0, self.bounds.size.height, self.bounds.size.height);
//        [self addSubview:_gamesBtn];
        
        _beginGameBtn.frame = CGRectMake(CGRectGetMaxX(_gamesBtn.frame)+kDefaultMargin, 0, self.bounds.size.height, self.bounds.size.height);
        [self addSubview:_beginGameBtn];
        
        _switchGameViewBtn.frame = CGRectMake(CGRectGetMaxX(_beginGameBtn.frame)+kDefaultMargin, 0, self.bounds.size.height, self.bounds.size.height);
        [self addSubview:_switchGameViewBtn];
        
        _switchBankerBtn.frame = CGRectMake(CGRectGetMaxX(_switchGameViewBtn.frame)+kDefaultMargin, 30, self.bounds.size.height, self.bounds.size.height);
        [self addSubview:_switchBankerBtn];
        
        if(!self.bjsbadge)
        {
            self.bjsbadge = [[JSBadgeView alloc]initWithParentView:_switchBankerBtn alignment:JSBadgeViewAlignmentTopRight];
        }
        if(_bankMessage)
        {
            self.bjsbadge.badgeText = @"···";
        }
        else
        {
            self.bjsbadge.badgeText = nil;
        }
    }
    else
    {
        if ([self.BuguLive.appModel.shopping_goods integerValue] == 1 || self.BuguLive.appModel.open_podcast_goods == 1)
        {
            _switchGameViewBtn.frame = CGRectMake(CGRectGetMaxX(_moreToolsBtn.frame)+kDefaultMargin, 0, self.bounds.size.height, self.bounds.size.height);
        }
        else
        {
            _switchGameViewBtn.frame = CGRectMake(CGRectGetMaxX(_msgMenuBtn.frame)+kDefaultMargin, 0, self.bounds.size.height, self.bounds.size.height);
        }
        [self addSubview:_switchGameViewBtn];
        
        _grabBankerBtn.frame = CGRectMake(CGRectGetMaxX(_switchGameViewBtn.frame)+kDefaultMargin, 0, self.bounds.size.height, self.bounds.size.height);
        [self addSubview:_grabBankerBtn];
    }
}

#pragma mark 按钮点击事件
- (void)menuButtonAction:(MenuButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(onBottomViewClickMenus:fromButton:)])
    {
        [_delegate onBottomViewClickMenus:self fromButton:btn];
    }
}

- (void)onEnableInteractCamera:(MenuButton *)btn
{
    if ([_multiDelegate respondsToSelector:@selector(onBottomView:operateCameraOf:fromButton:)])
    {
        [_multiDelegate onBottomView:self operateCameraOf:_showUser fromButton:btn];
    }
}

- (void)onEnableInteractMic:(MenuButton *)btn
{
    if ([_multiDelegate respondsToSelector:@selector(onBottomView:operateMicOf:fromButton:)])
    {
        [_multiDelegate onBottomView:self operateMicOf:_showUser fromButton:btn];
    }
}

- (void)onCancelInteract:(MenuButton *)btn
{
    if ([_multiDelegate respondsToSelector:@selector(onBottomView:cancelInteractWith:fromButton:)])
    {
        [_multiDelegate onBottomView:self cancelInteractWith:_showUser fromButton:btn];
    }
}

- (void)onSwtichSpeaker:(MenuButton *)btn
{
    btn.selected = !btn.selected;
    btn.enabled = NO;
}

- (void)showLight
{
    if (_canSendLightMsg)
    {
        _canSendLightMsg = NO;
        
        FWWeakify(self)
        // 点赞消息产生的动画，大量产生时非常耗性能，建议观众端不要频繁发送
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            FWStrongify(self)
            self.canSendLightMsg = YES;
            
        });
    }
}

- (void)showLikeHeart
{
    // 非纯净模式下显示点赞消息
    [self showLikeHeartStartRect:_heartRect];
}

#if kSupportIMMsgCache
- (void)showLikeHeart:(AVIMCache *)cache
{
    if (cache.count)
    {
        // 非纯净模式下显示点赞消息
        [self showLikeHeartStartRect:_heartRect count:cache.count > 5 ? 5 : cache.count];
    }
    else
    {
        // 没有的时候，释放缓存
        if (self.praiseAnimationCache.count)
        {
            UIImageView *imageView = [self.praiseAnimationCache objectAtIndex:0];
            [self.praiseAnimationCache removeObject:imageView];
            [imageView removeFromSuperview];
        }
    }
}
#endif

- (CAAnimation *)hearAnimationFrom:(CGRect)frame
{
    //位置
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.beginTime = 0.5;
    animation.duration = 2.5;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount= 0;
    animation.calculationMode = kCAAnimationCubicPaced;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint point0 = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
    
    CGPathMoveToPoint(curvedPath, NULL, point0.x, point0.y);
    
    float x11 = point0.x - arc4random() % 30 + 30;
    float y11 = frame.origin.y - arc4random() % 60 ;
    float x1 = point0.x - arc4random() % 15 + 15;
    float y1 = frame.origin.y - arc4random() % 60 - 30;
    CGPoint point1 = CGPointMake(x1, y1);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, x11, y11, point1.x, point1.y);
    
    int conffset2 = self.superview.bounds.size.width * 0.2;
    int conffset21 = self.superview.bounds.size.width * 0.1;
    float x2 = point0.x - arc4random() % conffset2 + conffset2;
    float y2 = arc4random() % 30 + 240;
    float x21 = point0.x - arc4random() % conffset21  + conffset21;
    float y21 = (y2 + y1) / 2 + arc4random() % 30 - 30;
    CGPoint point2 = CGPointMake(x2, y2);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, x21, y21, point2.x, point2.y);
    
    animation.path = curvedPath;
    
    CGPathRelease(curvedPath);
    
    //透明度变化
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0];
    opacityAnim.removedOnCompletion = NO;
    opacityAnim.beginTime = 0;
    opacityAnim.duration = 3;
    
    //比例
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //        int scale = arc4random() % 5 + 5;
    scaleAnim.fromValue = [NSNumber numberWithFloat:.0];//[NSNumber numberWithFloat:((float)scale / 10)];
    scaleAnim.toValue = [NSNumber numberWithFloat:1];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.fillMode = kCAFillModeForwards;
    scaleAnim.duration = .5;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects: scaleAnim,opacityAnim,animation, nil];
    animGroup.duration = 3;
    
    return animGroup;
}

- (void)showLikeHeartStartRect:(CGRect)frame
{
    _lightCount ++;
    
    UIImageView *imageView = [[UIImageView alloc ] initWithFrame:frame];
    //    imageView.image = [[UIImage imageNamed:@"img_like"] imageWithTintColor:[UIColor randomFlatDarkColor]];
    
    if (_heartImgViewName)
    {
        imageView.image = [UIImage imageNamed:_heartImgViewName];
    }
    else
    {
        int index = arc4random() % 6;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d",index]];
    }
    
    [self.superview addSubview:imageView];
    imageView.alpha = 0;
    
    [imageView.layer addAnimation:[self hearAnimationFrom:frame] forKey:nil];
    
    FWWeakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        FWStrongify(self)
        [imageView removeFromSuperview];
        self.lightCount --;
        
    });
    
}

#if kSupportIMMsgCache
- (void)showLikeHeartStartRect:(CGRect)frame count:(NSInteger)count
{
    for (int i = 0; i < count; i++)
    {
        [self showLikeHeartStartRectFrameCache:frame];
    }
}

- (void)showLikeHeartStartRectFrameCache:(CGRect)frame
{
    UIImageView *imageView = nil;
    if (self.praiseAnimationCache.count)
    {
        imageView = [self.praiseAnimationCache objectAtIndex:0];
        [self.praiseAnimationCache removeObject:imageView];
        imageView.frame = frame;
        imageView.hidden = NO;
    }
    else
    {
        imageView = [[UIImageView alloc ] initWithFrame:frame];
        imageView.image = self.praiseImageCache[arc4random()%self.praiseImageCache.count];
        [self.superview addSubview:imageView];
    }
    imageView.alpha = 0;
    
    [imageView.layer addAnimation:[self hearAnimationFrom:frame] forKey:nil];
    
    FWWeakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        FWStrongify(self)
        [self.praiseAnimationCache addObject:imageView];
        
    });
}
#endif

- (void)updateShowFunc
{
    
}

@end
