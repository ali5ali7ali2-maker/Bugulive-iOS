//
//  SignSuccessPopView.m
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "SignSuccessPopView.h"
@interface SignSuccessPopView ()
//@property(nonatomic, strong) UIView *bgView;
//@property(nonatomic, strong) UIButton *tipButton;
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *giftLabel;

@property(nonatomic, strong) UIImageView *successImageView;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) NSString *gift;
@property(nonatomic, strong) dismissBlock block;

@end

static NSString *const image_name_bg = @"签到成功背景";
static NSString *const image_name_success = @"签到成功";
static NSString *const image_name_btn = @"签到成功按钮";

@implementation SignSuccessPopView

+(void)showSignSuccessViewGift:(NSString *)gift WithComplete:(dismissBlock)complete{
    SignSuccessPopView *view=[[SignSuccessPopView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
   view.gift = gift;
   view.block = complete;
   [view pop];
    
}

- (void)setGift:(NSString *)gift{
    _gift = gift;
    _giftLabel.text = [NSString stringWithFormat:ASLocalizedString(@"恭喜获得%@个钻石"),gift];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
//    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    
    _bgImageView = ({
        UIImageView * iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:image_name_bg];
        iv.userInteractionEnabled = YES;
        iv;
    });
    
    _titleLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kWhiteColor;
        label.font = [UIFont boldSystemFontOfSize:22];
        label.text = ASLocalizedString(@"签到成功");
              label;
          });
    
    _giftLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kWhiteColor;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.text = @"";
              label;
          });
    _successImageView = ({
        UIImageView * iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:image_name_success];
        iv;
    });
     
       _closeButton = ({
           UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
           [btn setBackgroundImage:[UIImage imageNamed:image_name_btn] forState:UIControlStateNormal];
           [btn setTitle:ASLocalizedString(@"知道啦")forState:UIControlStateNormal];
           [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
           btn.titleLabel.font = [UIFont systemFontOfSize:14];
           [btn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
           btn;
       });

      
       [self addSubview:_bgImageView];
    [_bgImageView addSubview:_titleLabel];
    [_bgImageView addSubview:_giftLabel];
    [_bgImageView addSubview:_successImageView];
    
    [_bgImageView addSubview:_closeButton];

    
}

- (void)dismissAction{
    [self dismiss];
    !self.block?:self.block();
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(187);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(31);
         make.centerX.mas_equalTo(0);

     }];
    [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(64);
//           make.centerX.mas_equalTo(0);
            
        make.right.equalTo(_bgImageView).offset(-5);
        make.left.equalTo(_bgImageView).offset(5);

       }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.bottom.mas_equalTo(-20);
             make.centerX.mas_equalTo(0);

         }];
    
    [_successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-70);
                make.centerX.mas_equalTo(0);

            }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self]) {
        [self dismiss];
    }
}
-(void)pop
{
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [keyWindow addSubview:self];
    self.bgImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 animations:^{
        self.bgImageView.transform = CGAffineTransformIdentity;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }];
}
@end
