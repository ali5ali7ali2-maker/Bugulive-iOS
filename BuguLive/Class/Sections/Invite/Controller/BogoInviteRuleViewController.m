//
//  BogoInviteRuleViewController.m
//  UniversalApp
//
//  Created by Mac on 2021/6/25.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteRuleViewController.h"
#import "FDWKUserContentController.h"

@interface BogoInviteRuleViewController ()

@property(nonatomic, strong) WKWebView *webView;

@end

@implementation BogoInviteRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =ASLocalizedString( @"邀请规则");
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.webView loadHTMLString:self.content baseURL:nil];
}

- (WKWebView *)webView{
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc]initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        FDWKUserContentController *wkUController = [FDWKUserContentController new];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.userContentController = wkUController;
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
