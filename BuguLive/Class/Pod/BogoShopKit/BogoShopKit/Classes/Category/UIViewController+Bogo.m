//
//  UIViewController+Bogo.m
//  BuGuDY
//
//  Created by bogokj on 2020/4/20.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "UIViewController+Bogo.h"

@implementation UIViewController (Bogo)
- (void)addBackButton
{
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"com_arrow_vc_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    //不要是蓝色
    self.navigationController.navigationBar.tintColor = [UIColor qmui_colorWithHexString:@"#333333"];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor qmui_colorWithHexString:@"#333333"]};
}

- (void)backBtnClicked {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {

    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }

    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }

    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}



@end
