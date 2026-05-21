//
//  RoomShareView.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/5.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "CommonShareView.h"

@interface CommonShareView ()

@property(nonatomic, strong) UIView *shadowView;

@end

@implementation CommonShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.width, 21)];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"分享至",nil);
    [self addSubview:titleLabel];
    
    NSArray *titleArray = @[NSLocalizedString(@"微信",nil),NSLocalizedString(@"朋友圈",nil),@"QQ",NSLocalizedString(@"QQ空间",nil),NSLocalizedString(@"保存图片",nil)];
    NSArray *imageArray = @[@"邀请_微信",@"邀请_朋友圈",@"邀请_QQ",@"邀请_QQ空间",@"邀请_保存图片"];
    
    NSArray *tagArray = @[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_UnKnown)];
    CGFloat itemWidth = self.width / 5;
    for (NSInteger i = 0; i < imageArray.count; i ++) {
        NSInteger row = i / 5;
        NSInteger col = i % 5;
        CGFloat x = itemWidth * col;
        CGFloat y = 51;
        QMUIButton *button = [[QMUIButton alloc]initWithFrame:CGRectMake(x, y, itemWidth, 70)];
        [button setImagePosition:QMUIButtonImagePositionTop];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateSelected];
        button.tag = kRoomShareViewBaseBtnTag + [tagArray[i] integerValue];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button setSpacingBetweenImageAndTitle:5];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 137, self.width, 1)];
//    lineView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
//    [self addSubview:lineView];
//
//    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 138, self.width, self.height - kTabBarHeight1 - 138)];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:cancelBtn];
}

- (void)buttonAction:(QMUIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:didClickBtn:)]) {
        [self.delegate shareView:self didClickBtn:sender];
    }
}

- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.left, kScreenH - strongSelf.height - FD_Top_Height, strongSelf.width, strongSelf.height);
    }];
}

- (void)hide{
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.left, kScreenH - FD_Top_Height, strongSelf.width, strongSelf.height);
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

@end
