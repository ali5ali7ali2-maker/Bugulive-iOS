//
//  BogoBindPhoneViewController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoBindPhoneViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "FDUIKitObjC.h"
#import "BogoShopInfoFillViewController.h"

@interface BogoBindPhoneViewController ()

@property (weak, nonatomic) IBOutlet QMUITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation BogoBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = FD_WhiteColor;
    self.title = @"开店须知";
    _timeCount = 60;
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,FD_ScreenWidth - 70,40);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:29/255.0 blue:22/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:137/255.0 blue:96/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.nextBtn.layer addSublayer:gl];
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField{
    self.nextBtn.enabled = (self.phoneTextField.text.length == 11 && self.codeTextField.text.length);
    self.codeBtn.enabled = self.phoneTextField.text.length == 11;
}

- (IBAction)codeBtnAction:(id)sender {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction{
    self.codeBtn.enabled = NO;
    _timeCount--;
    if (_timeCount == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.codeBtn.enabled = YES;
    }
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ld 秒",_timeCount] forState:UIControlStateNormal];
}

- (IBAction)nextBtnAction:(id)sender {
    [self.view endEditing:YES];
    BogoShopInfoFillViewController *infoVC = [[BogoShopInfoFillViewController alloc]init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
