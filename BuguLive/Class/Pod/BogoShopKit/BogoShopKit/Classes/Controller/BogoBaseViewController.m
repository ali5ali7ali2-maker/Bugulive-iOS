//
//  BogoBaseViewController.m
//  UniversalApp
//
//  Created by bogokj on 2019/11/5.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "BogoBaseViewController.h"
#import "BogoShopKit.h"
#import "FDUIKitObjC.h"

@interface BogoBaseViewController ()

@end

@implementation BogoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = FD_WhiteColor;
    if (!_isHideBack) {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [backBtn setImage:imageNamed(@"shop_back") forState:UIControlStateNormal];
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
}

@end
