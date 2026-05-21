//
//  BogoYoungModeBlindPhoneVC.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/13.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BOGO_YOUNTH_BLIND_TYPE_PHONE,
    BOGO_YOUNTH_BLIND_TYPE_CODE,
} BOGO_YOUNTH_BLIND_TYPE;

@interface BogoYoungModeBlindPhoneVC : BGBaseViewController

-(instancetype)initWithBlindType:(BOGO_YOUNTH_BLIND_TYPE)type;

@property(nonatomic, strong) NSString *phoneNum;

@property(nonatomic, assign) BOGO_YOUNTH_BLIND_TYPE type;

@end

NS_ASSUME_NONNULL_END
