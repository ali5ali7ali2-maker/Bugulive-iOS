//
//  MGLoginView.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/7/16.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "MGLoginView.h"

@implementation MGLoginView{
    UILabel *_titleL;
    UITextField *_phoneT;
    UITextField *_confirmT;
    UIButton *_confirmBtn;
    
    UIView *_line1;
    UIView *_line2;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
        [self resetView];
        [self updateThirdLoginButton];
    }
    return self;
}

-(void)setUpView{
    
    self.bgImgView = [UIImageView new];
    self.bgImgView.image = [UIImage imageNamed:@"lg_new_bgImage"];
    [self addSubview:self.bgImgView];
    
    _titleL = [UILabel new];
    _titleL.font = [UIFont systemFontOfSize:17];
    _titleL.text = ASLocalizedString(@"手机号验证码登录");
    _titleL.textColor = [UIColor colorWithHexString:@"#CC45FF"];
    
    
    _phoneT = [UITextField new];
    _phoneT.font = [UIFont systemFontOfSize:15];
    _phoneT.placeholder = ASLocalizedString(@"请输入手机号");
    _phoneT.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneText = _phoneT;
    
    _confirmT = [UITextField new];
    _confirmT.font = [UIFont systemFontOfSize:15];
    _confirmT.placeholder = ASLocalizedString(@"请输入验证码");
    _confirmT.keyboardType = UIKeyboardTypeNumberPad;
    _codeText = _confirmT;
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:ASLocalizedString(@"获取验证码")forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#CC45FF"] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"mg_ig_CodeBtn"] forState:UIControlStateNormal];
    _confirmBtn.tag = 10;
    _codeBtn = _confirmBtn;
    
    _line1 = [UIView new];
    _line2 = [UIView new];
    _line1.backgroundColor = KMGLineColor;
    _line2.backgroundColor = KMGLineColor;
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:ASLocalizedString(@"立即登录")forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"mg_ig_LoginBtn"] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.tag = 11;
    
    self.wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wxLoginBtn setImage:[UIImage imageNamed:@"mg_ig_wxLoginBtn"] forState:UIControlStateNormal];
    [self.wxLoginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.wxLoginBtn.tag = 12;
    
    self.infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.infoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString *firstStr = ASLocalizedString(@"登录即代表同意");
    NSString *secondStr = ASLocalizedString(@"《用户隐私政策》");
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",firstStr,secondStr]];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#646464"] range:NSMakeRange(0,  firstStr.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFAD00"] range:NSMakeRange(firstStr.length,  secondStr.length)];
    self.infoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.infoBtn.tag = 13;
    [self.infoBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
    [self.infoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.otherL = [UILabel new];
    self.otherL.text = ASLocalizedString(@"-----其他方式登录-----");
    self.otherL.font = [UIFont systemFontOfSize:14];
    self.otherL.textAlignment = NSTextAlignmentCenter;
    self.otherL.textColor = [UIColor colorWithHexString:@"#666666"];
    
    self.loginView = [UIView new];
    
    self.qqBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.qqBtn setImage:[UIImage imageNamed:@"mg_login_qq"] forState:UIControlStateNormal];
    
    self.wxBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.wxBtn setImage:[UIImage imageNamed:@"mg_login_wx"] forState:UIControlStateNormal];
    self.wxBtn.tag = 12;
    [self.wxBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginView addSubview:self.qqBtn];
    [self.loginView addSubview:self.wxBtn];
    
    [self addSubview:_titleL];
    [self addSubview:_phoneT];
    [self addSubview:_confirmT];
    [self addSubview:_confirmBtn];
    [self addSubview:_line1];
    [self addSubview:_line2];
    [self addSubview:self.loginBtn];
    [self addSubview:self.wxLoginBtn];
    [self addSubview:self.infoBtn];
    [self addSubview:self.otherL];
    [self addSubview:self.loginView];
}

-(void)updateThirdLoginButton
{
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"init" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            
            //            [GlobalVariables sharedInstance].appModel.has_qq_login = 1;
            self.loginArr = [NSMutableArray array];
            if ([GlobalVariables sharedInstance].appModel.has_qq_login != 0) {
                [self.loginArr addObject:_qqBtn];
            }
            
            if ([GlobalVariables sharedInstance].appModel.has_wx_login != 0) {
                [self.loginArr addObject:_wxBtn];
            }
            
            self.loginView.frame = CGRectMake(0,self.otherL.bottom, kRealValue(335), kRealValue(50));
            
            self.loginView.width = self.loginArr.count *( 42 + 26);
            
            
            self.infoBtn.frame = CGRectMake(kRealValue(5), self.loginView.bottom + kRealValue(10), kRealValue(200), kRealValue(11));
            self.loginView.centerX = self.infoBtn.centerX = self.otherL.centerX = self.loginBtn.centerX = _line1.centerX;
            
            [self makeEqualWidthViews:self.loginArr inView:self.loginView LRpadding:5 viewPadding:0];
            
        }
        
    } FailureBlock:^(NSError *error) {
//        [weakSelf updateThirdLoginButton];
    }];
}

-(void)resetView{
    
    _titleL.frame = CGRectMake(kRealValue(10), kRealValue(28), kRealValue(200), kRealValue(20));
    _phoneT.frame = CGRectMake(kRealValue(10), _titleL.bottom + kRealValue(24), kRealValue(314), kRealValue(50));
    _line1.frame = CGRectMake(_phoneT.left, _phoneT.bottom, _phoneT.width, 1);
    
    _confirmT.frame = CGRectMake(kRealValue(10), _phoneT.bottom + kRealValue(25), kRealValue(220), kRealValue(50));
    _line2.frame = CGRectMake(_line1.left, _confirmT.bottom, _line1.width, 1);
    
    _confirmBtn.frame = CGRectMake(_confirmT.right, _confirmT.top, kRealValue(98), kRealValue(35));
    
    self.loginBtn.frame =  CGRectMake(_line1.left - kRealValue(5), _line2.bottom + kRealValue(30), kRealValue(187) ,kRealValue(52));
    //    self.wxLoginBtn.frame = CGRectMake(self.loginBtn.left, self.loginBtn.bottom + kRealValue(30), self.loginBtn.width, self.loginBtn.height);
    
    
    
    self.otherL.frame = CGRectMake(0, self.loginBtn.bottom + kRealValue(15), kRealValue(223), kRealValue(20));
    
    self.loginView.frame = CGRectMake(0,self.otherL.bottom, kRealValue(335), kRealValue(50));
    
    self.loginView.width = self.loginArr.count *( 42 + 26);
    
    
    self.infoBtn.frame = CGRectMake(kRealValue(5), self.loginView.bottom + kRealValue(10), kRealValue(200), kRealValue(11));
    self.loginView.centerX = self.infoBtn.centerX = self.otherL.centerX = self.loginBtn.centerX = _line1.centerX;
    
    
    
}

-(void)makeEqualWidthViews:(NSArray *)views inView:(UIView *)containerView LRpadding:(CGFloat)LRpadding viewPadding :(CGFloat)viewPadding
{
    UIView *lastView;
    for (UIView *view in views) {
        [containerView addSubview:view];
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(containerView);
                make.left.equalTo(lastView.mas_right).offset(viewPadding);
                make.width.equalTo(lastView);
            }];
        }else
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(containerView).offset(LRpadding);
                make.top.bottom.equalTo(containerView);
            }];
        }
        
        lastView=view;
    }
    
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(containerView).offset(-LRpadding);
        
    }];
}

-(void)btnClick:(UIButton *)sender{
    
    if (self.clickLoginBlock) {
        self.clickLoginBlock(sender.tag - 10);
    }
}

@end
