//
//  FDHUDManager.m
//  FDUIKitObjC
//
//  Created by fandongtongxue on 2020/2/29.
//

#import "FDHUDManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface FDHUDManager ()

@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation FDHUDManager

+ (FDHUDManager *)defaultManager{
    static FDHUDManager *defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (void)show:(NSString *)message ToView:(nonnull UIView *)superView{
    [self hideLoading];
    NSString *newMessage = message;
    if (!message.length) {
       return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    // Set the text mode to show only text.
    _hud.mode = MBProgressHUDModeText;
    _hud.label.text = newMessage;
    _hud.label.numberOfLines = 0;
    _hud.userInteractionEnabled = NO;
    [_hud hideAnimated:YES afterDelay:3];
}

- (void)showLoading:(NSString *)message ToView:(UIView *)superView{
    [self hideLoading];
    _hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.label.text = message;
    _hud.label.numberOfLines = 0;
}

- (void)hideLoading{
    if (_hud) {
        [_hud hideAnimated:YES];
    }
}

@end
