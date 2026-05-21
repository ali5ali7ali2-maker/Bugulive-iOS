//
//  DMBaseViewController.h
//  iphoneLive
//
//  Created by 志刚杨 on 2017/4/2.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WZXNetworking.h"
//#import "LoginManager.h"
//#import <JPUSHService.h>
#import "AppDelegate.h"
//#import "MCTabBarController.h"
@protocol dmnavdelegae<NSObject>
@optional
-(void)navLeftButtonClick;
@end
@interface DMBaseViewController : UIViewController
-(void)navtionWithTitle:(NSString *)title;
-(void)setLeftButtonWith:(NSString *)title;
-(void)doReturn;
@property(nonatomic, weak) id<dmnavdelegae> navdelegate;
@end
