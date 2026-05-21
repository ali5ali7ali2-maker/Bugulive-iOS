//
//  RoomUserCell.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/1.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomUserCell.h"
#import "RoomUserInfo.h"
#import "RoomVoiceModel.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "SVGAHeader.h"
@interface RoomUserCell ()
{
    NSString *lastHeadImageUrl;
}
@property (weak, nonatomic) IBOutlet UIImageView *adminImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *adminView;
@property (weak, nonatomic) IBOutlet UIImageView *giftSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *borderImageView;
@property (weak, nonatomic) IBOutlet UIView *breathView;
@property (weak, nonatomic) IBOutlet UIImageView *muteImageView;
@property(nonatomic, strong) SVGAHeader *svgaHeader;

@property(nonatomic, strong) UIImageView *animateImageView;

@property(nonatomic, strong) CAShapeLayer *shapeLayer;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@property (weak, nonatomic) IBOutlet QMUIButton *nameBtn;

@property(nonatomic, strong) UIButton *glBtn;


@end

@implementation RoomUserCell
{
    YYAnimatedImageView *yyimg;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.font = [UIFont systemFontOfSize:11];
    self.nameLabel.textColor = kWhiteColor;
    self.giftView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.2];
    self.giftLabel.textColor = [UIColor colorWithHexString:@"#FB3F72"];
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
    
    self.nameLabel.hidden = YES;
    
    self.nameBtn.imagePosition = QMUIButtonImagePositionLeft;
    self.nameBtn.spacingBetweenImageAndTitle = 5;
    
    [self addSubview:self.glBtn];
    
    
    [self.glBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55+5);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(30.5);
        make.height.mas_equalTo(12);
    }];
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = NO;
    self.breathView.clipsToBounds = NO;
    
//    self.glBtn.centerX = self.centerX;
//    self.glBtn.top = 55;
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,30.5,12);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:204/255.0 blue:101/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:89/255.0 blue:152/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    [_glBtn.layer insertSublayer:gl atIndex:0];
//    yyimg = [[YYAnimatedImageView alloc] init];
//    yyimg.image = [YYImage imageNamed:@"mic_pppp.webp"];
//    
//    [self.breathView addSubview:yyimg];
//    [yyimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.breathView);
//        make.size.equalTo(self.breathView);
//    }];
    
}

- (void)giftViewAction:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCell:didClickGiftView:)]) {
        [self.delegate userCell:self didClickGiftView:tap.view];
    }
}

- (void)setModel:(RoomUserInfo *)model{
    _model = model;
    if (model.is_ban_voice.integerValue == 0) {
        self.muteImageView.hidden = !model.isMuted;
    }else{
        self.muteImageView.hidden = !model.is_ban_voice;
    }
    
    if(lastHeadImageUrl != model.headwear_url)
    {
        lastHeadImageUrl = model.headwear_url;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headwear_url]];
    }
    
//    if (model.face_img && model.face_img.length) {
//        if (!self.animateImageView.isAnimating) {
//            [self.contentView addSubview:self.animateImageView];
//            [self.animateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.iconImageView);
//            }];
//            [self.animateImageView setAnimatedImage:[FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.face_img]]]];
//            [self performSelector:@selector(dismissGif) withObject:nil afterDelay:3];
//        }
//    }
    if (model.user_id.intValue) {
        if (model.isMuted || model.is_ban_voice.integerValue) {
            self.breathView.hidden = YES;
            [self stopVolumeAnimation];
        }else{

            if (model.volume > 10) {
                self.breathView.hidden = NO;
            } else {
                self.breathView.hidden = YES;
            }
            [self volumeAnimation];
        }
    }else{
        self.breathView.hidden = YES;
        [self stopVolumeAnimation];
    }
}

- (void)dismissGif{
    self.model.face_img = @"";
//    [self.animateImageView stopAnimating];
    [self.animateImageView removeFromSuperview];
}

- (void)setWheatModel:(Wheat_Type_List *)wheatModel{
    _wheatModel = wheatModel;
//    if(wheatModel.totalVolume > 10)
//    {
//
//    }
    self.breathView.backgroundColor = kClearColor;
    if (wheatModel.even_wheat.user_id) {
        if (wheatModel.even_wheat.is_ban_voice) {
            self.breathView.hidden = YES;
            [self stopVolumeAnimation];
        }else{

            if (wheatModel.totalVolume > 10) {
                self.breathView.hidden = NO;
            } else {
                self.breathView.hidden = YES;
            }
            [self volumeAnimation];
        }
    }else{
        self.breathView.hidden = YES;
//        [self stopVolumeAnimation];
    }
    
//    self.breathView.hidden = YES;

    if (!_wheatModel.even_wheat.user_id) {
    

//        [self.iconImageView setImage:[UIImage imageNamed:wheatModel.type.integerValue == 1 ? @"upper_wheat" : @"apply"]];
        if (_model.location.intValue == 1 && self.is_open_guest) {
            [self.iconImageView setImage:[UIImage imageNamed:@"guest_haed"]];
            [self.linkLabel setText:ASLocalizedString(@"嘉宾位")];

        } else {

            [self.iconImageView setImage:[UIImage imageNamed:wheatModel.type == 1 ? @"mic_colck" : @"mic_up"]];
            [self.linkLabel setText:wheatModel.type == 0 ? ASLocalizedString(@"直接上麦") : ASLocalizedString(@"申请上麦")];


        }
        
        self.muteImageView.hidden = YES;
    }else{
        self.muteImageView.hidden = !wheatModel.even_wheat.is_ban_voice;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:wheatModel.even_wheat.head_image] placeholderImage:kDefaultPreloadHeadImg];
        
        if (wheatModel.face_img && wheatModel.face_img.length) {
            [self.contentView addSubview:self.animateImageView];
            [self.animateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.iconImageView);
            }];
            [self.animateImageView sd_setImageWithURL:[NSURL URLWithString:SafeStr(wheatModel.face_img)]];
            [self performSelector:@selector(dismissGif) withObject:nil afterDelay:3];

        }
    }
//
    if(lastHeadImageUrl != wheatModel.even_wheat.avatar_frame_url)
    {
        lastHeadImageUrl = wheatModel.even_wheat.avatar_frame_url;
        self.svgaHeader.headerUrl = wheatModel.even_wheat.avatar_frame_url;
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headwear_url]];
    }
//    self.headImageView
    
    
    self.adminImageView.hidden = !_model.is_admin.integerValue;
    if (wheatModel.even_wheat.nick_name) {
        [self.nameLabel setText:wheatModel.even_wheat.nick_name];
        [self.nameBtn setTitle:wheatModel.even_wheat.nick_name forState:UIControlStateNormal];
    }else{

        [self.nameBtn setTitle:[NSString stringWithFormat:@"%@",wheatModel.wheat_name] forState:UIControlStateNormal];

    }
    if (_model.is_vip.intValue) {
        [self.nameLabel setTextColor:kRedColor];
        [self.nameBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    }else{
//        [self.nameLabel setTextColor:[[UIColor colorWithHexString:@"D0FFFF"] colorWithAlphaComponent:0.5]];
        self.nameLabel.textColor = kWhiteColor;
        [self.nameBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];

    }
    
//    if (self.is_open_guest) {
//        [self.nameBtn setImage:nil forState:UIControlStateNormal];
//
//    }else{
//
//        if (_model.is_admin.integerValue) {
//            [self.nameBtn setImage:[UIImage imageNamed:@"administrators"] forState:UIControlStateNormal];
//        } else {
//            [self.nameBtn setImage:nil forState:UIControlStateNormal];
//
//        }
//    }
    
    if (_model.location.intValue == 1 && self.is_open_guest) {
        self.glBtn.hidden = NO;
    }else{
        self.glBtn.hidden = YES;
    }
    
    
    self.giftView.hidden = !_wheatModel.even_wheat.user_id;
    self.linkLabel.hidden = _model.user_id.integerValue;
    self.borderImageView.image = _model.user_id.integerValue ? [UIImage imageNamed:@"member_haed"] : nil;
    //显示信息
    self.giftSexImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.giftSexImageView.image = [UIImage imageNamed: _model.sex.integerValue == 1 ? @"hart1" : @"hart1"];
    if(_wheatModel.even_wheat.gift_earnings == 0)
    {
        self.giftLabel.text = @"0";
    }
    else
    {
        self.giftLabel.text = [NSString stringWithFormat:@"%ld",_wheatModel.even_wheat.gift_earnings];
    }
//    self.giftLabel.text = _model.gift_earnings;
//    if (KGlobalVariable.appmodel.voice_charm_type.intValue == 1) {
//        self.giftLabel.text = [NSString formatStringFromSum:_model.gift_earnings.length ? _model.gift_earnings : @"0.00"];
//    }else{
//        self.giftLabel.text = [NSString formatStringFromSum:_model.gift_earnings.length ? _model.gift_earnings : @"0"];
//    }
    
}

- (UIImageView *)animateImageView{
    if (!_animateImageView) {
        //        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"]]];
        _animateImageView = [[UIImageView alloc] init];
        //        imageView.animatedImage = image;
    }
    return _animateImageView;
}

#pragma mark - 水波纹

- (void)volumeAnimation{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = CGRectMake(0, 0, self.breathView.width, self.breathView.height);
        _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.breathView.width, self.breathView.height)].CGPath;
        _shapeLayer.fillColor = [UIColor colorWithHexString:@"#02E0C3"].CGColor;
        _shapeLayer.opacity = 0.0;
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = CGRectMake(0, 0, self.breathView.width, self.breathView.height);
        replicatorLayer.instanceDelay = 0.8;
        replicatorLayer.instanceCount = 5;
        replicatorLayer.cornerRadius = 40;
        [replicatorLayer addSublayer:_shapeLayer];
        self.breathView.layer.cornerRadius = 40;
        self.breathView.clipsToBounds = YES;
        [self.breathView.layer addSublayer:replicatorLayer];
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[[self alphaAnimation],[self scaleAnimation]];
        animationGroup.duration = 3;
        animationGroup.autoreverses = NO;
        animationGroup.repeatCount = HUGE;
        //页面跳转再返回后，动画是否停止
        animationGroup.removedOnCompletion = NO;
        [_shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];
    }
}

- (void)stopVolumeAnimation{
    [_shapeLayer removeAnimationForKey:@"animationGroup"];
    _shapeLayer = nil;
}

- (CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(1.0);
    alpha.toValue = @(0.0);
    return alpha;
}

- (CABasicAnimation *)scaleAnimation{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 0.0)];
    return scale;
}

- (UIButton *)glBtn{
    if (!_glBtn) {
        _glBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30.5, 12)];
        [_glBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
        [_glBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_glBtn setTitle:ASLocalizedString(@"嘉宾") forState:UIControlStateNormal];

        ViewRadius(_glBtn, 12/2.0);
        
//        [_glBtn setThemeGradientBgColor];
        _glBtn.hidden = YES;
        

     

    }
    return _glBtn;
}


@end
