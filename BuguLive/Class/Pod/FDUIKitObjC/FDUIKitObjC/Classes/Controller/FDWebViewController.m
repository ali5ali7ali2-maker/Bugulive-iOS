//
//  FDWebViewController.m
//  Project
//
//  Created by bogokj on 2020/5/20.
//  Copyright © 2020 fandong. All rights reserved.
//

#import "FDWebViewController.h"
#import <WebKit/WebKit.h>
#import "FDHUDManager.h"
#import "FDWKUserContentController.h"
#import <Masonry/Masonry.h>

@interface FDWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) NSURL *url;

@end

@implementation FDWebViewController

- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        _url = url;
        if (_url) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
        }else{
            [[FDHUDManager defaultManager] show:@"未初始化地址" ToView:self.view];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivewap_interceptNoti) name:@"wap_intercept" object:nil];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)onReceivewap_interceptNoti{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.title = webView.title;
}

- (WKWebView *)webView{
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc]initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        FDWKUserContentController *wkUController = [FDWKUserContentController new];
//        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.userContentController = wkUController;
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
