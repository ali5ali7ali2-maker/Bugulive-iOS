//
//  WardTipView.m
//  BuguLive
//
//  Created by 范东 on 2019/2/11.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "GamePopView.h"

@interface GamePopView()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, copy) tipWebViewDidFinishLoadBlock tipWebViewDidFinishLoadBlock;

@end

@implementation GamePopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.alpha = 1;
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
//    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        CGFloat documentHeight = [result doubleValue];
//        CGRect webFrame = webView.frame;
//        webFrame.size.height = documentHeight;
//        webView.frame = webFrame;
//        self.height = documentHeight;
//    }];
}

- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
   
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
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@",url,[GlobalVariables sharedInstance].token]]]];
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
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
    }
    return _webView;
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"live"]) {
        [self handleCustomAction:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


/**
 url参数转字典
 
 @param urlStr 输入的url
 @return 转换好的字典
 */
-(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr
{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:urlStr];
    
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    
    return parm;
    
//    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
//        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
//        if (array && array.count == 2) {
//            NSString *paramsStr = array[1];
//            if (paramsStr.length) {
//                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
//                for (NSString *param in paramArray) {
//                    if (param && param.length) {
//                        NSArray *parArr = [param componentsSeparatedByString:@"="];
//                        if (parArr.count == 2) {
//                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
//                        }
//                    }
//                }
//                return paramsDict;
//            }else{
//                return nil;
//            }
//        }else{
//            return nil;
//        }
//    }else{
//        return nil;
//    }
}


#pragma mark - private method
- (void)handleCustomAction:(NSURL *)URL
{
    NSString *host = [URL host];
    
    NSDictionary *queryDic =  [self dictionaryWithUrlString:URL.absoluteString];
    if ([queryDic[@"action"] isEqualToString:@"close"]) {
        [self hide];
    }
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
