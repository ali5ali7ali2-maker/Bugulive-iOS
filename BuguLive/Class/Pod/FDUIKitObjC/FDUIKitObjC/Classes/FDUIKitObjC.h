//
//  FDUIKitObjC.h
//  FDUIKitObjC
//
//  Created by fandongtongxue on 2020/2/26.
//

#ifndef FDUIKitObjC_h
#define FDUIKitObjC_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FDUIDefine.h"
#import "FDUIColorDefine.h"
#import "FDTypeDefine.h"

#import "FDAction.h"

#import "UIView+FD.h"

#import "FDHUDManager.h"

#import "FDView.h"
#import "FDPopView.h"
#import "FDAlertView.h"
#import "FDActionSheet.h"
#import "FDPhotoGroupView.h"

#import "FDNavigationController.h"
#import "FDTabBarController.h"
#import "FDWebViewController.h"
#import "FDTableViewController.h"

#import "FDTableView.h"
#import "FDTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MLMSegmentManager.h"



#define ASLocalizedString(key)  [NSString stringWithFormat:@"%@", [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"ASLocalized"]]




#endif /* FDUIKitObjC_h */
