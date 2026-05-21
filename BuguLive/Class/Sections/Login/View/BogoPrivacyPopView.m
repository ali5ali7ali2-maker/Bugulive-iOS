//
//  BogoPrivacyPopView.m
//  BuguLive
//
//  Created by Mac on 2021/9/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoPrivacyPopView.h"
#import "MLEmojiLabel.h"

@interface BogoPrivacyPopView ()<MLEmojiLabelDelegate,WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) UIView *shadowView;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipTop;

@end

@implementation BogoPrivacyPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.hidden = YES;
    self.frame = CGRectMake(50, kScreenH, kScreenW - 100, 392);
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    [self addSubview:self.webView];
    self.tipTop.text = ASLocalizedString(@"温馨提示");
    
    NSString *string = ASLocalizedString(@"点击同意即表示您已阅读并同意《平台用户协议》和《隐私协议》。");
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:string];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5C8BFB"] range:[string rangeOfString:ASLocalizedString(@"《平台用户协议》")]];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5C8BFB"] range:[string rangeOfString:ASLocalizedString(@"《隐私协议》")]];
    [self.tipLabel setAttributedText:attr];
    [self.tipLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:[string rangeOfString:ASLocalizedString(@"《平台用户协议》")]] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#5C8BFB"]}];
    [self.tipLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:[string rangeOfString:ASLocalizedString(@"《隐私协议》")]] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#5C8BFB"]}];
    self.tipLabel.delegate = self;
    [self.disagreeBtn setTitle:ASLocalizedString(@"不同意") forState:UIControlStateNormal];
    [self.agreeBtn setTitle:ASLocalizedString(@"同意") forState:UIControlStateNormal];
}

#pragma mark - MLEmojiLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result{
    if (result.range.length == ASLocalizedString(@"《平台用户协议》").length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPopView:didClickUserAgreement:)]) {
            [self.delegate privacyPopView:self didClickUserAgreement:nil];
        }
    }else if (result.range.length == ASLocalizedString(@"《隐私协议》").length){
        if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPopView:didClickPrivacyAgreement:)]) {
            [self.delegate privacyPopView:self didClickPrivacyAgreement:nil];
        }
    }
}

- (void)setUrl:(NSString *)url{
    if ([url hasPrefix:@"http"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }else{
        [self.webView loadHTMLString:url baseURL:nil];
    }
}

- (IBAction)refuseBtnAction:(UIButton *)sender {
    [BGHUDHelper alert:ASLocalizedString(@"Please agree to the user agreement and privacy policy to continue.") action:nil];
}

- (IBAction)agreeBtnAction:(UIButton *)sender {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPopView:didClickAgreeBtn:)]) {
        [self.delegate privacyPopView:self didClickAgreeBtn:sender];
    }
}

- (WKWebView *)webView{
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc]initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [WKUserContentController new];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.userContentController = wkUController;
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(15, 50, kScreenW - 130, 230) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}

- (void)show:(UIView *)superView{
    [superView addSubview:self.shadowView];
    [superView addSubview:self];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CGFloat offsetY = ( superView.fd_height - strongSelf.fd_height ) / 2;
        strongSelf.frame = CGRectMake(strongSelf.fd_left, offsetY, strongSelf.fd_width, strongSelf.fd_height);
    }];
}

- (void)hide{
    __weak __typeof(self)weakSelf = self;
    CGFloat offsetY = self.superview.fd_height;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(strongSelf.fd_left, offsetY, strongSelf.fd_width, strongSelf.fd_height);
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.shadowView removeFromSuperview];
        [strongSelf removeFromSuperview];
    }];
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, FD_ScreenHeight)];
        _shadowView.backgroundColor = [FD_BlackColor colorWithAlphaComponent:0.4];
        _shadowView.hidden = YES;
    }
    return _shadowView;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.shadowView.hidden = NO;
    self.hidden = NO;
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        CGFloat ratio =  CGRectGetWidth(webView.frame) /[result floatValue];
        NSLog(@"scrollWidth高度：%.2f",[result floatValue]);
        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            NSLog(@"scrollHeight高度：%.2f",[result floatValue]*ratio);
            CGFloat height = [result floatValue]*ratio;
            self.webView.frame = CGRectMake(15, 50, FD_ScreenWidth - 130, height - 10);
            self.webView.scrollView.frame = CGRectMake(0, 0, FD_ScreenWidth - 130, height);
            self.webView.scrollView.contentSize = CGSizeMake(FD_ScreenWidth - 130, height);
            self.bounds = CGRectMake(0, 0, kScreenW - 100, 152 + height);
        }];
    }];
}

@end
