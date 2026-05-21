//
//  BGLoginView.m
//  BuguLive
//
//  Created by bugu on 2019/12/10.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGLoginView.h"
#import <QMUIKit/QMUIKit.h>
@interface BGLoginView ()<UITextFieldDelegate,NLgDelegate>

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) UIView *loginBgView;

@property(nonatomic, strong) UILabel *countryTipLabel;
@property(nonatomic, strong) UIView *countryView;
@property(nonatomic, strong) UIImageView *countryBgImageView;
@property(nonatomic, strong) UIImageView *countryImageView;
@property(nonatomic, strong) UILabel *countryLabel;

@property(nonatomic, strong) UILabel *phoneTipLabel;
@property(nonatomic, strong) UIImageView *phoneBgImageView;
@property(nonatomic, strong) UITextField *mobileTF;
@property(nonatomic, strong) UILabel *phoneLabel;


@property(nonatomic, strong) UILabel *codeTipLabel;
@property(nonatomic, strong) UIImageView *codeBgImageView;
@property(nonatomic, strong) UITextField *codeTF;
@property(nonatomic, strong) UIButton *codeButton;

@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UIButton *infoBtn;
//第三方登录
@property(nonatomic, strong) UILabel *otherLoginL;
@property(nonatomic, strong) ULGView *LView;

@property(nonatomic, strong) UIButton *vistorBtn;
@property(nonatomic, strong) UIButton *registerBtn;

@property(nonatomic, strong) UIButton *forgetBtn;//忘记密码

@end

static NSString *const image_name_bg = @"log背景";
static NSString *const image_name = @"";
static NSString *const image_name_layer_country = @"log选中输入框";
static NSString *const image_name_layer_phone = @"log手机号输入";
static NSString *const image_name_layer_code = @"log输入验证码";

static NSString *const image_name_phone = @"log手机号";
static NSString *const image_name_code = @"log验证码";

static NSString *const image_name_login = @"mg_button_global";




@implementation BGLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _bgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image_name_bg];
        imageView;
    });
    
    [self addSubview:_bgImageView];
    
    _loginBgView = ({
        UIView * view = [[UIView alloc]init];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.backgroundColor = kWhiteColor;
        view;
    });
    [self addSubview:_loginBgView];
    
    _iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = kDefaultPreloadHeadImg;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 40;
        imageView;
    });
    _iconImageView.hidden = YES;
    [self addSubview:_iconImageView];
    
    _countryTipLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = ASLocalizedString(@"国家和地区");
        label;
    });
    _countryBgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image_name_layer_country];
        imageView;
    });
    
    
    _countryImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:ASLocalizedString(@"中国")];
        imageView;
    });
    _countryLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:14];
        label.text = ASLocalizedString(@"中国");
        label;
    });
    [_loginBgView addSubview:_countryTipLabel];
    [_loginBgView addSubview:_countryBgImageView];
    [_countryBgImageView addSubview:_countryImageView];
    [_countryBgImageView addSubview:_countryLabel];
    _countryTipLabel.hidden = _countryBgImageView.hidden = YES;
    
    
    _phoneTipLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = ASLocalizedString(@"手机号");
        label;
    });
    _phoneBgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image_name_layer_phone];
        imageView;
    });
    
    _mobileTF = ({
        UITextField *TF = [[UITextField alloc] init];
        TF.placeholder = ASLocalizedString(@"请输入您的手机号");
//        @"+1";
        TF.keyboardType = UIKeyboardTypeNumberPad;
        TF.leftViewMode = UITextFieldViewModeAlways;
        TF.delegate = self;
        TF.font = [UIFont systemFontOfSize:15];;
        TF.leftView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image_name_phone]];
            iv.frame = CGRectMake(-5, 0, 30, 30);
            iv.contentMode = UIViewContentModeCenter;
            [view addSubview:iv];
            view;
        });
        [TF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        TF;
    });
    
    _phoneLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:14];
        label.text = ASLocalizedString(@"请输入您的手机号");
        label.textAlignment = NSTextAlignmentRight;
        label;
    });
    
    _phoneLabel.hidden = YES;
    _phoneBgImageView.userInteractionEnabled = YES;
    [_loginBgView addSubview:_phoneTipLabel];
    [_loginBgView addSubview:_phoneBgImageView];
    [_phoneBgImageView addSubview:_phoneLabel];
    [_phoneBgImageView addSubview:_mobileTF];
    
    
    
    
    
    _codeTipLabel= ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = ASLocalizedString(@"密码");
        label;
    });
    _codeBgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image_name_layer_phone];
        imageView;
    });
    
    _codeTF = ({
        UITextField *TF = [[UITextField alloc] init];
        TF.placeholder =ASLocalizedString(@"请输入密码");
//        TF.keyboardType = UIKeyboardTypeNumberPad;
        
        TF.leftViewMode = UITextFieldViewModeAlways;
        TF.delegate = self;
        TF.secureTextEntry = YES;
        TF.clearButtonMode = UITextFieldViewModeWhileEditing;
        TF.font = [UIFont systemFontOfSize:15];;
        TF.leftView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image_name_code]];
            iv.frame = CGRectMake(-5, 0, 30, 30);
            iv.contentMode = UIViewContentModeCenter;
            [view addSubview:iv];
            view;
        });
        TF;
    });
    
    _codeButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:ASLocalizedString(@"获取验证码") forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10;
        btn;
    });
    
    _codeBgImageView.userInteractionEnabled = YES;
    [_loginBgView addSubview:_codeTipLabel];
    [_loginBgView addSubview:_codeBgImageView];
    [_codeBgImageView addSubview:_codeTF];
    _codeButton.hidden = YES;
    [_codeBgImageView addSubview:_codeButton];
    
    _forgetBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:ASLocalizedString(@"忘记密码") forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(clickForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [_loginBgView addSubview:self.forgetBtn];
    
    _loginBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:image_name_login] forState:UIControlStateNormal];
        
        [btn setTitle:ASLocalizedString(@"登录") forState:UIControlStateNormal];
        
        [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//         [UIColor colorWithHexString:@"#CD49FF"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 11;
        btn;
    });
    
    [_loginBgView addSubview:_loginBtn];
    
    
    NSString *firstStr = ASLocalizedString(@"登录即代表你同意");
    NSString *secondStr = ASLocalizedString(@"《用户隐私政策》");
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",firstStr,secondStr]];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFFFFF"] range:NSMakeRange(0,  firstStr.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#DE88FF"] range:NSMakeRange(firstStr.length,  secondStr.length)];
    
    
    
    
    _infoBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setAttributedTitle:attributeString forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 13;
        btn;
    });
    [self addSubview:_infoBtn];
    
    _otherLoginL = ({
        UILabel * label = [[UILabel alloc]init];
        label.textColor = kWhiteColor;
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = ASLocalizedString(@"其他登录方式");
        label;
    });
    [self addSubview:_otherLoginL];
    
    _vistorBtn =({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:ASLocalizedString(@"游客身份登录") forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(clickVistor:) forControlEvents:UIControlEventTouchUpInside];
        btn;
   });
    _vistorBtn.hidden = YES;
    [_loginBgView addSubview:_vistorBtn];
    
    _registerBtn =({
         UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
         [btn setTitle:ASLocalizedString(@"注册") forState:UIControlStateNormal];
         [btn setTitleColor:kAppNewMainColor forState:UIControlStateNormal];
         btn.titleLabel.font = [UIFont systemFontOfSize:15];
         [btn addTarget:self action:@selector(clickRegister:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
         btn;
    });
    [_loginBgView addSubview:_registerBtn];
    
    [self loginWay];
    
    self.codeBtn = self.codeButton;
    self.phoneText = self.mobileTF;
    self.codeText = self.codeTF;
}

//iOS 13以上
-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField == self.mobileTF) {
        if (textField.text.length > 11) {
            [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
            self.mobileTF.text = [self.mobileTF.text substringToIndex:11];
        }
    }
}
//iOS 13以下
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.mobileTF) {
        if (textField.text.length > 11) {
            [FanweMessage alertHUD:ASLocalizedString(@"手机号限制11位数!")];
            self.mobileTF.text = [self.mobileTF.text substringToIndex:11];
        }
    }
}

-(void)clickVistor:(UIButton *)sender{
    if (self.clickVistorBlock) {
        self.clickVistorBlock(YES);
    }
}

-(void)clickRegister:(UIButton *)sender{
    if (self.clickReigsterBlock) {
        self.clickReigsterBlock(YES);
    }
}

-(void)clickForgetPassword:(UIButton *)sender{
    if (self.clickForgetPWBlock) {
        self.clickForgetPWBlock(YES);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
     [_infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           if(IS_47INCH_SCREEN)
           {
               make.bottom.mas_equalTo(-kRealValue(5)-(IPHONE_X ? 34 : 0));
           }
           else
           {
               make.bottom.mas_equalTo(-kRealValue(52)-(IPHONE_X ? 34 : 0));
           }
         make.centerX.mas_equalTo(0);
     }];
    
    [_loginBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kRealValue(144));
        make.left.mas_equalTo(28);
        make.height.mas_equalTo(372);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(_loginBgView.mas_top);
        make.width.height.mas_equalTo(80);
    }];
    
    [_countryTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.top.mas_equalTo(31);
    }];
    
    [_countryBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countryTipLabel.mas_bottom).offset(9);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    
    [_countryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(23);
    }];
    
    [_countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_countryImageView.mas_right).offset(14);
        make.centerY.mas_equalTo(0);
    }];
    
    [_phoneTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
//        equalTo(_countryBgImageView.mas_bottom).offset(21);
        make.left.mas_equalTo(21);
    }];
    
    [_phoneBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTipLabel.mas_bottom).offset(9);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    
    
    [_mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealValue(14));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(kRealValue(40));
        make.right.mas_equalTo(-10);
    }];
    
    
    [_codeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneBgImageView.mas_bottom).offset(21);
        make.left.mas_equalTo(21);
        
    }];
    
    [_codeBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeTipLabel.mas_bottom).offset(9);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(kRealValue(100));
    }];
    
    [_codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealValue(14));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        equalTo(_codeButton.mas_left).offset(-4);
//        make.width.mas_equalTo(kRealValue(180));
        make.height.mas_equalTo(kRealValue(40));
    }];
    
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_forgetBtn.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(241);
        make.height.mas_equalTo(44);
    }];
    _loginBtn.layer.cornerRadius = 44 / 2;
    _loginBtn.layer.masksToBounds = YES;
    
    [_otherLoginL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_loginBgView.mas_bottom).offset(15);
        make.height.mas_equalTo(44);
    }];
    
    [self.LView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_otherLoginL.mas_bottom).offset(15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kRealValue(44));
    }];
    
    [_vistorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_loginBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(self.loginBgView.mas_width).multipliedBy(0.5);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_forgetBtn.mas_right);
        make.top.mas_equalTo(_loginBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
//        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.loginBgView.mas_width).multipliedBy(0.4);
    }];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_codeBgImageView.mas_right);
        make.height.mas_equalTo(kRealValue(40));
        make.top.mas_equalTo(_codeBgImageView.mas_bottom).offset(10);
    }];
}


#pragma mark 登入方式 0qq 1微信 2微博 3手机
- (void)loginWay
{
    NSMutableArray *array = [NSMutableArray array];
    if ([GlobalVariables sharedInstance].appModel.has_qq_login == 1)//QQ
    {
        [array addObject:@"1"];
    }
    
    if ([GlobalVariables sharedInstance].appModel.has_wx_login == 1)//微信
    {
        [array addObject:@"2"];
    }

    if ([GlobalVariables sharedInstance].appModel.has_sina_login == 1)//微博
    {
        [array addObject:@"3"];
    }
    
    if ([GlobalVariables sharedInstance].appModel.has_visitors_login == 1) {//游客登录
        _vistorBtn.hidden = NO;
    }
    
    if ([GlobalVariables sharedInstance].appModel.open_mobile_code_login == 1) {//验证码登录
        [array addObject:@"4"];
    }
    
    [array addObject:@"5"];

    
    
    
//    [array addObject:@"6"];
    
//    //如果各种登入方式都没有就将手机的登入方式都显示出来
//    if (array.count < 1)
//    {
//        array = [[NSMutableArray alloc]initWithObjects:@"4", nil];
//    }
    
    self.LView = [[ULGView alloc]initWithFrame:CGRectMake(0, kScreenH*0.7, kScreenW, 47) Array:array];
    self.LView.LDelegate = self;
    [self addSubview:self.LView];
}

-(void)enterLoginWithCount:(int)count{
    
    if (self.clickLoginBlock) {
        self.clickLoginBlock(count + 1000);
    }
    
}


-(void)btnClick:(UIButton *)sender{
    
    if (self.clickLoginBlock) {
        self.clickLoginBlock(sender.tag - 10);
    }
}

@end
