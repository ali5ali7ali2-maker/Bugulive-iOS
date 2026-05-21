//
//  UIFont+Ext.m
//  UniversalApp
//
//  Created by bugu on 2020/3/21.
//  Copyright © 2020 voidcat. All rights reserved.
//

#import "UIFont+Ext.h"




@implementation UIFont (Ext)



// 设置 MediumFont
+ (UIFont*)mediumFont:(CGFloat)size {
    UIFont *font = [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    return font;
}

// 设置 BoldFont
+ (UIFont*)boldFont:(CGFloat)size {
    UIFont *font = [UIFont boldSystemFontOfSize:size];
    return font;
}

+ (instancetype)bg_mediumFont17{
    return [UIFont mediumFont:17];
}

+ (instancetype)bg_mediumFont16{
    return [UIFont mediumFont:16];
}
+ (instancetype)bg_mediumFont15{
    return [UIFont mediumFont:15];
}
+ (instancetype)bg_mediumFont14{
    return [UIFont mediumFont:14];
}

+ (instancetype)bg_mediumFont13{
    return [UIFont mediumFont:13];
}

+ (instancetype)bg_mediumFont11{
    return [UIFont mediumFont:11];
}
@end
