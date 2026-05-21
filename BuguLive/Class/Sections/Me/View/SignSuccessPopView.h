//
//  SignSuccessPopView.h
//  BuguLive
//
//  Created by bugu on 2019/11/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^dismissBlock)(void);

@interface SignSuccessPopView : UIView
+(void)showSignSuccessViewGift:(NSString *)gift WithComplete:(dismissBlock)complete;

@end

NS_ASSUME_NONNULL_END
