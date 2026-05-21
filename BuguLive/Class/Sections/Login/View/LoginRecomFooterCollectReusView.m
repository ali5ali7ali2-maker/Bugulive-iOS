//
//  LoginRecomFooterCollectReusView.m
//  BuguLive
//
//  Created by bugu on 2019/12/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "LoginRecomFooterCollectReusView.h"

@interface LoginRecomFooterCollectReusView ()

@property(nonatomic, strong) QMUIButton *changeBtn;
@property(nonatomic, strong) QMUIButton *goBtn;

@end
static NSString *const image_name_change = @"lr换一批";
static NSString *const image_name_go = @"lr进入按钮";

@implementation LoginRecomFooterCollectReusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    _changeBtn  = ({
        QMUIButton * btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:ASLocalizedString(@"换一批")forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:image_name_change] forState:UIControlStateNormal];
        btn.imagePosition = QMUIButtonImagePositionLeft;
        btn.spacingBetweenImageAndTitle = 2;
        [btn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    _goBtn  = ({
        QMUIButton * btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:ASLocalizedString(@"点击进入")forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:image_name_go] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    [self addSubview:_changeBtn];
    [self addSubview:_goBtn];
    
}
- (void)changeAction {
    
    if (self.changeBlock) {
        self.changeBlock();
    }
    
}

- (void)goAction {
    
    if (self.goBlock) {
        self.goBlock();
    }
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(44);
    }];
}




@end
