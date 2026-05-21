//
//  RoomPopView.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/3.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomPopView.h"

@interface RoomPopView ()

@property(nonatomic, strong) UIView *shadowView;
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation RoomPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#2B2739"];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
//    [self insertSubview:self.bgImageView atIndex:0];
//    [self insertSubview:self.effectView atIndex:0];
}

- (void)show:(UIView *)superView{
    //从底部弹出。与hide后  frame一致
    self.top = superView.height;
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.left, superView.height - strongSelf.height, strongSelf.width, strongSelf.height);
    }];
}

- (void)hide{
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.left, self.superview.height, strongSelf.width, strongSelf.height);
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.shadowView removeFromSuperview];
        [strongSelf removeFromSuperview];
    }];
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.4];
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgImageView.image = [UIImage imageNamed:@"live_bckgrund"];
    }
    return _bgImageView;
}

- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc]initWithFrame:self.bounds];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView.effect = blur;
    }
    return _effectView;
}

- (void)setVagueImgUrl:(NSString *)vagueImgUrl{
    _vagueImgUrl = vagueImgUrl;
    [self vagueBackGround];
}
- (void)vagueBackGround
{
    
    if (!_vagueImgView) {
        
            _vagueImgView = [[UIImageView alloc] initWithFrame:self.bounds];
            if (_vagueImgUrl && ![_vagueImgUrl isEqualToString:@""])
            {
                [_vagueImgView sd_setImageWithURL:[NSURL URLWithString:_vagueImgUrl]];
            }
            else
            {
                [_vagueImgView setImage:[UIImage imageNamed:@"background"]];
            }
            [self addSubview:_vagueImgView];
            [self insertSubview:_vagueImgView atIndex:0];
        //    [self.faceView bringSubviewToFront:_vagueImgView];
            self.backgroundColor = [UIColor clearColor];
            
            UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            
            UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:beffect];
            
            effectview.frame = self.bounds;
            
            [_vagueImgView addSubview:effectview];
        
        
    } else {
        [_vagueImgView sd_setImageWithURL:[NSURL URLWithString:_vagueImgUrl]];

    }
    
    

}


@end
