//
//  EveryDayFirstLoginPopView.h
//  BuguLive
//
//  Created by bugu on 2019/11/30.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^dismissBlock)(void);

@interface EveryDayFirstLoginPopView : UIView

+(void)showEveryDayFirstLoginViewScore:(NSString *)score WithComplete:(dismissBlock)complete;

@end

NS_ASSUME_NONNULL_END
