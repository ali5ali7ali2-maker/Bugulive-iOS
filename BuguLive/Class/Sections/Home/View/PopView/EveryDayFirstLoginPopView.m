//
//  EveryDayFirstLoginPopView.m
//  BuguLive
//
//  Created by bugu on 2019/11/30.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "EveryDayFirstLoginPopView.h"

@interface EveryDayFirstLoginPopView ()
//@property(nonatomic, strong) UIView *bgView;
//@property(nonatomic, strong) UIButton *tipButton;
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *titleImageView;
@property(nonatomic, strong) UILabel *scoreLabel;

@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) NSString *score;
@property(nonatomic, strong) dismissBlock block;

@end

static NSString *const image_name_bg = @"首次弹窗背景";
static NSString *const image_name_success = @"每日首次登录奖励";
static NSString *const image_name_btn = @"知道了按钮";

@implementation EveryDayFirstLoginPopView

+(void)showEveryDayFirstLoginViewScore:(NSString *)score WithComplete:(dismissBlock)complete{
    EveryDayFirstLoginPopView *view=[[EveryDayFirstLoginPopView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
       view.score = score;
       view.block = complete;
       [view pop];
    
}
- (void)setScore:(NSString *)score{
    _score = score;
//    _scoreLabel.text = [NSString stringWithFormat:ASLocalizedString(@"+%@经验"),score];
    NSString * str = [NSString stringWithFormat:ASLocalizedString(@"+%@经验"),score];

  NSMutableAttributedString *attribute =  [[NSMutableAttributedString alloc]initWithString:str];
    
    
    [attribute setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  range:NSMakeRange(str.length-2, 2)];
    [_scoreLabel setAttributedText:attribute];

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
    
    _titleImageView = ({
           UIImageView * iv = [[UIImageView alloc] init];
           iv.image = [UIImage imageNamed:image_name_success];
           iv;
       });
    _scoreLabel = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#9D21FE"];
        label.font = [UIFont boldSystemFontOfSize:36];
        label.text = @"";
              label;
          });
   
     
       _closeButton = ({
           UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
           [btn setBackgroundImage:[UIImage imageNamed:image_name_btn] forState:UIControlStateNormal];
           [btn setTitle:ASLocalizedString(@"我知道了")forState:UIControlStateNormal];
           [btn setTitleColor:[UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
           btn.titleLabel.font = [UIFont systemFontOfSize:18];
           [btn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
           btn;
       });

      
       [self addSubview:_bgImageView];
    [_bgImageView addSubview:_titleImageView];
    [_bgImageView addSubview:_scoreLabel];
    [_bgImageView addSubview:_closeButton];

    
}

- (void)dismissAction{
    [self dismiss];
    !self.block?:self.block();
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(190);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(24);
         make.centerX.mas_equalTo(0);

     }];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(_titleImageView.mas_bottom).offset(14);
           make.centerX.mas_equalTo(0);

   }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.bottom.mas_equalTo(-20);
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
