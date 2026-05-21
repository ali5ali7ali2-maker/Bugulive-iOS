//
//  CYImagePickerViewController.m
//  UniversalApp
//
//  Created by 志刚杨 on 2018/1/31.
//  Copyright © 2018年 voidcat. All rights reserved.
//

#import "CYImagePickerViewController.h"

@interface CYImagePickerViewController ()

@end

@implementation CYImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
//    self.needShowStatusBar = ![UIApplication sharedApplication].statusBarHidden;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    self.oKButtonTitleColorNormal   =  [UIColor blackColor];
    self.oKButtonTitleColorDisabled =  [UIColor blackColor];
    
//    @property (nonatomic, strong) UIColor *oKButtonTitleColorNormal;
  //  @property (nonatomic, strong) UIColor *oKButtonTitleColorDisabled;
//    if (iOS7Later) {
        self.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationBar.tintColor = [UIColor blackColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
//        if (self.needShowStatusBar) [UIApplication sharedApplication].statusBarHidden = NO;
//    }
    
    self.naviTitleColor = [UIColor blackColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
