//
//  BogoYouthModeViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/11.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoYouthModeViewController.h"
#import "BogoYouthModePassWordViewController.h"
#import "BogoNetworkKit.h"

@interface BogoYouthModeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;



@end

@implementation BogoYouthModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.subTitle setLocalizedString];
    self.navigationItem.title = ASLocalizedString(@"青少年模式");
    [self backBtnWithBlock];
//    [self setUpView];
    
    [self setModel];
}

-(void)setModel{
    
    
    [[BogoNetwork shareInstance]GET:@"young/getInfo" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
        
        
//        _contentL.text = result.data;
        
        [self setUpViewWithContentStr:result.data];
     
    } failure:^(NSString * _Nonnull error) {
        [self setUpViewWithContentStr:@""];
    }];

}

- (void)backBtnWithBlock
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}

-(void)setUpViewWithContentStr:(NSString *)content{
    
    if (!StrValid(content)) {
        _contentL.text = ASLocalizedString(@"青少年模式是布谷直播App为促进青少年健康成长做出的设置。若您手机被未成年使用，建议您开启此模式。\n开启青少年模式后，将无法正常使用App功能，只能观看短视频。\n每日开启青少年模式使用40分钟需要输入监护密码\n开启青少年模式需要先设置独立密码，用户需要牢记密码，如果忘记可通过手机验证码重置密码，需要输入正确密码才能关闭");
    }
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                 NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)};
       NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
       
       
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;  //设置行间距
    paragraphStyle.lineBreakMode = _contentL.lineBreakMode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
//    NSString *content =ASLocalizedString( @"为呵护未成年人健康成长，布谷直播特别推出青少年模式，该模式下部分功能无法正常使用。请监护人主动选择，并设置监护密码。");
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_contentL.text];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    

    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    [attStr setAttributes:attributes range:NSMakeRange(0, attStr.length)];
    _contentL.attributedText = attStr;
    
}


- (IBAction)clickOpenBtn:(UIButton *)sender {
    BogoYouthModePassWordViewController *vc = [[BogoYouthModePassWordViewController alloc]initWithYounthType:BOGO_YOUNTH_TYPE_PASSWORD_SET];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)setModel:(BogoCommodityDetailModel *)model{
//    _model = model;
//    if (!_isLoad && model) {
//        NSString *htmls = [NSString stringWithFormat:@"<html> \n"
//                                   "<head> \n"
//                                   "<style type=\"text/css\"> \n"
//                                   "body {font-size:15px;}\n"
//                                   "</style> \n"
//                                   "</head> \n"
//                                   "<body>"
//                                   "<script type='text/javascript'>"
//                                   "window.onload = function(){\n"
//                                   "var $img = document.getElementsByTagName('img');\n"
//                                   "for(var p in  $img){\n"
//                                      " $img[p].style.width = '100%%';\n"
//                                       "$img[p].style.height ='auto'\n"
//                                   "}\n"
//                                   "}"
//                                   "</script>%@"
//                                   "</body>"
//                                   "</html>",model.detail];
//        [self.webView loadHTMLString:htmls baseURL:nil];
//        _isLoad = YES;
//    }
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
//        CGFloat ratio =  CGRectGetWidth(webView.frame) /[result floatValue];
//        NSLog(@"scrollWidth高度：%.2f",[result floatValue]);
//        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
//            NSLog(@"scrollHeight高度：%.2f",[result floatValue]*ratio);
//            CGFloat height = [result floatValue]*ratio;
//            self.webView.frame = CGRectMake(0, 40, FD_ScreenWidth, height);
//            self.webView.scrollView.frame = CGRectMake(0, 0, FD_ScreenWidth, height);
//            self.webView.scrollView.contentSize = CGSizeMake(FD_ScreenWidth, height);
//            if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:didFinishLoad:)]) {
//                [self.delegate detailCell:self didFinishLoad:height];
//            }
//        }];
//    }];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//- (WKWebView *)webView{
//    if (!_webView) {
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
//        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 40, FD_ScreenWidth, self.contentView.fd_height) configuration:config];
//        _webView.navigationDelegate = self;
//        _webView.scrollView.scrollEnabled = NO;
//    }
//    return _webView;
//}

@end
