//
//  UIFont+Ext.h
//  UniversalApp
//
//  Created by bugu on 2020/3/21.
//  Copyright © 2020 voidcat. All rights reserved.
//



#import <UIKit/UIKit.h>

// 灰色字体(颜色：由深到浅)
#define kAppGrayColor0              RGB(50, 50, 50)             // #323232
#define kAppGrayColor1              RGB(51, 51, 51)             // #333333
#define kAppGrayColor2              RGB(102, 102, 102)          // #666666
#define kAppGrayColor3              RGB(153, 153, 153)          // #999999

#define KAppBlueColor               RGB(149, 99, 247) //#9563F7
#define KAppThemeColor               RGB(149, 99, 247) //#9563F7

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Ext)

+ (instancetype)bg_mediumFont17;

+ (instancetype)bg_mediumFont16;
+ (instancetype)bg_mediumFont15;
+ (instancetype)bg_mediumFont14;

+ (instancetype)bg_mediumFont13;


+ (instancetype)bg_mediumFont11;
+ (UIFont*)mediumFont:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
