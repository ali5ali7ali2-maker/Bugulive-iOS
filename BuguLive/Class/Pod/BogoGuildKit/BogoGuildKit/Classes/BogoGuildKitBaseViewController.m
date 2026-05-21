//
//  BogoGuildKitBaseViewController.m
//  BogoGuildKit
//
//  Created by Mac on 2021/9/24.
//

#import "BogoGuildKitBaseViewController.h"
#import "FDUIKitObjC.h"
#import "BogoGuildKit.h"

@interface BogoGuildKitBaseViewController ()

@end

@implementation BogoGuildKitBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = FD_WhiteColor;
    if (!_isShowBack) {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [backBtn setImage:kBogoGuildKitBundleImageNamed(@"guild_back") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        UIBarButtonItem *fixItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixItem.width = -3;
        
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
            backBtn.contentEdgeInsets =UIEdgeInsetsMake(0, -9, 0, 0);
            backBtn.imageEdgeInsets =UIEdgeInsetsMake(0, -9, 0, 0);
            self.navigationItem.leftBarButtonItem = backItem;
        }else{
            self.navigationItem.leftBarButtonItems = @[fixItem,backItem];
        }
    }
}

- (void)backBtnAction:(UIButton *)sender{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.clickCancleBlock) {
        self.clickCancleBlock(YES);
    }
    
}

@end
