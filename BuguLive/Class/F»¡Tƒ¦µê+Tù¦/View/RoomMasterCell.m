//
//  RoomMasterCell.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/2.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomMasterCell.h"
#import "RoomUserInfo.h"
#import "RoomVoiceModel.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "SVGAHeader.h"

@interface RoomMasterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *borderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *breathView;
@property (weak, nonatomic) IBOutlet UIImageView *muteImageView;

@property(nonatomic, strong) FLAnimatedImageView *animateImageView;
@property(nonatomic, strong) SVGAHeader *svgaHeader;

@property (weak, nonatomic) IBOutlet UIView *offlineView;
@property (weak, nonatomic) IBOutlet UILabel *offlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIImageView *masterImageView;

@property(nonatomic, strong) UIButton *glBtn;
@property(nonatomic, strong) CAGradientLayer *gl;

@end

@implementation RoomMasterCell
{
    NSString *lastHeadImageUrl;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.font = [UIFont systemFontOfSize:11];
    self.offlineView.userInteractionEnabled = NO;
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userAction:)];
    [self.iconImageView addGestureRecognizer:tap1];
    
    for (UIView *subView in self.contentView.subviews) {
        NSLog(@"func:%s class:%@ address:%@",__func__,subView.className,subView);
    }
    self.giftView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(giftViewAction:)];
    [self.giftView addGestureRecognizer:tap];
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconImageView);
        make.size.mas_equalTo(50*headdressRatio);
    }];
    
    self.svgaHeader = [[SVGAHeader alloc] init];
    self.svgaHeader.userInteractionEnabled = NO;
    [self.headImageView addSubview:self.svgaHeader];
    [self.svgaHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headImageView);
    }];
    
//    self.giftView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.2];
//    self.giftLabel.textColor = [UIColor colorWithHexString:@"#FB3F72"];
//
    self.giftView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.08];
    self.giftLabel.textColor = [UIColor colorWithHexString:@"#CDCDCD"];
    
    
    [self.contentView addSubview:self.glBtn];
    
//    self.glBtn.centerX = self.centerX;
//    self.glBtn.top = 55;
    [self.glBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55+5);
        make.centerX.equalTo(self.iconImageView);
        make.width.mas_equalTo(30.5);
        make.height.mas_equalTo(12);

    }];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,30.5,12);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#7833FE"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#AD1BFB"].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    [_glBtn.layer insertSublayer:gl atIndex:0];
    self.gl = gl;
    
    self.masterImageView.hidden = YES;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
    }];
    
    
    self.offlineView.hidden = YES;
}

- (void)userAction:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterCell:didClickUser:)]) {
        [self.delegate masterCell:self didClickUser:self.model];
    }
}
- (void)giftViewAction:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterCell:didClickGiftView:)]) {
        [self.delegate masterCell:self didClickGiftView:tap.view];
    }
}

- (void)setIs_open_guest:(BOOL)is_open_guest{
    _is_open_guest = is_open_guest;
//    self.glBtn.hidden = !is_open_guest;
    
    if (is_open_guest) {
//        self.gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:95/255.0 blue:219/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:156/255.0 green:102/255.0 blue:255/255.0 alpha:1.0].CGColor];

    } else {
        
//        self.gl.colors= @[(__bridge id)[UIColor colorWithRed:255/255.0 green:204/255.0 blue:101/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:89/255.0 blue:152/255.0 alpha:1.0].CGColor];
    }
    
}

- (void)setModel:(RoomUserInfo *)model{
    _model = model;
    if (model.user_id.integerValue) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:nil];
        
        if(lastHeadImageUrl != model.headwear_url)
        {
            lastHeadImageUrl = model.headwear_url;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headwear_url]];

        }
        
        self.nameLabel.text = model.nick_name;

    }else{
        self.nameLabel.text = ASLocalizedString(@"主持位");
    }
//    self.masterView.hidden = !model.user_id.integerValue;
    self.giftView.hidden = !_wheatModel.even_wheat.user_id;
    self.circleImageView.image = model.user_id.integerValue ? [UIImage imageNamed:@"master_speech1"] : nil;
    self.borderImageView.image = model.user_id.integerValue ? [UIImage imageNamed:@"master_haed"] : nil;
   
    
//    self.masterImageView.hidden = self.is_open_guest;
//    self.nameLabel.text = model.user_nickname;

//    if (self.is_open_guest) {
//        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(5);
//        }];
//    } else {
//        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(5+14+5);
//        }];
//    }
    
    self.giftSexImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.giftSexImageView.image = [UIImage imageNamed: model.sex.integerValue == 1 ? @"hart1" : @"hart1"];
    self.breathView.image = [UIImage imageNamed: model.sex.integerValue == 1 ? @"yt" : @"yu"];
    
    //有时候没数据
    if (StrValid(_model.gift_earnings)) {
        self.giftLabel.text = _model.gift_earnings;
    } else {
   
            self.giftLabel.text = @"0";
        
    }
    

//    self.giftLabel.text = [NSString formatStringFromSum:_model.gift_earnings.length ? _model.gift_earnings : @"0"];
    if (model.is_ban_voice.integerValue == 0) {
        self.muteImageView.hidden = !model.isMuted;
    }else{
        self.muteImageView.hidden = !model.is_ban_voice;
    }
    if (model.face_img && model.face_img.length) {
        if (!self.animateImageView.isAnimating) {
            [self.contentView addSubview:self.animateImageView];
            [self.animateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.iconImageView);
            }];
            [self.animateImageView setAnimatedImage:[FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.face_img]]]];
            [self performSelector:@selector(dismissGif) withObject:nil afterDelay:3];
        }
    }
    if (model.volume > 10) {
        self.breathView.hidden = NO;
        CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
        animation.autoreverses = YES;
        animation.duration = 1;//动画循环的时间，也就是呼吸灯效果的速度
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.breathView.layer addAnimation:animation forKey:@"breath"];
    }else{
        self.breathView.hidden = YES;
        [self.breathView.layer removeAnimationForKey:@"breath"];
    }
    
//    self.offlineView.hidden = model.is_room.intValue;
   
    if (self.is_open_guest) {
        
        if (model.user_id.integerValue) {
          
        }else{
            self.headImageView.image = nil;
            self.iconImageView.image = [UIImage imageNamed:@"master_haed_rod"];
        }
        
    }else{
        ;
        if ([[IMAPlatform sharedInstance].host.userId isEqualToString:model.user_id]) {
            
//            self.offlineView.hidden = YES;

        } else {

            if (model.is_room.intValue == 1 || model.status.intValue == 1) {
//                self.offlineView.hidden = YES;
            }else{
//                self.offlineView.hidden = NO;
                
//                self.iconImageView.image = [UIImage imageNamed:@"master_haed11"];
                self.iconImageView.image = [UIImage imageNamed:@"master_haed_rod"];

                
//                self.iconImageView.image = nil;
                self.headImageView.image = nil;
            }
            
        }
        
        
    }
    
//    if (model.status.intValue == 3) {
//        self.offlineView.hidden = NO;
//    }else if (model.status.intValue == 1){
//        self.offlineView.hidden = YES;
//
//    }
//
//    if (model.is_room.intValue == 1) {
//        self.offlineView.hidden = YES;
//    } else {
//        self.offlineView.hidden = NO;
//
//    }
    
//    self.nameLabel.textColor = [UIColor colorWithHexString:model.is_room.intValue ? @"#FFFFFF" : @"999999"];
}

- (void)dismissGif{
    self.wheatModel.face_img = @"";
    [self.animateImageView stopAnimating];
    [self.animateImageView removeFromSuperview];
}

- (void)setWheatModel:(Wheat_Type_List *)wheatModel{
    _wheatModel = wheatModel;
    if (!wheatModel.even_wheat.user_id) {

        if (self.is_open_guest) {
            self.iconImageView.image = [UIImage imageNamed:@"master_haed_rod"];
        }else{
//            self.iconImageView.image = [UIImage imageNamed:@"master_haed11"];
            self.iconImageView.image = [UIImage imageNamed:@"master_haed_rod"];

//            [self.iconImageView setImage:[UIImage imageNamed:wheatModel.type == 0 ? @"upper_wheat" : @"apply"]];
            self.headImageView.image = nil;
            self.nameLabel.text = ASLocalizedString(@"主持位");
        }
        self.muteImageView.hidden = YES;
    }
    else
    {
        self.muteImageView.hidden = !wheatModel.even_wheat.is_ban_voice;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:wheatModel.even_wheat.head_image] placeholderImage:kDefaultPreloadHeadImg];

        if (wheatModel.face_img && wheatModel.face_img.length) {
            if (!self.animateImageView.isAnimating) {
                [self.contentView addSubview:self.animateImageView];
                [self.animateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.iconImageView);
                }];
                [self.animateImageView setAnimatedImage:[FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:wheatModel.face_img]]]];
                [self performSelector:@selector(dismissGif) withObject:nil afterDelay:3];
            }
        }
        
    }
    
    
    if (wheatModel.even_wheat.nick_name) {
        [self.nameLabel setText:wheatModel.even_wheat.nick_name];
    }else{


    }

    self.giftView.hidden = !_wheatModel.even_wheat.user_id;
    //有时候没数据
    if (wheatModel.even_wheat.gift_earnings) {
        self.giftLabel.text = [NSString stringWithFormat:@"%ld",(long)wheatModel.even_wheat.gift_earnings];
    } else {
   
            self.giftLabel.text = @"0";
        
    }
    self.giftSexImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.giftSexImageView.image = [UIImage imageNamed:@"hart1"];
    
    if(lastHeadImageUrl != wheatModel.even_wheat.avatar_frame_url)
    {
        lastHeadImageUrl = wheatModel.even_wheat.avatar_frame_url;
        self.svgaHeader.headerUrl = wheatModel.even_wheat.avatar_frame_url;
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headwear_url]];
    }
    
    
}

- (FLAnimatedImageView *)animateImageView{
    if (!_animateImageView) {
        //        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"]]];
        _animateImageView = [[FLAnimatedImageView alloc] init];
        //        imageView.animatedImage = image;
    }
    return _animateImageView;
}


- (UIButton *)glBtn{
    if (!_glBtn) {
        
        _glBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30.5, 12)];
        [_glBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
        [_glBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_glBtn setTitle:ASLocalizedString(@"主持") forState:UIControlStateNormal];
        ViewRadius(_glBtn, 12/2.0);
        
//        [_glBtn setThemeGradientBgColor];
//        _glBtn.hidden = YES;
  

    }
    return _glBtn;
}

@end
