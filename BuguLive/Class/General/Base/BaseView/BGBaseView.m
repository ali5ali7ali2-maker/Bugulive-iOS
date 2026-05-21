//
//  BGBaseView.m
//  BuguLive
//
//  Created by xfg on 2017/6/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseView.h"
#import "BGNoContentView.h"

@implementation BGBaseView

- (NetHttpsManager *)httpsManager
{
    if (!_httpsManager)
    {
        _httpsManager = [NetHttpsManager manager];
    }
    return _httpsManager;
}

- (GlobalVariables *)BuguLive
{
    if (!_BuguLive)
    {
        _BuguLive = [GlobalVariables sharedInstance];
    }
    return _BuguLive;
}

#pragma mark - HUD
- (MBProgressHUD *)proHud
{
    if (!_proHud)
    {
        _proHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _proHud.mode = MBProgressHUDModeIndeterminate;
    }
    return _proHud;
}

- (void)hideMyHud
{
    if (_proHud)
    {
        [_proHud hideAnimated:YES];
        _proHud = nil;
    }
}

- (void)showMyHud
{
    [self.proHud showAnimated:YES];
}


- (void)showNoContentViewOnView:(UIView *)view
{
    if (!self.noContentView)
    {
     self.noContentView = [BGNoContentView noContentWithFrame:CGRectMake(0, 0, 150, 175)];
    }
    self.noContentView.center = CGPointMake(view.frame.size.width/2,view.frame.size.height/2);
    [view addSubview:self.noContentView];
}


- (void)hideNoContentViewOnView:(UIView *)view
{
   [self.noContentView removeFromSuperview];
    self.noContentView = nil;
}

- (void)show:(UIView *)superView{
//    [self requestWardData];
    [superView addSubview:self.shadowViews];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        //        self.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        self.bottom = kScreenH;
        self.shadowViews.alpha = 1;
    }];
}

- (void)show:(UIView *)superView frame:(CGRect)frame{
    [superView addSubview:self.shadowViews];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        //        self.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        self.frame = frame;
        self.shadowViews.alpha = 1;
    }];
}

- (void)hide{
    
    if (self.clickShadowBlock) {
        self.clickShadowBlock(YES);
//        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
//        self.frame = CGRectMake(0, kScreenH, self.width, self.height);
//        self.shadowViews.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.shadowViews removeFromSuperview];
    }];
}

- (UIView *)shadowViews{
    if (!_shadowViews) {
        _shadowViews = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowViews.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
        _shadowViews.alpha = 0;
        _shadowViews.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowViews addGestureRecognizer:tap];
    }
    return _shadowViews;
}


@end
