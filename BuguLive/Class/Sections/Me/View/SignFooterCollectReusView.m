//
//  SignFooterCollectReusView.m
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "SignFooterCollectReusView.h"

@interface SignFooterCollectReusView ()



@end
static NSString *const image_name_btn = @"签到按钮";

@implementation SignFooterCollectReusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
  
    
    _signBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:image_name_btn] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];

            [btn setTitle:ASLocalizedString(@"立即签到")forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn addTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchUpInside];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = kRealValue(22);
            btn;
        });

       
        [self addSubview:_signBtn];
    
    
}

- (void)signAction{
    
    !self.signBlock ? : self.signBlock();

}
- (void)layoutSubviews {
    [super layoutSubviews];
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kRealValue(188), kRealValue(40)));
    }];
}

- (void)setAlreadySign:(BOOL)alreadySign{
    _alreadySign = alreadySign;
//    _signBtn.selected = alreadySign;
    if (alreadySign) {
      
        _signBtn.backgroundColor = [UIColor colorWithHexString:@"#C0C0C0"];
        [_signBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _signBtn.userInteractionEnabled = NO;
        [_signBtn setTitle:ASLocalizedString(@"已签到") forState:UIControlStateNormal];
    } else {
        _signBtn.userInteractionEnabled = YES;

        [_signBtn setBackgroundImage:[UIImage imageNamed:image_name_btn] forState:UIControlStateNormal];

        _signBtn.backgroundColor = [UIColor clearColor];;
        [_signBtn setTitle:ASLocalizedString(@"立即签到") forState:UIControlStateNormal];
    }
    
}


@end
