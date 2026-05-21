//
//  CommonSexView.h
//  UniversalApp
//
//  Created by bogokj on 2019/11/6.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoSex) {
    BogoUnknown,
    BogoMale,
    BogoFemale
};

@interface CommonSexView : UIView

- (void)setSex:(BogoSex)sex age:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
