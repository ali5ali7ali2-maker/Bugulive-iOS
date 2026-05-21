//
//  BogoCountryChoiceViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/25.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseViewController.h"
#import "BogoChoiceAreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BogoCountryChoiceViewController : BGBaseViewController

@property(nonatomic, copy) void (^clickAreaBlock)(BogoChoiceAreaModel *model);
@end

NS_ASSUME_NONNULL_END
