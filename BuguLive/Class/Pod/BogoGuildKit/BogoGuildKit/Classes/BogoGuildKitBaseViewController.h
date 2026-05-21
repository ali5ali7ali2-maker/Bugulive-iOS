//
//  BogoGuildKitBaseViewController.h
//  BogoGuildKit
//
//  Created by Mac on 2021/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoGuildKitBaseViewController : UIViewController

@property(nonatomic, assign) BOOL isShowBack;

@property(nonatomic, copy) void (^clickCancleBlock)(BOOL isRefresh);

@end

NS_ASSUME_NONNULL_END
