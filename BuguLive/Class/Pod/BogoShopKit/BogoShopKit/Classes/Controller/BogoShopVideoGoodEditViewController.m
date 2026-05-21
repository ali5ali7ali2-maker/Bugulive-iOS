//
//  BogoShopVideoGoodEditViewController.m
//  BogoShopKit
//
//  Created by Mac on 2021/8/17.
//

#import "BogoShopVideoGoodEditViewController.h"
#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>
#import <UIKit/UIKit.h>
#import "BogoShopKit.h"

@interface BogoShopVideoGoodEditViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation BogoShopVideoGoodEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"编辑商品";
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, FD_ScreenWidth - 100, 40);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#9E64FF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#EF60F6"].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.finishBtn.layer insertSublayer:gl atIndex:0];
    
    self.titleLabel.text = self.model.title;
    self.textField.maximumTextLength = 8;
}

- (IBAction)finishBtnAction:(UIButton *)sender {
    if (!self.textField.text.length) {
        [[FDHUDManager defaultManager] show:@"未填写商品短标题" ToView:self.view];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(editVC:didFinishEdit:)]) {
        [self.delegate editVC:self didFinishEdit:self.textField.text];
        
    }
}

@end

