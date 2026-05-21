//
//  FanweMessage.m
//  BuguLive
//
//  Created by xfg on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FanweMessage.h"

@implementation FanweMessage

#pragma mark - ----------------------- 一个按钮的弹框 -----------------------

+ (MMAlertView *)alert:(NSString *)message
{
    if (![BGUtils isBlankString:message])
    {
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:ASLocalizedString(@"温馨提示")detail:message];
        [alertView show];
        
        return alertView;
    }
    else
    {
        return [MMAlertView new];
    }
}

+ (MMAlertView *)alert:(NSString *)title message:(NSString *)message isHideTitle:(BOOL)isHideTitle destructiveAction:(FWVoidBlock)destructiveAction
{
    return [FanweMessage alert:title message:message isHideTitle:isHideTitle destructiveTitle:ASLocalizedString(@"确定")destructiveAction:destructiveAction];
}

+ (MMAlertView *)alert:(NSString *)title message:(NSString *)message isHideTitle:(BOOL)isHideTitle destructiveTitle:(NSString *)destructiveTitle destructiveAction:(FWVoidBlock)destructiveAction
{
    if (![BGUtils isBlankString:message])
    {
        MMPopupItemHandler block = ^(NSInteger index){
            
            if (destructiveAction)
            {
                destructiveAction();
            }
        };
        
        if ([BGUtils isBlankString:title])
        {
            title = ASLocalizedString(@"温馨提示");
        }
        
        if (isHideTitle)
        {
            title = @"";
        }
        
        if ([BGUtils isBlankString:destructiveTitle])
        {
            destructiveTitle = ASLocalizedString(@"知道了");
        }
        
        NSArray *items = @[MMItemMake(destructiveTitle, MMItemTypeNormal, block)];
        
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:message items:items];
        [alertView show];
        return alertView;
    }
    else
    {
        return [MMAlertView new];
    }
}


#pragma mark - ----------------------- 两个按钮的弹框 -----------------------

+ (MMAlertView *)alert:(NSString *)title message:(NSString *)message destructiveAction:(FWVoidBlock)destructiveAction cancelAction:(FWVoidBlock)cancelAction
{
    return [FanweMessage alert:title message:message destructiveTitle:ASLocalizedString(@"确定")destructiveAction:destructiveAction cancelTitle:ASLocalizedString(@"取消")cancelAction:cancelAction];
}

+ (MMAlertView *)alert:(NSString *)title message:(NSString *)message destructiveTitle:(NSString *)destructiveTitle destructiveAction:(FWVoidBlock)destructiveAction cancelTitle:(NSString *)cancelTitle cancelAction:(FWVoidBlock)cancelAction
{
    return [FanweMessage alertType:FanweMessageTypeAlertTwoBtn title:title message:message placeholder:@"" keyboardType:UIKeyboardTypeDefault destructiveTitle:destructiveTitle destructiveAction:destructiveAction cancelTitle:cancelTitle cancelAction:cancelAction inputHandler:nil];
}

+ (MMAlertView *)alertType:(FanweMessageType)messageType title:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType destructiveTitle:(NSString *)destructiveTitle destructiveAction:(FWVoidBlock)destructiveAction cancelTitle:(NSString *)cancelTitle cancelAction:(FWVoidBlock)cancelAction inputHandler:(MMPopupInputHandler)inputHandler
{
    if (![BGUtils isBlankString:message])
    {
        MMPopupItemHandler block = ^(NSInteger index){
            
            if (index == 0)
            {
                if(cancelAction)
                {
                    cancelAction();
                }
            }
            else if (index == 1)
            {
                if (destructiveAction)
                {
                    destructiveAction();
                }
            }
        };
        
        if ([BGUtils isBlankString:destructiveTitle])
        {
            destructiveTitle = ASLocalizedString(@"确定");
        }
        if ([BGUtils isBlankString:cancelTitle])
        {
            cancelTitle = ASLocalizedString(@"取消");
        }
        
        NSArray *items = @[MMItemMake(cancelTitle, MMItemTypeNormal, block), MMItemMake(destructiveTitle, MMItemTypeNormal, block)];
        
        if ([BGUtils isBlankString:title])
        {
            title = ASLocalizedString(@"温馨提示");
        }
        
        MMAlertView *alertView;
        if (messageType == FanweMessageTypeAlertTwoBtn)
        {
            alertView = [[MMAlertView alloc] initWithTitle:title detail:message items:items];
        }
        else if (messageType == FanweMessageTypeInputAlertTwoBtn)
        {
            alertView = [[MMAlertView alloc] initWithInputTitle:title detail:message placeholder:placeholder keyboardType:keyboardType items:items handler:^(NSString *text) {
                
                if (inputHandler)
                {
                    inputHandler(text);
                }
                
            }];
        }
        [alertView show];
        
        return alertView;
    }
    else
    {
        return [MMAlertView new];
    }
    
    //    [UIAlertView bk_showAlertViewWithTitle:ASLocalizedString(@"温馨提示")message:message cancelButtonTitle:ASLocalizedString(@"取消")otherButtonTitles:@[ASLocalizedString(@"确定")] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
    //
    //        if (buttonIndex == 0)
    //        {
    //            if(cancelAction)
    //            {
    //                cancelAction();
    //            }
    //        }
    //        else if (buttonIndex == 1)
    //        {
    //            if (destructiveAction)
    //            {
    //                destructiveAction();
    //            }
    //        }
    //
    //    }];
}

+ (UIAlertController *)alertController:(NSString *)message viewController:(UIViewController *)viewController
{
    return [FanweMessage alertController:message viewController:viewController destructiveAction:nil cancelAction:nil];
}

+ (UIAlertController *)alertController:(NSString *)message viewController:(UIViewController *)viewController destructiveAction:(FWVoidBlock)destructiveAction cancelAction:(FWVoidBlock)cancelAction
{
    if ([BGUtils isBlankString:message])
    {
        return [UIAlertController new];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ASLocalizedString(@"提示")message:message preferredStyle:UIAlertControllerStyleAlert];
    
//    // 修改message
//    NSString *tmpStr = [NSString stringWithFormat:@"\n%@",message];
//    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:tmpStr];
//    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:kAppGrayColor1 range:NSMakeRange(0, tmpStr.length)];
//    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, tmpStr.length)];
//    [alertControllerMessageStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n "]];
//
//    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    if (destructiveAction)
    {
        UIAlertAction *destructive = [UIAlertAction actionWithTitle:ASLocalizedString(@"确定")style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            destructiveAction();
        }];
//        [destructive setValue:kAppGrayColor2 forKey:@"titleTextColor"];
        [alertController addAction:destructive];
    }
    
    if (cancelAction)
    {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelAction();
        }];
//        [cancel setValue:kAppGrayColor2 forKey:@"titleTextColor"];
        [alertController addAction:cancel];
    }
    
    if (viewController)
    {
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        id rootViewController = kCurrentWindow.rootViewController;
        if([rootViewController isKindOfClass:[UIWindow class]])
        {
            rootViewController = ((UIWindow *)rootViewController).rootViewController;
        }
        if([rootViewController isKindOfClass:[UINavigationController class]])
        {
            rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
        }
        if([rootViewController isKindOfClass:[UITabBarController class]])
        {
            rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
        }
        
        if([rootViewController isKindOfClass:[UIViewController class]])
        {
            [rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            [FanweMessage alert:ASLocalizedString(@"温馨提示")message:message destructiveAction:destructiveAction cancelAction:destructiveAction];
        }
    }
    
    return alertController;
}


#pragma mark - ----------------------- 两个按钮的带输入框的弹框 -----------------------

+ (MMAlertView *)alertInput:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType destructiveTitle:(NSString *)destructiveTitle destructiveAction:(MMPopupInputHandler)destructiveAction cancelTitle:(NSString *)cancelTitle cancelAction:(FWVoidBlock)cancelAction
{
    return [FanweMessage alertType:FanweMessageTypeInputAlertTwoBtn title:title message:message placeholder:placeholder keyboardType:keyboardType destructiveTitle:destructiveTitle destructiveAction:nil cancelTitle:cancelTitle cancelAction:cancelAction inputHandler:destructiveAction];
}


#pragma mark - ----------------------- HUD类型弹框（无按钮） -----------------------

+ (void)alertHUD:(NSString *)message
{
    if (![BGUtils isBlankString:message])
    {
        [[BGHUDHelper sharedInstance] tipMessage:message];
    }
}

+ (void)alertHUD:(NSString *)message delay:(CGFloat)seconds
{
    if (![BGUtils isBlankString:message])
    {
        [[BGHUDHelper sharedInstance] tipMessage:message delay:seconds];
    }
}


#pragma mark - ----------------------- TWMessageBar类型弹框（无按钮） -----------------------

+ (void)alertTWMessage:(NSString *)message
{
    if (![BGUtils isBlankString:message])
    {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:message description:nil type:TWMessageBarMessageTypeInfo];
    }
}

@end
