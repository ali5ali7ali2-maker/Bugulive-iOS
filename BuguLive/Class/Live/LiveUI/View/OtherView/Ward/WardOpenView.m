//
//  WardOpenView.m
//  BuguLive
//
//  Created by 范东 on 2019/1/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "WardOpenView.h"
#import "WardPriceButton.h"
#import "WardPrivilegeButton.h"

#define kWardOpenViewPriceBtnBaseTag 200
#define kWardOpenViewPrivilegeBtnBaseTag 300
#define kWardOpenViewOpenBtnTag 1107

@interface WardOpenView()

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *topBackView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *wardImageView;
@property (nonatomic, strong) UILabel *diamondLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) QMUIButton *diamondBtn;

@property (nonatomic, copy) clickFAQBtnBlock clickFAQBtnBlock;
@property (nonatomic, copy) clickWardListBtnBlock clickWardListBtnBlock;
@property (nonatomic, copy) clickOpenViewBtnBlock clickOpenViewBtnBlock;
@property (nonatomic, copy) clickPrivilegeBtnBlock clickPrivilegeBtnBlock;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *currentId;
@property (nonatomic, strong) NSArray *privilegeArray;

@end

@implementation WardOpenView

- (instancetype)initWithFrame:(CGRect)frame UserId:(nonnull NSString *)userId{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KMGMainBGColor;
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        self.layer.mask = shape;
        self.userId = userId;
        [self initSubview];
        [self requestData];
    }
    return self;
}

- (void)initSubview{
    
    UIImageView *topBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 160 + 30)];
//    topBackView.image = [UIImage imageNamed:@"lr_img_ward_open_back_blue"];
    topBackView.backgroundColor = kRedColor;
    [self addSubview:topBackView];
    self.topBackView = topBackView;
    
    UIButton *faqBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [faqBtn setBackgroundImage:[UIImage imageNamed:@"lr_btn_ward_faq"] forState:UIControlStateNormal];
    [faqBtn addTarget:self action:@selector(faqBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:faqBtn];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.wardImageView];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, kRealValue(25), kRealValue(25))];
    closeBtn.right = self.right - kRealValue(10);
    [closeBtn setImage:[UIImage imageNamed:@"lr_btn_ward_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    CGSize wardListBtnSize = [ASLocalizedString(@"TA的守护")textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
    UIButton *wardListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, wardListBtnSize.width, 20)];
    wardListBtn.right = closeBtn.left - 15;
    [wardListBtn setTitle:ASLocalizedString(@"TA的守护")forState:UIControlStateNormal];
    [wardListBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [wardListBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [wardListBtn addTarget:self action:@selector(wardListBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wardListBtn];
    
    closeBtn.centerY = wardListBtn.centerY;
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, topBackView.bottom + 15, self.width, 20)];
    tipLabel.text = ASLocalizedString(@"守护特权");
//    ASLocalizedString(@"成为Ta的守护,享受独一无二的特权");
    tipLabel.font = [UIFont systemFontOfSize:17];
    tipLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    RGB(120, 120, 120);
    tipLabel.backgroundColor =KMGMainBGColor;
    [self addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 50 - 10, self.width, 0.5)];
    lineView.backgroundColor = RGB(230, 230, 230);
    [self addSubview:lineView];
    
    UIButton *openBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, lineView.bottom + 5, 80, 34)];
    openBtn.tag = kWardOpenViewOpenBtnTag;
    openBtn.right = self.right - 10;
    openBtn.layer.cornerRadius = 17;
    [openBtn setBackgroundImage:[UIImage imageNamed:@"lr_btn_ward_bg"] forState:UIControlStateNormal];
    openBtn.clipsToBounds = YES;
    [openBtn setTitle:ASLocalizedString(@"开通守护")forState:UIControlStateNormal];
    [openBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [openBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:openBtn];
    
    UIImageView *moreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    moreImageView.image = [UIImage imageNamed:@"lr_btn_ward_right"];
    moreImageView.centerY = wardListBtn.centerY;
    moreImageView.right = wardListBtn.right + 10;
    [self addSubview:moreImageView];
    
    [self addSubview:self.diamondLabel];
    self.diamondLabel.centerY = openBtn.centerY;
    
    [self addSubview:self.timeLabel];
    self.timeLabel.centerY = openBtn.centerY;
    
    [self.diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(@44);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-100);
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(self.diamondLabel.mas_right).offset(10);
        make.height.mas_equalTo(@44);
    }];
}

-(void)closeBtn:(UIButton *)sender{
    [self hide];
}

- (void)requestData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"guardians_old" forKey:@"ctl"];
    [dict setValue:@"duardian_index" forKey:@"act"];
    [dict setValue:self.userId forKey:@"host_id"];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:responseJson[@"head_image"]] placeholderImage:kDefaultPreloadHeadImg];
            NSString *is_guaritian = responseJson[@"is_guartian"];
            NSString *diamond = responseJson[@"diamonds"];
            if (is_guaritian.integerValue == 1) {
                UIButton *openBtn = [self viewWithTag:kWardOpenViewOpenBtnTag];
                [openBtn setTitle:ASLocalizedString(@"续费守护")forState:UIControlStateNormal];
                NSString *time = responseJson[@"guartian_time"];
                NSDateFormatter *originFormatter = [[NSDateFormatter alloc]init];
                [originFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDateFormatter *newFormatter = [[NSDateFormatter alloc]init];
                [newFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *originDate = [originFormatter dateFromString:time];
                NSString *newDateString = [newFormatter stringFromDate:originDate];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",ASLocalizedString(@"到期: "),newDateString]];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#399ADF"] range:NSMakeRange(ASLocalizedString(@"到期: ").length, newDateString.length)];
                self.timeLabel.attributedText = attr;
            }
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:ASLocalizedString(@"我的钻石: %@"),diamond]];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#399ADF"] range:NSMakeRange(ASLocalizedString(@"我的钻石: ").length, diamond.length)];
            [self.diamondLabel setAttributedText:attrStr];
            if ([is_guaritian isEqualToString:@"1"]) {
                //已开通守护
                self.wardImageView.hidden = NO;
            }else{
                //未开通守护
                self.wardImageView.hidden = YES;
            }
            [self setDataWithPriceArray:responseJson[@"data"] PrivilegeArray:responseJson[@"guardian_type"]];
        }else{
            NSLog(ASLocalizedString(@"守护类型接口请求失败responseJson:%@"),responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"守护类型接口请求失败error:%@"),error);
    }];
}

- (void)setDataWithPriceArray:(NSArray *)priceArray PrivilegeArray:(NSArray *)privilegeArray{
    self.privilegeArray = privilegeArray;
    CGFloat viewWidth = (self.width - 14 * 2 - 19 * 2) / 3;
    for (NSInteger i = 0; i < priceArray.count; i++) {
        WardPriceButton *button = [[WardPriceButton alloc]initWithFrame:CGRectMake( 14 + i * (viewWidth + 19), 35 + 10, viewWidth, 80)];
        
        button.type_name = priceArray[i][@"type_name"];
        button.dict = priceArray[i];
        if (i == 0) button.layer.borderWidth = 0.8f;
        button.layer.borderColor = [UIColor colorWithHexString:@"#F5A623"].CGColor;
        button.layer.cornerRadius = 10;
        [button setSelected:NO];
        [button addTarget:self action:@selector(wardPriceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kWardOpenViewPriceBtnBaseTag + i;
        [self addSubview:button];
    }
    WardPriceButton *button = [self viewWithTag:kWardOpenViewPriceBtnBaseTag];
    [button setSelected:YES];
    
    self.currentId = button.dict[@"id"];
    
    for (NSInteger i = 0; i < privilegeArray.count; i++) {
        NSDictionary *dict = privilegeArray[i];
        WardPrivilegeButton *button = [[WardPrivilegeButton alloc]initWithFrame:CGRectMake( i * 85, 220, 85, 85)];
        [button setTitle:dict[@"name"]];
        [button setImageUrl:dict[@"default_icon"]];
        [button setId:dict[@"id"]];
        [button setDict:privilegeArray[i]];
        button.tag = kWardOpenViewPrivilegeBtnBaseTag + i;
        [button addTarget:self action:@selector(privilegeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[WardPrivilegeButton class]]) {
            WardPrivilegeButton *subBtn = (WardPrivilegeButton *)subView;
            if ([button.type_name containsObject:subBtn.id]) {
                [subBtn setImageUrl:subBtn.dict[@"select_icon"]];
            }
        }
    }
}

- (void)wardListBtnAction{
    [self hide];
    if (self.clickWardListBtnBlock) {
        self.clickWardListBtnBlock();
    }
}

- (void)faqBtnAction{
    [self hide];
    if (self.clickFAQBtnBlock) {
        self.clickFAQBtnBlock();
    }
}

- (void)privilegeButtonAction:(WardPrivilegeButton *)sender{
    //TODO
    if (self.clickPrivilegeBtnBlock) {
        self.clickPrivilegeBtnBlock(sender.dict[@"id"],sender,sender.tag - kWardOpenViewPrivilegeBtnBaseTag == (self.privilegeArray.count - 1));
    }
}

- (void)wardPriceButtonAction:(WardPriceButton *)sender{
    self.currentId = sender.dict[@"id"];
//    if (sender.tag - kWardOpenViewPriceBtnBaseTag == 2) {
//        self.topBackView.image = [UIImage imageNamed:@"lr_img_ward_open_back_purple"];
//    }else{
//        self.topBackView.image = [UIImage imageNamed:@"lr_img_ward_open_back_blue"];
//    }
    
    NSLog(ASLocalizedString(@"点击了第%ld个按钮"),sender.tag - kWardOpenViewPriceBtnBaseTag);
    //选中或者x不选中
    [sender setSelected:YES];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[WardPriceButton class]]) {
            WardPriceButton *subBtn = (WardPriceButton *)subView;
            subBtn.layer.borderWidth = 0;
            if (subBtn == sender) {
                sender.layer.borderWidth = 0.5f;
            }
            [subBtn setSelected:(subBtn == sender)];
        }
        
        if ([subView isKindOfClass:[WardPrivilegeButton class]]) {
            WardPrivilegeButton *subBtn = (WardPrivilegeButton *)subView;
            if ([sender.type_name containsObject:subBtn.id]) {
                [subBtn setImageUrl:subBtn.dict[@"select_icon"]];
            }else{
                [subBtn setImageUrl:subBtn.dict[@"default_icon"]];
                
            }
        }
    }
}

- (void)openBtnAction{
    NSLog(ASLocalizedString(@"点击了开通守护按钮"));
    [self hide];
    if (self.clickOpenViewBtnBlock) {
        self.clickOpenViewBtnBlock(self.currentId);
    }
}

- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenH - self.height, self.width, self.height);
        self.shadowView.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenH, self.width, self.height);
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.shadowView removeFromSuperview];
    }];
}

- (void)setClickFAQBtnBlock:(clickFAQBtnBlock)clickFAQBtnBlock{
    _clickFAQBtnBlock = clickFAQBtnBlock;
}

- (void)setClickWardListBtnBlock:(clickWardListBtnBlock)clickWardListBtnBlock{
    _clickWardListBtnBlock = clickWardListBtnBlock;
}

- (void)setClickOpenViewBtnBlock:(clickOpenViewBtnBlock)clickOpenViewBtnBlock{
    _clickOpenViewBtnBlock = clickOpenViewBtnBlock;
}

- (void)setClickPrivilegeBtnBlock:(clickPrivilegeBtnBlock)clickPrivilegeBtnBlock{
    _clickPrivilegeBtnBlock = clickPrivilegeBtnBlock;
}

#pragma mark - Lazy Load
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScaleH)];
        _shadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
        _shadowView.alpha = 0;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width - 60 ) / 2, 35, 60, 60)];
        _iconImageView.layer.cornerRadius = 30;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.hidden = YES;
    }
    return _iconImageView;
}

- (UIImageView *)wardImageView{
    if (!_wardImageView) {
        _wardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        _wardImageView.right = self.iconImageView.right;
        _wardImageView.top = self.iconImageView.top;
        _wardImageView.image = [UIImage imageNamed:@"lr_img_corner_ward_vip"];
        _wardImageView.hidden = YES;
    }
    
    return _wardImageView;
}

- (UILabel *)diamondLabel{
    if (!_diamondLabel) {
        _diamondLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.width - 10 - 10 - 80 - 10, 44)];
        [_diamondLabel setText:ASLocalizedString(@"我的钻石: 0")];
        [_diamondLabel setFont:[UIFont systemFontOfSize:15]];
        [_diamondLabel setTextColor:RGB(150, 150, 150)];
    }
    return _diamondLabel;
}

-(QMUIButton *)diamondBtn{
    if (!_diamondBtn) {
        _diamondBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_diamondBtn setTitleColor:KMGMainBlueFontColor forState:UIControlStateNormal];
//        _diamondBtn settitl
    }
    return _diamondBtn;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.diamondLabel.right + 10, 0, self.width - 10 - 10 - 80 - 10 - (self.width - 10 - 10 - 80 - 10) - 20, 44)];
        [_timeLabel setFont:[UIFont systemFontOfSize:15]];
        [_timeLabel setTextColor:RGB(150, 150, 150)];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _timeLabel;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
