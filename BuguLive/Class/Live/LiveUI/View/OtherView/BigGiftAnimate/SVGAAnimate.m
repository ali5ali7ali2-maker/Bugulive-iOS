//
//  SVGAAnimate.m
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/26.
//  Copyright © 2017年 voidcat. All rights reserved.
//

#import "SVGAAnimate.h"

static SVGAParser *parser;
@interface SVGAAnimate ()<SVGAPlayerDelegate>
{
    CGFloat _top;
    NSString *_senderName;
    
    NSURL *svgUrl;
    UIImageView *rankImgView;
    UILabel *userNameLabel;
    UILabel *contentlab;
}

@property (nonatomic, weak)IBOutlet FLAnimatedImageView *gifImage;
@property (nonatomic, weak)IBOutlet UILabel *nickLabel;
@property (nonatomic, assign) NSUInteger currentLoopIndex;   // 当前循环的次数
@property (nonatomic, strong) SVGAPlayer *aPlayer;


@end

@implementation SVGAAnimate

- (id)initWithModel:(CustomMessageModel*)gift inView:(UIView*)superView andSenderName:(NSString *)senderName
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SVGAAnimate" owner:self options:nil] lastObject];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _nickLabel.hidden = YES;
        [superView addSubview:self];
        [superView sendSubviewToBack:self];
        
        _senderName = senderName;
        
        [self cfgWithGift:gift andTop:0];
    }
    return self;
}

+ (void)showGift:(CustomMessageModel *)gift inVc:(UIViewController *)vc
{
//    SVGAAnimate *xx = [[NSBundle mainBundle] loadNibNamed:@"SVGAAnimate" owner:nil options:nil].firstObject;
//    xx.backgroundColor = [UIColor clearColor];
//    [vc.view addSubview:xx];
//
//    [xx cfgWithGift:gift andTop:0];
}

- (void)cfgWithGift:(CustomMessageModel*)gift andTop:(CGFloat)top
{
    _giftItem = gift;
    _top = top;
    
    __weak typeof(self) ws = self;

    parser = [[SVGAParser alloc] init];

    
    [parser parseWithURL:[NSURL URLWithString:gift.animated_url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        self.aPlayer.videoItem = videoItem;

        dispatch_async(dispatch_get_main_queue(), ^{
            [ws setUpView:gift];
        });
        

        //图片下载完成  在这里进行相关操作，如加到数组里 或者显示在imageView上
//        if (ws.giftItem.delay_time)
//        {
//            ws.hidden = YES;
//            [ws performSelector:@selector(setUpView:) withObject:gift afterDelay:_giftItem.delay_time/1000];
//        }
//        else
//        {
//            [ws setUpView:gift];
//        }
    } failureBlock:^(NSError * _Nullable error) {
        [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:ASLocalizedString(@"svga播放错误%@"),error]];
    }];
}

- (void)setUpView:(CustomMessageModel*)gift
{
    self.hidden = NO;
    
    [self setUserInteractionEnabled:NO];
    
    CGRect pRect = self.superview.frame; //superview的frame
    CGRect vRect = self.gifImage.frame; //gifImage的frame
    CGSize size = self.gifImage.currentFrame.size; //图片的size
    CGFloat imageScale = size.width/size.height; //图片宽高比
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    if ((size.width-pRect.size.width) > 0 && (size.height-pRect.size.height) > 0)
    { //如果图片的宽、高都超过的屏幕宽、高
        if ((size.width-pRect.size.width) > (size.height-pRect.size.height))
        {
            w = pRect.size.width;
            h = w / imageScale;
        }
        else
        {
            h = pRect.size.height;
            w = h * imageScale;
        }
    }
    else if ((size.width-pRect.size.width) > 0 && (size.height-pRect.size.height) < 0)
    { //如果图片的宽超过的屏幕宽，但是高小于屏幕的高
        w = pRect.size.width;
        h = w / imageScale;
    }
    else if ((size.width-pRect.size.width) < 0 && (size.height-pRect.size.height) > 0)
    { //如果图片的高超过的屏幕高，但是宽小于屏幕的宽
        h = pRect.size.height;
        w = h * imageScale;
    }
    vRect.size = CGSizeMake(w, h);
    self.gifImage.frame = vRect;
    size = vRect.size;
    
//    if (_giftItem.show_user == 0)
//    {
//        _nickLabel.hidden = YES;
//        _nickLabel.text = @"";
//    }
//    else
//    {
        _nickLabel.hidden = NO;
        [self bringSubviewToFront:_nickLabel];
        size.height += _nickLabel.frame.size.height;
        _nickLabel.text = _senderName;
//    }
    
    CGRect rect = CGRectMake((pRect.size.width-size.width)/2, _top, size.width, size.height);
    
    //0：使用path路径；1：屏幕上部；2：屏幕中间；3：屏幕底部
    if (_giftItem.type == 0)
    {
        
    }
    else if(_giftItem.type == 1)
    {
        rect.origin.y = 0;
    }
    else if(_giftItem.type == 2)
    {
        rect.origin.y = (pRect.size.height - size.height)/2;
    }
    else if(_giftItem.type == 3)
    {
        rect.origin.y = pRect.size.height - size.height;
    }
    self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.aPlayer.delegate = self;
    self.aPlayer.frame = self.bounds;
    self.aPlayer.loops = 1;
    self.aPlayer.clearsAfterStop = YES;
    [self addSubview:self.aPlayer];
    [self layoutIfNeeded];
    
    [self.aPlayer startAnimation];
}

-(void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    [self dismissSelf];
    
}
- (void)dismissSelf
{
    [UIView animateWithDuration:0.01 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (_delegate && [_delegate respondsToSelector:@selector(gifImageViewFinish:andSenderName:)]) {
//            _giftItem.isFinishAnimate = YES;
            [_delegate SVGAViewFinish:_giftItem andSenderName:_senderName];
//            [_delegate gifImageViewFinish:_giftItem andSenderName:_senderName];
        }
    }];
}

- (SVGAPlayer *)aPlayer {
    if (_aPlayer == nil) {
        _aPlayer = [[SVGAPlayer alloc] init];
        _aPlayer.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _aPlayer;
}


@end
