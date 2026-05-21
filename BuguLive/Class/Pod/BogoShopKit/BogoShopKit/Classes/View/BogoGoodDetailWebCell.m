//
//  BogoGoodDetailWebCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/30.
//

#import "BogoGoodDetailWebCell.h"
#import <WebKit/WebKit.h>
#import "BogoCommodityDetailModel.h"
#import "FDUIKitObjC.h"

@interface BogoGoodDetailWebCell ()<WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, assign) BOOL isLoad;

@end

@implementation BogoGoodDetailWebCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.webView];
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    if (!_isLoad && model) {
        NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "</head> \n"
                                   "<body>"
                                   "<script type='text/javascript'>"
                                   "window.onload = function(){\n"
                                   "var $img = document.getElementsByTagName('img');\n"
                                   "for(var p in  $img){\n"
                                      " $img[p].style.width = '100%%';\n"
                                       "$img[p].style.height ='auto'\n"
                                   "}\n"
                                   "}"
                                   "</script>%@"
                                   "</body>"
                                   "</html>",model.detail];
        [self.webView loadHTMLString:htmls baseURL:nil];
        _isLoad = YES;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        CGFloat ratio =  CGRectGetWidth(webView.frame) /[result floatValue];
        NSLog(@"scrollWidth高度：%.2f",[result floatValue]);
        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            NSLog(@"scrollHeight高度：%.2f",[result floatValue]*ratio);
            CGFloat height = [result floatValue]*ratio;
            self.webView.frame = CGRectMake(0, 40, FD_ScreenWidth, height);
            self.webView.scrollView.frame = CGRectMake(0, 0, FD_ScreenWidth, height);
            self.webView.scrollView.contentSize = CGSizeMake(FD_ScreenWidth, height);
            if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didFinishLoad:)]) {
                [self.delegate detailCell:self didFinishLoad:height];
            }
        }];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 40, FD_ScreenWidth, self.contentView.fd_height) configuration:config];
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

@end
