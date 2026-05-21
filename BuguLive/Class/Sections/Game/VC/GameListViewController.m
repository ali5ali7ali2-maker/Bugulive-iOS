//
//  GameListViewController.m
//  BuguLive
//
//  Created by voidcat on 2023/8/29.
//  Copyright © 2023 xfg. All rights reserved.
//

#import "GameListViewController.h"

@interface GameListViewController ()
//webview
@property(nonatomic, strong) WKWebView *webView;
@end

@implementation GameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
    
    NSString *url = [GlobalVariables sharedInstance].appModel.h5_url.game_list;
    url = [url urlAddCompnentForValue:[IMAPlatform sharedInstance].host.userId key:@"uid"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *token = [BogoNetwork shareInstance].token;
    if (token.length > 0) {
        [request setValue:token forHTTPHeaderField:@"token"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    }

    [self.webView loadRequest:request];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
//        config.backgroundColor = [UIColor clearColor];
//        config.userContentController.backgroundColor = [UIColor clearColor];

        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _webView.opaque = NO;
        _webView.navigationDelegate = self;
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.frame = self.view.bounds;
        [_webView setBackgroundColor:[UIColor clearColor]];


//        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        closeBtn.frame = CGRectMake(40, kStatusBarHeight, 30, 30);
//        [closeBtn setImage:[UIImage imageNamed:@"com_close_1"] forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
//        [_webView addSubview:closeBtn];
//        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"BogoNetworkIndexModel"];
//        BogoNetworkInitModel *model = [BogoNetworkInitModel mj_objectWithKeyValues:dict];
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 判断URL是否为"bogogame://exit"，如果是，则隐藏webView
    if ([webView.URL.absoluteString isEqualToString:@"bogogame://exit"]) {
        [webView goBack];
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    // 判断是否是您希望拦截的 URL，这里的示例是以 "myapp://" 开头的 URL
    if ([url.absoluteString isEqualToString:@"bogogame://exit"]) {
        [webView goBack];
        // 自己处理逻辑，不加载该 URL
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
        // 允许加载该 URL
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
