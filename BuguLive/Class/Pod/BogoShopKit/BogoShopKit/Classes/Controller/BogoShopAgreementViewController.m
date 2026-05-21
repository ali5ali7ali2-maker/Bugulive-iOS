//
//  BogoShopAgreementViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoShopAgreementViewController.h"
#import "FDUIKitObjC.h"
#import "BogoBindPhoneViewController.h"
#import "BogoShopKit.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import "BogoShopKit.h"
#import "BogoShopInfoFillViewController.h"
#import <MJExtension/MJExtension.h>
#import "BogoNetworkInitModel.h"
@interface BogoShopAgreementViewController ()
@property(nonatomic, strong) WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation BogoShopAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = FD_WhiteColor;
    self.title = @"开店须知";
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,FD_ScreenWidth - 70,40);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.agreeBtn.layer addSublayer:gl];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.agreeBtn.mas_top).offset(-40);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)agreeBtnAction:(id)sender {
    if (0) {
        BogoBindPhoneViewController *bindVC = [[BogoBindPhoneViewController alloc]initWithNibName:NSStringFromClass([BogoBindPhoneViewController class]) bundle:kShopKitBundle];
        [self.navigationController pushViewController:bindVC animated:YES];
    }else{
        BogoShopInfoFillViewController *infoVC = [[BogoShopInfoFillViewController alloc]init];
        infoVC.status = -1;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"BogoNetworkIndexModel"];
        BogoNetworkInitModel *model = [BogoNetworkInitModel mj_objectWithKeyValues:dict];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.shops_agreement]]];
    }
    return _webView;
}

@end
