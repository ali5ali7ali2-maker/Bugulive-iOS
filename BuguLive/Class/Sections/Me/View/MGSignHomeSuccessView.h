//
//  MGSignHomeSuccessView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/21.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^dismissBlock)(void);

@interface MGSignHomeSuccessView : UIView

+(void)showTodaySignSuccessViewGift:(NSString *)gift frame:(CGRect)frame WithComplete:(dismissBlock)complete;

@end

NS_ASSUME_NONNULL_END
