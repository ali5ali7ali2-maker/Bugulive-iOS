//
//  PublishLiveTopView.m
//  BuguLive
//
//  Created by xgh on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VoiceLiveTopView.h"

@implementation VoiceLiveTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
        [self locationCityJudge];
        self.locationBtn =  [self setButtomNormalImage:@"pl_publishlive_nolocation" selectedImage:@"pl_publishlive_location" text:ASLocalizedString(@"开启定位")normalcolor:kAppGrayColor4 selectedColor:kWhiteColor  frame:CGRectMake(15, 25, 65, kRealValue(45)) sel:@selector(locationBtnAction:)];
        self.locationBtn.selected = YES;
        self.locationBtn.hidden = YES;
        self.isCanLocation = YES;
        [self.locationBtn setTitle:[NSString stringWithFormat:@"%@", _locationCityString] forState:UIControlStateSelected];
        self.pravicyBtn = [self setButtomNormalImage:@"pl_publishlive_pravicyoff" selectedImage:@"pl_publishlive_pravicyon" text:ASLocalizedString(@"私密")normalcolor:kAppGrayColor4 selectedColor:kWhiteColor frame:CGRectMake(80, 25, kRealValue(60), kRealValue(45)) sel:@selector(pravicyBtnAction:)];
        self.pravicyBtn.centerY = self.locationBtn.centerY;
        self.pravicyBtn.hidden = YES;
        
        self.passwordBtn = [self setButtomNormalImage:@"pl_publishlive_key_off" selectedImage:@"pl_publishlive_key_on" text:ASLocalizedString(@"密码")normalcolor:kAppGrayColor4 selectedColor:kWhiteColor frame:CGRectMake(self.pravicyBtn.left, 25, kRealValue(60), kRealValue(45)) sel:@selector(passwordBtnAction:)];
        self.passwordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.passwordBtn.centerY = self.locationBtn.centerY;
        self.passwordBtn.hidden = YES;
        
        self.shopBtn = [self setButtomNormalImage:@"pl_publishlive_shop_off" selectedImage:@"pl_publishlive_shop_on" text:ASLocalizedString(@"购物")normalcolor:kAppGrayColor4 selectedColor:kWhiteColor frame:CGRectMake(self.passwordBtn.right, 25, kRealValue(80), kRealValue(45)) sel:@selector(shopBtnAction:)];
        self.shopBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.shopBtn.centerY = self.locationBtn.centerY;
        self.shopBtn.hidden = YES;
//        if ([[GlobalVariables sharedInstance].appModel.is_open_shop isEqualToString:@"1"]) {
            self.shopBtn.hidden = YES;
//        }
        
        self.classifyBtn = [self setButtomNormalImage:@"pl_publishlive_classify" selectedImage:@"pl_publishlive_classify" text:ASLocalizedString(@"直播分类:请选择")normalcolor:kWhiteColor selectedColor:kWhiteColor frame:CGRectMake(self.locationBtn.left, self.locationBtn.bottom + 36, 200, 20) sel:@selector(classifyBtnAction:)];
        self.classifyBtn.imagePosition = QMUIButtonImagePositionRight;
        self.classifyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.classifyBtn.hidden = YES;
        
        
        self.closeBtn = [self setButtomNormalImage:@"ac_auction_back" selectedImage:@"ac_auction_back" text:@"" normalcolor:kWhiteColor selectedColor:kWhiteColor frame:CGRectMake(21, 45, 20, 20) sel:@selector(closeBtnAction:)];
        
        self.announcement = [[QMUIButton alloc] initWithFrame:CGRectMake(self.width - 50 - 8, 45, 50, 20)];
        [self.announcement setTitle:@"公告" forState:UIControlStateNormal];
        [self.announcement setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.announcement.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [self.announcement addTarget:self action:@selector(handleAnnouncementEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.announcement];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"创建直播";
        titleLab.font = [UIFont boldSystemFontOfSize:18];
        titleLab.textColor = kWhiteColor;
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.announcement);
        }];
        
        
        
//        [self resetView];
        [GlobalVariables sharedInstance].isShop = NO;
        
    }
    return self;
}

- (void)handleAnnouncementEvent {
    __weak __typeof(self)weakSelf = self;
    [FanweMessage alertInput:nil message:@"请输入公告" placeholder:@"" keyboardType:UIKeyboardTypeDefault destructiveTitle:@"确认" destructiveAction:^(NSString *text) {
        weakSelf.announcement_str = text;
    } cancelTitle:@"取消" cancelAction:^{
        
    }];

}

-(void)resetView{
//    CGRectMake(15, 25, 65, kRealValue(45)
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(45);
    }];
    
    [self.passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationBtn.mas_right).offset(10);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(45);
    }];
    
    [self.shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordBtn.mas_right).offset(10);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(45);
    }];
    
}

- (void)locationBtnAction:(ImageTitleButton *)sender
{
    sender.selected = !sender.selected;
    self.isCanLocation = sender.selected;
    if (!self.isCanLocation) {
        [sender setTitle:ASLocalizedString(@"开启定位") forState:UIControlStateNormal];
    }
    [self resetView];
}

- (void)pravicyBtnAction:(ImageTitleButton *)sender
{
    sender.selected = !sender.selected;
    self.pravicy = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ispracychangeActionDelegate:)]) {
        [self.delegate ispracychangeActionDelegate:self.pravicy];
    }
}


- (void)passwordBtnAction:(ImageTitleButton *)sender
{
    if ([BGUtils isBlankString:self.password]) {
        sender.selected = !sender.selected;
    }
    
//    self.passwordBtn = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPasswordActionDelegate:)]) {
        [self.delegate clickPasswordActionDelegate:sender.selected];
    }
}

- (void)classifyBtnAction:(ImageTitleButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(classifyButtonActionDelegate)]) {
        [self.delegate classifyButtonActionDelegate];
    }
}

-(void)shopBtnAction:(ImageTitleButton *)sender{
    sender.selected = !sender.selected;
    self.isShop = sender.selected;
    
    [GlobalVariables sharedInstance].isShop = self.isShop;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShopActionDelegate:)]) {
        [self.delegate clickShopActionDelegate:self.isShop];
    }
}

- (void)closeBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeThePublishLive:)]) {
        [self.delegate closeThePublishLive:self];
    }
}
#pragma mark 获取到地理位置
- (void)locationCityJudge
{
    if ( self.BuguLive.province != nil && self.BuguLive.locationCity!=nil)
    {
        _locationCityString = self.BuguLive.locationCity;
        _provinceSrting = self.BuguLive.province;
    }
    else
    {
        _locationCityString =[self.BuguLive.appModel.ip_info objectForKey:@"city"];
        _provinceSrting =[self.BuguLive.appModel.ip_info objectForKey:@"province"];
    }
}

- (QMUIButton *)setButtomNormalImage:(NSString *)image selectedImage:(NSString *)selectedImage text:(NSString *)text normalcolor:(UIColor *)color selectedColor:(UIColor *)selecedColor frame:(CGRect)frame sel:(SEL)sel
{
    QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    //    [[ImageTitleButton alloc]initWithStyle: EImageLeftTitleRight];
    if (sel == @selector(closeBtnAction:)) {
        button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    }
    button.frame  = frame;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:selecedColor forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.spacingBetweenImageAndTitle = 5;
    button.imagePosition = QMUIButtonImagePositionLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:button];
    
    return button;
}

@end
