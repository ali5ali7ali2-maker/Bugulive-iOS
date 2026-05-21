//
//  HMShareView.m
//  BuguLive
//
//  Created by 范东 on 2019/1/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "HMShareView.h"

#define kShareViewButtonBaseTag 11

#define kShareViewHeight              150
#define kShareViewHasReportHeight 250

@interface HMShareView ()

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *reportBtn;

@end

@implementation HMShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenW, 50)];
    [titleLabel setText:ASLocalizedString(@"分享到")];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setBackgroundColor:kWhiteColor];
    [self addSubview:titleLabel];
    
    
    if (self.BuguLive.appModel.wx_app_api == 1)
    {
        [self.dataArray addObject:@"fw_share_circle"];
        [self.dataArray addObject:@"fw_share_wechat"];
    }
    if (self.BuguLive.appModel.qq_app_api == 1)
    {
        [self.dataArray addObject:@"fw_share_qq"];
        [self.dataArray addObject:@"fw_share_qqCircle"];
    }
    if (self.BuguLive.appModel.sina_app_api == 1)
    {
        [self.dataArray addObject:@"fw_share_weiBo"];
    }

    NSArray *titleArray = @[ASLocalizedString(@"朋友圈"),ASLocalizedString(@"微信"),ASLocalizedString(@"微博"),@"QQ",ASLocalizedString(@"QQ空间")];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20 + i*(50 + 20), 0, 50, 50)];
        [button setTag:kShareViewButtonBaseTag + i];
        [button setImage:[UIImage imageNamed:self.dataArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom, 70, 50)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.centerX = button.centerX;
        [self.scrollView addSubview:titleLabel];
    }
    [self addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.dataArray.count * (50 + 20 ) + 20, self.scrollView.height);
//    self.scrollView.centerX = kScreenW / 2;
//    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, kScreenW, 50)];
//    [cancelBtn setTitle:ASLocalizedString(@"取消分享")forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
//    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:cancelBtn];
    
    [self addSubview:self.reportBtn];
    UILabel *reportLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.reportBtn.bottom, 70, 50)];
    reportLabel.text = ASLocalizedString(@"举报");
    reportLabel.font = [UIFont systemFontOfSize:15];
    reportLabel.textAlignment = NSTextAlignmentCenter;
    reportLabel.centerX = self.reportBtn.centerX;
    [self addSubview:reportLabel];
}

- (void)onClick:(UIButton *)sender{
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShareViewBtn:)]) {
        NSString *imageName = self.dataArray[sender.tag - kShareViewButtonBaseTag];
        if ([imageName equalsString:@"fw_share_qq"]) {
            [self.delegate clickShareViewBtn:UMSocialPlatformType_QQ];
        }
        if ([imageName equalsString:@"fw_share_qqCircle"]) {
            [self.delegate clickShareViewBtn:UMSocialPlatformType_Qzone];
        }
        if ([imageName equalsString:@"fw_share_wechat"]) {
            [self.delegate clickShareViewBtn:UMSocialPlatformType_WechatSession];
        }
        if ([imageName equalsString:@"fw_share_circle"]) {
            [self.delegate clickShareViewBtn:UMSocialPlatformType_WechatTimeLine];
        }
        if ([imageName equalsString:@"fw_share_weiBo"]) {
            [self.delegate clickShareViewBtn:UMSocialPlatformType_Sina];
        }
    }
}

- (void)reportBtnAction{
    [self hide];
    //点击了举报
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShareViewReportBtn)]) {
        [self.delegate clickShareViewReportBtn];
    }
}

- (void)show:(UIView *)superView isNeedReport:(BOOL)isNeedReport{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH - (isNeedReport ? kShareViewHasReportHeight : kShareViewHeight);
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, kScreenW, 100)];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
        _shadowView.alpha = 0;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (UIButton *)reportBtn{
    if (!_reportBtn) {
        _reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, 50, 50)];
        [_reportBtn setImage:[UIImage imageNamed:@"ss_icon_report"] forState:UIControlStateNormal];
        [_reportBtn addTarget:self action:@selector(reportBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
