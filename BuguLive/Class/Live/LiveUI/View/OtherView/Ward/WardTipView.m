//
//  WardTipView.m
//  BuguLive
//
//  Created by 范东 on 2019/2/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "WardTipView.h"

@interface WardTipView()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, copy) tipWebViewDidFinishLoadBlock tipWebViewDidFinishLoadBlock;

@end

@implementation WardTipView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
        self.layer.shadowColor = kBlackColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 5);
        self.layer.shadowOpacity = 0.5;
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    [self addSubview:self.webView];
}

#pragma mark - WkWebViewDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat documentHeight = [result doubleValue];
        CGRect webFrame = webView.frame;
        webFrame.size.height = documentHeight;
        webView.frame = webFrame;
        self.height = documentHeight;
    }];
}

- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(80, kScreenH / 4, kScreenW - 160, kScreenH / 2);
        self.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(80, kScreenH, kScreenW - 160, kScreenH / 2);
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setURL:(NSString *)url{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&id=%@",self.BuguLive.appModel.h5_url.guartian_special_effects,url]]]];
    NSLog(@"%@&id=%@",self.BuguLive.appModel.h5_url.guartian_special_effects,url);
}

- (void)setTipWebViewDidFinishLoadBlock:(tipWebViewDidFinishLoadBlock)tipWebViewDidFinishLoadBlock{
    _tipWebViewDidFinishLoadBlock = tipWebViewDidFinishLoadBlock;
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        _webView = [[WKWebView alloc]initWithFrame:self.bounds configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}



- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = kClearColor;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
