//
//  BGBaseWebViewController.m
//  BuguLive
//
//  Created by xfg on 2017/6/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseWebViewController.h"

@interface BGBaseWebViewController ()
{
    NSTimeInterval _beginTime;
}

@property (nonatomic, assign) BOOL              isFirstLoad;                // 是否第一次加载

@property (nonatomic, strong) UIBarButtonItem       *rightBarBtnItem;
@property (nonatomic, strong) UIImageView           *launchImgView;         // h5框架中，加载h5网页时用来遮盖当前页面，防止加载过程中的空白过程，等页面加载完后再隐藏

@end

@implementation BGBaseWebViewController

+ (void)initialize
{
//    NSString *sdk_guid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
//    NSString *userAgent = [[[uwebview alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    NSString *customUserAgent = [userAgent stringByAppendingFormat:[NSString stringWithFormat:@" fanwe_app_sdk sdk_type/ios sdk_version_name/%@ sdk_version/%@ sdk_guid/%@ kScreenW/%@ kScreenH/%@",VersionNum,VersionTime,sdk_guid,[NSString stringWithFormat:@"%f",kScaleW],[NSString stringWithFormat:@"%f",kScaleH]],nil];
//    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    
//    WKWebView *wkwebView =  [WKWebView new];
//    NSURL *url = [NSURL URLWithString:@"h5Url"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy                                         timeoutInterval:2.f];
//    [wkwebView loadRequest:request];
            
        
//    [wkwebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        //1）获取默认userAgent：
//            NSString *oldUA = result;  //直接获取为nil
//        //2）设置userAgent：添加额外的信息
//            NSString *newUA = [NSString stringWithFormat:@"%@ crfapp/(%@)", oldUA , @"ios;43"];
//            NSDictionary *dictNU = [NSDictionary dictionaryWithObjectsAndKeys:newUA, @"UserAgent", nil];
//            [[NSUserDefaults standardUserDefaults] registerDefaults:dictNU];
//    }];
}

/**
 类方法初始1
 
 @param urlStr WebView加载地址
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr
{
    BGBaseWebViewController *tmpControl = [[self alloc]init];
    tmpControl.urlStr = urlStr;
    return tmpControl;
}

/**
 类方法初始2
 
 @param urlStr urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator
{
    BGBaseWebViewController *tmpControl = [[self alloc]init];
    tmpControl.urlStr = urlStr;
    tmpControl.isShowIndicator = isShowIndicator;
    return tmpControl;
}

/**
 类方法初始3
 
 @param urlStr urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @param isShowNavBar 是否显示导航栏
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator isShowNavBar:(BOOL)isShowNavBar
{
    BGBaseWebViewController *tmpControl = [[self alloc]init];
    tmpControl.urlStr = urlStr;
    tmpControl.isShowIndicator = isShowIndicator;
    tmpControl.isShowNavBar = isShowNavBar;
    return tmpControl;
}

/**
 类方法初始4
 
 @param urlStr urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @param isShowNavBar 是否显示导航栏
 @param isShowTabBar 是否显示tabBar
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator isShowNavBar:(BOOL)isShowNavBar isShowTabBar:(BOOL)isShowTabBar
{
    BGBaseWebViewController *tmpControl = [[self alloc]init];
    tmpControl.urlStr = urlStr;
    tmpControl.isShowIndicator = isShowIndicator;
    tmpControl.isShowNavBar = isShowNavBar;
    tmpControl.isShowTabBar = isShowTabBar;
    return tmpControl;
}

/**
 类方法初始5
 
 @param urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @param isShowNavBar 是否显示导航栏
 @param isShowBackBtn 是否显示返回按钮
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator isShowNavBar:(BOOL)isShowNavBar isShowBackBtn:(BOOL)isShowBackBtn
{
    BGBaseWebViewController *tmpControl = [[self alloc]init];
    tmpControl.urlStr = urlStr;
    tmpControl.isShowIndicator = isShowIndicator;
    tmpControl.isShowNavBar = isShowNavBar;
    tmpControl.isShowBackBtn = isShowBackBtn;
    return tmpControl;
}

/**
 类方法初始5
 
 @param urlStr WebView加载地址
 @param isShowIndicator 是否显示指示器
 @param isShowNavBar 是否显示导航栏
 @param isShowBackBtn 是否显示返回按钮
 @param isShowCloseBtn 是否显示关闭按钮（前提是 isShowBackBtn==YES）
 @return 返回WKWebView
 */
+ (instancetype)webControlerWithUrlStr:(NSString *)urlStr isShowIndicator:(BOOL)isShowIndicator isShowNavBar:(BOOL)isShowNavBar isShowBackBtn:(BOOL)isShowBackBtn isShowCloseBtn:(BOOL)isShowCloseBtn
{
    BGBaseWebViewController *tmpControl = [[self alloc]init];
    tmpControl.urlStr = urlStr;
    tmpControl.isShowIndicator = isShowIndicator;
    tmpControl.isShowNavBar = isShowNavBar;
    tmpControl.isShowBackBtn = isShowBackBtn;
    tmpControl.isShowCloseBtn = isShowCloseBtn;
    return tmpControl;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isShowSegHead = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (!_isShowNavBar)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if (_isViewWillAppearRefresh)
    {
        [self reLoadCurrentWKWebView];
    }
    
    // 指定边缘要延伸的方向，该属性很重要
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self hideMyHud];
}

#pragma mark UI创建
- (void)initFWUI
{
    [super initFWUI];
    
    if (![BGUtils isBlankString:_navTitleStr])
    {
        self.navigationItem.title = _navTitleStr;
    }
    
    [self statusBarCurrentBackgroundColor];
    
    // 获取cookie
    NSString *cookieStr = @"document.cookie = ";
    NSString *cookieStr2 = @"";
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kMyCookies];
    if([cookiesdata length])
    {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies)
        {
            if (![BGUtils isBlankString:cookie.name] && ![BGUtils isBlankString:cookie.value])
            {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                cookieStr = [cookieStr stringByAppendingString:[NSString stringWithFormat:@"'%@=%@';", [cookie name],[cookie value]]];
                cookieStr2 = [cookieStr2 stringByAppendingString:[NSString stringWithFormat:@"%@=%@;", [cookie name],[cookie value]]];
            }
        }
    }
    
    if (_userContentC)
    {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserScript * cookieScript;
        if ([cookiesdata length])
        {
            cookieScript = [[WKUserScript alloc] initWithSource: cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        }
        else
        {
            cookieScript = [[WKUserScript alloc] initWithSource:@"window.webkit.messageHandlers.updateCookies.postMessage(document.cookie);" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        }
        [_userContentC addUserScript:cookieScript];
        configuration.userContentController = _userContentC;
        
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    }
    else
    {
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    }
    
    // OC
    if (@available(iOS 16.4, *)) {
        self.webView.inspectable = true;
    } else {
        // Fallback on earlier versions
    }
    
    [self.view addSubview:self.webView];
    if (!_isShouldOpenBounces)
    {
        self.webView.scrollView.bounces = NO;
    }
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    [self adjustWebViewFrame];
    
    if (_isShowBackBtn && _isShowCloseBtn)
    {  // 显示返回、关闭按钮
        UIBarButtonItem *buttonItem1 = [UIBarButtonItem itemWithTarget:self action:@selector(webViewReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]; // 该UIBarButtonItem只是用来控制间距的
        spaceItem.width = 5;
        UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithTitle:ASLocalizedString(@"关闭")style:UIBarButtonItemStylePlain target:self action:@selector(webViewCloseBtnPress)];
        buttonItem2.tintColor = kAppMainColor;
        
        self.navigationItem.leftBarButtonItems = @[buttonItem1,spaceItem,buttonItem2];
    }
    else if (_isShowBackBtn)
    {  // 显示关闭按钮
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(webViewReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    }
    
    [self initLaunchImgView];
}

#pragma mark h5框架中，加载h5网页时用来遮盖当前页面，防止加载过程中的空白过程，等页面加载完后再隐藏
- (void)initLaunchImgView
{
    if (_isShowLaunchImgView)
    {
        _launchImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_launchImgView setImage:[UIImage imageNamed:@"wel"]];
        [self.view addSubview:_launchImgView];
    }
}

#pragma mark 移除LaunchImgView
- (void)removeLaunchImgView
{
    if (_launchImgView)
    {
        [_launchImgView removeFromSuperview];
    }
}

#pragma mark 设置当前状态栏的背景色
- (void)statusBarCurrentBackgroundColor
{
    if (![BGUtils isBlankString:self.BuguLive.appModel.statusbar_color])
    {
        NSMutableString *statusbar_color = [NSMutableString stringWithString:self.BuguLive.appModel.statusbar_color];
        if ([statusbar_color hasPrefix:@"#"])
        {
            [statusbar_color deleteCharactersInRange:NSMakeRange(0,1)];
        }
        
        unsigned int hexValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:statusbar_color];
        [scanner setScanLocation:0]; // depends on your exact string format you may have to use location 1
        [scanner scanHexInt:&hexValue];
        self.view.backgroundColor = RGBOF(hexValue);
    }
    else
    {
        self.view.backgroundColor = kAppMainColor;
    }
    self.view.backgroundColor = kWhiteColor;
}

#pragma mark 调整webview的frame
- (void)adjustWebViewFrame
{
    if (!_isShowNavBar)
    {
        self.webView.y = 20;
    }
    
    if (!_isShowTabBar && !_isShowNavBar)
    {
        self.webView.height = kScreenH-kStatusBarHeight;
    }
    else if (_isShowTabBar && _isShowNavBar)
    {
        self.webView.height = kScreenH-kStatusBarHeight-64-kTabBarHeight;
    }
    else
    {
        if(!_isShowTabBar)
        {
            self.webView.height = kScreenH-kStatusBarHeight-44;
        }
        if(!_isShowNavBar)
        {
            self.webView.height = kScreenH-kStatusBarHeight-kTabBarHeight;
        }
    }
    
    if (self.isShowSegHead) {
        self.webView.height = kScreenH-kStatusBarHeight - 64 -44-kTabBarHeight-44;
    }
    
}

- (void)reLoadWebViewAndHideRightBarBtnItem
{
    [self reLoadCurrentWKWebView];
    if (_rightBarBtnItem)
    {
        _rightBarBtnItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark 添加导航栏右侧按钮
- (void)initRightBarBtnItemWithType:(RightBarBtnItem)type titleStr:(NSString *)titleStr
{
    if (_rightBarBtnItem)
    {
        _rightBarBtnItem = nil;
    }
    
    if (type == RightBarBtnItemRefresh)
    {
        _rightBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:titleStr style:UIBarButtonItemStylePlain target:self action:@selector(reLoadWebViewAndHideRightBarBtnItem)];
        [_rightBarBtnItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kAppGrayColor1} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = _rightBarBtnItem;
    }
}

#pragma mark 初始化变量
- (void)initFWVariables
{
    [super initFWVariables];
}

#pragma mark 加载数据
- (void)initFWData
{
    [super initFWData];
    
    if (_isFrontRefresh)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadCurrentWKWebView) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    [self loadCurrentWKWebView];
}

#pragma mark 加载当前WKWebView
- (void)loadCurrentWKWebView
{
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:KAppLanguage];
    if([lang isEqualToString:@"zh-Hans"]) {
        lang = @"zh-cn";
    } else if([lang isEqualToString:@"ar"]) {
        lang = @"ar";
    } else {
        lang = @"zh-en";
    }

    // 使用NSURLComponents安全地构建URL
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:_urlStr];
    NSMutableArray *queryItems = [NSMutableArray array];

    // 添加现有的查询参数(如果有)
    BOOL hasToken = NO;
    BOOL hasLanguage = NO;
    
    if (components.queryItems) {
        for (NSURLQueryItem *item in components.queryItems) {
            [queryItems addObject:item];
            if ([item.name isEqualToString:@"token"]) {
                hasToken = YES;
            }
            if ([item.name isEqualToString:@"language"]) {
                hasLanguage = YES;
            }
        }
    }
    
    // 只在参数不存在时添加
    if (!hasToken) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"token" value:[GlobalVariables sharedInstance].token]];
    }
    if (!hasLanguage) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"language" value:lang]];
    }

    components.queryItems = queryItems;

    // 获取最终的URL字符串
    _urlStr = components.URL.absoluteString;
    NSLog(@"当前url：%@\n",_urlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr]];
    request.timeoutInterval = kWebViewTimeoutInterval;
    [self.webView loadRequest:request];
}

#pragma mark 重新加载当前WKWebView
- (void)reLoadCurrentWKWebView
{
    [self.webView reload];
}

#pragma mark webview返回，此时不一定会结束该controller
- (void)webViewReturnBtnPress
{
    // 退出或者返回时做该判断防止内存泄露
    if ([self.webView isLoading])
    {
        [self.webView stopLoading];
    }
    
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self webViewCloseBtnPress];
    }
}

#pragma mark 关闭当前页面
- (void)webViewCloseBtnPress
{
    // 退出或者返回时做该判断防止内存泄露
    if ([self.webView isLoading])
    {
        [self.webView stopLoading];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.userContentC)
    {
        [self removeScriptMessageHandler];
    }
    
    if (self.isSmallScreen)
    {
        [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:NO nextViewController:nil delegateWindowRCNameStr:@"BGTabBarController" complete:^(BOOL finished) {
            
        }];
    }
    else
    {
        UIViewController *tmpVC = [self.navigationController popViewControllerAnimated:YES];
        if (!tmpVC)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark 移除ScriptMessageHandler，防止退出时内存泄露
- (void)removeScriptMessageHandler
{
    // 子类重写
}


#pragma mark  - ----------------------- webview生命周期相关函数 -----------------------
#pragma mark js请求oc
- (void)evaluateMyJavaScript:(WKWebView *)webView
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"fun.js" ofType:nil];
    NSString *jsStr=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView evaluateJavaScript:jsStr completionHandler:nil];
}

#pragma mark 开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
    _beginTime = [[NSDate date] timeIntervalSince1970];
    NSLog(ASLocalizedString(@"============加载webview开始时间点：%f"),_beginTime);
    
    [self evaluateMyJavaScript:webView];
    
    NSString *curUrl = [webView.URL absoluteString];
    NSMutableString *curMstr = [NSMutableString stringWithString:curUrl];
    NSRange curSubstr = [curMstr rangeOfString:@"show_prog=1"]; // 字符串查找,可以判断字符串中是否有
    if (curSubstr.location != NSNotFound || [curUrl hasSuffix:@"show_prog=1"] || _isShowIndicator)
    {
        [self showMyHud:@""];
    }
    
    // 判断是否拨打电话
    if ([curUrl hasPrefix:@"tel:"])
    {
        NSMutableString *mstr = [NSMutableString stringWithString:curUrl];
        // 查找并删除
        NSRange substr = [mstr rangeOfString:@"tel:"]; // 字符串查找,可以判断字符串中是否有
        if (substr.location != NSNotFound)
        {
            [mstr deleteCharactersInRange:substr];
        }
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",mstr];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark 加载出错
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s",__func__);
    
    [self hideMyHud];
    
    if (self.isCanShowRightBarRefreshBtn)
    {
        [self initRightBarBtnItemWithType:RightBarBtnItemRefresh titleStr:ASLocalizedString(@"刷新")];
    }
}

#pragma mark 加载完毕
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
    NSLog(ASLocalizedString(@"============加载webview总耗时:%f"),[[NSDate date] timeIntervalSince1970] - _beginTime);
    
    _isFirstLoad = NO;
    [self removeLaunchImgView];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=false;
    
    [self evaluateMyJavaScript:webView];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    // 使用 JavaScript 获取页面标题
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id result, NSError *error) {
        if (!error && [result isKindOfClass:[NSString class]] && ![BGUtils isBlankString:result]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.title = result;
                self.title = result;
            });
        }
    }];
    
    [self hideMyHud];
    [self saveCookie:webView];
}

#pragma mark 保存cookie
- (void)saveCookie:(WKWebView *)webView
{
    NSHTTPCookie *sessinCookie;
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:webView.URL];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject])
    {
        if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""] )
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            if ([cookie.name isEqualToString:@"PHPSESSID2"])
            {
                sessinCookie = cookie;
            }
        }
    }
    //当请求成共后调用如下代码, 保存Cookie
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kMyCookies];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [self performSelector:@selector(removeLaunchImgView) withObject:nil afterDelay:5];
    
    [self evaluateMyJavaScript:webView];
    
    if (_isFirstLoad)
    {
        [self performSelector:@selector(hideMyHud) withObject:nil afterDelay:5];
    }
    else
    {
        [self performSelector:@selector(hideMyHud) withObject:nil afterDelay:1.5];
    }
    _isFirstLoad = NO;
    
    [self saveCookie:webView];
}

#pragma mark Decides whether to allow or cancel a navigation.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    [FanweMessage alert:message];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    [FanweMessage alert:nil message:message destructiveAction:^{
        
        completionHandler(YES);
        
    } cancelAction:^{
        
        completionHandler(NO);
        
    }];
}


#pragma mark  - ----------------------- HUD -----------------------
- (void)showMyHud:(NSString *)statusStr
{
    if (![BGUtils isBlankString:statusStr])
    {
        [SVProgressHUD showWithStatus:statusStr];
    }
    else
    {
        [SVProgressHUD showWithStatus:ASLocalizedString(@"加载中...")];
    }
}

- (void)hideMyHud
{
    [SVProgressHUD dismiss];
}

@end
